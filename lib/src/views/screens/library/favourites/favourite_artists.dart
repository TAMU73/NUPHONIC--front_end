import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nuphonic_front_end/src/app_logics/models/user_model.dart';
import 'package:nuphonic_front_end/src/app_logics/services/api_services/auth_service.dart';
import 'package:nuphonic_front_end/src/app_logics/services/api_services/favourite_services.dart';
import 'package:nuphonic_front_end/src/app_logics/services/shared_pref_services/shared_pref_service.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/custom_error.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/custom_refresh_header.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/custom_snackbar.dart';
import 'package:nuphonic_front_end/src/views/screens/music/user_profile.dart';
import 'package:nuphonic_front_end/src/views/utils/consts.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class FavouriteArtists extends StatefulWidget {
  @override
  _FavouriteArtistsState createState() => _FavouriteArtistsState();
}

class _FavouriteArtistsState extends State<FavouriteArtists>
    with AutomaticKeepAliveClientMixin<FavouriteArtists> {
  @override
  bool get wantKeepAlive => true;

  RefreshController _refreshController = RefreshController();
  CustomSnackBar _customSnackBar = CustomSnackBar();
  SharedPrefService _sharedPrefService = SharedPrefService();
  FavouriteServices _favouriteServices = FavouriteServices();
  AuthService _authService = AuthService();

  bool isLoading = true;
  List<UserModel> _favouriteArtists = [];

  Widget _showErrorMessage() {
    return CustomError(
      title: 'No Favourite Artist',
      subTitle: 'Check out some artist and mark them as favourite to see here.',
      onPressed: () {
        getFavouriteArtists();
      },
    );
  }

  Widget _artistImage(UserModel artist) {
    return CircleAvatar(
      radius: 30,
      backgroundColor: textFieldColor,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(60),
        child: Stack(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: textFieldColor,
              child: Icon(
                Icons.person_outline_outlined,
                color: mainColor,
                size: 30,
              ),
            ),
            artist.profilePicture != null
                ? Image.network(
                    artist.profilePicture,
                    height: 56,
                    fit: BoxFit.cover,
                  )
                : SizedBox(),
            // profilePicture == null ? SizedBox() : Image.network(profilePicture),
          ],
        ),
      ),
    );
  }

  Widget _artistName(UserModel artist) {
    return Text(
      artist.username,
      style: normalFontStyle.copyWith(fontSize: 18),
    );
  }

  Widget _favouriteArtistBox(UserModel artist) {
    return InkWell(
      onTap: () {
        Get.to(UserProfile(
          user: artist,
        ));
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 25),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            height: 60,
            child: Row(
              children: [
                _artistImage(artist),
                SizedBox(
                  width: 10,
                ),
                _artistName(artist),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _showArtists() {
    return Column(
      children: _favouriteArtists
          .map(
            (artist) => _favouriteArtistBox(artist),
          )
          .toList(),
    );
  }

  Future<void> getFavouriteArtists() async {
    setState(() {
      isLoading = true;
    });
    var userID = await _sharedPrefService.read(id: 'user_id');
    dynamic result = await _favouriteServices.getFavouriteArtists(userID);
    if (result == null) {
      setState(() {
        isLoading = false;
      });
      _customSnackBar.buildSnackBar('Network Error, please try again!!', false);
    } else {
      List artistDataList = result.data["artist_list"]["artist_list"];
      if (artistDataList != null && artistDataList.isNotEmpty) {
        List<UserModel> list = List<UserModel>();
        for (var artistID in artistDataList) {
          dynamic result1 = await _authService.getUserInfo(artistID);
          Map<String, dynamic> artistDetail = result1.data['user'];
          list.add(UserModel.fromJson(artistDetail));
        }
        _favouriteArtists.clear();
        setState(() {
          _favouriteArtists = list;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getFavouriteArtists();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? loading
        : _favouriteArtists.length == 0
            ? _showErrorMessage()
            : SmartRefresher(
                controller: _refreshController,
                onRefresh: () {
                  getFavouriteArtists()
                      .then((value) => _refreshController.refreshCompleted());
                },
                header: CustomRefreshHeader(),
                child: SingleChildScrollView(
                  child: Column(children: [
                    SizedBox(
                      height: 20,
                    ),
                    _showArtists()
                  ]),
                ),
              );
  }
}
