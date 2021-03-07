import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nuphonic_front_end/src/app_logics/models/supporter_model.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/custom_app_bar.dart';
import 'package:nuphonic_front_end/src/views/utils/consts.dart';

class SupportDetail extends StatelessWidget {
  final SupporterModel support;

  SupportDetail({this.support});

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

  Widget _showSupporterBox() {
    return ClipRRect(
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                CustomAppBar(
                  label: 'Supported by',
                  leadIconPath: 'assets/icons/back_icon.svg',
                  onIconTap: () {
                    Get.back();
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                _showSupporterBox(),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    SizedBox(width: 10,),
                    Text(
                      'For song ',
                      style: normalFontStyle.copyWith(
                          color: whitishColor.withOpacity(0.7)
                      ),
                    ),
                    Text(
                      'Batash',
                      style: normalFontStyle,
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    SizedBox(width: 10,),
                    Text(
                      'on ',
                      style: normalFontStyle.copyWith(
                          color: whitishColor.withOpacity(0.7)
                      ),
                    ),
                    Text(
                      'Dec 12, 2020',
                      style: normalFontStyle,
                    ),
                  ],
                ),
                SizedBox(height: 20,),
                Text(
                  'Support message',
                  style: normalFontStyle,
                  textAlign: TextAlign.justify,
                ),
                SizedBox(height: 20,),
                SizedBox(height: 20,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
