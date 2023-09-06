import 'package:flutter/material.dart';

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

  final Widget child;

  Offset padding = Offset.zero;

  @override
  Widget build(BuildContext context) {

    void adjustPadding(Duration timestamp) {
      final RenderBox renderBox = context.findRenderObject() as RenderBox;
      final Offset position = renderBox.localToGlobal(Offset.zero);
      double subpixelX = position.dx % 1;
      double subpixelY = position.dy % 1;
      if((subpixelX != padding.dx || subpixelY != padding.dy)) {
        setState(() {
            print('Set ${widget.key} ${subpixelX}:${subpixelY} (x:${position.dx}, y: ${position.dy})');
            padding = Offset(subpixelX, subpixelY);
        });
      }
      WidgetsBinding.instance.addPostFrameCallback(adjustPadding);
    }

    WidgetsBinding.instance.addPostFrameCallback(adjustPadding);

    print('Build ${widget.key} ${padding.dx}:${padding.dy}');
    return 
    Container(
          padding:EdgeInsets.fromLTRB(padding.dx, padding.dy, 0,0),
          alignment: Alignment.topLeft,
          // decoration: BoxDecoration(
          //   border: Border.all(
          //     color: Colors.purple,    
          //     width: 0.5
          //   )
          // ),
          child: 
          Stack(
            children: [
              child,
              Text(' Align ${padding.dx} <-> ${padding.dy}', style: TextStyle(color: Colors.green),)
            ],
          ),
    );
  }
}