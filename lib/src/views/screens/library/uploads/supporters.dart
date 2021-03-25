import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nuphonic_front_end/src/app_logics/models/song_model.dart';
import 'package:nuphonic_front_end/src/app_logics/models/supporter_model.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/custom_error.dart';
import 'package:nuphonic_front_end/src/views/screens/library/uploads/support_detail.dart';
import 'package:nuphonic_front_end/src/views/utils/consts.dart';

class Supporters extends StatefulWidget {
  @override
  _SupportersState createState() => _SupportersState();
}

class _SupportersState extends State<Supporters>
    with AutomaticKeepAliveClientMixin<Supporters> {
  @override
  bool get wantKeepAlive => true;

  double total;

  List<SupporterModel> _supporters = [
    SupporterModel(
      supportID: 'id',
      supporterId: '5fd87603a1e53c2f5cb1d10d',
      supporterName: 'Shaswat Khadka',
      supportedAmount: 100,
      message: 'This is your message',
      paymentMethod: 'Khalti',
      supportedDate: '2020-12-15T08:36:22.615+00:00',
      supporterProfilePicture:
          'https://yt3.ggpht.com/ytc/AAUvwnjXKdJzqeiY1ald_XuvFG5hSmBEyj_NAp42WH__jCg=s88-c-k-c0x00ffffff-no-rj-mo',
      supportedSong: SongModel(
          songID: '5fd87895a1e53c2f5cb1d118',
          songName: 'Batash',
          publishedDate: '2020-12-15T08:36:22.615+00:00',
          songURL:
              'https://firebasestorage.googleapis.com/v0/b/darpandentalhome-3567e.appspot.com/o/BATASH%20Shashwot%20Khadka%20(Prod.%20by%20Sanjv)%20(Official%20Lyric%20Video).mp3?alt=media&token=e01d3818-378f-48cf-b495-d47d71b3dcf5',
          songImage: 'https://i.ytimg.com/vi/AtoZw7o2kRo/mqdefault.jpg',
          genreName: 'Independent',
          artistID: '5fd87603a1e53c2f5cb1d10d',
          artistName: 'Shashwat Khadka',
          albumID: null,
          albumName: 'Single',
          songDescription: 'hahaha',
          songLyrics: 'dsds',
          songListens: '324'),
    ),
    SupporterModel(
      supportID: 'id',
      supporterId: '5fd87603a1e53c2f5cb1d10d',
      supporterName: 'Shaswat Khadka',
      supportedAmount: 400,
      message: 'This is your message',
      paymentMethod: 'Khalti',
      supportedDate: '2020-12-15T08:36:22.615+00:00',
      supporterProfilePicture:
          'https://yt3.ggpht.com/ytc/AAUvwnjXKdJzqeiY1ald_XuvFG5hSmBEyj_NAp42WH__jCg=s88-c-k-c0x00ffffff-no-rj-mo',
      supportedSong: SongModel(
          songID: '5fd87895a1e53c2f5cb1d118',
          songName: 'Batash',
          publishedDate: '2020-12-15T08:36:22.615+00:00',
          songURL:
              'https://firebasestorage.googleapis.com/v0/b/darpandentalhome-3567e.appspot.com/o/BATASH%20Shashwot%20Khadka%20(Prod.%20by%20Sanjv)%20(Official%20Lyric%20Video).mp3?alt=media&token=e01d3818-378f-48cf-b495-d47d71b3dcf5',
          songImage: 'https://i.ytimg.com/vi/AtoZw7o2kRo/mqdefault.jpg',
          genreName: 'Independent',
          artistID: '5fd87603a1e53c2f5cb1d10d',
          artistName: 'Shashwat Khadka',
          albumID: null,
          albumName: 'Single',
          songDescription: 'hahaha',
          songLyrics: 'dsds',
          songListens: '324'),
    ),
  ];

  Widget _totalSupportAmount() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        'Rs. ${total.toString()}',
        style: titleTextStyle.copyWith(color: greenishColor),
      ),
    );
  }

  Widget _showErrorMessage() {
    return Column(
      children: [
        SizedBox(
          height: 40,
        ),
        CustomError(
          title: 'No Supporters',
          subTitle:
              'There are no supports as of now. But you can have by uploading more songs on this platform.',
          buttonLabel: 'UPLOAD SONG',
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _showSupporters() {
    return Column(
      children: _supporters
          .map(
            (supporter) => _supporterBox(supporter),
          )
          .toList(),
    );
  }

  Widget _showSupporterImage(SupporterModel supporter) {
    return CircleAvatar(
      radius: 28,
      backgroundColor: backgroundColor,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: Stack(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: backgroundColor,
              child: Icon(
                Icons.person_outline_outlined,
                color: mainColor,
                size: 30,
              ),
            ),
            Image.network(
              supporter.supporterProfilePicture,
              height: 56,
              fit: BoxFit.cover,
            ),
            // profilePicture == null ? SizedBox() : Image.network(profilePicture),
          ],
        ),
      ),
    );
  }

  Widget _showSupporterDetail(SupporterModel supporter) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          supporter.supporterName,
          style: normalFontStyle.copyWith(
              fontWeight: FontWeight.w600, fontSize: 18),
        ),
      ],
    );
  }

  Widget _supportedAmount(SupporterModel supporter) {
    return Text(
      'Rs. ${supporter.supportedAmount}',
      style: normalFontStyle.copyWith(
        color: greenishColor,
        fontSize: 16,
      ),
    );
  }

  Widget _supporterBox(SupporterModel supporter) {
    return InkWell(
      onTap: () {
        Get.to(SupportDetail(
          support: supporter,
        ));
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 25),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
              color: darkGreyColor,
              height: 80,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    _showSupporterImage(supporter),
                    SizedBox(
                      width: 10,
                    ),
                    _showSupporterDetail(supporter),
                    Spacer(),
                    _supportedAmount(supporter)
                  ],
                ),
              )),
        ),
      ),
    );
  }

  void _countTotalSupport() {
    double amount = 0;
    for (SupporterModel supporter in _supporters) {
      amount = amount + supporter.supportedAmount;
    }
    setState(() {
      total = amount;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    total = 0;
    _countTotalSupport();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _totalSupportAmount(),
          SizedBox(
            height: 20,
          ),
          _supporters.length == 0 ? _showErrorMessage() : _showSupporters(),
        ],
      ),
    );
  }
}
