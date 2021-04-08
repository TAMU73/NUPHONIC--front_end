import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nuphonic_front_end/src/app_logics/services/api_services/album_services.dart';
import 'package:nuphonic_front_end/src/app_logics/services/api_services/auth_service.dart';
import 'package:nuphonic_front_end/src/app_logics/services/file_services.dart';
import 'package:nuphonic_front_end/src/app_logics/services/shared_pref_services/shared_pref_service.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/custom_app_bar.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/custom_button.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/custom_snackbar.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/custom_textfield.dart';
import 'package:nuphonic_front_end/src/views/utils/consts.dart';

class CreateAlbum extends StatefulWidget {
  @override
  _CreateAlbumState createState() => _CreateAlbumState();
}

class _CreateAlbumState extends State<CreateAlbum> {
  FileServices _fileServices = FileServices();
  AlbumServices _albumServices = AlbumServices();
  CustomSnackBar _customSnackBar = CustomSnackBar();
  SharedPrefService _sharedPrefService = SharedPrefService();
  AuthService _auth = AuthService();

  String albumName = '';
  String artistId = '';
  String artistName = '';
  String albumPictureUrl = '';
  String albumDescription = '';

  String albumImageFileName = '';

  bool allFields = false;
  bool isLoading = false;

  void checkTextFields() {
    if (albumName == '' ||
        artistId == '' ||
        artistName == '' ||
        albumPictureUrl == '' ||
        albumDescription == '') {
      allFields = false;
    } else {
      setState(() {
        allFields = true;
      });
    }
  }

  Future<void> _getUserInfo() async {
    var userID = await _sharedPrefService.read(id: 'user_id');
    setState(() {
      artistId = userID;
    });
    dynamic result = await _auth.getUserInfo(userID);
    if (result != null) {
      setState(() {
        artistName = result.data['user']['username'];
      });
    }
  }

  Future<void> _create() async {
    setState(() {
      isLoading = true;
    });
    dynamic result = await _albumServices.createAlbum(
      albumName: albumName,
      artistName: artistName,
      artistID: artistId,
      albumPicture: albumPictureUrl,
      albumDescription: albumDescription
    );
    setState(() {
      isLoading = false;
    });
    if (result == null) {
      _customSnackBar.buildSnackBar('Network Error', false);
    } else {
      if(result.data['success']) {
        await _customSnackBar.buildSnackBar(result.data['msg'], result.data['success']);
        Get.back();
      } else {
        _customSnackBar.buildSnackBar(result.data['msg'], result.data['success']);
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
      _customSnackBar.buildSnackBar('Failed to initialize firebase.', false);
    }
  }

  Widget _chooseFile({String label, Function onPressed, String fileName}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: texFieldLabelStyle,
        ),
        SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: InkWell(
            onTap: onPressed,
            child: Container(
              height: 55,
              width: Size.infinite.width,
              color: textFieldColor,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    fileName == '' ? 'Choose file' : fileName,
                    style: normalFontStyle.copyWith(
                      color: whitishColor.withOpacity(
                          fileName == '' || fileName == 'Uploading...'
                              ? 0.25
                              : 1),
                      fontSize: 13,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializeFlutterFire();
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
                SizedBox(height: 20),
                CustomAppBar(
                  label: 'Create Album',
                  leadIconPath: 'assets/icons/back_icon.svg',
                  onIconTap: () {
                    Get.back();
                  },
                ),
                SizedBox(height: 20),
                CustomTextField(
                  labelName: 'Album Name',
                  hint: 'Name of the album',
                  onChanged: (val) {
                    setState(() {
                      albumName = val;
                    });
                    checkTextFields();
                  },
                ),
                SizedBox(height: 15),
                Container(
                  child: CustomTextField(
                    labelName: 'Album Description',
                    hint: 'Add description here...',
                    maxLines: 100,
                    height: 100,
                    onChanged: (val) {
                      setState(() {
                        albumDescription = val;
                      });
                      checkTextFields();
                    },
                  ),
                ),
                SizedBox(height: 15),
                _chooseFile(
                  label: 'Album Image File',
                  fileName: albumImageFileName,
                  onPressed: () async {
                    setState(() {
                      albumImageFileName = 'Uploading...';
                    });
                    List result =
                        await _fileServices.uploadFile(UploadFileType.images);
                    if (result != null) {
                      setState(() {
                        albumPictureUrl = result[0].toString();
                        albumImageFileName = result[1].toString();
                      });
                    } else {
                      setState(() {
                        albumImageFileName = '';
                        albumPictureUrl = '';
                      });
                    }
                    checkTextFields();
                  },
                ),
                SizedBox(height: 15),
                SizedBox(height: 30),
                CustomButton(
                    labelName: "UPLOAD",
                    isLoading: isLoading,
                    onPressed: !allFields ? null : _create),
                SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
