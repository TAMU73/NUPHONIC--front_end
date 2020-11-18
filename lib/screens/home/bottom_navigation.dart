import 'dart:ui';

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

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _navigationOption[_selectedIndex],
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
                    BottomNavigationBarItem(
                        icon: SvgPicture.asset(
                          'assets/icons/grid.svg',
                          color: _selectedIndex == 0 ? mainColor : whitishColor,
                        ),
                        label: 'Home'),
                    BottomNavigationBarItem(
                        icon: SvgPicture.asset(
                          'assets/icons/search.svg',
                          color: _selectedIndex == 1 ? mainColor : whitishColor,
                        ),
                        label: "Search"),
                    BottomNavigationBarItem(
                        icon: SvgPicture.asset(
                          'assets/icons/library.svg',
                          color: _selectedIndex == 2 ? mainColor : whitishColor,
                        ),
                        label: 'Library'),
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
