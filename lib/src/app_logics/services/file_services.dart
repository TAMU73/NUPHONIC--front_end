import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:nuphonic_front_end/src/app_logics/services/shared_pref_services/shared_pref_service.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/custom_snackbar.dart';
import 'package:uuid/uuid.dart';

enum UploadFileType {
  songs,
  images,
}

class FileServices {
  Future<PlatformFile> chooseFile(UploadFileType type) async {
    if (type != UploadFileType.songs && type != UploadFileType.images)
      return null;
    FilePickerResult result = await FilePicker.platform.pickFiles(
        type: type == UploadFileType.songs || type == UploadFileType.images
            ? type == UploadFileType.songs
                ? FileType.audio
                : FileType.image
            : FileType.any);
    if (result != null) {
      PlatformFile file = result.files.first;
      return file;
    } else {
      return null;
    }
  }

  Future<List> uploadFile(UploadFileType uploadType) async {
    String type = uploadType == UploadFileType.images ? 'images' : 'songs';
    SharedPrefService _sharedPrefService = SharedPrefService();
    Uuid uuid = Uuid();
    CustomSnackBar _customSnackBar = CustomSnackBar();
    var userID = await _sharedPrefService.read(id: 'user_id');
    try {
      PlatformFile platformFile = await chooseFile(uploadType);
      if(platformFile != null) {
        File file = File(platformFile.path);
        String fileName = uuid.v1() + '.${platformFile.extension}';
        firebase_storage.FirebaseStorage storage =
            firebase_storage.FirebaseStorage.instance;
        await storage.ref('$type/$userID/$fileName').putFile(file);
        String url = await storage.ref('$type/$userID/$fileName').getDownloadURL();
        _customSnackBar.buildSnackBar('Successfully Uploaded the file.', true);
        return [
          url,
          platformFile.name
        ];
      } else {
        return null;
      }
    } catch (e) {
      _customSnackBar.buildSnackBar('Error in uploading file', false);
      return null;
    }
  }
}
