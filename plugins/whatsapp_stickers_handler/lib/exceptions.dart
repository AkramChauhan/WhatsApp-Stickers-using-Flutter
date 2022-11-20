class WhatsappStickersException implements Exception {
  final String? cause;

  WhatsappStickersException(this.cause);
}

class WhatsappStickersFileNotFoundException extends WhatsappStickersException {
  static const String CODE = 'FILE_NOT_FOUND';

  final String? cause;

  WhatsappStickersFileNotFoundException(this.cause) : super('');
}

class WhatsappStickersNumOutsideAllowableRangeException
    extends WhatsappStickersException {
  static const String CODE = 'OUTSIDE_ALLOWABLE_RANGE';

  final String? cause;

  WhatsappStickersNumOutsideAllowableRangeException(this.cause) : super('');
}

class WhatsappStickersUnsupportedImageFormatException
    extends WhatsappStickersException {
  static const String CODE = 'UNSUPPORTED_IMAGE_FORMAT';

  final String? cause;

  WhatsappStickersUnsupportedImageFormatException(this.cause) : super('');
}

class WhatsappStickersImageTooBigException extends WhatsappStickersException {
  static const String CODE = 'IMAGE_TOO_BIG';

  final String? cause;

  WhatsappStickersImageTooBigException(this.cause) : super('');
}

class WhatsappStickersIncorrectImageSizeException
    extends WhatsappStickersException {
  static const String CODE = 'INCORRECT_IMAGE_SIZE';

  final String? cause;

  WhatsappStickersIncorrectImageSizeException(this.cause) : super('');
}

class WhatsappStickersAnimatedImagesNotSupportedException
    extends WhatsappStickersException {
  static const String CODE = 'ANIMATED_IMAGES_NOT_SUPPORTED';

  final String? cause;

  WhatsappStickersAnimatedImagesNotSupportedException(this.cause) : super('');
}

class WhatsappStickersTooManyEmojisException extends WhatsappStickersException {
  static const String CODE = 'TOO_MANY_EMOJIS';

  final String? cause;

  WhatsappStickersTooManyEmojisException(this.cause) : super('');
}

class WhatsappStickersEmptyStringException extends WhatsappStickersException {
  static const String CODE = 'EMPTY_STRING';

  final String? cause;

  WhatsappStickersEmptyStringException(this.cause) : super('');
}

class WhatsappStickersStringTooLongException extends WhatsappStickersException {
  static const String CODE = 'STRING_TOO_LONG';

  final String? cause;
  WhatsappStickersStringTooLongException(this.cause) : super('');
}
