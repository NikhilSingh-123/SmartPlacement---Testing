package com.smartplacement.util;

public class JavaMailSimulator {
    /**
     * Simulates sending an email via SMTP.
     * Logs the email to the Tomcat console perfectly without requiring email credentials.
     */
    public static void sendEmail(String toEmail, String subject, String body) {
        System.out.println("==================================================");
        System.out.println("[EMAIL SIMULATOR] Sending Email...");
        System.out.println("TO      : " + toEmail);
        System.out.println("SUBJECT : " + subject);
        System.out.println("--------------------------------------------------");
        System.out.println(body);
        System.out.println("==================================================");
    }
}
