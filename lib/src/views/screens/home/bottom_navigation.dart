import 'dart:ui';

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nuphonic_front_end/src/app_logics/blocs/now_playing_bloc.dart';
import 'package:nuphonic_front_end/src/views/screens/home/home.dart';
import 'package:nuphonic_front_end/src/views/screens/home/library.dart';
import 'package:nuphonic_front_end/src/views/screens/home/search.dart';
import 'file:///C:/Users/DELL/Desktop/FYP/NUPHONIC%20-%20front_end/lib/src/views/screens/music/music_player.dart';
import 'package:nuphonic_front_end/src/views/utils/consts.dart';
import 'package:provider/provider.dart';

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
        backgroundColor: Colors.black,
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
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
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
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: SizedBox(
                  height: 65,
                  child: BottomNavigationBar(
                    backgroundColor: backgroundColor.withOpacity(0.7),
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
      ),
    );
  }
}
