import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_whatsapp_stickers/flutter_whatsapp_stickers.dart';
import 'package:trendy_whatsapp_stickers/utils.dart';

class StickerPackInformation extends StatefulWidget {
  final List stickerPack;

  StickerPackInformation(this.stickerPack);
  @override
  _StickerPackInformationState createState() => _StickerPackInformationState(stickerPack);
}

class _StickerPackInformationState extends State<StickerPackInformation> {
  List stickerPack;
  final WhatsAppStickers _waStickers = WhatsAppStickers();

  _StickerPackInformationState(this. stickerPack);  //constructor

  void _checkInstallationStatuses() async {
    print("Total Stickers : ${stickerPack.length}");
    var tempName = stickerPack[0];
    bool tempInstall = await WhatsAppStickers().isStickerPackInstalled(tempName);

    if(tempInstall==true){
      if(!stickerPack[6].contains(tempName)){
        setState(() {
          stickerPack[6].add(tempName);
        });
      }
    }else{
      if(stickerPack[6].contains(tempName)){
        setState(() {
          stickerPack[6].remove(tempName);
        });
      }
    }
    print("${stickerPack[6]}");
  }

  @override
  Widget build(BuildContext context) {
    List totalStickers = stickerPack[4];
    List<Widget> fakeBottomButtons = new List<Widget>();
    fakeBottomButtons.add(
      Container(
        height: 50.0,
      ),
    );
    Widget depInstallWidget;
    if (stickerPack[5]==true) {
      depInstallWidget =  Padding(
        padding: const EdgeInsets.symmetric(vertical:8.0),
        child: Text("Sticker Added",style: TextStyle(
            color: Colors.green,
            fontSize: 16.0,
            fontWeight: FontWeight.bold
        ),),
      );
    } else {
      depInstallWidget =RaisedButton(
        child: Text("Add Sticker"),
        textColor: Colors.white,
        color: Colors.teal[900],
        onPressed: () async {
          _waStickers.addStickerPack(
            packageName: WhatsAppPackage.Consumer,
            stickerPackIdentifier: stickerPack[0],
            stickerPackName: stickerPack[1],
            listener: (action, result, {error}) => processResponse(
              action: action,
              result: result,
              error: error,
              successCallback: () async{
                setState(() {
                  _checkInstallationStatuses();
                });
              },
              context: context,
            ),
          );
        },
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("${stickerPack[1]} Stickers"),
      ),
      body: Column(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Image.asset("sticker_packs/${stickerPack[0]}/${stickerPack[3]}",
                  width: 100,
                  height: 100,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("${stickerPack[1]}",style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal[900],
                    ),),
                    Text("${stickerPack[2]}",style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.black54,
                    ),),
                    depInstallWidget,
                  ],
                ),
              )

            ],
          ),
          Expanded(
            child: GridView.builder(
                gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 1,
                ),
                itemCount: totalStickers.length,
                itemBuilder: (context, index) {
                  var stickerImg = "sticker_packs/${stickerPack[0]}/${totalStickers[index]['image_file']}";
                  return Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Image.asset(stickerImg,
                      width:100,
                      height: 100,
                    ),
                  );
                }
            ),
          ),
        ],
      ),
      persistentFooterButtons: fakeBottomButtons,

    );
  }
}
