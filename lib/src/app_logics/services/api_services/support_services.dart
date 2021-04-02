import 'package:dio/dio.dart';

class SupportServices {
  Dio dio = Dio();

  Future<dynamic> superSupport({
    String supporterID,
    String supporterName,
    String supporterProfilePicture,
    double supportedAmount,
    Map supportedSong,
    String message,
    String paymentMethod,
  }) async {
    try {
      Response response = await dio.post(
        'https://nuphonic--backend.herokuapp.com/super_support',
        data: {
          "supporter_id": supporterID,
          "supporter_name": supporterName,
          "supporter_profile_picture": supporterProfilePicture,
          "supported_amount": supportedAmount,
          "supported_song": supportedSong,
          "message": message,
          "payment_method": paymentMethod
        },
        options: Options(contentType: Headers.jsonContentType),
      );
      return response;
    } on DioError catch (e) {
      return e.response;
    } catch (e) {
      return null;
    }
  }

  Future<dynamic> getSuperSupporters(String userID) async {
    try {
      Response response = await dio.get(
          'https://nuphonic--backend.herokuapp.com/super_supporters/$userID',
          options: Options(contentType: Headers.formUrlEncodedContentType));
      return response;
    } on DioError catch (e) {
      return e.response;
    } catch (e) {
      return null;
    }
  }

  Future<dynamic> getSuperSupported(String userID) async {
    try {
      Response response = await dio.get(
          'https://nuphonic--backend.herokuapp.com/super_supported/$userID',
          options: Options(contentType: Headers.formUrlEncodedContentType));
      return response;
    } on DioError catch (e) {
      return e.response;
    } catch (e) {
      return null;
    }
  }
}
