import 'package:dio/dio.dart';
import 'package:nuphonic_front_end/src/app_logics/services/shared_pref_services/shared_pref_service.dart';

class AuthService {
  Dio dio = Dio();
  SharedPrefService _sharedPrefService = SharedPrefService();

  Future<dynamic> signIn(String email, String password) async {
    try {
      Response response = await dio.post(
          'https://nuphonic--backend.herokuapp.com/sign_in',
          data: {"email": email, "password": password},
          options: Options(contentType: Headers.formUrlEncodedContentType));
      return response;
    } on DioError catch (e) {
      return e.response;
    } catch (e) {
      return null;
    }
  }

  Future<dynamic> signUp(String fullName, String username, String email,
      String password, String retypePassword) async {
    try {
      Response response =
          await dio.post('https://nuphonic--backend.herokuapp.com/sign_up',
              data: {
                "full_name": fullName,
                "username": username,
                "email": email,
                "password": password,
                "retypePassword": retypePassword
              },
              options: Options(contentType: Headers.formUrlEncodedContentType));
      return response;
    } on DioError catch (e) {
      return e.response;
    } catch (e) {
      return null;
    }
  }

  Future<dynamic> forgotPassword(String email) async {
    try {
      Response response = await dio.patch(
          'https://nuphonic--backend.herokuapp.com/forgot_password',
          data: {
            "email": email,
          },
          options: Options(contentType: Headers.formUrlEncodedContentType));
      return response;
    } on DioError catch (e) {
      return e.response;
    } catch (e) {
      return null;
    }
  }

  Future<dynamic> confirmCode(String email, String code) async {
    try {
      Response response = await dio.patch(
          'https://nuphonic--backend.herokuapp.com/confirm_code',
          data: {"email": email, "code": code},
          options: Options(contentType: Headers.formUrlEncodedContentType));
      return response;
    } on DioError catch (e) {
      return e.response;
    } catch (e) {
      return null;
    }
  }

  Future<dynamic> resetPassword(String email, String password) async {
    try {
      Response response = await dio.patch(
          'https://nuphonic--backend.herokuapp.com/reset_password',
          data: {
            "email": email,
            "password": password,
            "retypePassword": password
          },
          options: Options(contentType: Headers.formUrlEncodedContentType));
      return response;
    } on DioError catch (e) {
      return e.response;
    } catch (e) {
      return null;
    }
  }

  Future<dynamic> getUserInfo(String id) async {
    try {
      Response response = await dio.get(
          'https://nuphonic--backend.herokuapp.com/get_info/$id',
          options: Options(contentType: Headers.formUrlEncodedContentType));
      return response;
    } on DioError catch (e) {
      return e.response;
    } catch (e) {
      return null;
    }
  }

  Future<dynamic> changeProfilePicture(String userID, String profilePicture) async {
    try {
      Response response = await dio.patch(
          'https://nuphonic--backend.herokuapp.com/edit_profile_picture',
          data: {
            "user_id": userID,
            "profile_picture": profilePicture
          },
          options: Options(contentType: Headers.formUrlEncodedContentType));
      return response;
    } on DioError catch (e) {
      return e.response;
    } catch (e) {
      return null;
    }
  }

  Future<dynamic> changeUsername(String userID, String username) async {
    try {
      Response response = await dio.patch(
          'https://nuphonic--backend.herokuapp.com/edit_username',
          data: {
            "user_id": userID,
            "username": username
          },
          options: Options(contentType: Headers.formUrlEncodedContentType));
      return response;
    } on DioError catch (e) {
      return e.response;
    } catch (e) {
      return null;
    }
  }

  Future<dynamic> changeFullName(String userID, String fullName) async {
    try {
      Response response = await dio.patch(
          'https://nuphonic--backend.herokuapp.com/edit_fullname',
          data: {
            "user_id": userID,
            "full_name": fullName
          },
          options: Options(contentType: Headers.formUrlEncodedContentType));
      return response;
    } on DioError catch (e) {
      return e.response;
    } catch (e) {
      return null;
    }
  }

  Future<dynamic> changePassword(String newPassword, String oldPassword) async {
    try {
      var userID = await _sharedPrefService.read(id: 'user_id');
      Response response = await dio.patch(
          'https://nuphonic--backend.herokuapp.com/change_password/$userID',
          data: {"newPassword": newPassword, "currentPassword": oldPassword},
          options: Options(contentType: Headers.formUrlEncodedContentType));
      return response;
    } on DioError catch (e) {
      return e.response;
    } catch (e) {
      return null;
    }
  }
}
