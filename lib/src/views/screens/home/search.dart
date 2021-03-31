import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nuphonic_front_end/src/app_logics/models/song_model.dart';
import 'package:nuphonic_front_end/src/app_logics/models/user_model.dart';
import 'package:nuphonic_front_end/src/app_logics/services/api_services/genre_service.dart';
import 'package:nuphonic_front_end/src/app_logics/services/api_services/search_services.dart';
import 'package:nuphonic_front_end/src/app_logics/services/shared_pref_services/shared_pref_service.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/custom_app_bar.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/custom_bottom_sheet.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/custom_snackbar.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/custom_text_button.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/custom_textfield.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/genre_box.dart';
import 'package:nuphonic_front_end/src/views/screens/search/search_artists.dart';
import 'package:nuphonic_front_end/src/views/screens/search/search_songs.dart';
import 'file:///C:/Users/DELL/Desktop/FYP/NUPHONIC%20-%20front_end/lib/src/views/screens/genre/genre_songs.dart';
import 'package:nuphonic_front_end/src/views/utils/consts.dart';
import 'package:nuphonic_front_end/src/views/utils/genres.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> with SingleTickerProviderStateMixin {
  PanelController controller = PanelController();
  TextEditingController searchController = TextEditingController();
  TextEditingController genreNameController = TextEditingController();
  TextEditingController genreDescriptionController = TextEditingController();
  SharedPrefService _sharedPrefService = SharedPrefService();
  GenreService _genreService = GenreService();
  SearchService _searchService = SearchService();
  CustomSnackBar _customSnackBar = CustomSnackBar();

  TabController _tabController;
  FocusNode searchNode;
  int selectedIndex = 0;

  String searchName = "";
  String genreName = "";
  String genreDescription = "";
  bool isLoading = false;
  bool isMainLoading = false;

  List genres;

  List<SongModel> songList = [];
  List<UserModel> artistList = [];

  Widget genreLists() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Column(
            children: genres
                .map(
                  (genre) => GenreBox(
                    onTap: () {
                      // getGenreSongs(genre.genreName);
                      Get.to(
                        GenreSongs(
                          genreName: genre.genreName,
                          genreColor: genre.color,
                        ),
                      );
                    },
                    genreName: genre.genreName,
                    color: Color(int.parse(genre.color)),
                    imageSrc: genre.imageSrc,
                  ),
                )
                .toList(),
          ),
          SizedBox(
            height: 10,
          ),
          CustomTextButton(
            label: 'SUGGEST GENRE',
            onPressed: () {
              controller.open();
            },
            isLoading: false,
          ),
          SizedBox(
            height: 80,
          ),
        ],
      ),
    );
  }

  Widget searchList(double height) {
    return Container(
      height: height - 230,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: TabBar(
              isScrollable: true,
              controller: _tabController,
              indicatorSize: TabBarIndicatorSize.label,
              labelStyle: normalFontStyle.copyWith(
                fontSize: 20,
              ),
              unselectedLabelStyle: normalFontStyle.copyWith(
                fontSize: 20,
              ),
              labelColor: mainColor,
              unselectedLabelColor: whitishColor.withOpacity(0.6),
              indicatorColor: Colors.transparent,
              tabs: [
                Text(
                  'Songs',
                ),
                Text(
                  'Artists',
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                SearchedSongs(
                  songList: songList,
                  searchNode: searchNode,
                ),
                SearchedArtists(
                  artistList: artistList,
                  searchNode: searchNode,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> searchSongs(String name) async {
    dynamic result = await _searchService.searchSongs(name);
    if (result == null) {
      _customSnackBar.buildSnackBar('Network Error, please try again.', false);
    } else {
      if (result.data['success']) {
        List list = result.data['songs'];
        List<SongModel> list1 = List<SongModel>();
        for (var song in list) {
          list1.add(SongModel.fromJson(song));
        }
        setState(() {
          songList.clear();
          songList = list1;
        });
      } else {
        _customSnackBar.buildSnackBar(
            result.data['msg'], result.data['success']);
      }
    }
  }

  Future<void> searchArtists(String name) async {
    dynamic result1 = await _searchService.searchArtists(name);
    if (result1 == null) {
      _customSnackBar.buildSnackBar('Network Error, please try again.', false);
    } else {
      if (result1.data['success']) {
        List list = result1.data['artists'];
        List<UserModel> list1 = List<UserModel>();
        for (var user in list) {
          list1.add(UserModel.fromJson(user));
        }
        setState(() {
          artistList.clear();
          artistList = list1;
        });
      } else {
        _customSnackBar.buildSnackBar(
            result1.data['msg'], result1.data['success']);
      }
    }
  }

  Future<void> search(String name) async {
    setState(() {
      isMainLoading = true;
    });
    searchSongs(name);
    await searchArtists(name);
    setState(() {
      isMainLoading = false;
    });
  }

  Future<void> suggestGenre(String genreName, String genreDescription) async {
    setState(() {
      isLoading = true;
    });
    String userID = await _sharedPrefService.read(id: 'user_id');
    dynamic result =
        await _genreService.suggestGenre(genreName, genreDescription, userID);
    setState(() {
      isLoading = false;
    });
    if (result == null) {
      await CustomSnackBar().buildSnackBar("Network Error", false);
    } else {
      await CustomSnackBar()
          .buildSnackBar(result.data['msg'], result.data['success']);
      if (result.data['success']) {
        setState(() {
          this.genreName = "";
          this.genreDescription = "";
        });
        genreDescriptionController.clear();
        genreNameController.clear();
        controller.close();
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    genres = allGenres;
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        selectedIndex = _tabController.index;
      });
    });
    searchNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: SafeArea(
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: CustomAppBar(
                      label: 'Search',
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Stack(
                      alignment: Alignment.centerLeft,
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: CustomTextField(
                            focusNode: searchNode,
                            controller: searchController,
                            hint: 'Search songs or artists',
                            contentPadding: EdgeInsets.only(
                              left: 50,
                              right: 35,
                            ),
                            textInputAction: TextInputAction.done,
                            onChanged: (val) {
                              setState(() {
                                searchName = val;
                              });
                              if (searchName != "") {
                                search(searchName);
                              } else {
                                setState(() {
                                  isMainLoading = false;
                                });
                              }
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: SvgPicture.asset(
                            'assets/icons/search.svg',
                          ),
                        ),
                        searchName != "" ? Positioned(
                          right: 15,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                searchName = "";
                              });
                              searchNode.unfocus();
                              searchController.clear();
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(left: 15),
                              child: SvgPicture.asset(
                                'assets/icons/cross.svg',
                              ),
                            ),
                          ),
                        ) : SizedBox(),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  isMainLoading
                      ? Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: loading,
                        )
                      : searchName != ""
                          ? searchList(height)
                          : genreLists()
                ],
              ),
            ),
          ),
          CustomBottomSheet(
            titleName: 'SUGGEST GENRE',
            labelName: 'Genre Name',
            hintName: 'Genre name',
            secondLabelName: 'Genre Description',
            secondHintName: 'Genre Description here',
            onPressed: genreName == "" || genreDescription == ""
                ? null
                : () {
                    suggestGenre(genreName, genreDescription);
                  },
            isLoading: isLoading,
            controller: controller,
            buttonName: 'SUGGEST',
            textController: genreNameController,
            secondTextController: genreDescriptionController,
            onChanged: (val) {
              setState(() {
                genreName = val;
              });
            },
            secondOnChanged: (val) {
              setState(() {
                genreDescription = val;
              });
            },
          )
        ],
      ),
    );
  }
}
