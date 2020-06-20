import 'package:flutter/material.dart';
import 'package:trendy_whatsapp_stickers/Widgets/Admob.dart';
import 'package:trendy_whatsapp_stickers/Widgets/Drawer.dart';
import 'package:trendy_whatsapp_stickers/sticker_list.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final String title = 'Trendy WhatsApp Stickers';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      theme: ThemeData(
        primaryColor: Colors.teal[900],
      ),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  void initState() {
    super.initState();
    AdmobAd.initialize();
    AdmobAd.showBannerAd();
  }
  @override
  void dispose() {
    AdmobAd.hideBannerAd();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> fakeBottomButtons = new List<Widget>();
    fakeBottomButtons.add(
      Container(
        height: 50.0,
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text("Trendy WhatsApp Stickers"),
      ),
      body: StaticContent(),
      drawer: Drawer(
        child: MyDrawer(),
      ),
      persistentFooterButtons: fakeBottomButtons,
    );
  }
}
