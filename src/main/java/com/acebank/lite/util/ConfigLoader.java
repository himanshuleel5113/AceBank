package com.acebank.lite.util;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;
import java.util.logging.Logger;

public class ConfigLoader {
    private static final Properties properties = new Properties();
    private static final Logger log = Logger.getLogger(ConfigLoader.class.getName());

    static {
        try (InputStream is = ConfigLoader.class.getClassLoader()
                .getResourceAsStream(ConfigKeys.DEV_PROPERTIES)) {

            if (is != null) {
                properties.load(is);
                log.info("Loaded configuration from " + ConfigKeys.DEV_PROPERTIES);
            } else {
                log.warning(ConfigKeys.DEV_PROPERTIES + " not found — relying on environment variables");
            }

        } catch (IOException e) {
            log.warning("Failed to load properties file — relying on environment variables: " + e.getMessage());
        }
    }

    /**
     * Retrieves a property value.
     * Priority: Environment Variables > Properties File > Default
     * Env var key derived from property key: db.url → DB_URL
     */
    public static String getProperty(String key) {
        // Priority 1: Check System Environment (Railway / Docker / Aiven)
        String envValue = System.getenv(key.replace(".", "_").toUpperCase());
        if (envValue != null && !envValue.isBlank()) return envValue;

        // Priority 2: Check the properties file
        return properties.getProperty(key);
    }

    /**
     * Retrieves a property value with a default fallback.
     */
    public static String getProperty(String key, String defaultValue) {
        String value = getProperty(key);
        return (value != null && !value.isBlank()) ? value : defaultValue;
    }

    /**
     * Retrieves an integer property with a default fallback.
     */
    public static int getIntProperty(String key, int defaultValue) {
        String value = getProperty(key);
        if (value == null || value.isBlank()) return defaultValue;
        try {
            return Integer.parseInt(value.trim());
        } catch (NumberFormatException e) {
            log.warning("Invalid integer for key " + key + ": " + value);
            return defaultValue;
        }
    }
}
