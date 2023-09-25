import 'dart:async';
import 'dart:html' as html;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pixel_snapping/pixel_aligned_container.dart';

void main() {


  runApp(MaterialApp(
      home: LayoutBuilder(builder: (context, constraints) => 
    //   FutureBuilder(
    //     future: getImage("https://i.imgur.com/nu3X5uU.png"),
    //     builder:(context, snapshot) => 
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
        SizedBox(height: 10.5),
        Expanded(
          child: 
          Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(width: 10.5),
              Expanded(child:Jumping("testimage", key: Key("TL"))),
              SizedBox(width: 10),
              Expanded(child:Jumping("testimage", key: Key("TR"))),
              SizedBox(width: 10),
          ],),
        ),
        SizedBox(height: 10),
        Expanded(
          child: 
          Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(width: 10),
              Expanded(child:Jumping("testimage", key: Key("BL"))),
              SizedBox(width: 10),
              Expanded(child:Jumping("testimage", key: Key("BR"))),
              SizedBox(width: 10),
          ],),
        ),
        SizedBox(height: 10),
    ],
  ))));
}


class Jumping extends StatefulWidget {
  const Jumping(
    this.elementType, 
    {Key? key}) : super(key: key);


  final String elementType;

  @override
  State<StatefulWidget> createState() => JumpingState(this.elementType);
}

class JumpingState extends State<Jumping> {
  final showImageToogle = ValueNotifier(true);

  JumpingState(this.elementType) {}

  final String elementType;

  @override
  void initState() {
    super.initState();
    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory("testimage", (int viewId) {
      final element = html.ImageElement()
        // ..src = "https://i.imgur.com/5XcyKlH.png"
        ..src = "https://storage.googleapis.com/render-instance-testdata/red-100x100.png"
        ..style.objectFit = 'fill'
        ..style.border = 'none'
        ..style.width = '100%'
        // ..style.overflow = 'clip'
        // ..style..overflowClip
        ..style.height = '100%';
      return element;
    });
    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory("testdiv", (int viewId) {
      final element = html.DivElement()
        ..style.border = 'none'
        ..style.backgroundColor = 'red'
        ..style.width = '100%'
        ..style.height = '100%';
      return element;
    });

    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory("testvideo", (int viewId) {
      final element = html.DivElement()
        ..style.border = 'none'
        ..style.objectFit = 'fill'
        ..style.backgroundColor = 'red'
        ..style.width = '100%'
        ..style.height = '100%';
      final video = html.VideoElement()
        ..src =
            // "https://storage.googleapis.com/render-instance-testdata/test-video-100x100_1.mp4"
            "https://storage.googleapis.com/render-instance-testdata/red-100x100.mp4"
        ..style.objectFit = 'cover'
        ..style.border = 'none'
        ..style.width = '100%'
        ..style.height = '100%'
        ..controls = false
        ..autoplay = true
        ..loop = true
        ..muted = true
        ..setAttribute('playsinline', 'true');
      element.append(video);

      return element;
    });
    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory("testvideo1", (int viewId) {
      final element = html.VideoElement()
        ..src =
            "https://storage.googleapis.com/render-instance-testdata/test-video-100x100_1.mp4"
        ..style.objectFit = 'cover'
        ..style.border = 'none'
        ..style.width = '100%'
        ..style.height = '100%'
        ..controls = false
        ..autoplay = true
        ..loop = true
        ..muted = true
        ..setAttribute('playsinline', 'true');
      
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
  Widget build(BuildContext context)  => FutureBuilder(
        // future: _getImage("https://i.imgur.com/nu3X5uU.png"),
        future: _getImage("https://storage.googleapis.com/render-instance-testdata/red-100x100.png"),
        builder: (context, AsyncSnapshot<ui.Image> snapshot) => ValueListenableBuilder(
            valueListenable: showImageToogle,
            builder: (context, value, child) => 
            PixelAlignedContainer(key: Key("pac-${widget.key}"), child: showImageToogle.value
                ? RawImage(
                    image: snapshot.data,
                    filterQuality: FilterQuality.medium,
                    fit: BoxFit.fill,
                    isAntiAlias: true)
                : HtmlElementView(viewType: "testvideo")
                // ? Container(color: ui.Color.fromARGB(255, 255, 0, 0),)
                // : HtmlElementView(viewType: "testdiv")
                ,
          )));

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
