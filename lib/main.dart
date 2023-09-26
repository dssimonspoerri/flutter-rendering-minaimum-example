import 'dart:async';
import 'dart:html' as html;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MaterialApp(
      home: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: 10),
              SizedBox(
                  width: 100,
                  height: 100,
                  child: Jumping("testimage", key: Key("TL"))),
              SizedBox(width: 10.5),
              SizedBox(
                  width: 100,
                  height: 100,
                  child: Jumping("testimage", key: Key("TM"))),
              SizedBox(width: 10.333),
              SizedBox(
                  width: 100,
                  height: 100,
                  child: Jumping("testimage", key: Key("TR"))),
            ],
          ),
          SizedBox(height: 10.5),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: 10),
              SizedBox(
                  width: 100,
                  height: 100,
                  child: Jumping("testimage", key: Key("ML"))),
              SizedBox(width: 10),
              SizedBox(
                  width: 100,
                  height: 100,
                  child: Jumping("testimage", key: Key("MM"))),
              SizedBox(width: 10.333),
              SizedBox(
                  width: 100,
                  height: 100,
                  child: Jumping("testimage", key: Key("MR"))),
            ],
          ),
          SizedBox(height: 10.333),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: 10),
              SizedBox(
                  width: 100,
                  height: 100,
                  child: Jumping("testimage", key: Key("BL"))),
              SizedBox(width: 10),
              SizedBox(
                  width: 100,
                  height: 100,
                  child: Jumping("testimage", key: Key("BM"))),
              SizedBox(width: 10.333),
              SizedBox(
                  width: 100,
                  height: 100,
                  child: Jumping("testimage", key: Key("BR"))),
            ],
          ),
        ],
  )));
}

class Jumping extends StatefulWidget {
  const Jumping(this.elementType, {Key? key}) : super(key: key);

  final String elementType;

  @override
  State<StatefulWidget> createState() => JumpingState(this.elementType);
}

class JumpingState extends State<Jumping> {
  final showImageToogle = ValueNotifier(true);

  JumpingState(this.elementType);

  final String elementType;

  @override
  void initState() {
    super.initState();
    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory("testimage", (int viewId) {
      final element = html.ImageElement()
        ..src =
            "https://storage.googleapis.com/render-instance-testdata/red-100x100.png"
        ..style.objectFit = 'none'
        ..style.border = 'none'
        ..style.width = '100%'
        ..style.height = '100%';
      return element;
    });

    RawKeyboard.instance.addListener((value) {
      if (value.character == 'v') {
        showImageToogle.value = false;
      } else if (value.character == 'i') {
        showImageToogle.value = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) => FutureBuilder(
      future: _getImage(
          "https://storage.googleapis.com/render-instance-testdata/red-100x100.png"),
      builder: (context, AsyncSnapshot<ui.Image> snapshot) =>
          ValueListenableBuilder(
            valueListenable: showImageToogle,
            builder: (context, value, child) => showImageToogle.value
                ? RawImage(
                    image: snapshot.data,
                    filterQuality: FilterQuality.none,
                    fit: BoxFit.none,
                    isAntiAlias: false)
                : HtmlElementView(viewType: elementType),
          ));

  Future<ui.Image> _getImage(String path) async {
    final completer = Completer<ImageInfo>();
    final img = NetworkImage(path);
    img
        .resolve(const ImageConfiguration())
        .addListener(ImageStreamListener((info, _) {
      completer.complete(info);
    }));
    final ImageInfo imageInfo = await completer.future;

    return imageInfo.image;
  }
}
