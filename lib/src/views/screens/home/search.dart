import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nuphonic_front_end/src/app_logics/models/genre_model.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/custom_app_bar.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/custom_textfield.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/genre_box.dart';
import 'package:nuphonic_front_end/src/views/utils/consts.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  List genres = [
    Genre(
      color: Color(0xffF4D293),
      genreName: 'Hip Hop',
      imageSrc: 'https://images.pexels.com/photos/159613/ghettoblaster-radio-recorder-boombox-old-school-159613.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
    ),
    Genre(
      color: Color(0xffD8D8D9),
      genreName: 'Pop',
      imageSrc: 'https://images.pexels.com/photos/114820/pexels-photo-114820.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
    ),
    Genre(
      color: Color(0xffE0BA8F),
      genreName: 'Folk Rock',
      imageSrc: 'https://images.pexels.com/photos/6029957/pexels-photo-6029957.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
    ),
    Genre(
      color: Color(0xffA58E9F),
      genreName: 'Rock',
      imageSrc: 'https://images.pexels.com/photos/4629625/pexels-photo-4629625.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
    ),
    Genre(
      color: Color(0xffB7CEFB),
      genreName: 'Blues',
      imageSrc: 'https://images.pexels.com/photos/733767/pexels-photo-733767.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
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
                  height: 20,
                ),
                Column(
                  children: genres
                      .map(
                        (genre) => GenreBox(
                          genreName: genre.genreName,
                          color: genre.color,
                          imageSrc: genre.imageSrc,
                        ),
                      )
                      .toList(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
