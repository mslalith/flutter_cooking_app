import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_cooking_app/widgets/common/mobile_view.dart';
import 'package:flutter_cooking_app/widgets/fill_transition/fill_transition_overlay.dart';

class FillTransition extends StatefulWidget {
  final ValueNotifier<bool> shouldFillNotifier;
  final Widget Function(FillTransitionOverlayDetails) builder;
  final VoidCallback onFillComplete;
  final double borderRadius;

  const FillTransition({
    Key key,
    @required this.shouldFillNotifier,
    @required this.builder,
    @required this.onFillComplete,
    this.borderRadius = 16.0,
  }) : super(key: key);

  @override
  _FillTransitionState createState() => _FillTransitionState();
}

class _FillTransitionState extends State<FillTransition> {
  OverlayEntry overlayEntry;

  @override
  void initState() {
    super.initState();
    widget.shouldFillNotifier.addListener(_shouldFillListener);
  }

  @override
  void dispose() {
    widget.shouldFillNotifier.removeListener(_shouldFillListener);
    _hideOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.shouldFillNotifier.value
        ? Container()
        : widget.builder(
            FillTransitionOverlayDetails(
              animationValue: 0.0,
              isAnimating: false,
              status: AnimationStatus.dismissed,
            ),
          );
  }

  void _shouldFillListener() {
    if (widget.shouldFillNotifier.value) {
      _showOverlay();
    } else {
      _hideOverlay();
    }
  }

  void _showOverlay() {
    final RenderBox box = context.findRenderObject();
    final topLeft = box.localToGlobal(Offset.zero);
    Rect itemRect = Rect.fromLTWH(
      topLeft.dx,
      topLeft.dy,
      box.size.width,
      box.size.height,
    );
    Rect appRect;
    double appBorderRadius;
    if (kIsWeb) {
      appBorderRadius = MobileView.borderRadius(context);
      appRect = MobileView.dimensions(context);
    } else {
      appBorderRadius = 0.0;
      final mediaQuery = MediaQuery.of(context).size;
      appRect = Rect.fromLTWH(
        0.0,
        0.0,
        mediaQuery.width,
        mediaQuery.height,
      );
    }

    overlayEntry = OverlayEntry(
      builder: (_) {
        return FillTransitionOverlay(
          fromRect: itemRect,
          toRect: appRect,
          fromBorderRadius: widget.borderRadius,
          toBorderRadius: appBorderRadius,
          builder: widget.builder,
          onFillComplete: () {
            widget.onFillComplete();
            Future.delayed(const Duration(milliseconds: 150), () {
              widget.shouldFillNotifier.value = false;
            });
          },
        );
      },
    );

    Overlay.of(context).insert(overlayEntry);
  }

  void _hideOverlay() {
    overlayEntry?.remove();
    overlayEntry = null;
  }
}
