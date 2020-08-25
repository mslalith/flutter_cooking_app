import 'package:flutter/material.dart';

class FillTransitionOverlay extends StatefulWidget {
  final Rect fromRect;
  final Rect toRect;
  final Widget Function(FillTransitionOverlayDetails) builder;
  final VoidCallback onFillComplete;
  final Duration duration;
  final double fromBorderRadius;
  final double toBorderRadius;

  const FillTransitionOverlay({
    Key key,
    @required this.fromRect,
    @required this.toRect,
    @required this.builder,
    @required this.onFillComplete,
    this.fromBorderRadius = 0.0,
    this.toBorderRadius = 0.0,
    this.duration = const Duration(milliseconds: 600),
  }) : super(key: key);

  @override
  _FillTransitionOverlayState createState() => _FillTransitionOverlayState();
}

class _FillTransitionOverlayState extends State<FillTransitionOverlay>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Tween<double> borderRadiusTween;
  RectTween rectTween;

  @override
  void initState() {
    super.initState();
    rectTween = RectTween(
      begin: widget.fromRect,
      end: widget.toRect,
    );
    borderRadiusTween = Tween<double>(
      begin: widget.fromBorderRadius,
      end: widget.toBorderRadius,
    );

    controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )
      ..addListener(() => setState(() {}))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          widget.onFillComplete();
        }
      });

    controller.forward(from: 0.0);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final borderRadius = borderRadiusTween.transform(controller.value);
    return Stack(
      children: [
        Positioned.fromRect(
          rect: rectTween.transform(controller.value),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(borderRadius),
            child: widget.builder(
              FillTransitionOverlayDetails(
                animationValue: controller.value,
                isAnimating: controller.isAnimating,
                status: controller.status,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class FillTransitionOverlayDetails {
  final double animationValue;
  final bool isAnimating;
  final AnimationStatus status;

  FillTransitionOverlayDetails({
    @required this.animationValue,
    @required this.isAnimating,
    @required this.status,
  });
}
