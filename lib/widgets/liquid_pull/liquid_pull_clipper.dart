import 'package:flutter/material.dart';

class LiquidPullClipper extends CustomClipper<Path> {
  final double leftPointPercent;
  final double rightPointPercent;
  final Offset controlPointPercent;
  final Offset dragPosition;
  final ValueNotifier<Size> widgetSizeNotifier;
  final ValueNotifier<Offset> outWavePointNotifier;
  final ValueNotifier<double> outLeftPointNotifier;
  final ValueNotifier<double> outRightPointNotifier;

  const LiquidPullClipper({
    @required this.leftPointPercent,
    @required this.rightPointPercent,
    @required this.controlPointPercent,
    @required this.dragPosition,
    @required this.widgetSizeNotifier,
    @required this.outWavePointNotifier,
    @required this.outLeftPointNotifier,
    @required this.outRightPointNotifier,
  });

  @override
  Path getClip(Size size) {
    if (widgetSizeNotifier.value.height == 0.0) {
      widgetSizeNotifier.value = size;
    }

    final width = size.width;
    final height = size.height;
    final widthCenter = width / 2;

    Offset wavePoint;
    Offset leftPoint;
    Offset rightPoint;
    Offset leftTopCurvePoint;
    Offset leftBottomCurvePoint;
    Offset rightTopCurvePoint;
    Offset rightBottomCurvePoint;
    if (dragPosition != null) {
      final firstHalfPercent = dragPosition.dx <= widthCenter
          ? (dragPosition.dx / widthCenter)
          : 0.0;
      final secondHalfPercent = dragPosition.dx > widthCenter
          ? (dragPosition.dx - widthCenter) / widthCenter
          : 0.0;

      wavePoint = Offset(
        dragPosition.dx,
        dragPosition.dy.clamp(height * 0.5, height * 0.8),
      );
      leftPoint = Offset(
        0.0,
        (height * 0.7) + (height * 0.3 * (wavePoint.dy / height)),
      );
      rightPoint = Offset(
        width,
        leftPoint.dy,
      );

      outLeftPointNotifier.value = leftPoint.dy / height;
      outRightPointNotifier.value = rightPoint.dy / height;
      outWavePointNotifier.value = Offset(
        wavePoint.dx / width,
        wavePoint.dy / height,
      );

      leftTopCurvePoint = Offset(
        dragPosition.dx - (width * 0.3),
        wavePoint.dy,
      );
      leftBottomCurvePoint = Offset(
        dragPosition.dx - (width * 0.3),
        leftPoint.dy - (0.2 * firstHalfPercent),
      );

      rightTopCurvePoint = Offset(
        dragPosition.dx + (width * 0.3),
        wavePoint.dy,
      );
      rightBottomCurvePoint = Offset(
        dragPosition.dx + (width * 0.3),
        rightPoint.dy - (0.2 * secondHalfPercent),
      );
    } else {
      wavePoint = Offset(
        width * controlPointPercent.dx,
        height * controlPointPercent.dy,
      );
      leftPoint = Offset(
        0.0,
        height * leftPointPercent,
      );
      rightPoint = Offset(
        width,
        height * rightPointPercent,
      );

      final offsetPercent = (controlPointPercent.dx - 0.4) / 0.2;

      leftTopCurvePoint = Offset(
        width * 0.4 - (width * 0.3 * (1.0 - offsetPercent)),
        wavePoint.dy,
      );
      leftBottomCurvePoint = Offset(
        width * 0.3 * offsetPercent,
        leftPoint.dy,
      );

      rightTopCurvePoint = Offset(
        width * 0.6 + (width * 0.3 * offsetPercent),
        wavePoint.dy,
      );
      rightBottomCurvePoint = Offset(
        width * 0.7 + (width * 0.3 * offsetPercent),
        rightPoint.dy,
      );
    }

    return Path()
      ..moveTo(leftPoint.dx, leftPoint.dy)
      ..lineTo(0.0, height)
      ..lineTo(width, height)
      ..lineTo(rightPoint.dx, rightPoint.dy)
      ..cubicTo(
        rightBottomCurvePoint.dx,
        rightBottomCurvePoint.dy,
        rightTopCurvePoint.dx,
        rightTopCurvePoint.dy,
        wavePoint.dx,
        wavePoint.dy,
      )
      ..cubicTo(
        leftTopCurvePoint.dx,
        leftTopCurvePoint.dy,
        leftBottomCurvePoint.dx,
        leftBottomCurvePoint.dy,
        leftPoint.dx,
        leftPoint.dy,
      )
      ..close();
  }

  @override
  bool shouldReclip(LiquidPullClipper oldClipper) =>
      oldClipper.leftPointPercent != leftPointPercent ||
      oldClipper.rightPointPercent != rightPointPercent ||
      oldClipper.controlPointPercent != controlPointPercent ||
      oldClipper.dragPosition != dragPosition;
}
