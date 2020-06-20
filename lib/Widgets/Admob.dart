import 'package:firebase_admob/firebase_admob.dart';

class AdmobAd{
  bool isConnected;
  static BannerAd _bannerAd;
  static bool isShown = false;
  static bool _isGoingToBeShown = false;
  static InterstitialAd _interstitialAd;

  static void initialize() {
    var appID = FirebaseAdMob.testAppId;
    FirebaseAdMob.instance.initialize(appId: appID);
  }
  static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    keywords: <String>['stickers'],
    //childDirected: true,
  );

  static void setBannerAd(){
    _bannerAd = BannerAd(
      adUnitId: BannerAd.testAdUnitId,
      size: AdSize.banner,
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        if (event == MobileAdEvent.loaded) {
          isShown = true;
          _isGoingToBeShown = false;
        } else if (event == MobileAdEvent.failedToLoad) {
          isShown = false;
          _isGoingToBeShown = false;
        }
      },
    );
  }

  static void showBannerAd() {
    if (_bannerAd == null) setBannerAd();
    if (!isShown && !_isGoingToBeShown) {
      _isGoingToBeShown = true;
      isShown = true;
      print(isShown);
      print(_isGoingToBeShown);
      _bannerAd
        ..load()..show(anchorOffset: 10.0);
    }
  }

  static InterstitialAd createInterstitialAd(){
    return new InterstitialAd(
        adUnitId: InterstitialAd.testAdUnitId,
        targetingInfo: targetingInfo,
        listener: (MobileAdEvent event){
        }
    );
  }

  static void hideFullScreenAd(){
    if (_interstitialAd != null && !_isGoingToBeShown) {
      _interstitialAd.dispose().then((disposed) {
        isShown = !disposed;
      });
      _isGoingToBeShown = null;
      isShown = false;
    }
  }
  static void hideBannerAd(){
    if (_bannerAd != null && !_isGoingToBeShown) {
      _bannerAd.dispose().then((disposed) {
        isShown = !disposed;
      });
      _bannerAd = null;
      isShown = false;
    }
  }
}