package com.bloodbridge.util;

import java.util.Arrays;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class BloodCompatibilityUtil {


    private static final Map<String, List<String>> CAN_DONATE_TO;


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


    public static List<String> getCompatibleDonorTypes(String patientBloodType) {
        return CAN_RECEIVE_FROM.getOrDefault(patientBloodType, Collections.emptyList());
    }


    public static List<String> getCanDonateTo(String donorBloodType) {
        return CAN_DONATE_TO.getOrDefault(donorBloodType, Collections.emptyList());
    }


    public static boolean isCompatible(String donorBloodType, String patientBloodType) {
        List<String> compatible = getCompatibleDonorTypes(patientBloodType);
        return compatible.contains(donorBloodType);
    }


    public static String getUniversalDonor() {
        return "O-";
    }


    public static String getUniversalRecipient() {
        return "AB+";
    }


    public static boolean isUniversalDonor(String bloodType) {
        return "O-".equals(bloodType);
    }
}