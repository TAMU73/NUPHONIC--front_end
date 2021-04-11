import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nuphonic_front_end/src/app_logics/models/user_model.dart';
import 'package:nuphonic_front_end/src/app_logics/services/api_services/auth_service.dart';
import 'package:nuphonic_front_end/src/app_logics/services/file_services.dart';
import 'package:nuphonic_front_end/src/app_logics/services/shared_pref_services/shared_pref_service.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/back_blank.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/custom_app_bar.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/custom_button.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/custom_error.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/custom_snackbar.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/custom_textfield.dart';
import 'package:nuphonic_front_end/src/views/screens/library/change_password.dart';
import 'package:nuphonic_front_end/src/views/screens/library/suggest_feature.dart';
import 'package:nuphonic_front_end/src/views/utils/consts.dart';

class EditProfile extends StatefulWidget {
  final UserModel user;
  final String userID;

  EditProfile({this.user, this.userID});

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  AuthService _authService = AuthService();
  SharedPrefService _sharedPrefService = SharedPrefService();
  CustomSnackBar _customSnackBar = CustomSnackBar();
  FileServices _fileServices = FileServices();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _fullNameController = TextEditingController();

  String changeProfileTitle = "Change Picture";

  bool isLoading = false;
  bool networkError = false;
  UserModel user;

