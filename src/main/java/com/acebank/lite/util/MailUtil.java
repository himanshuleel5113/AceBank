package com.acebank.lite.util;

import jakarta.mail.*;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import lombok.extern.java.Log;

import java.util.Properties;
import java.util.concurrent.CompletableFuture;

@Log
public class MailUtil {

    public static void sendMailAsync(String recipient, String subject, String body) {
        CompletableFuture.runAsync(() -> {
            try {
                sendMail(recipient, subject, body);
            } catch (Exception e) {
                log.warning("Background email failed: " + e.getMessage());
            }
        });
    }

    public static boolean sendMail(final String recipient, String subject, String body) {
        log.info("Attempting to send email to: " + recipient);

        try {
            // Get email configuration
            String fromAddr = ConfigLoader.getProperty(ConfigKeys.MAIL_ADDR);
            String password = ConfigLoader.getProperty(ConfigKeys.MAIL_PWD);
            String host = ConfigLoader.getProperty(ConfigKeys.MAIL_SMTP_HOST);
            String port = ConfigLoader.getProperty(ConfigKeys.MAIL_SMTP_PORT);

            log.info("Email Config - From: " + fromAddr + ", Host: " + host + ", Port: " + port);

            if (fromAddr == null || fromAddr.isEmpty() || password == null || password.isEmpty()) {
                log.severe("Email configuration missing. Check MAIL_ADDR and MAIL_PWD in properties");
                return false;
            }

            Properties props = new Properties();
            props.put("mail.smtp.host", host);
            props.put("mail.smtp.port", port);
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.starttls.enable", "true");
            props.put("mail.smtp.connectiontimeout", "5000");
            props.put("mail.smtp.timeout", "5000");
            props.put("mail.debug", "true"); // Enable debug mode

            Session session = Session.getInstance(props, new Authenticator() {
                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(fromAddr, password);
                }
            });

            session.setDebug(true); // Print debug info

            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(fromAddr, "AceBank Support"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipient));
            message.setSubject(subject);
            message.setText(body);

            Transport.send(message);
            log.info("Email sent successfully to " + recipient);
            return true;

        } catch (Exception e) {
            log.severe("Failed to send email: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
}