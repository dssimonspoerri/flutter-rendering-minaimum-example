import 'dart:ui' as ui;

import 'package:pixel_snapping/images/test_image_v2.dart';
import 'package:pixel_snapping/pixel_aligned_container.dart';
import 'package:pixel_snapping/sandbox/stubs/simple_none_view.dart'
    if (dart.library.html) 'package:pixel_snapping/sandbox/simple_html_view.dart';
import 'package:flutter/material.dart';
// import 'package:pixel_snap/material.dart';

/// A [MinimalRenderView] is a very minimal render view which displays
/// video or an image.
class MinimalRenderView extends StatefulWidget {
  /// Creates an instance of [MinimalRenderView].
  const MinimalRenderView({
    required this.id,
    required this.showImageValueNotifier,
    Key? key,
  }) : super(key: key);

  /// If it should show the image or the video
  final ValueNotifier<bool> showImageValueNotifier;

  final int id;

  @override
  State<MinimalRenderView> createState() =>
      MinimalRenderViewState(showImageValueNotifier);
}

/// State for a [MinimalRenderView] widget.
class MinimalRenderViewState extends State<MinimalRenderView> {
  /// Creates an instance of [MinimalRenderViewState].
  MinimalRenderViewState(this._showImageValueNotifier);

  // Holds the last decoded image of the renderView
  // Setting this to null causes flickering.
  ui.Image? _screenshotImage;

  /// If it should show the image or the video
  final ValueNotifier<bool> _showImageValueNotifier;
  _ShowImgVideoState _showImage = _ShowImgVideoState.showVideo;

  @override
  void initState() {
    super.initState();
    TestImageV2.loadImage().then((ui.Image image) {
      setState(() => _screenshotImage = image);
    });
    _showImageValueNotifier.addListener(() => setState(() {
          if (_showImageValueNotifier.value) {
            _showImage = _ShowImgVideoState.showImage;
          } else {
            _showImage = _ShowImgVideoState.TransitionImageToVideo;
            Future.delayed(
                const Duration(milliseconds: 100),
                () => setState(() {
                      _showImage = _ShowImgVideoState.showVideo;
                    }));
          }
        }));
  }

  @override
  void dispose() {
    super.dispose();
    _screenshotImage?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget screenshotWidget = RawImage(
      image: _screenshotImage,
      width: 640,
      height: 386,
      fit: BoxFit.cover,
      alignment: Alignment.topLeft,
    );
    // screenshotWidget = Image.memory(,
    //   image: _screenshotImage,
    //   width: 640,
    //   height: 386,
    //   fit: BoxFit.none,
    //   alignment: Alignment.topLeft,
    // );
    
    

    // minimal widget to show video as an HTML video element
    const videoWidget = HtmlVideoView(
        videoUrl:
            'https://storage.googleapis.com/render-instance-testdata/demo_blur_video.mp4');

    final children = <Widget>[];
    if (_showImage == _ShowImgVideoState.showImage ||
        _showImage == _ShowImgVideoState.TransitionImageToVideo) {
      children.add(screenshotWidget);
    }
    if (_showImage == _ShowImgVideoState.showVideo ||
        _showImage == _ShowImgVideoState.TransitionImageToVideo) {
      children.add(videoWidget);
    }

    Widget child = Stack(
                    // fit: StackFit.passthrough,
                    alignment: Alignment.topLeft,
                    children: children);
    child = PositionOverlay(child: child);

    return SizedBox(
        width: 640,
        height: 386,
        child: OverflowBox(
            alignment: Alignment.topLeft,
                child: child));
  }
}

enum _ShowImgVideoState { showVideo, showImage, TransitionImageToVideo }


// /// A widget that displays a [dart:ui.Image] directly.
// ///
// /// The image is painted using [paintImage], which describes the meanings of the
// /// various fields on this class in more detail.
// ///
// /// The [image] is not disposed of by this widget. Creators of the widget are
// /// expected to call [Image.dispose] on the [image] once the [RawImage] is no
// /// longer buildable.
// ///
// /// This widget is rarely used directly. Instead, consider using [Image].
// class MyRawImage extends RawImage {
//   const MyRawImage({
//     super.key,
//     super.image,
//     super.debugImageLabel,
//     super.width,
//     super.height,
//     super.scale,
//     super.color,
//     super.opacity,
//     super.colorBlendMode,
//     super.fit,
//     super.alignment,
//     super.repeat,
//     super.centerSlice,
//     super.matchTextDirection,
//     super.invertColors,
//     super.isAntiAlias,
//     super.filterQuality,
//   });

//   @override
//   RenderImage createRenderObject(BuildContext context) {
//     print('Creating render object');
//     return super.createRenderObject(context);
//   }

//   @override
//   void updateRenderObject(BuildContext context, RenderImage renderObject) {
//     print('Updating render object');
//     // renderObject.
//     return super.updateRenderObject(context, renderObject);
//   }
// }