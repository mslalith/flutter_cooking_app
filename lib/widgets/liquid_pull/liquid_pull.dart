import 'dart:math' show Random;

import 'package:flutter/material.dart';
import 'package:flutter_cooking_app/widgets/fill_transition/fill_transition.dart';
import 'package:flutter_cooking_app/widgets/fill_transition/fill_transition_overlay.dart';
import 'package:flutter_cooking_app/widgets/liquid_pull/liquid_pull_clipper.dart';

class LiquidPull extends StatefulWidget {
  final double wavePointHeightPercent;
  final double endPointsHeightPercent;
  final String liquidText;
  final Color backgroundColor;
  final Color textColor;
  final Widget child;
  final VoidCallback onLiquidPull;
  final VoidCallback onLiquidPullComplete;
  final VoidCallback onWaveDraggingStart;
  final VoidCallback onWaveDraggingEnd;

  const LiquidPull({
    Key key,
    @required this.liquidText,
    @required this.child,
    @required this.onWaveDraggingStart,
    @required this.onWaveDraggingEnd,
    this.onLiquidPull,
    this.onLiquidPullComplete,
    this.wavePointHeightPercent = 0.8,
    this.endPointsHeightPercent = 0.9,
    this.backgroundColor = Colors.black,
    this.textColor = Colors.white,
  }) : super(key: key);

  @override
  _LiquidPullState createState() => _LiquidPullState();
}

