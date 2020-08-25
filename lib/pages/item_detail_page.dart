import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_cooking_app/pages/registration_page.dart';
import 'package:flutter_cooking_app/transitions/fade_route.dart';
import 'package:flutter_cooking_app/widgets/common/circular_icon_button.dart';
import 'package:flutter_cooking_app/widgets/liquid_pull/liquid_pull.dart';
import 'package:flutter_cooking_app/widgets/common/mobile_view.dart';

class ItemDetailPage extends StatefulWidget {
  final String imagePath;
  final Color backgroundColor;
  final Color textColor;

  const ItemDetailPage({
    Key key,
    @required this.imagePath,
    this.backgroundColor = Colors.black,
    this.textColor = Colors.white,
  }) : super(key: key);

  @override
  _ItemDetailPageState createState() => _ItemDetailPageState();
}

class _ItemDetailPageState extends State<ItemDetailPage>
    with SingleTickerProviderStateMixin {
  final double bottomEmptyWaveHeight = kToolbarHeight * 3;
  AnimationController controller;
  ScrollController scrollController;
  ValueNotifier<bool> enableScrollingNotifier;
  ValueNotifier<double> percentVisibleNotifier;

  @override
  void initState() {
    super.initState();
    enableScrollingNotifier = ValueNotifier(true);
    percentVisibleNotifier = ValueNotifier(0.0);
    scrollController = ScrollController()
      ..addListener(() {
        if (scrollController.hasClients) {
          final currentPosition = scrollController.offset;
          final visibleThreshold =
              scrollController.position.maxScrollExtent - bottomEmptyWaveHeight;
          final percent = currentPosition > visibleThreshold
              ? ((currentPosition - visibleThreshold) / bottomEmptyWaveHeight)
              : 0.0;
          percentVisibleNotifier.value = percent.clamp(0.0, 1.0);
        }
      });

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..addListener(() => setState(() {}));

    controller.forward(from: 0.0);
  }

  @override
  void dispose() {
    controller.dispose();
    scrollController.dispose();
    enableScrollingNotifier.dispose();
    percentVisibleNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget child = SafeArea(
      child: Scaffold(
        backgroundColor: widget.backgroundColor,
        body: LayoutBuilder(
          builder: (_, constraints) {
            final widgetSize = Size(
              constraints.maxWidth,
              constraints.maxHeight,
            );

            return Stack(
              children: [
                ValueListenableBuilder<bool>(
                  valueListenable: enableScrollingNotifier,
                  builder: (_, enableScrolling, child) {
                    return SingleChildScrollView(
                      physics: enableScrolling
                          ? const BouncingScrollPhysics()
                          : const NeverScrollableScrollPhysics(),
                      controller: scrollController,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 24.0),
                          Container(
                            margin:
                                const EdgeInsets.symmetric(horizontal: 24.0),
                            child: CircularIconButton(
                              icon: Icons.arrow_back_ios,
                              iconColor: widget.textColor,
                              iconSize: 16.0,
                              onPressed: Navigator.of(context).pop,
                            ),
                          ),
                          const SizedBox(height: 12.0),
                          _translateAndFadeIn(
                            child: Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 36.0),
                              child: Text(
                                'Recipe\nContest',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline4
                                    .copyWith(
                                      color: widget.textColor,
                                    ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24.0),
                          _translateAndFadeIn(
                            child: Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 24.0),
                              child: AspectRatio(
                                aspectRatio: 1.0,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(24.0),
                                  child: Image.asset(
                                    widget.imagePath,
                                    fit: BoxFit.fitWidth,
                                    alignment: Alignment.bottomCenter,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 36.0),
                          _translateAndFadeIn(
                            translateDistance: 200.0,
                            child: Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 36.0),
                              child: Text(
                                'Share Your Wonder\nRecipe With Us',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6
                                    .copyWith(
                                      color: widget.textColor,
                                    ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24.0),
                          _translateAndFadeIn(
                            translateDistance: 200.0,
                            child: Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 36.0),
                              child: Text(
                                'Cooking competitions can be fun and exciting because of the suspense and wonders of what might bring in the end. If you love cooking or you are a great cook who can make tasty food, then we invite you to participate in our cooking contest.',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(
                                      color: widget.textColor,
                                    ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24.0),
                          _translateAndFadeIn(
                            translateDistance: 200.0,
                            child: Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 36.0),
                              child: Text(
                                'Anyone who has passion for food, a bit of creative insiration, and loves the thrill of competition, they can be part of this contest.',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(
                                      color: widget.textColor,
                                    ),
                              ),
                            ),
                          ),
                          SizedBox(height: bottomEmptyWaveHeight),
                        ],
                      ),
                    );
                  },
                ),
                ValueListenableBuilder<double>(
                  valueListenable: percentVisibleNotifier,
                  builder: (_, percentVisible, child) {
                    return Positioned.fill(
                      top: widgetSize.height * (1.0 - percentVisible),
                      bottom: -widgetSize.height * 0.5 * (1.0 - percentVisible),
                      child: child,
                    );
                  },
                  child: LiquidPull(
                    liquidText: 'Sign Up',
                    child: IgnorePointer(
                      child: Container(color: Colors.transparent),
                    ),
                    backgroundColor: Colors.white,
                    textColor: Colors.black,
                    onWaveDraggingStart: () =>
                        enableScrollingNotifier.value = false,
                    onWaveDraggingEnd: () =>
                        enableScrollingNotifier.value = true,
                    onLiquidPullComplete: _navigateToRegistrationPage,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );

    if (kIsWeb) {
      child = MobileView(child: child);
    }
    return child;
  }

  Widget _translateAndFadeIn({
    @required Widget child,
    double translateDistance = 100.0,
  }) {
    return Transform.translate(
      offset: Offset(
        0.0,
        translateDistance * (1.0 - controller.value),
      ),
      child: Opacity(
        opacity: controller.value,
        child: child,
      ),
    );
  }

  _navigateToRegistrationPage() {
    Navigator.push(
      context,
      FadeRoute(page: RegistrationPage()),
    );
  }
}
