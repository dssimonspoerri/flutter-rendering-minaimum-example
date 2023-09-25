import 'dart:async';
import 'dart:html' as html;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MaterialApp(
      home: LayoutBuilder(
          builder: (context, constraints) => Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 10.5),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(width: 10.5),
                        Expanded(child: Jumping("testimage", key: Key("TL"))),
                        SizedBox(width: 10),
                        Expanded(child: Jumping("testimage", key: Key("TR"))),
                        SizedBox(width: 10),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(width: 10),
                        Expanded(child: Jumping("testimage", key: Key("BL"))),
                        SizedBox(width: 10),
                        Expanded(child: Jumping("testimage", key: Key("BR"))),
                        SizedBox(width: 10),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ))));
}

class Jumping extends StatefulWidget {
  const Jumping(this.elementType, {Key? key}) : super(key: key);

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
        ..src =
            "https://storage.googleapis.com/render-instance-testdata/red-100x100.png"
        ..style.objectFit = 'none'
        ..style.border = 'none'
        ..style.width = '100%'
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
            "https://storage.googleapis.com/render-instance-testdata/red-100x100.mp4"
        ..style.objectFit = 'none'
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
              builder: (context, value, child) => PixelAlignedContainer(
                    key: Key("pac-${widget.key}"),
                    child: showImageToogle.value
                        ? RawImage(
                            image: snapshot.data,
                            filterQuality: FilterQuality.none,
                            fit: BoxFit.none,
                            isAntiAlias: false)
                        : HtmlElementView(viewType: elementType),
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


class PixelAlignedContainer extends StatefulWidget {
  const PixelAlignedContainer({
    required this.child,
    Key? key,
  }) : super(key: key);

  final Widget child;

  @override
  State<PixelAlignedContainer> createState() =>
      PixelAlignedContainerState(this.child);
}

class PixelAlignedContainerState extends State<PixelAlignedContainer> {
  PixelAlignedContainerState(this.child);

  Widget child;
  final globalPositionNotifier = ValueNotifier<Offset>(Offset.zero);

  Offset position = Offset.zero;
  Size size = Size.zero;


  @override
  void didUpdateWidget(PixelAlignedContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.child != widget.child) {
      child = widget.child;
    }
  }
  @override
  Widget build(BuildContext context) {
    final dpr = MediaQuery.of(context).devicePixelRatio;

    void updateRenderBox(Duration timestamp) {
      final RenderBox renderBox = context.findRenderObject() as RenderBox;
      final Offset position = renderBox.localToGlobal(Offset.zero);
      print('${widget.key} Position: ${position.dx}:${position.dy}');

      if (position != this.position) {
        print('${widget.key} Changed Position: ${position.dx}:${position.dy}');
        setState(() {
          this.position = position;
          globalPositionNotifier.value = position;
        });
      }
      WidgetsBinding.instance.addPostFrameCallback(updateRenderBox);
    }

    WidgetsBinding.instance.addPostFrameCallback(updateRenderBox);

    return CustomSingleChildLayout(delegate: _SnappingChildLayoutDelegate(globalPositionNotifier, dpr, widget.key.toString()), child: child,);
  }
}
class _SnappingChildLayoutDelegate extends SingleChildLayoutDelegate {

  _SnappingChildLayoutDelegate(this.globalParentPosition, this.dpr, this.key):super(relayout: globalParentPosition){
    print('${key}');
  }
  
  final double dpr;

  final ValueNotifier<Offset> globalParentPosition;

  final String? key;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    final childOffset = _getOffset();
    Offset maxChildSize = Offset(constraints.maxWidth - childOffset.dx, constraints.maxHeight - childOffset.dy);
    maxChildSize = Offset(
      maxChildSize.dx - (maxChildSize.dx % (1.0/dpr)),
      maxChildSize.dy - (maxChildSize.dy % (1.0/dpr))
    );
    print('${this.key}: ChildSize ${maxChildSize.dx}:${maxChildSize.dy}\t${childOffset.dx}:${childOffset.dy}\t${globalParentPosition.value.dx}:${globalParentPosition.value.dy}');
    return BoxConstraints.tightFor(width: maxChildSize.dx, height: maxChildSize.dy);
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    return _getOffset();
  }

  Offset _getOffset() {
    return Offset(
      globalParentPosition.value.dx % (1.0 / dpr),
      globalParentPosition.value.dy % (1.0 / dpr)
    );
  }

  @override
  bool shouldRelayout(_SnappingChildLayoutDelegate oldDelegate) {
    return dpr == oldDelegate.dpr || globalParentPosition.value != oldDelegate.globalParentPosition.value;
  }
}
