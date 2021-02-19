import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nuphonic_front_end/src/app_logics/models/SupporterModel.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/custom_error.dart';
import 'package:nuphonic_front_end/src/views/screens/library/uploads/support_detail.dart';
import 'package:nuphonic_front_end/src/views/utils/consts.dart';

class Supporters extends StatefulWidget {
  @override
  _SupportersState createState() => _SupportersState();
}

class _SupportersState extends State<Supporters> {
  double total = 0;

  List<SupporterModel> _supporters = [
    SupporterModel(supportedAmount: 100),
    SupporterModel(supportedAmount: 400),
    SupporterModel(supportedAmount: 400),
    SupporterModel(supportedAmount: 400),
    SupporterModel(supportedAmount: 400),
    SupporterModel(supportedAmount: 400),
    SupporterModel(supportedAmount: 400),
  ];

  void _countTotalSupport() {
    _supporters.map((e) {
      setState(() {
        total = e.supportedAmount;
      });
    });
  }

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
              'There are no supports as of now. But you can have by uploading more on this platform.',
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

  Widget _showSupporterImage() {
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
              'https://miro.medium.com/max/3840/1*LPESvqEeQ9V3DAx-6cD6SQ.jpeg',
              height: 56,
              fit: BoxFit.cover,
            ),
            // profilePicture == null ? SizedBox() : Image.network(profilePicture),
          ],
        ),
      ),
    );
  }

  Widget _showSupporterDetail() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'SHuas',
          style: normalFontStyle.copyWith(
              fontWeight: FontWeight.w600, fontSize: 18),
        ),
        Text(
          'SHuas dsfas',
          style: normalFontStyle.copyWith(color: whitishColor.withOpacity(0.6)),
        ),
      ],
    );
  }

  Widget _supportedAmount() {
    return Text(
      'Rs. 100',
      style: normalFontStyle.copyWith(color: greenishColor, fontSize: 16),
    );
  }

  Widget _supporterBox(SupporterModel supporter) {
    return InkWell(
      onTap: () {
        Get.to(SupportDetail());
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
                    _showSupporterImage(),
                    SizedBox(
                      width: 10,
                    ),
                    _showSupporterDetail(),
                    Spacer(),
                    _supportedAmount()
                  ],
                ),
              )),
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