class _LiquidPullState extends State<LiquidPull>
    with SingleTickerProviderStateMixin {
  final Random random = Random();
  final double borderRadius = 16.0;
  AnimationController controller;
  Tween<double> leftPointTween;
  Tween<double> rightPointTween;
  Tween<Offset> controlPointTween;
  ValueNotifier<Size> widgetSizeNotifier;
  ValueNotifier<Offset> dragPositionNotifier;
  ValueNotifier<Offset> outWavePointPercentNotifier;
  ValueNotifier<double> outLeftPointPercentNotifier;
  ValueNotifier<double> outRightPointPercentNotifier;
  ValueNotifier<bool> shouldFillNotifier;

  @override
  void initState() {
    super.initState();
    widgetSizeNotifier = ValueNotifier(Size.zero);
    dragPositionNotifier = ValueNotifier(null);
    outWavePointPercentNotifier = ValueNotifier(null);
    outLeftPointPercentNotifier = ValueNotifier(null);
    outRightPointPercentNotifier = ValueNotifier(null);
    shouldFillNotifier = ValueNotifier(false);

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )
      ..addListener(_animationListener)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          if (shouldFillNotifier.value) {
            shouldFillNotifier.addListener(_shouldFillNotifierListener);
            return;
          }

          _updateTweenAnimations(
            left: leftPointTween.end,
            right: rightPointTween.end,
            control: controlPointTween.end,
          );
          controller.forward(from: 0.0);
        }
      });

    _updateTweenAnimations();
    controller.forward(from: 0.0);
  }

  @override
  void dispose() {
    widgetSizeNotifier.dispose();
    dragPositionNotifier.dispose();
    outWavePointPercentNotifier.dispose();
    outLeftPointPercentNotifier.dispose();
    outRightPointPercentNotifier.dispose();
    shouldFillNotifier.dispose();
    controller.dispose();
    super.dispose();
  }

  void _animationListener() => setState(() {});
  void _shouldFillNotifierListener() {
    if (!shouldFillNotifier.value) {
      _updateTweenAnimations(
        left: leftPointTween.end,
        right: rightPointTween.end,
        control: controlPointTween.end,
      );
      controller.forward(from: 0.0);
      shouldFillNotifier.removeListener(_shouldFillNotifierListener);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Stack(
        children: [
          widget.child,
          Positioned.fill(
            child: FillTransition(
              borderRadius: borderRadius,
              shouldFillNotifier: shouldFillNotifier,
              builder: (FillTransitionOverlayDetails details) =>
                  _buildWave(details),
              onFillComplete: widget.onLiquidPullComplete ?? () {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWave(FillTransitionOverlayDetails details) {
    bool shouldTakeOverlayValue =
        details.isAnimating || details.status == AnimationStatus.completed;
    final value =
        shouldTakeOverlayValue ? details.animationValue : controller.value;
    final curve = shouldFillNotifier.value ? Curves.easeInQuart : Curves.linear;
    final controlPointValue =
        controlPointTween.transform(curve.transform(value));
    return ValueListenableBuilder<Offset>(
      valueListenable: dragPositionNotifier,
      builder: (_, dragPosition, child) {
        double liquidTextHeightPercent = widget.endPointsHeightPercent;
        if (dragPosition != null) {
          final dragPositionPercent =
              dragPosition.dy / widgetSizeNotifier.value.height;
          liquidTextHeightPercent = dragPositionPercent +
              (widget.wavePointHeightPercent - dragPositionPercent) / 2;
        } else {
          liquidTextHeightPercent = widget.endPointsHeightPercent +
              (widget.wavePointHeightPercent - controlPointValue.dy) / 2;
        }

        return RepaintBoundary(
          child: ClipPath(
            clipper: LiquidPullClipper(
              leftPointPercent: leftPointTween.transform(value),
              rightPointPercent: rightPointTween.transform(value),
              controlPointPercent: controlPointValue,
              widgetSizeNotifier: widgetSizeNotifier,
              dragPosition: dragPosition,
              outWavePointNotifier: outWavePointPercentNotifier,
              outLeftPointNotifier: outLeftPointPercentNotifier,
              outRightPointNotifier: outRightPointPercentNotifier,
            ),
            child: GestureDetector(
              onPanCancel: widget.onWaveDraggingEnd,
              onPanDown: (_) => widget.onWaveDraggingStart(),
              onPanStart: _onPanStart,
              onPanUpdate: _onPanUpdate,
              onPanEnd: _onPanEnd,
              child: Container(
                color: widget.backgroundColor,
                alignment: Alignment(
                  0.0,
                  liquidTextHeightPercent,
                ),
                child: child,
              ),
            ),
          ),
        );
      },
      child: Material(
        color: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 30.0,
              height: 2.0,
              color: widget.textColor,
            ),
            const SizedBox(height: 8.0),
            Text(
              widget.liquidText,
              style: Theme.of(context).textTheme.bodyText1.copyWith(
                    color: widget.textColor,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  void _onPanStart(DragStartDetails details) {
    controller.removeListener(_animationListener);
    controller.stop();
  }

  void _onPanUpdate(DragUpdateDetails details) =>
      dragPositionNotifier.value = details.localPosition;

  void _onPanEnd(DragEndDetails details) {
    dragPositionNotifier.value = null;
    if (details.velocity.pixelsPerSecond.dy < 0.0 ||
        outWavePointPercentNotifier.value.dy <= 0.6) {
      leftPointTween = Tween<double>(
        begin: outLeftPointPercentNotifier.value,
        end: 0.0,
      );
      rightPointTween = Tween<double>(
        begin: outRightPointPercentNotifier.value,
        end: 0.0,
      );
      controlPointTween = Tween<Offset>(
        begin: outWavePointPercentNotifier.value,
        end: Offset(0.5, 0.0),
      );

      shouldFillNotifier.value = true;
      if (widget.onLiquidPull != null) widget.onLiquidPull();
    } else {
      _updateTweenAnimations(
        left: outLeftPointPercentNotifier.value,
        right: outRightPointPercentNotifier.value,
        control: outWavePointPercentNotifier.value,
      );
    }

    controller.addListener(_animationListener);
    controller.forward(from: 0.0);
    widget.onWaveDraggingEnd();
  }

  void _updateTweenAnimations({
    double left = 1.0,
    double right = 1.0,
    Offset control = const Offset(0.5, 1.0),
  }) {
    leftPointTween = Tween<double>(
      begin: left,
      end: _randomPoint(),
    );
    rightPointTween = Tween<double>(
      begin: right,
      end: _randomPoint(),
    );
    controlPointTween = Tween<Offset>(
      begin: control,
      end: _randomControlPoint(),
    );
  }

  double _randomPoint([double minPercent, int percent = 11]) =>
      (minPercent ?? widget.endPointsHeightPercent) +
      (random.nextInt(percent) / 100);

  Offset _randomControlPoint([double centerPercent = 0.5, int percent = 21]) {
    final dx = centerPercent + ((random.nextInt(percent) / 100) - 0.1);
    return Offset(
      dx,
      _randomPoint(widget.wavePointHeightPercent, 11),
    );
  }
}
