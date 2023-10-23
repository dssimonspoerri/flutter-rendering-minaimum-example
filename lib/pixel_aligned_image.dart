import 'dart:core';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class PixelAlignedImage extends StatefulWidget {
  const PixelAlignedImage({
    required this.image,
    Key? key,
  }) : super(key: key);

  final ui.Image image;

  @override
  State<PixelAlignedImage> createState() =>
      PixelAlignedImageState(image, key);
}

class PixelAlignedImageState extends State<PixelAlignedImage> {
  PixelAlignedImageState(this.image, this.key);

  ui.Image image;

  Offset position = Offset.zero;

  final Key? key;

  @override
  void didUpdateWidget(PixelAlignedImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.image != widget.image) {
      image = widget.image;
    }
  }

  final _globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {

    final dpr = MediaQuery.of(context).devicePixelRatio;
    // final dpr = 1.0;

    void updateRenderBox(Duration timestamp) {
      if(!mounted) {
        return;
      }
      final RenderBox? renderBox = _globalKey.currentContext?.findRenderObject() as RenderBox?;
      if (renderBox == null) {
        return;
      }
      final Offset position = renderBox.localToGlobal(Offset.zero);
      // print('Renderbox ${renderBox.size.width}:${renderBox.size.height}');

        // print('${widget.key} Position: ${position.dx}:${position.dy}');
      

      if (position != this.position) {
        // print('${widget.key} Changed Position: ${position.dx}:${position.dy}');
        setState(() {
          this.position = position;
        });
      }
      WidgetsBinding.instance.addPostFrameCallback(updateRenderBox);
    }

    WidgetsBinding.instance.addPostFrameCallback(updateRenderBox);

    return CustomPaint(key: _globalKey,
      painter: ImagePainter(key, image, dpr, position)
    );
  }
}

// class _SnappingChildLayoutDelegate extends SingleChildLayoutDelegate {

//   _SnappingChildLayoutDelegate(this.globalParentPosition, this.dpr, this.key):super(relayout: globalParentPosition){
//     print('${key}');
//   }
  
//   final double dpr;

//   final ValueNotifier<Offset> globalParentPosition;

//   final String? key;

//   @override
//   BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
//         // print('getConstraintsForChild');

//     final childOffset = _getOffset();
//     Offset maxChildSize = Offset(constraints.maxWidth - childOffset.dx, constraints.maxHeight - childOffset.dy);
//     maxChildSize = Offset(
//       constraints.maxWidth,
//       constraints.maxHeight
//     );
//     print('${this.key}: ChildSize ${maxChildSize.dx}:${maxChildSize.dy}\t${childOffset.dx}:${childOffset.dy}\t${globalParentPosition.value.dx}:${globalParentPosition.value.dy}');
//     return BoxConstraints.tightFor(width: maxChildSize.dx, height: maxChildSize.dy);

//   }
//   @override
//   Offset getPositionForChild(Size size, Size childSize) {
//     return _getOffset();
//   }

//   Offset _getOffset() {
//     return Offset(
//       globalParentPosition.value.dx % (1.0 / dpr),
//       globalParentPosition.value.dy % (1.0 / dpr)
//     );
//   }

//   @override
//   bool shouldRelayout(_SnappingChildLayoutDelegate oldDelegate) {
//     return dpr == oldDelegate.dpr || globalParentPosition.value != oldDelegate.globalParentPosition.value;
//   }
// }


class ImagePainter extends CustomPainter {
  final Key? key;
  final ui.Image image;
  final Offset globalPosition;
  final double dpr;

  const ImagePainter(this.key, this.image, this.dpr, this.globalPosition);

  @override
  void paint(Canvas canvas, Size size) {    
    final imageSize = Size(image.width*1.0, image.height*1.0);
    // final FittedSizes sizes = applyBoxFit(boxFit, imageSize, size);
    // final Rect inputSubrect = Alignment.topLeft.inscribe(sizes.source, Offset.zero & imageSize);
    final Rect inputSubrect = Rect.fromLTWH(0, 0, imageSize.width, imageSize.height);

    final outputStartX = globalPosition.dx % (1.0 / dpr);
    final outputStartY = globalPosition.dy % (1.0 / dpr);
    final outputWidth = image.width * 1.0;
    final outputHeight = image.height * 1.0;

    final Rect outputSubrect = Rect.fromLTWH(outputStartX, outputStartY, outputWidth, outputHeight);

    print("$key: painting from $inputSubrect to $outputSubrect ($outputStartX:$outputStartY)");
    final imagePaint = Paint()
      ..isAntiAlias = false
    ;
    
    canvas.drawImageRect(image, inputSubrect, outputSubrect, imagePaint);
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}