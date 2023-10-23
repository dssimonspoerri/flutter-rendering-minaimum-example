import 'dart:async';
import 'dart:math' as math;
import 'dart:html' as html;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pixel_snapping/pixel_aligned_container.dart';
import 'package:pixel_snapping/pixel_aligned_image.dart';

final width = 101.0;
final height = 102.0;


void main() {

  final boxFitTop = BoxFit.none;
  final boxFitMiddle = BoxFit.fill;
  final boxFitBottom = BoxFit.contain;

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
                  width: width,
                  height: height,
                  child: Jumping("testimage", boxFitTop, key: Key("TL"))),
              SizedBox(width: 10.5),
              SizedBox(
                  width: width,
                  height: height,
                  child: Jumping("testimage", boxFitTop, key: Key("TM"))),
              SizedBox(width: 10.5),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                SizedBox(height: 0.5),
                SizedBox(
                    width: width,
                    height: height,
                    child: Jumping("testimage", boxFitTop, key: Key("TR"))),
              ],)
            ],
          ),
          // SizedBox(height: 10.5),
          // Row(
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: [
          //     SizedBox(width: 10),
          //     SizedBox(
          //         width: width,
          //         height: height,
          //         child: Jumping("testimage", boxFitMiddle, key: Key("ML"))),
          //     SizedBox(width: 10.5),
          //     SizedBox(
          //         width: width,
          //         height: height,
          //         child: Jumping("testimage", boxFitMiddle, key: Key("MM"))),
          //     SizedBox(width: 10.5),
          //     Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          //       SizedBox(height: 0.5),
          //         SizedBox(
          //             width: width,
          //             height: height,
          //             child: Jumping("testimage", boxFitMiddle, key: Key("MR"))),

          //     ],)
          //   ],
          // ),
          // SizedBox(height: 10.5),
          // Row(
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: [
          //     SizedBox(width: 10),
          //     SizedBox(
          //         width: width,
          //         height: height,
          //         child: Jumping("testimage", boxFitBottom, key: Key("BL"))),
          //     SizedBox(width: 10.5),
          //     SizedBox(
          //         width: width,
          //         height: height,
          //         child: Jumping("testimage", boxFitBottom, key: Key("BM"))),
          //     SizedBox(width: 10.5),
          //     Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          //       SizedBox(height: 0.5),
          //         SizedBox(
          //             width: width,
          //             height: height,
          //             child: Jumping("testimage", boxFitBottom, key: Key("BR"))),

          //     ],)
          //   ],
          // ),
        ],
  )));
}

class Jumping extends StatefulWidget {
  const Jumping(this.elementType, this.boxFit, {Key? key}) : super(key: key);

  final String elementType;

  final BoxFit boxFit;

  @override
  State<StatefulWidget> createState() => JumpingState(this.elementType, this.boxFit, this.key!.toString());
}

class JumpingState extends State<Jumping> {
  final showImageToogle = ValueNotifier(true);

  JumpingState(this.elementType, this.boxFit, this.key);

  final String elementType;

  final BoxFit boxFit;

  final String key;

  @override
  void initState() {
    super.initState();
    // ignore: undefined_prefixed_name
    // ui.platformViewRegistry.registerViewFactory("$key-video", createVideoElement);
    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory("$key-video", (int viewId) {
      final video = html.VideoElement()
        ..src =
            // "https://storage.googleapis.com/render-instance-testdata/test-video-100x100_1.mp4"
            "https://storage.googleapis.com/render-instance-testdata/red-100x100.mp4"
        ..style.objectFit = boxFit.name
        ..style.objectPosition = 'top left'
        ..style.border = 'none'
        ..style.width = '100%'
        ..style.height = '100%'
        ..style.imageRendering = 'pixelated'
        ..controls = false
        ..autoplay = true
        ..loop = true
        ..muted = true
        ..setAttribute('playsinline', 'true');
        return video;
    });
    // // ignore: undefined_prefixed_name
    // ui.platformViewRegistry.registerViewFactory("testdiv", (int viewId) {
    //   final element = html.DivElement()
    //     ..style.objectFit = 'none'
    //     ..style.backgroundColor = 'rgb(255,0,0)'
    //     ..style.border = 'none'
    //     ..style.width = '100%'
    //     ..style.height = '100%';
    //   return element;
    // });

    RawKeyboard.instance.addListener((value) {
      if (value.character == 'v') {
        showImageToogle.value = false;
      } else if (value.character == 'i') {
        showImageToogle.value = true;
      }
    });
  }



