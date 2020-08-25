import 'package:flutter/material.dart';
import 'package:flutter_cooking_app/pages/item_detail_page.dart';
import 'package:flutter_cooking_app/transitions/fade_route.dart';
import 'package:flutter_cooking_app/widgets/liquid_pull/liquid_pull.dart';

class HomeListItem extends StatelessWidget {
  final ValueNotifier<bool> enableScrollingNotifier;
  final String imagePath;

  const HomeListItem({
    Key key,
    @required this.enableScrollingNotifier,
    @required this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 24.0,
        vertical: 12.0,
      ),
      child: LiquidPull(
        liquidText: 'How they work',
        child: Image.asset(imagePath),
        onWaveDraggingStart: () => enableScrollingNotifier.value = false,
        onWaveDraggingEnd: () => enableScrollingNotifier.value = true,
        onLiquidPullComplete: () => _navigateToItemDetailPage(context),
      ),
    );
  }

  void _navigateToItemDetailPage(BuildContext context) {
    Navigator.push(
      context,
      FadeRoute(
        page: ItemDetailPage(imagePath: imagePath),
      ),
    );
  }
}
