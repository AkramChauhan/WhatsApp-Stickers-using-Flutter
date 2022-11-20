
package com.indiagenisys.whatsapp_stickers_handler;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.text.TextUtils;
import android.util.Patterns;
import android.webkit.URLUtil;

import androidx.annotation.NonNull;

import java.io.File;
import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.List;

class StickerPackValidator {
    private static final int STICKER_FILE_SIZE_LIMIT_KB = 100;
    static final int EMOJI_MAX_LIMIT = 3;
    private static final int EMOJI_MIN_LIMIT = 1;
    private static final int IMAGE_HEIGHT = 512;
    private static final int IMAGE_WIDTH = 512;
    private static final int STICKER_SIZE_MIN = 3;
    private static final int STICKER_SIZE_MAX = 30;
    private static final int CHAR_COUNT_MAX = 128;
    private static final long ONE_KIBIBYTE = 8 * 1024;
    private static final int TRAY_IMAGE_FILE_SIZE_MAX_KB = 50;
    private static final int TRAY_IMAGE_DIMENSION_MIN = 24;
    private static final int TRAY_IMAGE_DIMENSION_MAX = 512;
    private static final String PLAY_STORE_DOMAIN = "play.google.com";
    private static final String APPLE_STORE_DOMAIN = "itunes.apple.com";