  Widget changeUserName(double width) {
    String username = "";
    bool isButtonLoading = false;
    return StatefulBuilder(builder: (context, setState) {
      return AlertDialog(
        backgroundColor: darkGreyColor,
        insetPadding: EdgeInsets.all(25),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        content: Container(
          width: width,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              CustomTextField(
                controller: _usernameController,
                labelName: 'Username',
                hint: 'New username',
                onChanged: (val) {
                  setState(() {
                    username = val;
                  });
                },
              ),
              SizedBox(
                height: 50,
              ),
              CustomButton(
                labelName: 'CHANGE',
                isLoading: isButtonLoading,
                onPressed: username == ""
                    ? null
                    : () async {
                        setState(() {
                          isButtonLoading = true;
                        });
                        var userID =
                            await _sharedPrefService.read(id: 'user_id');
                        dynamic result =
                            await _authService.changeUsername(userID, username);
                        if (result == null) {
                          _customSnackBar.buildSnackBar(
                              'Network error, please try again.', false);
                        } else {
                          if (!result.data['success']) {
                            _customSnackBar.buildSnackBar(
                                result.data['msg'], false);
                          } else {
                            _usernameController.clear();
                            _customSnackBar.buildSnackBar(
                                result.data['msg'], true);
                            setState(() {
                              username = "";
                            });
                          }
                        }
                        setState(() {
                          isButtonLoading = false;
                        });
                      },
              )
            ],
          ),
        ),
      );
    });
  }

  Widget changeFullName(double width) {
    String fullName = "";
    bool isButtonLoading = false;
    return StatefulBuilder(builder: (context, setState) {
      return AlertDialog(
        backgroundColor: darkGreyColor,
        insetPadding: EdgeInsets.all(25),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        content: Container(
          width: width,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              CustomTextField(
                controller: _fullNameController,
                labelName: 'Full Name',
                hint: 'New full name',
                onChanged: (val) {
                  setState(() {
                    fullName = val;
                  });
                },
              ),
              SizedBox(
                height: 50,
              ),
              CustomButton(
                labelName: 'CHANGE',
                isLoading: isButtonLoading,
                onPressed: fullName == ""
                    ? null
                    : () async {
                        setState(() {
                          isButtonLoading = true;
                        });
                        var userID =
                            await _sharedPrefService.read(id: 'user_id');
                        dynamic result =
                            await _authService.changeFullName(userID, fullName);
                        if (result == null) {
                          _customSnackBar.buildSnackBar(
                              'Network error, please try again.', false);
                        } else {
                          if (!result.data['success']) {
                            _customSnackBar.buildSnackBar(
                                result.data['msg'], false);
                          } else {
                            _fullNameController.clear();
                            _customSnackBar.buildSnackBar(
                                result.data['msg'], true);
                            setState(() {
                              fullName = "";
                            });
                          }
                        }
                        setState(() {
                          isButtonLoading = false;
                        });
                      },
              )
            ],
          ),
        ),
      );
    });
  }

  Widget settingContainer(double width, String name, Function onPressed) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        height: 55,
        width: width,
        decoration: BoxDecoration(
            color: darkGreyColor, borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              Text(
                name,
                style: normalFontStyle,
              ),
              Spacer(),
              SvgPicture.asset('assets/icons/proceed.svg')
            ],
          ),
        ),
      ),
    );
  }

  Future<void> pickProfilePicture() async {
    setState(() {
      changeProfileTitle = 'Uploading...';
    });
    List result1 = await _fileServices.uploadFile(UploadFileType.images);
    if (result1 != null) {
      await changeProfilePicture(result1[0].toString());
    }
    setState(() {
      changeProfileTitle = "Change Picture";
    });
  }

  Future<void> changeProfilePicture(String profilePicture) async {
    var userID = await _sharedPrefService.read(id: 'user_id');
    dynamic result =
        await _authService.changeProfilePicture(userID, profilePicture);
    if (result == null) {
      _customSnackBar.buildSnackBar('Network error, please try again.', false);
    } else {
      if (!result.data['success']) {
        _customSnackBar.buildSnackBar(result.data['msg'], false);
      } else {
        _customSnackBar.buildSnackBar(result.data['msg'], true);
        getUserDetail();
      }
    }
  }

  Future<void> getUserDetail() async {
    if (widget.user != null) {
      setState(() {
        user = widget.user;
      });
    } else {
      setState(() {
        isLoading = true;
      });
      dynamic result = await _authService.getUserInfo(widget.userID);
      if (result == null) {
        setState(() {
          networkError = true;
        });
      } else {
        Map<String, dynamic> artistDetail = result.data['user'];
        setState(() {
          isLoading = false;
          user = UserModel.fromJson(artistDetail);
        });
      }
    }
  }

  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();
      // _customSnackBar.buildSnackBar('Firebase Successfully initialized.', true);
    } catch (e) {
      // Set `_error` state to true if Firebase initialization fails
      _customSnackBar.buildSnackBar(
          'Failed to initialize firebase, please try again.', false);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserDetail();
    initializeFlutterFire();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: isLoading
            ? Container(
                child: BackBlank(
                  child: Expanded(child: Center(child: loading)),
                ),
              )
            : networkError
                ? CustomError(
                    title: 'Network Error.',
                    subTitle: 'Please check your connection and try again.',
                    onPressed: () {
                      getUserDetail();
                    },
                  )
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: CustomAppBar(
                            leadIconPath: 'assets/icons/back_icon.svg',
                            onIconTap: () {
                              Get.back();
                            },
                            label: "",
                          ),
                        ),
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: textFieldColor,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Stack(
                              children: [
                                CircleAvatar(
                                  radius: 50,
                                  backgroundColor: textFieldColor,
                                  child: Icon(
                                    Icons.person_outline_outlined,
                                    color: mainColor,
                                    size: 40,
                                  ),
                                ),
                                user.profilePicture == null
                                    ? SizedBox()
                                    : Image.network(
                                        user.profilePicture,
                                        height: 100,
                                        width: 100,
                                        fit: BoxFit.cover,
                                      ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        InkWell(
                          onTap: () {
                            pickProfilePicture();
                          },
                          child: Text(
                            changeProfileTitle,
                            style: normalFontStyle.copyWith(color: mainColor),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Opacity(
                                opacity: 0.4,
                                child: Text(
                                  'Account',
                                  style: normalFontStyle.copyWith(fontSize: 12),
                                ),
                              ),
                              Opacity(
                                opacity: 0.4,
                                child: Divider(
                                  color: whitishColor,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              settingContainer(
                                width,
                                'Change Username',
                                () {
                                  showDialog(
                                      context: context,
                                      builder: (_) => changeUserName(width));
                                },
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              settingContainer(
                                width,
                                'Change Full Name',
                                () {
                                  showDialog(
                                      context: context,
                                      builder: (_) => changeFullName(width));
                                },
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              settingContainer(
                                width,
                                'Change Password',
                                () {
                                  Get.to(ChangePassword());
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Opacity(
                                opacity: 0.4,
                                child: Text(
                                  'Help and Support',
                                  style: normalFontStyle.copyWith(fontSize: 12),
                                ),
                              ),
                              Opacity(
                                opacity: 0.4,
                                child: Divider(
                                  color: whitishColor,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              settingContainer(
                                width,
                                'Suggest Feature',
                                () {
                                  Get.to(SuggestFeature());
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }
}
