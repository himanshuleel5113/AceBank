package com.acebank.lite.util;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.logging.Logger;
import java.util.stream.Collectors;

public final class ConnectionManager {

    private static HikariDataSource dataSource;
    private static volatile boolean isSchemaInitialized = false;
    private static final Logger log = Logger.getLogger(ConnectionManager.class.getName());

    private ConnectionManager() {}

    /**
     * Returns a connection from the HikariCP pool.
     * Initializes the pool and runs schema script on first call.
     */
    public static Connection getConnection() throws SQLException {
        if (dataSource == null) {
            synchronized (ConnectionManager.class) {
                if (dataSource == null) {
                    initializePool();
                }
            }
        }

        Connection conn = dataSource.getConnection();

        if (!isSchemaInitialized) {
            synchronized (ConnectionManager.class) {
                if (!isSchemaInitialized) {
                    runInitScript(conn);
                    isSchemaInitialized = true;
                }
            }
        }

        return conn;
    }

    private static void initializePool() {
        String url = ConfigLoader.getProperty(ConfigKeys.DB_URL);
        String user = ConfigLoader.getProperty(ConfigKeys.DB_USER);
        String pass = ConfigLoader.getProperty(ConfigKeys.DB_PWD);
        String driver = ConfigLoader.getProperty(ConfigKeys.DB_MYSQL_DRIVER, "com.mysql.cj.jdbc.Driver");

        if (url == null || user == null || pass == null) {
            throw new RuntimeException("Database configuration missing. Set DB_URL, DB_USER, DB_PASSWORD env vars or application-dev.properties");
        }

        // Ensure SSL for remote databases (Aiven requires it).
        // MySQL Connector/J 8.x uses sslMode instead of legacy useSSL/requireSSL.
        if (url.contains("aivencloud") && !url.contains("sslMode")) {
            url += url.contains("?") ? "&sslMode=REQUIRED" : "?sslMode=REQUIRED";
        }

        HikariConfig config = new HikariConfig();
        config.setJdbcUrl(url);
        config.setUsername(user);
        config.setPassword(pass);
        config.setDriverClassName(driver);

        // Pool sizing: Aiven free tier allows ~5 connections
        int poolSize = ConfigLoader.getIntProperty(ConfigKeys.DB_POOL_SIZE, 5);
        config.setMaximumPoolSize(poolSize);
        config.setMinimumIdle(2);

        // Timeouts
        config.setConnectionTimeout(ConfigLoader.getIntProperty(ConfigKeys.DB_POOL_TIMEOUT, 30000));
        config.setIdleTimeout(ConfigLoader.getIntProperty(ConfigKeys.DB_POOL_IDLE_TIMEOUT, 600000));
        config.setMaxLifetime(1800000); // 30 minutes

        // MySQL optimizations
        config.addDataSourceProperty("cachePrepStmts", "true");
        config.addDataSourceProperty("prepStmtCacheSize", "250");
        config.addDataSourceProperty("prepStmtCacheSqlLimit", "2048");
        config.addDataSourceProperty("useServerPrepStmts", "true");

        config.setPoolName("AceBankPool");

        dataSource = new HikariDataSource(config);
        log.info("HikariCP pool initialized: " + url + " (maxPoolSize=" + poolSize + ")");
    }

    /**
     * Executes the schema initialization script using plain JDBC.
     * Splits on semicolons and executes each statement individually.
     */
    private static void runInitScript(Connection conn) {
        String scriptPath = ConfigLoader.getProperty(ConfigKeys.DB_SCRIPT_PATH, "/sql/schema_initializer.sql");
        if (scriptPath == null || scriptPath.isEmpty()) {
            log.warning("No script path configured, skipping schema initialization");
            return;
        }

        String normalizedPath = scriptPath.startsWith("/") ? scriptPath : "/" + scriptPath;
        log.info("Running schema script from: " + normalizedPath);

        try (InputStream is = ConnectionManager.class.getResourceAsStream(normalizedPath)) {
            if (is == null) {
                log.warning("Schema script not found at: " + normalizedPath);
                return;
            }

            String fullScript;
            try (BufferedReader reader = new BufferedReader(new InputStreamReader(is))) {
                fullScript = reader.lines().collect(Collectors.joining("\n"));
            }

            // Split on semicolons, filter empty statements
            String[] statements = fullScript.split(";");
            int executed = 0;

            try (Statement stmt = conn.createStatement()) {
                for (String sql : statements) {
                    String trimmed = sql.trim();
                    if (!trimmed.isEmpty() && !trimmed.startsWith("--")) {
                        try {
                            stmt.execute(trimmed);
                            executed++;
                        } catch (SQLException e) {
                            // Log but continue — CREATE IF NOT EXISTS may warn on existing indexes
                            log.fine("Schema statement note: " + e.getMessage());
                        }
                    }
                }
            }

            log.info("Schema initialization complete: " + executed + " statements executed");

            // Verify tables
            try (Statement stmt = conn.createStatement();
                 var rs = stmt.executeQuery("SHOW TABLES")) {
                StringBuilder tables = new StringBuilder("Tables in database: ");
                while (rs.next()) {
                    tables.append(rs.getString(1)).append(", ");
                }
                log.info(tables.toString());
            }

        } catch (Exception e) {
            log.severe("Schema initialization error: " + e.getMessage());
        }
    }

    /**
     * Graceful shutdown of the connection pool.
     */
    public static void shutdown() {
        if (dataSource != null && !dataSource.isClosed()) {
            dataSource.close();
            log.info("HikariCP pool shut down");
        }
    }
}
