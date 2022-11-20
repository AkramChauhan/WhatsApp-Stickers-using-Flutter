#import "WhatsappStickersHandlerPlugin.h"
#if __has_include(<whatsapp_stickers_handler/whatsapp_stickers_handler-Swift.h>)
#import <whatsapp_stickers_handler/whatsapp_stickers_handler-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "whatsapp_stickers_handler-Swift.h"
#endif

@implementation WhatsappStickersHandlerPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftWhatsappStickersHandlerPlugin registerWithRegistrar:registrar];
}
@end
