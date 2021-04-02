import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CustomRefreshHeader extends StatefulWidget {

  @override
  _CustomRefreshHeaderState createState() => _CustomRefreshHeaderState();
}

class _CustomRefreshHeaderState extends State<CustomRefreshHeader> with TickerProviderStateMixin {
  AnimationController _aniController, _scaleController;
  RefreshController _refreshControllers = RefreshController();

  @override
  void initState() {
    // TODO: implement initState
    _aniController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 2000));
    _scaleController =
        AnimationController(value: 0.0, vsync: this, upperBound: 1.0);
    _refreshControllers.headerMode.addListener(() {
      if (_refreshControllers.headerStatus == RefreshStatus.idle) {
        _scaleController.value = 0.0;
        _aniController.reset();
      } else if (_refreshControllers.headerStatus == RefreshStatus.refreshing) {
        _aniController.repeat();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomHeader(
      refreshStyle: RefreshStyle.Behind,
      onOffsetChange: (offset) {
        if (_refreshControllers.headerMode.value != RefreshStatus.refreshing)
          _scaleController.value = offset / 80.0;
      },
      builder: (context, mode) {
        return Container(
          color: Colors.white.withOpacity(0.07),
          child: FadeTransition(
            opacity: _scaleController,
            child: ScaleTransition(
              child: SpinKitFadingCube(
                controller: _aniController,
                color: Color(0xff7B4BFF),
                duration: Duration(milliseconds: 800),
                size: 20,
              ),
              scale: _scaleController,
            ),
          ),
          alignment: Alignment.center,
        );
      },
    );
  }
}
