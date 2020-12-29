import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nuphonic_front_end/src/app_logics/models/genre_model.dart';
import 'package:nuphonic_front_end/src/app_logics/services/api_services/genre_service.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/custom_app_bar.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/custom_bottom_sheet.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/custom_text_button.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/custom_textfield.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/genre_box.dart';
import 'package:nuphonic_front_end/src/views/utils/consts.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  PanelController controller = PanelController();

  GenreService genreService = GenreService();

  List genres = [
    GenreModel(
      color: '0xff9B948B',
      genreName: 'Hip Hop',
      imageSrc:
          'https://images.pexels.com/photos/1319828/pexels-photo-1319828.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
    ),
    GenreModel(
      color: '0xffD8D8D9',
      genreName: 'Pop',
      imageSrc:
          'https://images.pexels.com/photos/114820/pexels-photo-114820.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
    ),
    GenreModel(
      color: '0xffA58E9F',
      genreName: 'Independent',
      imageSrc:
          'https://images.pexels.com/photos/3771823/pexels-photo-3771823.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940',
    ),
    GenreModel(
      color: '0xffE0BA8F',
      genreName: 'Rock',
      imageSrc:
          'https://images.pexels.com/photos/2956143/pexels-photo-2956143.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940',
    ),
    GenreModel(
      color: '0xffB7CEFB',
      genreName: 'Blues',
      imageSrc:
          'https://images.pexels.com/photos/733767/pexels-photo-733767.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
    ),
    GenreModel(
      color: '0xff9B9D9D',
      genreName: 'Acoustic',
      imageSrc:
          'https://images.pexels.com/photos/3971985/pexels-photo-3971985.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
    ),
    GenreModel(
      color: '0xffDBDBFF',
      genreName: 'Electronic',
      imageSrc:
          'https://images.pexels.com/photos/2111015/pexels-photo-2111015.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
    ),
  ];

  Future<void> getGenreSongs(String genreName) async {
    dynamic result = await genreService.getGenreSongs(genreName);
    if (result == null) {
      print('Network Error');
    } else {
      print(result.data);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                      children: genres
                          .map(
                            (genre) => GenreBox(
                              onTap: () {
                                getGenreSongs(genre.genreName);
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
              ),
            ),
          ),
          CustomBottomSheet(
            titleName: 'SUGGEST GENRE',
            labelName: 'Genre Name',
            hintName: 'Genre name',
            onPressed: () {},
            isLoading: false,
            controller: controller,
            buttonName: 'SUGGEST',
          )
        ],
      ),
    );
  }
}
