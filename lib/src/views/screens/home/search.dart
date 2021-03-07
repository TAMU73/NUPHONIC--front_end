import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nuphonic_front_end/src/app_logics/models/genre_model.dart';
import 'package:nuphonic_front_end/src/app_logics/services/api_services/genre_service.dart';
import 'package:nuphonic_front_end/src/app_logics/services/shared_pref_services/shared_pref_service.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/custom_app_bar.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/custom_bottom_sheet.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/custom_snackbar.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/custom_text_button.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/custom_textfield.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/genre_box.dart';
import 'file:///C:/Users/DELL/Desktop/FYP/NUPHONIC%20-%20front_end/lib/src/views/screens/genre/genre_songs.dart';
import 'package:nuphonic_front_end/src/views/utils/consts.dart';
import 'package:nuphonic_front_end/src/views/utils/genres.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  PanelController controller = PanelController();
  TextEditingController genreNameController = TextEditingController();
  TextEditingController genreDescriptionController = TextEditingController();
  SharedPrefService _sharedPrefService = SharedPrefService();
  GenreService _genreService = GenreService();

  String genreName = "";
  String genreDescription = "";
  bool isLoading = false;

  List genres;

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
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    CustomAppBar(
                      label: 'Search',
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Stack(
                      alignment: Alignment.centerLeft,
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: CustomTextField(
                            hint: 'Search songs or artists',
                            contentPadding: EdgeInsets.only(
                              left: 50,
                            ),
                            textInputAction: TextInputAction.search,
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: SvgPicture.asset(
                              'assets/icons/search.svg',
                            ))
                      ],
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Column(
                      children: [
                        Column(
                          children: genres
                              .map(
                                (genre) => GenreBox(
                                  onTap: () {
                                    // getGenreSongs(genre.genreName);
                                    Get.to(GenreSongs(
                                      genreName: genre.genreName,
                                      genreColor: genre.color,
                                    ));
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
                    )
                  ],
                ),
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
