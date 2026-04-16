package com.bloodbridge.util;

import java.util.Arrays;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class BloodCompatibilityUtil {

    // ---------------------------------------------------
    // Who can donate TO whom
    // Key = donor blood type
    // Value = recipient blood types it can donate to
    // ---------------------------------------------------
    private static final Map<String, List<String>> CAN_DONATE_TO;

    // ---------------------------------------------------
    // Who can receive FROM whom
    // Key = recipient blood type
    // Value = donor blood types it can receive from
    // ---------------------------------------------------
    private static final Map<String, List<String>> CAN_RECEIVE_FROM;

    static {
        Map<String, List<String>> donateMap = new HashMap<>();
        donateMap.put("O-",  Arrays.asList("O-","O+","A-","A+","B-","B+","AB-","AB+"));
        donateMap.put("O+",  Arrays.asList("O+","A+","B+","AB+"));
        donateMap.put("A-",  Arrays.asList("A-","A+","AB-","AB+"));
        donateMap.put("A+",  Arrays.asList("A+","AB+"));
        donateMap.put("B-",  Arrays.asList("B-","B+","AB-","AB+"));
        donateMap.put("B+",  Arrays.asList("B+","AB+"));
        donateMap.put("AB-", Arrays.asList("AB-","AB+"));
        donateMap.put("AB+", Arrays.asList("AB+"));
        CAN_DONATE_TO = Collections.unmodifiableMap(donateMap);

        Map<String, List<String>> receiveMap = new HashMap<>();
        receiveMap.put("O-",  Arrays.asList("O-"));
        receiveMap.put("O+",  Arrays.asList("O-","O+"));
        receiveMap.put("A-",  Arrays.asList("O-","A-"));
        receiveMap.put("A+",  Arrays.asList("O-","O+","A-","A+"));
        receiveMap.put("B-",  Arrays.asList("O-","B-"));
        receiveMap.put("B+",  Arrays.asList("O-","O+","B-","B+"));
        receiveMap.put("AB-", Arrays.asList("O-","A-","B-","AB-"));
        receiveMap.put("AB+", Arrays.asList("O-","O+","A-","A+","B-","B+","AB-","AB+"));
        CAN_RECEIVE_FROM = Collections.unmodifiableMap(receiveMap);
    }

    // ---------------------------------------------------
    // Get compatible donor types for a patient
    // e.g. patient is A+ → returns [O-, O+, A-, A+]
    // ---------------------------------------------------
    public static List<String> getCompatibleDonorTypes(String patientBloodType) {
        return CAN_RECEIVE_FROM.getOrDefault(patientBloodType, Collections.emptyList());
    }

    // ---------------------------------------------------
    // Get who a donor can donate to
    // e.g. donor is O- → returns all 8 types
    // ---------------------------------------------------
    public static List<String> getCanDonateTo(String donorBloodType) {
        return CAN_DONATE_TO.getOrDefault(donorBloodType, Collections.emptyList());
    }

    // ---------------------------------------------------
    // Check if a donor is compatible with a patient
    // ---------------------------------------------------
    public static boolean isCompatible(String donorBloodType, String patientBloodType) {
        List<String> compatible = getCompatibleDonorTypes(patientBloodType);
        return compatible.contains(donorBloodType);
    }

    // ---------------------------------------------------
    // Get universal donor — O-
    // ---------------------------------------------------
    public static String getUniversalDonor() {
        return "O-";
    }

    // ---------------------------------------------------
    // Get universal recipient — AB+
    // ---------------------------------------------------
    public static String getUniversalRecipient() {
        return "AB+";
    }

    // ---------------------------------------------------
    // Check if donor is universal donor
    // ---------------------------------------------------
    public static boolean isUniversalDonor(String bloodType) {
        return "O-".equals(bloodType);
    }
}