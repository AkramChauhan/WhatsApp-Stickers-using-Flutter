import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:whatsapp_stickers_handler/whatsapp_stickers_handler.dart';

void main() {
  const MethodChannel channel = MethodChannel('whatsapp_stickers_handler');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await WhatsappStickersHandler.platformVersion, '42');
  });
}
