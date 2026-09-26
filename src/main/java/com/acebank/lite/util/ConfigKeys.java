package com.acebank.lite.util;

public class ConfigKeys {

    // The filename
    public static final String DEV_PROPERTIES = "application-dev.properties";

    // Email Auth Keys
    public static final String MAIL_ADDR = "mail.default.address";
    public static final String MAIL_PWD = "mail.google.app.password";

    // SMTP Server Keys
    public static final String MAIL_SMTP_HOST = "mail.smtp.host";
    public static final String MAIL_SMTP_PORT = "mail.smtp.port";
    public static final String MAIL_SMTP_AUTH = "mail.smtp.auth";
    public static final String MAIL_SMTP_STARTTLS = "mail.smtp.starttls.enable";
    public static final String MAIL_SMTP_CONN_TIMEOUT = "mail.smtp.connection-timeout";
    public static final String MAIL_SMTP_TIMEOUT = "mail.smtp.timeout";

    // Database Keys
    public static final String DB_URL = "db.url";
    public static final String DB_USER = "db.user";
    public static final String DB_PWD = "db.password";
    public static final String DB_SCRIPT_PATH = "db.script.path";
    public static final String DB_MYSQL_DRIVER = "db.mysql.driver";

    // HikariCP Pool Settings
    public static final String DB_POOL_SIZE = "db.pool.size";
    public static final String DB_POOL_TIMEOUT = "db.pool.timeout";
    public static final String DB_POOL_IDLE_TIMEOUT = "db.pool.idle.timeout";

    // Application
    public static final String APP_BASE_URL = "app.base.url";
    public static final String OTP_EXPIRY_MINUTES = "otp.expiry.minutes";
}