    /**
     * Checks whether a sticker pack contains valid data
     */
    static void verifyStickerPackValidity(@NonNull Context context, @NonNull StickerPack stickerPack) throws InvalidPackException {
        if (TextUtils.isEmpty(stickerPack.identifier)) {
            throw new InvalidPackException(InvalidPackException.EMPTY_STRING, "sticker pack identifier is empty");
        }
        if (stickerPack.identifier.length() > CHAR_COUNT_MAX) {
            throw new InvalidPackException(InvalidPackException.STRING_TOO_LONG, "sticker pack identifier cannot exceed " + CHAR_COUNT_MAX + " characters");
        }
        checkStringValidity(stickerPack.identifier);
        if (TextUtils.isEmpty(stickerPack.publisher)) {
            throw new InvalidPackException(InvalidPackException.EMPTY_STRING, "sticker pack publisher is empty, sticker pack identifier:" + stickerPack.identifier);
        }
        if (stickerPack.publisher.length() > CHAR_COUNT_MAX) {
            throw new InvalidPackException(InvalidPackException.STRING_TOO_LONG,"sticker pack publisher cannot exceed " + CHAR_COUNT_MAX + " characters, sticker pack identifier:" + stickerPack.identifier);
        }
        if (TextUtils.isEmpty(stickerPack.name)) {
            throw new InvalidPackException(InvalidPackException.EMPTY_STRING,"sticker pack name is empty, sticker pack identifier:" + stickerPack.identifier);
        }
        if (stickerPack.name.length() > CHAR_COUNT_MAX) {
            throw new InvalidPackException(InvalidPackException.STRING_TOO_LONG,"sticker pack name cannot exceed " + CHAR_COUNT_MAX + " characters, sticker pack identifier:" + stickerPack.identifier);
        }
        if (TextUtils.isEmpty(stickerPack.trayImageFile)) {
            throw new InvalidPackException(InvalidPackException.EMPTY_STRING,"sticker pack tray id is empty, sticker pack identifier:" + stickerPack.identifier);
        }
        if (!TextUtils.isEmpty(stickerPack.androidPlayStoreLink) && !isValidWebsiteUrl(stickerPack.androidPlayStoreLink)) {
            throw new InvalidPackException(InvalidPackException.INVALID_URL,"Make sure to include http or https in url links, android play store link is not a valid url: " + stickerPack.androidPlayStoreLink);
        }
        if (!TextUtils.isEmpty(stickerPack.androidPlayStoreLink) && !isURLInCorrectDomain(stickerPack.androidPlayStoreLink, PLAY_STORE_DOMAIN)) {
            throw new InvalidPackException(InvalidPackException.INVALID_URL,"android play store link should use play store domain: " + PLAY_STORE_DOMAIN);
        }
        if (!TextUtils.isEmpty(stickerPack.iosAppStoreLink) && !isValidWebsiteUrl(stickerPack.iosAppStoreLink)) {
            throw new InvalidPackException(InvalidPackException.INVALID_URL,"Make sure to include http or https in url links, ios app store link is not a valid url: " + stickerPack.iosAppStoreLink);
        }
        if (!TextUtils.isEmpty(stickerPack.iosAppStoreLink) && !isURLInCorrectDomain(stickerPack.iosAppStoreLink, APPLE_STORE_DOMAIN)) {
            throw new InvalidPackException(InvalidPackException.INVALID_URL,"iOS app store link should use app store domain: " + APPLE_STORE_DOMAIN);
        }
        if (!TextUtils.isEmpty(stickerPack.licenseAgreementWebsite) && !isValidWebsiteUrl(stickerPack.licenseAgreementWebsite)) {
            throw new InvalidPackException(InvalidPackException.INVALID_URL,"Make sure to include http or https in url links, license agreement link is not a valid url: " + stickerPack.licenseAgreementWebsite);
        }
        if (!TextUtils.isEmpty(stickerPack.privacyPolicyWebsite) && !isValidWebsiteUrl(stickerPack.privacyPolicyWebsite)) {
            throw new InvalidPackException(InvalidPackException.INVALID_URL,"Make sure to include http or https in url links, privacy policy link is not a valid url: " + stickerPack.privacyPolicyWebsite);
        }
        if (!TextUtils.isEmpty(stickerPack.publisherWebsite) && !isValidWebsiteUrl(stickerPack.publisherWebsite)) {
            throw new InvalidPackException(InvalidPackException.INVALID_URL,"Make sure to include http or https in url links, publisher website link is not a valid url: " + stickerPack.publisherWebsite);
        }
        if (!TextUtils.isEmpty(stickerPack.publisherEmail) && !Patterns.EMAIL_ADDRESS.matcher(stickerPack.publisherEmail).matches()) {
            throw new InvalidPackException(InvalidPackException.INVALID_EMAIL,"publisher email does not seem valid, email is: " + stickerPack.publisherEmail);
        }
        try {
            final byte[] bytes = StickerPackLoader.fetchStickerAsset(stickerPack.identifier, stickerPack.trayImageFile, context);
            if (bytes.length > TRAY_IMAGE_FILE_SIZE_MAX_KB * ONE_KIBIBYTE) {
                throw new InvalidPackException(InvalidPackException.INCORRECT_IMAGE_SIZE,"tray image should be less than " + TRAY_IMAGE_FILE_SIZE_MAX_KB + " KB, tray image file: " + stickerPack.trayImageFile);
            }
            Bitmap bitmap = BitmapFactory.decodeByteArray(bytes, 0, bytes.length);
            if (bitmap.getHeight() > TRAY_IMAGE_DIMENSION_MAX || bitmap.getHeight() < TRAY_IMAGE_DIMENSION_MIN) {
                throw new InvalidPackException(InvalidPackException.INCORRECT_IMAGE_SIZE,"tray image height should between " + TRAY_IMAGE_DIMENSION_MIN + " and " + TRAY_IMAGE_DIMENSION_MAX + " pixels, current tray image height is " + bitmap.getHeight() + ", tray image file: " + stickerPack.trayImageFile);
            }
            if (bitmap.getWidth() > TRAY_IMAGE_DIMENSION_MAX || bitmap.getWidth() < TRAY_IMAGE_DIMENSION_MIN) {
                throw new InvalidPackException(InvalidPackException.INCORRECT_IMAGE_SIZE,"tray image width should be between " + TRAY_IMAGE_DIMENSION_MIN + " and " + TRAY_IMAGE_DIMENSION_MAX + " pixels, current tray image width is " + bitmap.getWidth() + ", tray image file: " + stickerPack.trayImageFile);
            }
        } catch (IOException e) {
            String trayFileName = stickerPack.trayImageFile.replace("_SSP_",File.separator);
            trayFileName = trayFileName.replace("._.",File.separator);
            throw new InvalidPackException(InvalidPackException.FILE_NOT_FOUND,"Cannot open tray image, " + trayFileName);
        }
        final List<Sticker> stickers = stickerPack.getStickers();
        if (stickers.size() < STICKER_SIZE_MIN || stickers.size() > STICKER_SIZE_MAX) {
            throw new InvalidPackException(InvalidPackException.OUTSIDE_ALLOWABLE_RANGE,"sticker pack sticker count should be between 3 to 30 inclusive, it currently has " + stickers.size() + ", sticker pack identifier:" + stickerPack.identifier);
        }
        for (final Sticker sticker : stickers) {
            validateSticker(context, stickerPack.identifier, sticker);
        }
    }

