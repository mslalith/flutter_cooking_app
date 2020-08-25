import 'package:flutter/material.dart';

class BottomBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTap;

  const BottomBar({
    Key key,
    @required this.selectedIndex,
    @required this.onItemTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: onItemTap,
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
          icon: Icon(
            Icons.bookmark_border,
            color: Colors.black,
          ),
          title: Text(
            'Saved',
            style: TextStyle(color: Colors.black),
          ),
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.local_dining,
            color: Colors.black,
          ),
          title: Text(
            'Recipe',
            style: TextStyle(color: Colors.black),
          ),
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.local_bar,
            color: Colors.black,
          ),
          title: Text(
            'Products',
            style: TextStyle(color: Colors.black),
          ),
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.menu,
            color: Colors.black,
          ),
          title: Text(
            'Menu',
            style: TextStyle(color: Colors.black),
          ),
        ),
      ],
    );
  }
}
