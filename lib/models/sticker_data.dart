class StickerData {
  String? androidPlayStoreLink;
  String? iosAppStoreLink;
  List<StickerPacks>? stickerPacks;

  StickerData(
      {this.androidPlayStoreLink, this.iosAppStoreLink, this.stickerPacks});

  StickerData.fromJson(Map<String, dynamic> json) {
    androidPlayStoreLink = json['android_play_store_link'];
    iosAppStoreLink = json['ios_app_store_link'];
    if (json['sticker_packs'] != null) {
      stickerPacks = <StickerPacks>[];
      json['sticker_packs'].forEach((v) {
        stickerPacks!.add(StickerPacks.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['android_play_store_link'] = androidPlayStoreLink;
    data['ios_app_store_link'] = iosAppStoreLink;
    if (stickerPacks != null) {
      data['sticker_packs'] = stickerPacks!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  String toString() {
    return "androidPlayStoreLink: $androidPlayStoreLink, iosAppStoreLink: $iosAppStoreLink";
  }
}

class StickerPacks {
  String? identifier;
  String? name;
  String? publisher;
  String? trayImageFile;
  String? imageDataVersion;
  bool? avoidCache;
  String? publisherEmail;
  String? publisherWebsite;
  String? privacyPolicyWebsite;
  String? licenseAgreementWebsite;
  List<Stickers>? stickers;
  bool? animatedStickerPack;
  bool isInstalled = false;

  StickerPacks(
      {this.identifier,
        this.name,
        this.publisher,
        this.trayImageFile,
        this.imageDataVersion,
        this.avoidCache,
        this.publisherEmail,
        this.publisherWebsite,
        this.privacyPolicyWebsite,
        this.licenseAgreementWebsite,
        this.stickers,
        this.animatedStickerPack});

  StickerPacks.fromJson(Map<String, dynamic> json) {
    identifier = json['identifier'];
    name = json['name'];
    publisher = json['publisher'];
    trayImageFile = json['tray_image_file'];
    imageDataVersion = json['image_data_version'];
    avoidCache = json['avoid_cache'];
    publisherEmail = json['publisher_email'];
    publisherWebsite = json['publisher_website'];
    privacyPolicyWebsite = json['privacy_policy_website'];
    licenseAgreementWebsite = json['license_agreement_website'];
    if (json['stickers'] != null) {
      stickers = <Stickers>[];
      json['stickers'].forEach((v) {
        stickers!.add(Stickers.fromJson(v));
      });
    }
    animatedStickerPack = json['animated_sticker_pack'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['identifier'] = identifier;
    data['name'] = name;
    data['publisher'] = publisher;
    data['tray_image_file'] = trayImageFile;
    data['image_data_version'] = imageDataVersion;
    data['avoid_cache'] = avoidCache;
    data['publisher_email'] = publisherEmail;
    data['publisher_website'] = publisherWebsite;
    data['privacy_policy_website'] = privacyPolicyWebsite;
    data['license_agreement_website'] = licenseAgreementWebsite;
    if (stickers != null) {
      data['stickers'] = stickers!.map((v) => v.toJson()).toList();
    }
    data['animated_sticker_pack'] = animatedStickerPack;
    return data;
  }

  @override
  String toString() {
    // TODO: implement toString
    return "identifier: $identifier, name: $name, publisher: $publisher";
  }
}

class Stickers {
  String? imageFile;
  List<String>? emojis;

  Stickers({this.imageFile, this.emojis});

  Stickers.fromJson(Map<String, dynamic> json) {
    imageFile = json['image_file'];
    emojis = json['emojis'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['image_file'] = imageFile;
    data['emojis'] = emojis;
    return data;
  }
}