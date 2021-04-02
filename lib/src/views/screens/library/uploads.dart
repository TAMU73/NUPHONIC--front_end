import 'package:flutter/material.dart';
import 'package:nuphonic_front_end/src/views/screens/library/uploads/supporters.dart';
import 'package:nuphonic_front_end/src/views/screens/library/uploads/uploaded_albums.dart';
import 'package:nuphonic_front_end/src/views/screens/library/uploads/uploaded_songs.dart';
import 'package:nuphonic_front_end/src/views/utils/consts.dart';

class Uploads extends StatefulWidget {
  @override
  _UploadsState createState() => _UploadsState();
}

class _UploadsState extends State<Uploads> with SingleTickerProviderStateMixin {
  TabController _tabController1;

  List<Widget> tabs = [
    UploadedSongs(),
    UploadedAlbums(),
    Supporters(),
  ];

  int selectedIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController1 = TabController(length: tabs.length, vsync: this);
    _tabController1.addListener(() {
      setState(() {
        selectedIndex = _tabController1.index;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 50,
            child: TabBar(
              isScrollable: true,
              controller: _tabController1,
              indicatorSize: TabBarIndicatorSize.label,
              labelStyle: normalFontStyle.copyWith(
                fontSize: 18,
              ),
              unselectedLabelStyle: normalFontStyle.copyWith(
                fontSize: 18,
              ),
              labelColor: mainColor,
              unselectedLabelColor: whitishColor.withOpacity(0.6),
              indicatorColor: Colors.transparent,
              tabs: [
                Text('Songs'),
                Text('Albums'),
                Text('Supporters'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController1,
              children: tabs,
            ),
          ),
        ],
      ),
    );
  }
}
