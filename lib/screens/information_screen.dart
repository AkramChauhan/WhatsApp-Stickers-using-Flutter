import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:whatsapp_stickers_handler/whatsapp_stickers_handler.dart';

class InformationScreen extends StatefulWidget {
  static const routeName = 'information';

  const InformationScreen({Key? key}) : super(key: key);

  @override
  State<InformationScreen> createState() => _InformationScreenState();
}

class _InformationScreenState extends State<InformationScreen> {
  String _platformVersion = 'Unknown';
  bool _whatsAppInstalled = false;
  bool _whatsAppConsumerAppInstalled = false;
  bool _whatsAppSmbAppInstalled = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    String platformVersion;

    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = (await WhatsappStickersHandler.platformVersion)!;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    bool whatsAppInstalled = await WhatsappStickersHandler.isWhatsAppInstalled;
    bool whatsAppConsumerAppInstalled =
    await WhatsappStickersHandler.isWhatsAppConsumerAppInstalled;
    bool whatsAppSmbAppInstalled =
    await WhatsappStickersHandler.isWhatsAppSmbAppInstalled;

    setState(() {
      _platformVersion = platformVersion;
      _whatsAppInstalled = whatsAppInstalled;
      _whatsAppConsumerAppInstalled = whatsAppConsumerAppInstalled;
      _whatsAppSmbAppInstalled = whatsAppSmbAppInstalled;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Informations")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 100),
            Text('Running on: $_platformVersion'),
            const SizedBox(height: 10),
            Text("WhatsApp Installed: $_whatsAppInstalled"),
            const SizedBox(height: 10),
            Text("WhatsApp Consumer Installed: $_whatsAppConsumerAppInstalled"),
            const SizedBox(height: 10),
            Text("WhatsApp Business Installed: $_whatsAppSmbAppInstalled"),
            const SizedBox(height: 10),
            TextButton(
                onPressed: () {
                  WhatsappStickersHandler.launchWhatsApp();
                },
                child: const Text("Open WhatsApp"))
          ],
        ),
      ),
    );
  }
}