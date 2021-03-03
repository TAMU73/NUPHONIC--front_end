import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nuphonic_front_end/src/app_logics/services/file_services.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/custom_app_bar.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/custom_button.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/custom_snackbar.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/custom_textfield.dart';
import 'package:nuphonic_front_end/src/views/utils/consts.dart';
import 'package:nuphonic_front_end/src/views/utils/genres.dart';

class UploadSongs extends StatefulWidget {
  @override
  _UploadSongsState createState() => _UploadSongsState();
}

class _UploadSongsState extends State<UploadSongs> {
  CustomSnackBar _customSnackBar = CustomSnackBar();
  FileServices _fileServices = FileServices();

  List _genres = [];
  List _albums = [];

  String songFileName = '';
  String songImageFileName = '';

  String songName;
  String songDescription;
  String songUrl;
  String songPictureUrl;
  String genreName;
  String artistId;
  String artistName;

  //optional
  String albumId;
  String albumName;
  String songLyrics;

  bool showOptionalFields = false;

  Widget _genreDropDownList() {
    return DropdownButtonHideUnderline(
      child: DropdownButton(
        icon: SvgPicture.asset('assets/icons/drop_down.svg'),
        hint: Text(
          'Select Genre',
          style: normalFontStyle.copyWith(
              color: whitishColor.withOpacity(0.25),
              fontSize: 13,
              letterSpacing: 0.5),
        ),
        style: normalFontStyle,
        dropdownColor: darkGreyColor,
        isExpanded: true,
        value: genreName,
        items: _genres.map((genre) {
          return DropdownMenuItem(
            value: genre.genreName,
            child: Text(genre.genreName),
          );
        }).toList(),
        onChanged: (selectedItem) {
          setState(() {
            genreName = selectedItem;
          });
        },
      ),
    );
  }
  Widget _albumDropDownList() {
    return DropdownButtonHideUnderline(
      child: DropdownButton(
        icon: SvgPicture.asset('assets/icons/drop_down.svg'),
        hint: Text(
          'Select Album',
          style: normalFontStyle.copyWith(
              color: whitishColor.withOpacity(0.25),
              fontSize: 13,
              letterSpacing: 0.5),
        ),
        style: normalFontStyle,
        dropdownColor: darkGreyColor,
        isExpanded: true,
        value: albumName,
        items: _albums.map((album) {
          return DropdownMenuItem(
            value: album.albumName,
            child: Text(album.albumName),
          );
        }).toList(),
        onChanged: (selectedItem) {
          setState(() {
            genreName = selectedItem;
          });
        },
      ),
    );
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

  Widget _showOptionalFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(
          color: whitishColor.withOpacity(0.5),
          indent: 30,
          endIndent: 30,
          thickness: 0.2,
        ),
        SizedBox(height: 10),
        CustomTextField(
          labelName: 'Song Lyrics',
          hint: 'Add Lyrics here...',
          maxLines: 5,
          onChanged: (val) {
            setState(() {
              songDescription = val;
            });
          },
        ),
        SizedBox(height: 15),
        Text(
          'Song Album',
          style: texFieldLabelStyle,
        ),
        SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            color: textFieldColor,
            height: 53,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: _albumDropDownList(),
            ),
          ),
        ),
      ],
    );
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializeFlutterFire();
    _genres = allGenres;
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
                  label: 'Upload',
                  leadIconPath: 'assets/icons/back_icon.svg',
                  onIconTap: () {
                    Get.back();
                  },
                ),
                SizedBox(height: 20),
                CustomTextField(
                  labelName: 'Song Name',
                  hint: 'Name of the song',
                  onChanged: (val) {
                    setState(() {
                      songName = val;
                    });
                  },
                ),
                SizedBox(height: 15),
                CustomTextField(
                  labelName: 'Song Description',
                  hint: 'Add description here...',
                  maxLines: 5,
                  onChanged: (val) {
                    setState(() {
                      songDescription = val;
                    });
                  },
                ),
                SizedBox(height: 15),
                Text(
                  'Song Genre',
                  style: texFieldLabelStyle,
                ),
                SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    color: textFieldColor,
                    height: 53,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: _genreDropDownList(),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                _chooseFile(
                  label: 'Song File',
                  fileName: songFileName,
                  onPressed: () async {
                    setState(() {
                      songFileName = 'Uploading...';
                    });
                    List result =
                        await _fileServices.uploadFile(UploadFileType.songs);
                    if (result != null) {
                      setState(() {
                        songUrl = result[0].toString();
                        songFileName = result[1].toString();
                      });
                    } else {
                      setState(() {
                        songFileName = '';
                      });
                    }
                  },
                ),
                SizedBox(height: 15),
                _chooseFile(
                  label: 'Song Image File',
                  fileName: songImageFileName,
                  onPressed: () async {
                    setState(() {
                      songImageFileName = 'Uploading...';
                    });
                    List result =
                        await _fileServices.uploadFile(UploadFileType.images);
                    if (result != null) {
                      setState(() {
                        songPictureUrl = result[0].toString();
                        songImageFileName = result[1].toString();
                      });
                    } else {
                      setState(() {
                        songImageFileName = '';
                      });
                    }
                  },
                ),
                SizedBox(height: 15),
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: showOptionalFields ? _showOptionalFields() : InkWell(
                      onTap: () {
                        setState(() {
                          showOptionalFields = true;
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Show Optional Fields',
                            style: normalFontStyle,
                          ),
                          SvgPicture.asset('assets/icons/drop_down.svg')
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                CustomButton(
                  labelName: "UPLOAD",
                  isLoading: false,

                ),
                SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
