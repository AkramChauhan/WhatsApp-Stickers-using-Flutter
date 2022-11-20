package com.indiagenisys.whatsapp_stickers_handler;

public class InvalidPackException extends Exception {

    public static String FILE_NOT_FOUND = "FILE_NOT_FOUND";
    public static String OUTSIDE_ALLOWABLE_RANGE = "OUTSIDE_ALLOWABLE_RANGE";
    public static String UNSUPPORTED_IMAGE_FORMAT = "UNSUPPORTED_IMAGE_FORMAT";
    public static String IMAGE_TOO_BIG = "IMAGE_TOO_BIG";
    public static String INCORRECT_IMAGE_SIZE = "INCORRECT_IMAGE_SIZE";
    public static String ANIMATED_IMAGES_NOT_SUPPORTED = "ANIMATED_IMAGES_NOT_SUPPORTED";
    public static String TOO_MANY_EMOJIS = "TOO_MANY_EMOJIS";
    public static String EMPTY_STRING = "EMPTY_STRING";
    public static String STRING_TOO_LONG = "STRING_TOO_LONG";
    public static String INVALID_URL = "INVALID_URL";
    public static String INVALID_EMAIL = "INVALID_EMAIL";
    public static String OTHER = "OTHER";
    public static String FAILED = "FAILED";

    private String code;
    InvalidPackException(String code, String message){
        super(message);
        this.code = code;
    }

    String getCode(){
        return this.code;
    }

}
