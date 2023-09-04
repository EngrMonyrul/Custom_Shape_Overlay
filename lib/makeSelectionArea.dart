import 'dart:math';

import 'package:flutter/material.dart';

class MakeSelectionArea extends StatefulWidget {
  final Color borderColor;
  final double borderWidth;
  final Color overlayColor;
  final double borderRadius;
  final double borderLength;
  final double cutOutWidth;
  final double cutOutHeight;
  final double cutOutBottomOffset;
  const MakeSelectionArea({Key? key,
    this.borderColor = Colors.red,
    this.borderWidth = 3.0,
    this.overlayColor = const Color.fromRGBO(0, 0, 0, 80),
    this.borderRadius = 0,
    this.borderLength = 40,
    required this.cutOutWidth,
    required this.cutOutHeight,
    this.cutOutBottomOffset = 0,
  });

  @override
  State<MakeSelectionArea> createState() => _MakeSelectionAreaState();
}

class _MakeSelectionAreaState extends State<MakeSelectionArea> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }

  EdgeInsetsGeometry get dimensions => const EdgeInsets.all(10);

  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path()
      ..fillType = PathFillType.evenOdd
      ..addPath(getOuterPath(rect), Offset.zero);
  }

  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    Path _getLeftTopPath(Rect rect) {
      return Path()
        ..moveTo(rect.left, rect.bottom)
        ..lineTo(rect.left, rect.top)
        ..lineTo(rect.right, rect.top);
    }

    return _getLeftTopPath(rect)
      ..lineTo(
        rect.right,
        rect.bottom,
      )
      ..lineTo(
        rect.left,
        rect.bottom,
      )
      ..lineTo(
        rect.left,
        rect.top,
      );
  }

  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    final width = rect.width;
    final borderWidthSize = width / 2;
    final height = rect.height;
    final borderOffset = widget.borderWidth / 2;
    final _borderLength =
    widget.borderLength > min(widget.cutOutHeight, widget.cutOutHeight) / 2 + widget.borderWidth * 2 ? borderWidthSize / 2 : widget.borderLength;
    final _cutOutWidth = widget.cutOutWidth < width ? widget.cutOutWidth : width - borderOffset;
    final _cutOutHeight = widget.cutOutHeight < height ? widget.cutOutHeight : height - borderOffset;

    final backgroundPaint = Paint()
      ..color = widget.overlayColor
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = widget.borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = widget.borderWidth;

    final boxPaint = Paint()
      ..color = widget.borderColor
      ..style = PaintingStyle.fill
      ..blendMode = BlendMode.dstOut;

    final cutOutRect = Rect.fromLTWH(
      rect.left + width / 2 - _cutOutWidth / 2 + borderOffset,
      -widget.cutOutBottomOffset + rect.top + height / 2 - _cutOutHeight / 2 + borderOffset,
      _cutOutWidth - borderOffset * 2,
      _cutOutHeight - borderOffset * 2,
    );

    canvas
      ..saveLayer(
        rect,
        backgroundPaint,
      )
      ..drawRect(
        rect,
        backgroundPaint,
      )
    // Draw top right corner
      ..drawRRect(
        RRect.fromLTRBAndCorners(
          cutOutRect.right - _borderLength,
          cutOutRect.top,
          cutOutRect.right,
          cutOutRect.top + _borderLength,
          topRight: Radius.circular(widget.borderRadius),
        ),
        borderPaint,
      )
    // Draw top left corner
      ..drawRRect(
        RRect.fromLTRBAndCorners(
          cutOutRect.left,
          cutOutRect.top,
          cutOutRect.left + _borderLength,
          cutOutRect.top + _borderLength,
          topLeft: Radius.circular(widget.borderRadius),
        ),
        borderPaint,
      )
    // Draw bottom right corner
      ..drawRRect(
        RRect.fromLTRBAndCorners(
          cutOutRect.right - _borderLength,
          cutOutRect.bottom - _borderLength,
          cutOutRect.right,
          cutOutRect.bottom,
          bottomRight: Radius.circular(widget.borderRadius),
        ),
        borderPaint,
      )
    // Draw bottom left corner
      ..drawRRect(
        RRect.fromLTRBAndCorners(
          cutOutRect.left,
          cutOutRect.bottom - _borderLength,
          cutOutRect.left + _borderLength,
          cutOutRect.bottom,
          bottomLeft: Radius.circular(widget.borderRadius),
        ),
        borderPaint,
      )
      ..drawRRect(
        RRect.fromRectAndRadius(
          cutOutRect,
          Radius.circular(widget.borderRadius),
        ),
        boxPaint,
      )
      ..restore();
  }

  // ShapeBorder scale(double t) {
  //   return CutoutScreenArea(
  //     borderColor: borderColor,
  //     borderWidth: borderWidth,
  //     overlayColor: overlayColor,
  //   );
  // }
}

