import 'package:flutter/material.dart';
import 'package:trendy_whatsapp_stickers/constants/constants.dart';
import 'package:trendy_whatsapp_stickers/models/sticker_data.dart';
import 'package:trendy_whatsapp_stickers/screens/sticker_pack_info.dart';
import 'package:whatsapp_stickers_handler/exceptions.dart';
import 'package:whatsapp_stickers_handler/whatsapp_stickers_handler.dart';

class StickerPackItem extends StatelessWidget {
  final StickerPacks stickerPack;
  final String stickerFetchType;
  StickerPackItem({
    Key? key,
    required this.stickerPack,
    required this.stickerFetchType,
  }) : super(key: key);

  Widget addStickerPackButton(
      bool isInstalled, WhatsappStickersHandler _whatsappStickersHandler) {
    stickerPack.isInstalled = isInstalled;

    return IconButton(
      icon: Icon(
        isInstalled ? Icons.check : Icons.add,
      ),
      color: Colors.teal,
      tooltip: isInstalled
          ? 'Add Sticker to WhatsApp'
          : 'Sticker is added to WhatsApp',
      onPressed: () async {
        Map<String, List<String>> stickers = <String, List<String>>{};
        var tryImage = '';
        for (var e in stickerPack.stickers!) {
          stickers[WhatsappStickerImageHandler.fromAsset(
                  "sticker_packs/${stickerPack.identifier}/${e.imageFile as String}")
              .path] = e.emojis as List<String>;
        }
        tryImage = WhatsappStickerImageHandler.fromAsset(
                "sticker_packs/${stickerPack.identifier}/${stickerPack.trayImageFile}")
            .path;
        try {
          await _whatsappStickersHandler.addStickerPack(
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
        } on WhatsappStickersException catch (e) {
          print(e.cause);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    final WhatsappStickersHandler _whatsappStickersHandler =
        WhatsappStickersHandler();
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SizedBox(
        child: ListTile(
          onTap: () {
            Navigator.of(context)
                .pushNamed(StickerPackInfoScreen.routeName, arguments: {
              'stickerPack': stickerPack,
              'stickerFetchType': stickerFetchType,
            });
          },
          title: Text(stickerPack.name ?? ""),
          subtitle: Text(stickerPack.publisher ?? ""),
          leading: stickerFetchType == "remoteStickers"
              ? FadeInImage(
                  placeholder: const AssetImage("assets/images/loading.gif"),
                  image: NetworkImage(
                      "${BASE_URL}/${stickerPack.identifier}/${stickerPack.trayImageFile}"),
                )
              : Image.asset(
                  "sticker_packs/${stickerPack.identifier}/${stickerPack.trayImageFile}"),
          trailing: FutureBuilder(
              future: _whatsappStickersHandler
                  .isStickerPackInstalled(stickerPack.identifier as String),
              builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                return snapshot.connectionState == ConnectionState.waiting || snapshot.data == null
                    ? const Text("+")
                    : addStickerPackButton(
                        snapshot.data as bool,
                        _whatsappStickersHandler,
                      );
              }),
        ),
      ),
    );
  }
}
