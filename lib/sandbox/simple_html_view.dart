// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:html' as html;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
// import 'package:pixel_snap/material.dart';


/// [HtmlVideoView] uses only html.videoElement to show a video
/// it's the simplest widget to show a video.
class HtmlVideoView extends StatefulWidget {
  /// [HtmlVideoView] constructor.
  const HtmlVideoView({
    required String videoUrl,
    Key? key,
  })  : _videoUrl = videoUrl,
        super(key: key);

  final String _videoUrl;

  @override
  HtmlVideoViewState createState() => HtmlVideoViewState();
}

/// [HtmlVideoViewState] is the state for the [HtmlVideoView] widget.
class HtmlVideoViewState extends State<HtmlVideoView> {
  /// [HtmlVideoViewState] constructor.
  HtmlVideoViewState() : _textureId = _textureCounter++;

  static int _textureCounter = 10;
  final int _textureId;
  String get _viewType => 'RTCVideoRenderer-$_textureId';
  String get _elementIdForVideo => 'video_$_viewType';

  @override
  void initState() {
    super.initState();

    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(_viewType, (int viewId) {
      final element = html.VideoElement()
        ..autoplay = true
        ..muted = true
        ..controls = false
        ..src = widget._videoUrl
        ..id = _elementIdForVideo
        ..loop = true
        ..style.objectFit = 'contain'
        ..style.border = 'none'
        ..style.width = '100%'
        ..style.height = '100%'
        ..setAttribute('playsinline', 'true');

      element.onError.listen((html.Event _) {
        print('RTCVideoRenderer: videoElement.onError, '
            '${element.error.toString()}');
      });

      return element;
    });
  }

  @override
  void dispose() {
    super.dispose();
    if (mounted) {
      final element = _findHtmlView();
      element?.removeAttribute('src');
      element?.load();
    }
  }

  html.VideoElement? _findHtmlView() {
    final element = html.document.getElementById(_elementIdForVideo);
    if (null != element) {
      return element as html.VideoElement;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) => HtmlElementView(viewType: _viewType);
}
