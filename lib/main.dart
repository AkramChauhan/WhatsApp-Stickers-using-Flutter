import 'package:flutter/material.dart';
import 'package:trendy_whatsapp_stickers/screens/information_screen.dart';
import 'package:trendy_whatsapp_stickers/screens/sticker_pack_info.dart';
import 'package:trendy_whatsapp_stickers/screens/stickers_screen.dart';

enum PopupMenuOptions {
  staticStickers,
  remoteStickers,
  informations,
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Trendy WhatsApp Stickers",
      initialRoute: StickersScreen.routeName,
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      debugShowCheckedModeBanner: false,
      routes: {
        StickersScreen.routeName: (ctx) => const StickersScreen(),
        StickerPackInfoScreen.routeName: (ctx) => const StickerPackInfoScreen(),
        InformationScreen.routeName: (ctx) => const InformationScreen()
      },
    );
  }
}