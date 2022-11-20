
package com.indiagenisys.whatsapp_stickers_handler;

import android.text.TextUtils;
import android.util.JsonReader;
import android.util.Log;

import androidx.annotation.NonNull;

import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.List;

class ContentFileParser {

    private static final int LIMIT_EMOJI_COUNT = 3;

    @NonNull
    static List<StickerPack> parseStickerPacks(@NonNull InputStream contentsInputStream) throws IOException, IllegalStateException {
        try (JsonReader reader = new JsonReader(new InputStreamReader(contentsInputStream))) {
            return readStickerPacks(reader);
        }
    }

    @NonNull
    private static List<StickerPack> readStickerPacks(@NonNull JsonReader reader) throws IOException, IllegalStateException {
        List<StickerPack> stickerPackList = new ArrayList<>();
        String androidPlayStoreLink = null;
        String iosAppStoreLink = null;
        reader.beginObject();
        while (reader.hasNext()) {
            String key = reader.nextName();
            if ("android_play_store_link".equals(key)) {
                androidPlayStoreLink = reader.nextString();
            } else if ("ios_app_store_link".equals(key)) {
                iosAppStoreLink = reader.nextString();
            } else if ("sticker_packs".equals(key)) {
                reader.beginArray();
                while (reader.hasNext()) {
                    StickerPack stickerPack = readStickerPack(reader);
                    stickerPackList.add(stickerPack);
                }
                reader.endArray();
            } else {
                throw new IllegalStateException("unknown field in json: " + key);
            }
        }
        reader.endObject();
        for (StickerPack stickerPack : stickerPackList) {
            stickerPack.setAndroidPlayStoreLink(androidPlayStoreLink);
            stickerPack.setIosAppStoreLink(iosAppStoreLink);
        }
        //Log.e("StickerPackList", "READ => " + stickerPackList.toString());
        return stickerPackList;
    }

    @NonNull
    private static StickerPack readStickerPack(@NonNull JsonReader reader) throws IOException, IllegalStateException {
        reader.beginObject();
        String identifier = null;
        String name = null;
        String publisher = null;
        String trayImageFile = null;
        String publisherEmail = null;
        String publisherWebsite = null;
        String privacyPolicyWebsite = null;
        String licenseAgreementWebsite = null;
        String imageDataVersion = "";
        boolean avoidCache = false;
        boolean animatedStickerPack = false;
        List<Sticker> stickerList = null;
        while (reader.hasNext()) {
            String key = reader.nextName();
            switch (key) {
                case "identifier":
                    identifier = reader.nextString();
                    break;
                case "name":
                    name = reader.nextString();
                    break;
                case "publisher":
                    publisher = reader.nextString();
                    break;
                case "tray_image_file":
                    trayImageFile = reader.nextString();
                    break;
                case "publisher_email":
                    publisherEmail = reader.nextString();
                    break;
                case "publisher_website":
                    publisherWebsite = reader.nextString();
                    break;
                case "privacy_policy_website":
                    privacyPolicyWebsite = reader.nextString();
                    break;
                case "license_agreement_website":
                    licenseAgreementWebsite = reader.nextString();
                    break;
                case "stickers":
                    stickerList = readStickers(reader);
                    break;
                case "image_data_version":
                    imageDataVersion = reader.nextString();
                    break;
                case "avoid_cache":
                    avoidCache = reader.nextBoolean();
                    break;
                case "animated_sticker_pack":
                    animatedStickerPack = reader.nextBoolean();
                    break;
                default:
                    reader.skipValue();
            }
        }
        if (TextUtils.isEmpty(identifier)) {
            throw new IllegalStateException("identifier cannot be empty");
        }
        if (TextUtils.isEmpty(name)) {
            throw new IllegalStateException("name cannot be empty");
        }
        if (TextUtils.isEmpty(publisher)) {
            throw new IllegalStateException("publisher cannot be empty");
        }
        if (TextUtils.isEmpty(trayImageFile)) {
            throw new IllegalStateException("tray_image_file cannot be empty");
        }
        if (stickerList == null || stickerList.size() == 0) {
            throw new IllegalStateException("sticker list is empty");
        }
        if (identifier.contains("..") || identifier.contains("/")) {
            throw new IllegalStateException("identifier should not contain .. or / to prevent directory traversal");
        }
        if (TextUtils.isEmpty(imageDataVersion)) {
            throw new IllegalStateException("image_data_version should not be empty");
        }
        reader.endObject();
        final StickerPack stickerPack = new StickerPack(identifier, name, publisher, trayImageFile, publisherEmail, publisherWebsite, privacyPolicyWebsite, licenseAgreementWebsite, imageDataVersion, avoidCache, animatedStickerPack);
        stickerPack.setStickers(stickerList);
        return stickerPack;
    }

    @NonNull
    private static List<Sticker> readStickers(@NonNull JsonReader reader) throws IOException, IllegalStateException {
        reader.beginArray();
        List<Sticker> stickerList = new ArrayList<>();

        while (reader.hasNext()) {
            reader.beginObject();
            String imageFile = null;
            List<String> emojis = new ArrayList<>(LIMIT_EMOJI_COUNT);
            while (reader.hasNext()) {
                final String key = reader.nextName();
                if ("image_file".equals(key)) {
                    imageFile = reader.nextString();
                } else if ("emojis".equals(key)) {
                    reader.beginArray();
                    while (reader.hasNext()) {
                        String emoji = reader.nextString();
                        emojis.add(emoji);
                    }
                    reader.endArray();
                } else {
                    throw new IllegalStateException("unknown field in json: " + key);
                }
            }
            reader.endObject();
            if (TextUtils.isEmpty(imageFile)) {
                throw new IllegalStateException("sticker image_file cannot be empty");
            }
            if (!imageFile.endsWith(".webp")) {
                throw new IllegalStateException("image file for stickers should be webp files, image file is: " + imageFile);
            }
            stickerList.add(new Sticker(imageFile, emojis));
        }
        reader.endArray();
        return stickerList;
    }
}