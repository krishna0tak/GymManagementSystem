package p1;

import java.util.Properties;
import javax.mail.Authenticator;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

public class Emailclass {

    private static final String SENDER_EMAIL = "takkrishna95@gmail.com";
    // Gmail App Password (spaces removed)
    private static final String SENDER_PASSWORD = "kmmjcbxxiybfmfsg";

    // Stores last error so JSP can read it
    public String lastError = "";

    public boolean SendMail(String emailto, String newPassword) {
        lastError = "";

        // Try STARTTLS on port 587 first
        if (trySend(emailto, newPassword, "587", false)) {
            return true;
        }

        System.out.println("STARTTLS 587 failed: " + lastError + " — Trying SSL 465...");

        // Fallback: try SSL on port 465
        if (trySend(emailto, newPassword, "465", true)) {
            return true;
        }

        System.out.println("SSL 465 also failed: " + lastError);
        return false;
    }

    private boolean trySend(String emailto, String newPassword, String port, boolean useSSL) {
        try {
            Properties props = new Properties();
            props.put("mail.smtp.host", "smtp.gmail.com");
            props.put("mail.smtp.port", port);
            props.put("mail.smtp.auth", "true");

            if (useSSL) {
                props.put("mail.smtp.socketFactory.port", port);
                props.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
                props.put("mail.smtp.socketFactory.fallback", "false");
                props.put("mail.smtp.ssl.protocols", "TLSv1.2 TLSv1.3");
                props.put("mail.smtp.ssl.trust", "smtp.gmail.com");
            } else {
                props.put("mail.smtp.starttls.enable", "true");
                props.put("mail.smtp.starttls.required", "true");
                props.put("mail.smtp.ssl.protocols", "TLSv1.2 TLSv1.3");
                props.put("mail.smtp.ssl.trust", "smtp.gmail.com");
            }

            props.put("mail.smtp.timeout", "10000");
            props.put("mail.smtp.connectiontimeout", "10000");

            Authenticator auth = new Authenticator() {
                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(SENDER_EMAIL, SENDER_PASSWORD);
                }
            };

            Session session = Session.getInstance(props, auth);
            session.setDebug(false);

            MimeMessage msg = new MimeMessage(session);
            msg.setFrom(new InternetAddress(SENDER_EMAIL, "PowerFit Gym"));
            msg.addRecipient(MimeMessage.RecipientType.TO, new InternetAddress(emailto));
            msg.setSubject("PowerFit Gym - Your New Password");

            String body = "Dear Member,\n\n"
                    + "A password reset was requested for your PowerFit Gym account.\n\n"
                    + "Your new password is: " + newPassword + "\n\n"
                    + "Please login with this password and update it from your profile.\n\n"
                    + "If you did not request this, please contact the gym admin.\n\n"
                    + "Regards,\n"
                    + "PowerFit Gym Team";

            msg.setText(body);
            Transport.send(msg);

            System.out.println("Email sent successfully to: " + emailto + " via port " + port);
            return true;

        } catch (Exception e) {
            lastError = e.getClass().getSimpleName() + ": " + e.getMessage();
            e.printStackTrace();
            return false;
        }
    }
}
