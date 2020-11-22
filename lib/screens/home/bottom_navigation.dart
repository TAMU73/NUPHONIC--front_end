import 'dart:ui';

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nuphonic_front_end/screens/home/home.dart';
import 'package:nuphonic_front_end/screens/home/library.dart';
import 'package:nuphonic_front_end/screens/home/search.dart';
import 'package:nuphonic_front_end/shared/shared.dart';

class BottomNavigation extends StatefulWidget {
  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _selectedIndex = 0;

  static List<Widget> _navigationOption = <Widget>[
    Home(),
    Search(),
    Library(),
  ];

  void changeNavigation(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  BottomNavigationBarItem bottomNavigationBarItem(
      String label, String iconPath, bool isSelected) {
    return BottomNavigationBarItem(
        icon: AnimatedContainer(
          duration: Duration(milliseconds: 400),
          curve: Curves.ease,
          height: isSelected ? 26 : 24,
          width: isSelected ? 26 : 24,
          child: SvgPicture.asset(
            iconPath,
            color: isSelected ? mainColor : whitishColor,
          ),
        ),
        label: label);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // PageTransitionSwitcher(
        //   transitionBuilder: (child, primaryAnimation, secondaryAnimation) {
        //     return FadeScaleTransition(
        //       animation: primaryAnimation,
        //       child: child,
        //     );
        //   },
        //   child: IndexedStack(
        //     index: _selectedIndex,
        //     key: ValueKey<int>(_selectedIndex),
        //     children: _navigationOption,
        //   ),
        // ),
        IndexedStack(
          index: _selectedIndex,
          children: _navigationOption,
        ),
        Align(
          alignment: AlignmentDirectional.bottomCenter,
          child: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 27.18, sigmaY: 27.18),
              child: SizedBox(
                height: 70,
                child: BottomNavigationBar(
                  backgroundColor: Colors.black.withOpacity(0.92),
                  items: <BottomNavigationBarItem>[
                    bottomNavigationBarItem(
                      'Home',
                      'assets/icons/grid.svg',
                      _selectedIndex == 0 ? true : false,
                    ),
                    bottomNavigationBarItem(
                      'Search',
                      'assets/icons/search.svg',
                      _selectedIndex == 1 ? true : false,
                    ),
                    bottomNavigationBarItem(
                      'Library',
                      'assets/icons/library.svg',
                      _selectedIndex == 2 ? true : false,
                    ),
                  ],
                  currentIndex: _selectedIndex,
                  onTap: changeNavigation,
                  showSelectedLabels: false,
                  showUnselectedLabels: false,
                  elevation: 0,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
