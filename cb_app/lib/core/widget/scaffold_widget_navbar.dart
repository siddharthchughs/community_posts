import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ScaffoldWidgetNavbar extends StatelessWidget {
  const ScaffoldWidgetNavbar({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            label: 'Post',
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: 'Search',
            icon: Icon(Icons.search_outlined),
            activeIcon: Icon(Icons.search),
          ),
          BottomNavigationBarItem(
            label: 'Profile',
            icon: Icon(Icons.person_outlined),
            activeIcon: Icon(Icons.person),
          ),
        ],
        currentIndex: navigationShell.currentIndex,
        onTap: (int index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
      ),
    );
  }
}
