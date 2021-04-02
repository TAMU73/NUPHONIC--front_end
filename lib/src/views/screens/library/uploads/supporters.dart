import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nuphonic_front_end/src/app_logics/models/supporter_model.dart';
import 'package:nuphonic_front_end/src/app_logics/services/api_services/support_services.dart';
import 'package:nuphonic_front_end/src/app_logics/services/shared_pref_services/shared_pref_service.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/custom_error.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/custom_refresh_header.dart';
import 'package:nuphonic_front_end/src/views/screens/library/uploads/support_detail.dart';
import 'package:nuphonic_front_end/src/views/utils/consts.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class Supporters extends StatefulWidget {
  @override
  _SupportersState createState() => _SupportersState();
}

class _SupportersState extends State<Supporters>
    with AutomaticKeepAliveClientMixin<Supporters> {
  @override
  bool get wantKeepAlive => true;

  RefreshController _refreshController = RefreshController();
  SharedPrefService _sharedPrefService = SharedPrefService();
  SupportServices _supportServices = SupportServices();

  double total;

  bool isLoading = false;

  List<SupporterModel> _supporters = [];

  Future<void> getSupporters() async {
    _supporters.clear();
    setState(() {
      isLoading = true;
    });
    var userID = await _sharedPrefService.read(id: 'user_id');
    dynamic result = await _supportServices.getSuperSupporters(userID);
    setState(() {
      isLoading = false;
    });
    if (result == null) {
    } else {
      if (result.data['success']) {
        dynamic supporterList = result.data['supporters'];
        for (var supporter in supporterList) {
          setState(() {
            _supporters.add(SupporterModel.fromJson(supporter));
          });
        }
      }
    }
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
            supporter.supporterProfilePicture != null
                ? Image.network(
                    supporter.supporterProfilePicture,
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
        fontSize: 17,
        fontWeight: FontWeight.w600,
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
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _supportedAmount(supporter),
                        Image.asset(
                          'assets/images/khalti_logo.png',
                          height: 25,
                        )
                      ],
                    )
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

  void atStart() async {
    await getSupporters();
    _countTotalSupport();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    total = 0;
    atStart();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? loading
        : SmartRefresher(
            controller: _refreshController,
            onRefresh: () {
              getSupporters()
                  .then((value) => _refreshController.refreshCompleted());
            },
            header: CustomRefreshHeader(),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _totalSupportAmount(),
                  SizedBox(
                    height: 20,
                  ),
                  _supporters.length == 0
                      ? _showErrorMessage()
                      : _showSupporters(),
                ],
              ),
            ),
          );
  }
}
