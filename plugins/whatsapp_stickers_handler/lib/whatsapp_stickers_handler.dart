import 'dart:async';

import 'package:flutter/services.dart';

import 'exceptions.dart';

class WhatsappStickersHandler {
  static const consumerWhatsAppPackageName = 'com.whatsapp';
  static const businessWhatsAppPackageName = 'com.whatsapp.w4b';
  static const MethodChannel _channel =
      MethodChannel('whatsapp_stickers_handler');

  /// Get the platform version
  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('platformVersion');
    return version;
  }

  /// Check it whatsapp is installed or not
  static Future<bool> get isWhatsAppInstalled async {
    return await _channel.invokeMethod("isWhatsAppInstalled");
  }

  /// Check if the WhatsApp consumer package is installed
  static Future<bool> get isWhatsAppConsumerAppInstalled async {
    return await _channel.invokeMethod("isWhatsAppConsumerAppInstalled");
  }

  /// Check if the WhatsApp business package is installed
  static Future<bool> get isWhatsAppSmbAppInstalled async {
    return await _channel.invokeMethod("isWhatsAppSmbAppInstalled");
  }

  /// Launch WhatsApp
  static void launchWhatsApp() {
    _channel.invokeMethod("launchWhatsApp");
  }

  /// Check if a sticker pack is installed on WhatsApp
  ///
  /// [stickerPackIdentifier] The sticker pack identifier
  Future<bool> isStickerPackInstalled(String stickerPackIdentifier) async {
    final bool result = await _channel.invokeMethod(
        "isStickerPackInstalled", {"identifier": stickerPackIdentifier});
    return result;
  }

  /// Add a sticker pack to whatsapp.
  Future<dynamic> addStickerPack(
    identifier,
    String name,
    String publisher,
    String trayImageFileName,
    String? publisherWebsite,
    String? privacyPolicyWebsite,
    String? licenseAgreementWebsite,
    bool? animatedStickerPack,
    Map<String, List<String>> stickers,
  ) async {
    try {
      final payload = <String, dynamic>{};
      payload['identifier'] = identifier;
      payload['name'] = name;
      payload['publisher'] = publisher;
      payload['trayImageFileName'] = trayImageFileName;
      payload['publisherWebsite'] = publisherWebsite;
      payload['privacyPolicyWebsite'] = privacyPolicyWebsite;
      payload['licenseAgreementWebsite'] = licenseAgreementWebsite;
      payload['animatedStickerPack'] = animatedStickerPack;
      payload['stickers'] = stickers;
      return await _channel.invokeMethod('addStickerPack', payload);
    } on PlatformException catch (e) {
      switch (e.code) {
        case WhatsappStickersFileNotFoundException.CODE:
          throw WhatsappStickersFileNotFoundException(e.message);
        case WhatsappStickersNumOutsideAllowableRangeException.CODE:
          throw WhatsappStickersNumOutsideAllowableRangeException(e.message);
        case WhatsappStickersUnsupportedImageFormatException.CODE:
          throw WhatsappStickersUnsupportedImageFormatException(e.message);
        case WhatsappStickersImageTooBigException.CODE:
          throw WhatsappStickersImageTooBigException(e.message);
        case WhatsappStickersIncorrectImageSizeException.CODE:
          throw WhatsappStickersIncorrectImageSizeException(e.message);
        case WhatsappStickersAnimatedImagesNotSupportedException.CODE:
          throw WhatsappStickersAnimatedImagesNotSupportedException(e.message);
        case WhatsappStickersTooManyEmojisException.CODE:
          throw WhatsappStickersTooManyEmojisException(e.message);
        case WhatsappStickersEmptyStringException.CODE:
          throw WhatsappStickersEmptyStringException(e.message);
        case WhatsappStickersStringTooLongException.CODE:
          throw WhatsappStickersStringTooLongException(e.message);
        default:
          throw WhatsappStickersException(e.message);
      }
    }
  }
}

class WhatsappStickerImageHandler {
  final String path;

  WhatsappStickerImageHandler._internal(this.path);

  factory WhatsappStickerImageHandler.fromAsset(String asset) {
    return WhatsappStickerImageHandler._internal('assets://$asset');
  }

  factory WhatsappStickerImageHandler.fromFile(String file) {
    return WhatsappStickerImageHandler._internal('file://$file');
  }
}
