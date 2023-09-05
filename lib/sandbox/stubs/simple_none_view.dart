import 'package:flutter/material.dart';

/// [HtmlVideoView] uses only html.videoElement to show a video
/// it's the simplest widget to show a video.
class HtmlVideoView extends StatefulWidget {
  /// [HtmlVideoView] constructor.
  const HtmlVideoView({
    // ignore: avoid_unused_constructor_parameters
    required String videoUrl,
    Key? key,
  }) : super(key: key);

  @override
  HtmlVideoViewState createState() => HtmlVideoViewState();
}

/// [HtmlVideoViewState] is the state for the [HtmlVideoView] widget.
class HtmlVideoViewState extends State<HtmlVideoView> {
  /// [HtmlVideoViewState] constructor.
  HtmlVideoViewState();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Container();
}
