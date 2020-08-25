import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_cooking_app/widgets/common/circular_icon_button.dart';
import 'package:flutter_cooking_app/widgets/common/mobile_view.dart';

class RegistrationPage extends StatefulWidget {
  final Color backgroundColor;
  final Color textColor;

  const RegistrationPage({
    Key key,
    this.backgroundColor = Colors.white,
    this.textColor = Colors.black,
  }) : super(key: key);

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage>
    with SingleTickerProviderStateMixin {
  AnimationController controller;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..addListener(() => setState(() {}));

    controller.forward(from: 0.0);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget child = LayoutBuilder(
      builder: (_, constraints) {
        final boxSize = constraints.maxWidth * 0.25;

        return SafeArea(
          child: Scaffold(
            backgroundColor: widget.backgroundColor,
            body: Column(
              children: [
                SizedBox(
                  width: constraints.maxWidth,
                  height: 24.0,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24.0),
                  alignment: Alignment.centerLeft,
                  child: CircularIconButton(
                    icon: Icons.arrow_back_ios,
                    iconColor: widget.textColor,
                    iconSize: 16.0,
                    onPressed: Navigator.of(context).pop,
                  ),
                ),
                Expanded(
                  child: _translateAndFadeIn(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: boxSize,
                          height: boxSize,
                          decoration: BoxDecoration(
                            color: const Color(0xFF98F1EF),
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: Icon(
                            Icons.done,
                            size: boxSize * 0.4,
                            color: widget.textColor,
                          ),
                        ),
                        const SizedBox(height: 36.0),
                        Text(
                          'Congratulations!',
                          style: TextStyle(
                            fontSize: 30.0,
                            color: widget.textColor,
                          ),
                        ),
                        const SizedBox(height: 12.0),
                        Text(
                          'You have officially been\nregistered just in time!',
                          style: TextStyle(
                            color: widget.textColor.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                _translateAndFadeIn(
                  child: FlatButton(
                    onPressed: Navigator.of(context).pop,
                    child: Text('Cancel'),
                  ),
                ),
                const SizedBox(height: 24.0),
              ],
            ),
          ),
        );
      },
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
}
