import 'package:dio/dio.dart';

class AuthService {
  Dio dio = Dio();

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
}
