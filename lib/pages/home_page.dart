import 'package:flutter/material.dart';
import 'package:flutter_cooking_app/widgets/home/bottom_bar.dart';
import 'package:flutter_cooking_app/widgets/home/home_list_item.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ValueNotifier<int> bottomBarIndex;
  ValueNotifier<bool> enableScrollingNotifier;

  @override
  void initState() {
    super.initState();
    bottomBarIndex = ValueNotifier(0);
    enableScrollingNotifier = ValueNotifier(true);
  }

  @override
  void dispose() {
    bottomBarIndex.dispose();
    enableScrollingNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          toolbarHeight: kToolbarHeight * 1.5,
          titleSpacing: 40.0,
          title: Text(
            'Foodima',
            style: TextStyle(fontFamily: 'Arimo'),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.add_circle_outline),
              onPressed: () {},
            ),
            const SizedBox(width: 16.0),
          ],
        ),
        bottomNavigationBar: ValueListenableBuilder(
          valueListenable: bottomBarIndex,
          builder: (_, index, child) => BottomBar(
            selectedIndex: index,
            onItemTap: (i) => bottomBarIndex.value = i,
          ),
        ),
        body: ValueListenableBuilder<bool>(
          valueListenable: enableScrollingNotifier,
          builder: (_, enableScrolling, child) {
            return ListView.builder(
              physics: enableScrolling
                  ? const BouncingScrollPhysics()
                  : const NeverScrollableScrollPhysics(),
              itemCount: 3,
              itemBuilder: (_, index) => HomeListItem(
                enableScrollingNotifier: enableScrollingNotifier,
                imagePath: 'images/recipe_${index + 1}.jpg',
              ),
            );
          },
        ),
      ),
    );
  }
}
