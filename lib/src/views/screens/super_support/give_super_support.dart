import 'package:flutter/material.dart';
import 'package:flutter_khalti/flutter_khalti.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nuphonic_front_end/src/app_logics/models/song_model.dart';
import 'package:nuphonic_front_end/src/app_logics/services/api_services/auth_service.dart';
import 'package:nuphonic_front_end/src/app_logics/services/api_services/support_services.dart';
import 'package:nuphonic_front_end/src/app_logics/services/shared_pref_services/shared_pref_service.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/custom_app_bar.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/custom_button.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/custom_snackbar.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/custom_textfield.dart';
import 'package:nuphonic_front_end/src/views/utils/consts.dart';

class GiveSuperSupport extends StatefulWidget {
  final SongModel song;

  GiveSuperSupport({this.song});

  @override
  _GiveSuperSupportState createState() => _GiveSuperSupportState();
}

class _GiveSuperSupportState extends State<GiveSuperSupport> {
  SharedPrefService _sharedPrefService = SharedPrefService();
  AuthService _auth = AuthService();
  CustomSnackBar _customSnackBar = CustomSnackBar();
  SupportServices _supportServices = SupportServices();

  TextEditingController _supportAmountController = TextEditingController();
  TextEditingController _messageController = TextEditingController();

  List _paymentOptions = [
    {'name': 'Khalti', 'color': Color(0xff5D2E8E)},
    // {'name': 'eSewa', 'color': Color(0xff60BB48)},
  ];

  bool isSupportAmountError = false;
  bool isLoading = false;

  String _supporterID = "";
  String _supporterName = "";
  String _supporterProfilePicture = "";
  SongModel _supportedSong;
  double _supportAmount;
  String _paymentOptionName;
  String _message = "";

  Widget _paymentDropDownList() {
    return DropdownButtonHideUnderline(
      child: DropdownButton(
        icon: SvgPicture.asset('assets/icons/drop_down.svg'),
        hint: Text(
          'Select Payment Option',
          style: normalFontStyle.copyWith(
            color: whitishColor.withOpacity(0.25),
            fontSize: 13,
            letterSpacing: 0.5,
          ),
        ),
        style: normalFontStyle,
        dropdownColor: darkGreyColor,
        isExpanded: true,
        value: _paymentOptionName,
        items: _paymentOptions.map((paymentOption) {
          return DropdownMenuItem(
            value: paymentOption['name'],
            child: Text(
              paymentOption['name'],
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: paymentOption['color'],
              ),
            ),
          );
        }).toList(),
        onChanged: (selectedItem) {
          setState(() {
            _paymentOptionName = selectedItem;
          });
        },
      ),
    );
  }

  Future<void> _getUserInfo() async {
    var userID = await _sharedPrefService.read(id: 'user_id');
    setState(() {
      _supporterID = userID;
    });
    dynamic result = await _auth.getUserInfo(userID);
    if (result != null) {
      setState(() {
        _supporterName = result.data['user']['username'];
        _supporterProfilePicture = result.data['user']['profile_picture'];
      });
    }
  }

  Future sendDonationKhalti() async {
    setState(() {
      isLoading = true;
    });
    FlutterKhalti _flutterKhalti = FlutterKhalti.configure(
      publicKey: "test_public_key_959391e7bb334739a8015e7931afb6da",
      urlSchemeIOS: "KhaltiPayFlutterExampleScheme",
    );

    KhaltiProduct product = KhaltiProduct(
      id: "${widget.song.songName}",
      amount: _supportAmount * 100,
      name: _message,
    );

    _flutterKhalti.startPayment(
      product: product,
      onSuccess: (data) async {
        dynamic result = await _supportServices.superSupport(
          paymentMethod: _paymentOptionName,
          message: _message,
          supportedAmount: _supportAmount,
          supportedSong: _supportedSong.toJson(),
          supporterID: _supporterID,
          supporterName: _supporterName,
          supporterProfilePicture: _supporterProfilePicture,
        );
        setState(() {
          isLoading = false;
        });
        if (result != null) {
          _customSnackBar.buildSnackBar(
              result.data['msg'], result.data['success']);
          if (result.data['success']) {
            setState(() {
              _paymentOptionName = null;
              _messageController.clear();
              _supportAmountController.clear();
            });
          }
        } else {
          _customSnackBar.buildSnackBar(
              'Something went wrong, Please try again.', false);
        }
      },
      onFaliure: (error) {
        setState(() {
          isLoading = false;
        });
        _customSnackBar.buildSnackBar(
            'Sorry, your payment was not successful.', false);
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _supportedSong = widget.song;
    _getUserInfo();
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
                  label: 'Super Support',
                  leadIconPath: 'assets/icons/back_icon.svg',
                  onIconTap: () {
                    Get.back();
                  },
                  endChild: SvgPicture.asset('assets/icons/supported.svg'),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: darkGreyColor,
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Container(
                                height: 40,
                                width: 40,
                                child: Image.network(
                                  widget.song.songImage,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              widget.song.songName,
                              style: normalFontStyle.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: whitishColor,
                                  fontSize: 22,
                                  letterSpacing: 0.5),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Text(
                              widget.song.artistName,
                              style: normalFontStyle.copyWith(
                                fontSize: 15,
                                color: whitishColor.withOpacity(0.7),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              child: Icon(
                                Icons.circle,
                                size: 5,
                                color: whitishColor.withOpacity(0.7),
                              ),
                            ),
                            Text(
                              widget.song.albumName,
                              style: normalFontStyle.copyWith(
                                fontSize: 15,
                                color: whitishColor.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                CustomTextField(
                  controller: _supportAmountController,
                  labelName: 'Support Amount',
                  hint: 'Support amount in Rs.',
                  keyboardType: TextInputType.number,
                  onChanged: (val) {
                    setState(() {
                      try {
                        setState(() {
                          if (val != "")
                            _supportAmount = double.parse(val);
                          else
                            _supportAmount = null;
                          isSupportAmountError = false;
                        });
                      } catch (e) {
                        setState(() {
                          isSupportAmountError = true;
                        });
                      }
                    });
                  },
                ),
                isSupportAmountError
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Supporting amount should only contain numeric value.',
                          style: normalFontStyle.copyWith(
                              fontSize: 12, color: reddishColor),
                        ),
                      )
                    : SizedBox(),
                SizedBox(height: 15),
                Text(
                  'Payment Option',
                  style: texFieldLabelStyle,
                ),
                SizedBox(height: 15),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    color: textFieldColor,
                    height: 53,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: _paymentDropDownList(),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                CustomTextField(
                  controller: _messageController,
                  labelName: 'Message',
                  hint: 'Add your message here...',
                  maxLines: 500,
                  height: 100,
                  onChanged: (val) {
                    setState(() {
                      _message = val;
                    });
                  },
                ),
                SizedBox(height: 50),
                CustomButton(
                  labelName: 'SUPPORT',
                  isLoading: isLoading,
                  onPressed: _supportAmount == null ||
                          _paymentOptionName == null ||
                          _message == "" ||
                          isSupportAmountError == true ||
                          _supporterID == "" ||
                          _supportedSong == null ||
                          _supporterName == "" ||
                          _supporterProfilePicture == ""
                      ? null
                      : () {
                          sendDonationKhalti();
                        },
                ),
                SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
