import 'package:flutter/material.dart';

class MobileView extends StatefulWidget {
  final Widget child;
  final double mobileAspectRatio;
  final EdgeInsets margin;

  const MobileView({
    Key key,
    @required this.child,
    this.mobileAspectRatio = 9 / 18,
    this.margin = const EdgeInsets.all(24.0),
  }) : super(key: key);

  static Rect dimensions(BuildContext context) =>
      context.findAncestorStateOfType<_MobileViewState>().appRect;

  static double borderRadius(BuildContext context) =>
      context.findAncestorStateOfType<_MobileViewState>().borderRadius;

  @override
  _MobileViewState createState() => _MobileViewState();
}

class _MobileViewState extends State<MobileView> {
  GlobalKey sizeKey = GlobalKey();
  Rect appRect;
  double borderRadius = 36.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final RenderBox box = sizeKey.currentContext.findRenderObject();
      final topLeft = box.localToGlobal(Offset.zero);
      appRect = Rect.fromLTWH(
        topLeft.dx,
        topLeft.dy,
        box.size.width,
        box.size.height,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: widget.margin,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
            color: Colors.black,
            width: 4.0,
          ),
        ),
        child: AspectRatio(
          key: sizeKey,
          aspectRatio: widget.mobileAspectRatio,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(32.0),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
