import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nuphonic_front_end/src/app_logics/models/song_model.dart';
import 'package:nuphonic_front_end/src/app_logics/services/api_services/genre_service.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/custom_app_bar.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/custom_error.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/song_box.dart';
import 'package:nuphonic_front_end/src/views/utils/consts.dart';

class GenreSongs extends StatefulWidget {
  final String genreName;
  final String genreColor;

  GenreSongs({this.genreName, this.genreColor});

  @override
  _GenreSongsState createState() => _GenreSongsState();
}

class _GenreSongsState extends State<GenreSongs> {
  GenreService genreService = GenreService();

  bool isLoading = true;
  bool networkError = false;
  bool isEmpty = false;

  List<SongModel> genreSongs = [];

  Future<void> getGenreSongs(String genreName) async {
    dynamic result = await genreService.getGenreSongs(genreName);
    if (result == null) {
      setState(() {
        networkError = true;
      });
    } else {
      print(result.data);
      dynamic songList = result.data['songs'];
      if (songList == null) {
        setState(() {
          isEmpty = true;
          isLoading = false;
        });
      } else {
        for (var songs in songList) {
          setState(() {
            genreSongs.add(SongModel.fromJson(songs));
            isLoading = false;
          });
        }
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getGenreSongs(widget.genreName);
  }

  @override
  Widget build(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: networkError
            ? Container(
                height: height,
                child: CustomError(
                  buttonLabel: 'GO BACK',
                  onPressed: () {
                    Get.back();
                  },
                ),
              )
            : SafeArea(
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: CustomAppBar(
                        leadIconPath: 'assets/icons/back_icon.svg',
                        onIconTap: () {
                          Get.back();
                        },
                        label: '${widget.genreName} Songs',
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    isLoading
                        ? Container(
                            height: height - 200,
                            child: loading,
                          )
                        : isEmpty
                            ? Container(
                                height: height - 200,
                                child: CustomError(
                                  title: 'No Songs Found.',
                                  subTitle: 'Go back and try browsing another genre.',
                                  buttonLabel: 'GO BACK',
                                  onPressed: () {
                                    Get.back();
                                  },
                                )
                              )
                            : Column(
                                children: genreSongs
                                    .map(
                                      (song) => SongBox(
                                        song: song,
                                      ),
                                    )
                                    .toList())
                  ],
                ),
              ),
      ),
    );
    ;
  }
}
