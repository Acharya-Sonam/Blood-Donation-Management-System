package com.blooddonationmanagementsystem.util;

import jakarta.mail.Authenticator;
import jakarta.mail.Message;
import jakarta.mail.MessagingException;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

import java.util.Properties;

public class EmailUtil {

    private static final String SMTP_HOST = get("SMTP_HOST", "smtp.gmail.com");
    private static final String SMTP_PORT = get("SMTP_PORT", "587");
    private static final String SENDER_EMAIL = get("SMTP_USERNAME", get("SENDER_EMAIL", null));
    private static final String APP_PASSWORD = get("SMTP_PASSWORD", null);

    public static boolean sendOTP(String recipientEmail, String otp) {
        if (SENDER_EMAIL == null || SENDER_EMAIL.isBlank() || APP_PASSWORD == null || APP_PASSWORD.isBlank()) {
            System.err.println("Email is not configured. Set SMTP_USERNAME (or SENDER_EMAIL) and SMTP_PASSWORD.");
            return false;
        }

        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", SMTP_HOST);
        props.put("mail.smtp.port", SMTP_PORT);

        Session session = Session.getInstance(props, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(SENDER_EMAIL, APP_PASSWORD);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(SENDER_EMAIL));
            message.setRecipients(Message.RecipientType.TO,
                    InternetAddress.parse(recipientEmail));
            message.setSubject("Password Reset OTP - Blood Bridge");
            message.setText("Your OTP is: " + otp + "\nValid for 10 minutes.");

            Transport.send(message);
            return true;

        } catch (MessagingException e) {
            e.printStackTrace();
            return false;
        }
    }

    private static String get(String key, String defaultValue) {
        String v = System.getProperty(key);
        if (v == null || v.isBlank()) {
            v = System.getenv(key);
        }
        return (v == null || v.isBlank()) ? defaultValue : v;
    }
}
