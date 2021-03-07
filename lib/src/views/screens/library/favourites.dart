import 'package:flutter/material.dart';
import 'package:nuphonic_front_end/src/views/screens/library/favourites/favourite_artists.dart';
import 'package:nuphonic_front_end/src/views/screens/library/favourites/favourite_songs.dart';
import 'package:nuphonic_front_end/src/views/screens/library/favourites/playlists.dart';
import 'package:nuphonic_front_end/src/views/utils/consts.dart';

class Favourites extends StatefulWidget {
  @override
  _FavouritesState createState() => _FavouritesState();
}

class _FavouritesState extends State<Favourites>
    with SingleTickerProviderStateMixin {
  TabController _tabController1;

  List<Widget> tabs = [
    Playlists(),
    FavouriteArtists(),
    FavouriteSongs(),
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
                fontSize: 17,
              ),
              unselectedLabelStyle: normalFontStyle.copyWith(
                fontSize: 17,
              ),
              labelColor: mainColor,
              unselectedLabelColor: whitishColor.withOpacity(0.6),
              indicatorColor: Colors.transparent,
              tabs: [
                Text('Playlist'),
                Text('Artist'),
                Text('Songs'),
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
