import 'package:flutter/material.dart';
class fullScreenImage extends StatelessWidget {
  String imgpath;
  fullScreenImage(this.imgpath);
  
  final LinearGradient backgroundgradient = new LinearGradient(
      colors: [new Color(0x10000000),
      new Color(0x30000000)],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight
  );
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new SizedBox.expand(
        child: new Container(
          decoration: new BoxDecoration(gradient: backgroundgradient),
          child: new Stack(
            children: <Widget>[
              new Align(
                alignment: Alignment.center,
                child: new Hero(tag: imgpath, child: new Image.network(imgpath),
                ),
              ),
              new Align(
                alignment: Alignment.topCenter,
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    new AppBar(
                      elevation: 8.0,
                      backgroundColor: Colors.transparent,
                      leading: new IconButton(icon: new Icon(Icons.close,
                        color: Colors.black87),
                      onPressed: ()=>Navigator.of(context).pop(),
                      ),


                    )
                  ],

                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}
