
package com.indiagenisys.whatsapp_stickers_handler;

import android.os.Parcel;
import android.os.Parcelable;

import java.util.List;

class StickerPack implements Parcelable {
    final String identifier;
    final String name;
    final String publisher;
    String trayImageFile;
    final String publisherEmail;
    final String publisherWebsite;
    final String privacyPolicyWebsite;
    final String licenseAgreementWebsite;
    String imageDataVersion;
    final boolean avoidCache;
    final boolean animatedStickerPack;

    String iosAppStoreLink;
    private List<Sticker> stickers;
    private long totalSize;
    String androidPlayStoreLink;
    private boolean isWhitelisted;

    StickerPack(String identifier, String name, String publisher, String trayImageFile, String publisherEmail, String publisherWebsite, String privacyPolicyWebsite, String licenseAgreementWebsite, String imageDataVersion, boolean avoidCache, boolean animatedStickerPack) {
        this.identifier = identifier;
        this.name = name;
        this.publisher = publisher;
        this.trayImageFile = trayImageFile;
        this.publisherEmail = publisherEmail;
        this.publisherWebsite = publisherWebsite;
        this.privacyPolicyWebsite = privacyPolicyWebsite;
        this.licenseAgreementWebsite = licenseAgreementWebsite;
        this.imageDataVersion = imageDataVersion;
        this.avoidCache = avoidCache;
        this.animatedStickerPack = animatedStickerPack;
    }

    void setIsWhitelisted(boolean isWhitelisted) {
        this.isWhitelisted = isWhitelisted;
    }

    boolean getIsWhitelisted() {
        return isWhitelisted;
    }

    private StickerPack(Parcel in) {
        identifier = in.readString();
        name = in.readString();
        publisher = in.readString();
        trayImageFile = in.readString();
        publisherEmail = in.readString();
        publisherWebsite = in.readString();
        privacyPolicyWebsite = in.readString();
        licenseAgreementWebsite = in.readString();
        iosAppStoreLink = in.readString();
        stickers = in.createTypedArrayList(Sticker.CREATOR);
        totalSize = in.readLong();
        androidPlayStoreLink = in.readString();
        isWhitelisted = in.readByte() != 0;
        imageDataVersion = in.readString();
        avoidCache = in.readByte() != 0;
        animatedStickerPack = in.readByte() != 0;
    }

    public static final Creator<StickerPack> CREATOR = new Creator<StickerPack>() {
        @Override
        public StickerPack createFromParcel(Parcel in) {
            return new StickerPack(in);
        }

        @Override
        public StickerPack[] newArray(int size) {
            return new StickerPack[size];
        }
    };

    void setStickers(List<Sticker> stickers) {
        this.stickers = stickers;
        totalSize = 0;
        for (Sticker sticker : stickers) {
            totalSize += sticker.size;
        }
    }

    void setAndroidPlayStoreLink(String androidPlayStoreLink) {
        this.androidPlayStoreLink = androidPlayStoreLink;
    }

    void setIosAppStoreLink(String iosAppStoreLink) {
        this.iosAppStoreLink = iosAppStoreLink;
    }

    List<Sticker> getStickers() {
        return stickers;
    }

    long getTotalSize() {
        return totalSize;
    }

    Sticker getStickerByNameMatcher(String matcher) {
        for (int i = 0; i < getStickers().size(); i++) {
            Sticker sticker = getStickers().get(i);
            if (sticker.imageFileName.contains(matcher)) {
                return sticker;
            }
        }
        return null;
    }

    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public String toString() {
        return "StickerPack{" +
                "identifier='" + identifier + '\'' +
                ", name='" + name + '\'' +
                ", publisher='" + publisher + '\'' +
                ", trayImageFile='" + trayImageFile + '\'' +
                ", publisherEmail='" + publisherEmail + '\'' +
                ", publisherWebsite='" + publisherWebsite + '\'' +
                ", privacyPolicyWebsite='" + privacyPolicyWebsite + '\'' +
                ", licenseAgreementWebsite='" + licenseAgreementWebsite + '\'' +
                ", imageDataVersion='" + imageDataVersion + '\'' +
                ", avoidCache=" + avoidCache +
                ", animatedStickerPack=" + animatedStickerPack +
                ", iosAppStoreLink='" + iosAppStoreLink + '\'' +
                ", stickers=" + stickers +
                ", totalSize=" + totalSize +
                ", androidPlayStoreLink='" + androidPlayStoreLink + '\'' +
                ", isWhitelisted=" + isWhitelisted +
                '}';
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeString(identifier);
        dest.writeString(name);
        dest.writeString(publisher);
        dest.writeString(trayImageFile);
        dest.writeString(publisherEmail);
        dest.writeString(publisherWebsite);
        dest.writeString(privacyPolicyWebsite);
        dest.writeString(licenseAgreementWebsite);
        dest.writeString(iosAppStoreLink);
        dest.writeTypedList(stickers);
        dest.writeLong(totalSize);
        dest.writeString(androidPlayStoreLink);
        dest.writeByte((byte) (isWhitelisted ? 1 : 0));
        dest.writeString(imageDataVersion);
        dest.writeByte((byte) (avoidCache ? 1 : 0));
        dest.writeByte((byte) (animatedStickerPack ? 1 : 0));
    }
}