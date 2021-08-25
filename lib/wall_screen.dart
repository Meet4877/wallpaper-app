import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:Wally/fullscreen_image.dart';
import 'package:firebase_admob/firebase_admob.dart';

const String testdevice='';

class WallScreen extends StatefulWidget {
  @override
  _WallScreenState createState() => _WallScreenState();
}

class _WallScreenState extends State<WallScreen> {

  static final MobileAdTargetingInfo targetingInfo= new MobileAdTargetingInfo(
    testDevices: <String>[],
    keywords: <String>['wallpaper','walls','amoled','anime','naruto'],
    birthday:new DateTime.now(),
    childDirected:true,
  );

//  BannerAd _bannerAD;
  InterstitialAd _interstitialAd;


  StreamSubscription<QuerySnapshot> subscription;
  List<DocumentSnapshot> WallpaperList;
  final CollectionReference collectionReference=Firestore.instance.collection("wallpaper");

//  BannerAd createBannerAD(){
//    return new BannerAd(adUnitId:"ca-app-pub-" ,
//        size: AdSize.banner,
//        targetingInfo: targetingInfo,
//        listener: (MobileAdEvent event){
//          print("interstitial Event:$event");
//        }
//    );
//  }
  InterstitialAd createinterstitialAD(){
    return new InterstitialAd(adUnitId: "",

        targetingInfo: targetingInfo,
        listener: (MobileAdEvent event){
          print("inters Event:$event");
        }
    );
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseAdMob.instance.initialize(appId: "");
//    _bannerAD = createBannerAD()..load()..show();
    subscription=collectionReference.snapshots().listen((datasnapshot)=>{
      setState((){
        WallpaperList = datasnapshot.documents;
    }),
    });
  }
  @override
  void dispose() {
//    _bannerAD?.dispose();
    _interstitialAd.dispose();
    subscription?.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
       appBar: AppBar(
      centerTitle: true,
      title: Text("Naruto Wallpaper"),
      flexibleSpace: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[
                  Colors.deepPurple,
                  Colors.lightBlue,
                  Colors.deepPurple
                ])
        ),
      ),
    ),
      //new AppBar(title: new Text("Wally"),

      body: WallpaperList!=null?
          new StaggeredGridView.countBuilder(
            padding: const EdgeInsets.all(8.0),
            itemCount: WallpaperList.length,
            crossAxisCount: 4,
            itemBuilder: (context,i){
            String imgPath = WallpaperList[i].data['url'];
            return new Material(
              elevation: 8.0,
              borderRadius: new BorderRadius.all(new Radius.circular(8.0)),
              child: new InkWell(
                onTap: (){
                  //ads
                  createinterstitialAD()..load()..show();
                  Navigator.push(context, new MaterialPageRoute
                  (builder: (context)=>fullScreenImage(imgPath)));},
                child: new Hero(
                  tag: imgPath,
                  child: new FadeInImage(placeholder:new AssetImage("assets/uchiha.jpg"),
                      image: new NetworkImage(imgPath),
                      fit:BoxFit.cover,

                  ),
                ),
              ),
            );
          },
          staggeredTileBuilder:(i) =>new StaggeredTile.count(2, i.isEven?2:3),
            mainAxisSpacing: 8.0,
            crossAxisSpacing: 8.0,
          ): new Center(child: new CircularProgressIndicator(),)

    );
  }
}
