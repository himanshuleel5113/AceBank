package com.acebank.lite.service;

import lombok.extern.java.Log;

import java.security.SecureRandom;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@Log
public class OTPService {
    
    private static final Map<String, OTPData> otpMap = new ConcurrentHashMap<>();
    private static final SecureRandom random = new SecureRandom();
    private static final int OTP_EXPIRY_MINUTES = 10;
    
    public static class OTPData {
        private final String otp;
        private final long expiryTime;
        private final int accountNo;
        private final String email;
        private boolean verified;
        
        public OTPData(String otp, int accountNo, String email) {
            this.otp = otp;
            this.accountNo = accountNo;
            this.email = email;
            this.expiryTime = System.currentTimeMillis() + (OTP_EXPIRY_MINUTES * 60 * 1000);
            this.verified = false;
        }
        
        public String getOtp() { return otp; }
        public long getExpiryTime() { return expiryTime; }
        public int getAccountNo() { return accountNo; }
        public String getEmail() { return email; }
        public boolean isVerified() { return verified; }
        public void setVerified(boolean verified) { this.verified = verified; }
        public boolean isExpired() { return System.currentTimeMillis() > expiryTime; }
    }
    
    public static String generateOTP(int accountNo, String email) {
        // Generate 6-digit OTP
        int otpNumber = 100000 + random.nextInt(900000);
        String otp = String.valueOf(otpNumber);
        
        OTPData otpData = new OTPData(otp, accountNo, email);
        otpMap.put(email, otpData);
        
        log.info("OTP generated for email: " + email + " (valid for " + OTP_EXPIRY_MINUTES + " minutes)");
        return otp;
    }
    
    public static boolean validateOTP(String email, String otp) {
        OTPData otpData = otpMap.get(email);
        
        if (otpData == null) {
            log.warning("No OTP found for email: " + email);
            return false;
        }
        
        if (otpData.isExpired()) {
            log.warning("OTP expired for email: " + email);
            otpMap.remove(email);
            return false;
        }
        
        if (!otpData.getOtp().equals(otp)) {
            log.warning("Invalid OTP for email: " + email);
            return false;
        }
        
        // Mark as verified
        otpData.setVerified(true);
        log.info("OTP verified successfully for email: " + email);
        return true;
    }
    
    public static boolean isVerified(String email) {
        OTPData otpData = otpMap.get(email);
        return otpData != null && otpData.isVerified() && !otpData.isExpired();
    }
    
    public static OTPData getOTPData(String email) {
        return otpMap.get(email);
    }
    
    public static void clearOTP(String email) {
        otpMap.remove(email);
        log.info("OTP cleared for email: " + email);
    }
}