    private static void validateSticker(@NonNull Context context, @NonNull final String identifier, @NonNull final Sticker sticker) throws InvalidPackException {
        if (sticker.emojis.size() > EMOJI_MAX_LIMIT) {
            throw new InvalidPackException(InvalidPackException.TOO_MANY_EMOJIS,"emoji count exceed limit, sticker pack identifier:" + identifier + ", filename:" + sticker.imageFileName);
        }
        if (sticker.emojis.size() < EMOJI_MIN_LIMIT) {
            throw new InvalidPackException(InvalidPackException.TOO_MANY_EMOJIS,"To provide best user experience, please associate at least 1 emoji to this sticker, sticker pack identifier:" + identifier + ", filename:" + sticker.imageFileName);
        }
        if (TextUtils.isEmpty(sticker.imageFileName)) {
            throw new InvalidPackException(InvalidPackException.EMPTY_STRING,"no file path for sticker, sticker pack identifier:" + identifier);
        }
        validateStickerFile(context, identifier, sticker.imageFileName);
    }

    private static void validateStickerFile(@NonNull Context context, @NonNull String identifier, @NonNull final String fileName) throws InvalidPackException {
        try {
            final byte[] bytes = StickerPackLoader.fetchStickerAsset(identifier, fileName, context);
            if (bytes.length > STICKER_FILE_SIZE_LIMIT_KB * ONE_KIBIBYTE) {
                throw new InvalidPackException(InvalidPackException.IMAGE_TOO_BIG,"sticker should be less than " + STICKER_FILE_SIZE_LIMIT_KB + "KB, sticker pack identifier:" + identifier + ", filename:" + fileName);
            }
            /*try {
                Bitmap webPImage = BitmapFactory.decodeByteArray(bytes, 0, bytes.length);
                if (webPImage.getHeight() != IMAGE_HEIGHT) {
                    throw new InvalidPackException(InvalidPackException.INCORRECT_IMAGE_SIZE,"sticker height should be " + IMAGE_HEIGHT + ", sticker pack identifier:" + identifier + ", filename:" + fileName);
                }
                if (webPImage.getWidth() != IMAGE_WIDTH) {
                    throw new InvalidPackException(InvalidPackException.INCORRECT_IMAGE_SIZE,"sticker width should be " + IMAGE_WIDTH + ", sticker pack identifier:" + identifier + ", filename:" + fileName);
                }
//                if (webPImage.getFrameCount() > 1) {
//                    throw new InvalidPackException(InvalidPackException.ANIMATED_IMAGES_NOT_SUPPORTED,"sticker should be a static image, no animated sticker support at the moment, sticker pack identifier:" + identifier + ", filename:" + fileName);
//                }
            } catch (IllegalArgumentException e) {
                throw new InvalidPackException(InvalidPackException.UNSUPPORTED_IMAGE_FORMAT,"Error parsing webp image, sticker pack identifier:" + identifier + ", filename:" + fileName);
            }*/
        } catch (IOException e) {
            String stickerFileName = fileName.replace("_SSP_",File.separator);
            stickerFileName = stickerFileName.replace("._.", File.separator);

            throw new InvalidPackException(InvalidPackException.FILE_NOT_FOUND,"cannot open sticker file: sticker pack identifier:" + identifier + ", filename:" + stickerFileName+"\n\n"+e.getMessage());
        }
    }

    private static void checkStringValidity(@NonNull String string) throws InvalidPackException  {
        String pattern = "[\\w-.,'\\s]+"; // [a-zA-Z0-9_-.' ]
        if (!string.matches(pattern)) {
            throw new InvalidPackException(InvalidPackException.OTHER,string + " contains invalid characters, allowed characters are a to z, A to Z, _ , ' - . and space character");
        }
        if (string.contains("..")) {
            throw new InvalidPackException(InvalidPackException.OTHER,string + " cannot contain ..");
        }
    }

    @SuppressWarnings("BooleanMethodIsAlwaysInverted")
    private static boolean isValidWebsiteUrl(String websiteUrl) throws InvalidPackException {
        try {
            new URL(websiteUrl);
        } catch (MalformedURLException e) {
            throw new InvalidPackException(InvalidPackException.INVALID_URL,"url: " + websiteUrl + " is malformed");
        }
        return URLUtil.isHttpUrl(websiteUrl) || URLUtil.isHttpsUrl(websiteUrl);

    }

    @SuppressWarnings("BooleanMethodIsAlwaysInverted")
    private static boolean isURLInCorrectDomain(String urlString, String domain) throws InvalidPackException {
        try {
            URL url = new URL(urlString);
            if (domain.equals(url.getHost())) {
                return true;
            }
        } catch (MalformedURLException e) {
            throw new InvalidPackException(InvalidPackException.INVALID_URL,"url: " + urlString + " is malformed");
        }
        return false;
    }
}
