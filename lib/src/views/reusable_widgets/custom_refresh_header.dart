import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CustomRefreshHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomHeader(
      refreshStyle: RefreshStyle.Behind,
      builder: (context, mode) {
        return Container(
          color: Colors.white.withOpacity(0.07),
          child: SpinKitFadingCube(
            color: Color(0xff7B4BFF),
            duration: Duration(milliseconds: 800),
            size: 20,
          ),
        );
      },
    );
  }
}
