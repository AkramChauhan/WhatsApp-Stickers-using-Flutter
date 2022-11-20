import 'dart:io';

import 'package:flutter/material.dart';
import 'package:trendy_whatsapp_stickers/Widgets/Drawer.dart';
import 'package:trendy_whatsapp_stickers/constants/constants.dart';
import 'package:whatsapp_stickers_handler/exceptions.dart';
import 'package:whatsapp_stickers_handler/whatsapp_stickers_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:trendy_whatsapp_stickers/models/sticker_data.dart';

class StickerPackInfoScreen extends StatefulWidget {
  static const routeName = '/sticker-pack-info';

  const StickerPackInfoScreen({Key? key}) : super(key: key);

  @override
  State<StickerPackInfoScreen> createState() => _StickerPackInfoScreenState();
}

class _StickerPackInfoScreenState extends State<StickerPackInfoScreen> {
  Future<void> addStickerPack() async {}

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments as Map;

    final StickerPacks stickerPack = arguments['stickerPack'] as StickerPacks;
    final String stickerFetchType = arguments['stickerFetchType'] as String;

    List<Widget> fakeBottomButtons = [];
    fakeBottomButtons.add(
      Container(
        height: 50.0,
      ),
    );
    Widget depInstallWidget;
    if (stickerPack.isInstalled) {
      depInstallWidget = const Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: Text(
          "Sticker Added",
          style: TextStyle(
              color: Colors.green, fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
      );
    } else {
      depInstallWidget = ElevatedButton(
        child: const Text("Add Sticker"),
        onPressed: () async {
          Map<String, List<String>> stickers = <String, List<String>>{};
          var tryImage = '';
          if (stickerFetchType == 'staticStickers') {
            for (var e in stickerPack.stickers!) {
              stickers[WhatsappStickerImageHandler.fromAsset(
                      "sticker_packs/${stickerPack.identifier}/${e.imageFile as String}")
                  .path] = e.emojis as List<String>;
            }
            tryImage = WhatsappStickerImageHandler.fromAsset(
                    "sticker_packs/${stickerPack.identifier}/${stickerPack.trayImageFile}")
                .path;
          } else {
            final dio = Dio();
            final downloads = <Future>[];
            var applicationDocumentsDirectory =
                await getApplicationDocumentsDirectory();
            var stickersDirectory = Directory(
                //'${applicationDocumentsDirectory.path}/stickers/${stickerPack.identifier}');
                '${applicationDocumentsDirectory.path}/${stickerPack.identifier}');
            await stickersDirectory.create(recursive: true);

            downloads.add(
              dio.download(
                "${BASE_URL}${stickerPack.identifier}/${stickerPack.trayImageFile}",
                "${stickersDirectory.path}/${stickerPack.trayImageFile!.toLowerCase()}",
              ),
            );
            tryImage = WhatsappStickerImageHandler.fromFile(
                    "${stickersDirectory.path}/${stickerPack.trayImageFile!.toLowerCase()}")
                .path;

            for (var e in stickerPack.stickers!) {
              var urlPath =
                  "${BASE_URL}${stickerPack.identifier}/${(e.imageFile as String)}";
              var savePath =
                  "${stickersDirectory.path}/${(e.imageFile as String).toLowerCase()}";
              downloads.add(
                dio.download(
                  urlPath,
                  savePath,
                ),
              );

              stickers[WhatsappStickerImageHandler.fromFile(
                      "${stickersDirectory.path}/${(e.imageFile as String).toLowerCase()}")
                  .path] = e.emojis as List<String>;
            }

            await Future.wait(downloads);
          }

          try {
            final WhatsappStickersHandler _whatsappStickersHandler =
                WhatsappStickersHandler();
            var result = await _whatsappStickersHandler.addStickerPack(
              stickerPack.identifier,
              stickerPack.name as String,
              stickerPack.publisher as String,
              tryImage,
              stickerPack.publisherWebsite,
              stickerPack.privacyPolicyWebsite,
              stickerPack.licenseAgreementWebsite,
              stickerPack.animatedStickerPack ?? false,
              stickers,
            );
            print("RESULT $result");
          } on WhatsappStickersException catch (e) {
            print("INSIDE WhatsappStickersException ${e.cause}");
            var exceptionMessage = e.cause;
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(exceptionMessage.toString())
            ));
          } catch (e) {
            print("Exception ${e.toString()}");
          }
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(stickerPack.name.toString() + " Stickers"),
      ),
      drawer: Drawer(
        child: MyDrawer(),
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                TextButton(
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                Text(
                  "All Stickers",
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: stickerFetchType == "remoteStickers"
                    ? FadeInImage(
                        placeholder:
                            const AssetImage("assets/images/loading.gif"),
                        image: NetworkImage(
                            "${BASE_URL}/${stickerPack.identifier}/${stickerPack.trayImageFile}"),
                        height: 100,
                        width: 100,
                      )
                    : Image.asset(
                        "sticker_packs/${stickerPack.identifier}/${stickerPack.trayImageFile}",
                        width: 100,
                        height: 100,
                      ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 20.0, horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      stickerPack.name as String,
                      style: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    Text(
                      stickerPack.publisher as String,
                      style: const TextStyle(
                        fontSize: 14.0,
                        color: Colors.black54,
                      ),
                    ),
                    depInstallWidget,
                  ],
                ),
              )
            ],
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 1,
              ),
              itemCount: stickerPack.stickers!.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: stickerFetchType == "remoteStickers"
                      ? FadeInImage(
                          placeholder:
                              const AssetImage("assets/images/loading.gif"),
                          image: NetworkImage(
                              "${BASE_URL}${stickerPack.identifier}/${stickerPack.stickers![index].imageFile as String}"),
                        )
                      : Image.asset(
                          "sticker_packs/${stickerPack.identifier}/${stickerPack.stickers![index].imageFile as String}"),
                );
              },
            ),
          )
        ],
      ),
      persistentFooterButtons: fakeBottomButtons,
    );
  }
}
