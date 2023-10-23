import 'dart:core';
import 'dart:math';
import 'package:flutter/material.dart';

class PixelAlignedContainer extends StatelessWidget {
  
  final double dpr;
  final Point position;
  final Widget child;

  PixelAlignedContainer(this.dpr, this.position, this.child);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(position.x % (1.0 / dpr), position.y % (1.0 / dpr), 0,0),
      child: child
    );
  }
}

// class PositionOverlay extends StatefulWidget {
//   const PositionOverlay({
//     required this.child,
//     Key? key,
//   }) : super(key: key);

//   final Widget child;

//   @override
//   State<PositionOverlay> createState() =>
//       PositionOverlayState(this.child);
// }

// class PositionOverlayState extends State<PositionOverlay> {
//   PositionOverlayState(this.child);

//   final Widget child;

//   Offset position = Offset.zero;

//   @override
//   Widget build(BuildContext context) {

//     void getPosition(Duration timestamp) {
//       final RenderBox renderBox = context.findRenderObject() as RenderBox;
//       setState(() {
//         position = renderBox.localToGlobal(Offset.zero);
//       });
//       WidgetsBinding.instance.addPostFrameCallback(getPosition);
//     }

//     WidgetsBinding.instance.addPostFrameCallback(getPosition);

//     // return child;

//     return Stack(
//             children: [
//               child,
//               Align(
//                 child:Text('${position.dx} : ${position.dy}', style: TextStyle(color: Colors.lightBlue)),
//                 alignment: Alignment.bottomRight,)
//             ],
          
//     );
//   }
// }



// class PixelAlignedContainer extends StatefulWidget {
//   const PixelAlignedContainer({
//     required this.child,
//     Key? key,
//   }) : super(key: key);

//   final Widget child;

//   @override
//   State<PixelAlignedContainer> createState() =>
//       PixelAlignedContainerState(this.child);
// }

// class PixelAlignedContainerState extends State<PixelAlignedContainer> {
//   PixelAlignedContainerState(this.child);

//   Widget child;
//   final globalPositionNotifier = ValueNotifier<Offset>(Offset.zero);

//   Offset position = Offset.zero;
//   Size size = Size.zero;


//   @override
//   void didUpdateWidget(PixelAlignedContainer oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (oldWidget.child != widget.child) {
//       child = widget.child;
//     }
//   }
//   @override
//   Widget build(BuildContext context) {

//     final dpr = MediaQuery.of(context).devicePixelRatio;
//     // final dpr = 1.0;

//     void updateRenderBox(Duration timestamp) {
//       if (!mounted) {
//         return;
//       }
//       final RenderBox renderBox = context.findRenderObject() as RenderBox;
//       final Offset position = renderBox.localToGlobal(Offset.zero);
//       // print('Renderbox ${renderBox.size.width}:${renderBox.size.height}');

//         // print('${widget.key} Position: ${position.dx}:${position.dy}');
      

//       if (position != this.position) {
//         // print('${widget.key} Changed Position: ${position.dx}:${position.dy}');
//         setState(() {
//           this.position = position;
//         });
//         globalPositionNotifier.value = position;
//         globalPositionNotifier.notifyListeners();
//       }
//       WidgetsBinding.instance.addPostFrameCallback(updateRenderBox);
//     }

//     WidgetsBinding.instance.addPostFrameCallback(updateRenderBox);

//     return CustomSingleChildLayout(delegate: _SnappingChildLayoutDelegate(globalPositionNotifier, dpr, widget.key.toString()), child: child,);
//   }
// }
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