  Offset position = Offset.zero;

  final _globalKey = GlobalKey();
  
  html.HtmlElement createVideoElement(int viewId) {

    final dpr = MediaQuery.of(context).devicePixelRatio;
    final container = html.DivElement()
      ..style.height ='100%'
      ..style.width ='100%';
    final element = html.ImageElement()
      ..src =
          "https://storage.googleapis.com/render-instance-testdata/red-100x100.png"
      ..style.objectFit = boxFit.name
      ..style.objectPosition = 'top left'
      ..style.border = 'none'
      ..style.imageRendering = 'pixelated'
      ..style.width = '${100}px'
      ..style.height = '${100}px';
    container.append(element);
    return container;
  }

  @override
  Widget build(BuildContext context) {

    final dpr = MediaQuery.of(context).devicePixelRatio;
    print ('DPR: $dpr');
    // final dpr = 1.0;

    void updateRenderBox(Duration timestamp) {
      WidgetsBinding.instance.addPostFrameCallback(updateRenderBox);
      if(!mounted) {
        return;
      }
      final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
      if (renderBox == null) {
        return;
      }
      final Offset position = renderBox.localToGlobal(Offset.zero);
      // print('Renderbox ${renderBox.size.width}:${renderBox.size.height}');

        // print('${widget.key} Position: ${position.dx}:${position.dy}');
      

      if (position != this.position) {
        setState(() {
          print('${widget.key} Changed Position: ${position.dx}:${position.dy}');
          this.position = position;
        });
      }
    }

    WidgetsBinding.instance.addPostFrameCallback(updateRenderBox);

    return FutureBuilder(
      future: _getImage(
          "https://storage.googleapis.com/render-instance-testdata/red-100x100.png"),
      builder: (context, AsyncSnapshot<ui.Image> snapshot) =>
        !snapshot.hasData ? Container()
        : ValueListenableBuilder(
            valueListenable: showImageToogle,
            builder: (context, value, child) {
              final padding = EdgeInsets.fromLTRB(position.dx % (1.0 / dpr), position.dy % (1.0 / dpr), 0,0);
              print('$key: padding $padding');
              Widget widget = showImageToogle.value
                  // ? ColoredBox(color: Color.fromARGB(255, 255, 0,0))
                  // ? RawImage(
                  //     image: snapshot.data,
                  //     filterQuality: FilterQuality.none,
                  //     alignment: Alignment.topLeft,
                  //     fit: boxFit,
                  //     isAntiAlias: true)
                  ? CustomPaint(
                      painter: ImagePainter(Key(key), snapshot.data!, dpr, position))
                  // ? Image.network("https://storage.googleapis.com/render-instance-testdata/red-100x100.png")
                  // ? HtmlElementView(viewType: '$key-image')
                  // ? PixelAlignedImage(image: snapshot.data!, key: Key('pai-$key'))
                  // : PixelAlignedContainer(child: HtmlElementView(viewType: '$key-video'));
                  : Padding(
                      padding: padding,
                      child: HtmlElementView(viewType: '$key-video',)
                    );
              // widget = RepaintBoundary.wrap(widget, 0);
              // widget = PixelAlignedContainer(child: widget, key: Key('$key-pac'));
              // widget = SizedBox(width: width, height: height, child: widget);
              // widget = FittedBox(child: widget, alignment: Alignment.topLeft, fit: boxFit, clipBehavior: Clip.hardEdge,);
              return widget;
            }
          ));
  }

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


// class ImagePainter extends CustomPainter {
//   final ui.Image image;
//   final BoxFit boxFit;
//   final String key;
//   final Offset globalPosition;

//   const ImagePainter(this.key, this.image, this.boxFit, this.globalPosition);

//   @override
//   void paint(Canvas canvas, Size size) {    
//     final imageSize = Size(image.width*1.0, image.height*1.0);
//     final FittedSizes sizes = applyBoxFit(boxFit, imageSize, size);
//     final Rect inputSubrect = Alignment.topLeft.inscribe(sizes.source, Offset.zero & imageSize);

//     final dst = Rect.fromLTWH(0, 0, size.width, size.height);
//     final Rect outputSubrect = Alignment.topLeft.inscribe(sizes.destination, dst);

//     // print("$key: painting from $inputSubrect to $outputSubrect");
//     final imagePaint = Paint()
//       ..isAntiAlias = false
//     ;
    
//     canvas.drawImageRect(image, inputSubrect, outputSubrect, imagePaint);
//   }
  
//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return true;
//   }
// }

// FittedSizes applyBoxFit(BoxFit fit, Size inputSize, Size outputSize) {
//   if (inputSize.height <= 0.0 || inputSize.width <= 0.0 || outputSize.height <= 0.0 || outputSize.width <= 0.0) {
//     return const FittedSizes(Size.zero, Size.zero);
//   }

//   Size sourceSize, destinationSize;
//   switch (fit) {
//     case BoxFit.fill:
//       sourceSize = inputSize;
//       destinationSize = outputSize;
//       break;
//     case BoxFit.contain:
//       sourceSize = inputSize;
//       if (outputSize.width / outputSize.height > sourceSize.width / sourceSize.height) {
//         destinationSize = Size(sourceSize.width * outputSize.height / sourceSize.height, outputSize.height);
//       } else {
//         destinationSize = Size(outputSize.width, sourceSize.height * outputSize.width / sourceSize.width);
//       }
//       break;
//     case BoxFit.cover:
//       if (outputSize.width / outputSize.height > inputSize.width / inputSize.height) {
//         sourceSize = Size(inputSize.width, (inputSize.width * outputSize.height / outputSize.width).ceilToDouble());
//       } else {
//         sourceSize = Size((inputSize.height * outputSize.width / outputSize.height).ceilToDouble(), inputSize.height);
//       }
//       destinationSize = outputSize;
//       break;
//     case BoxFit.fitWidth:
//       if (outputSize.width / outputSize.height > inputSize.width / inputSize.height) {
//         // Like "cover"
//         sourceSize = Size(inputSize.width, inputSize.width * outputSize.height / outputSize.width);
//         destinationSize = outputSize;
//       } else {
//         // Like "contain"
//         sourceSize = inputSize;
//         destinationSize = Size(outputSize.width, sourceSize.height * outputSize.width / sourceSize.width);
//       }
//       break;
//     case BoxFit.fitHeight:
//       if (outputSize.width / outputSize.height > inputSize.width / inputSize.height) {
//         // Like "contain"
//         sourceSize = inputSize;
//         destinationSize = Size(sourceSize.width * outputSize.height / sourceSize.height, outputSize.height);
//       } else {
//         // Like "cover"
//         sourceSize = Size(inputSize.height * outputSize.width / outputSize.height, inputSize.height);
//         destinationSize = outputSize;
//       }
//       break;
//     case BoxFit.none:
//       sourceSize = Size(math.min(inputSize.width, outputSize.width), math.min(inputSize.height, outputSize.height));
//       destinationSize = sourceSize;
//       break;
//     case BoxFit.scaleDown:
//       sourceSize = inputSize;
//       destinationSize = inputSize;
//       final double aspectRatio = inputSize.width / inputSize.height;
//       if (destinationSize.height > outputSize.height) {
//         destinationSize = Size(outputSize.height * aspectRatio, outputSize.height);
//       }
//       if (destinationSize.width > outputSize.width) {
//         destinationSize = Size(outputSize.width, outputSize.width / aspectRatio);
//       }
//       break;
//   }
//   return FittedSizes(sourceSize, destinationSize);
// }