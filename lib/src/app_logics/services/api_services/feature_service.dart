import 'package:dio/dio.dart';

class FeatureService {
  Dio dio = Dio();

  Future<dynamic> getFeaturedSongs() async {
    try {
      Response response = await dio.get(
          'https://nuphonic--backend.herokuapp.com/featured_songs',
          options: Options(contentType: Headers.formUrlEncodedContentType));
      return response;
    } on DioError catch (e) {
      return e.response;
    } catch (e) {
      return null;
    }
  }

  Future<dynamic> getFeaturedArtists() async {
    try {
      Response response = await dio.get(
          'https://nuphonic--backend.herokuapp.com/featured_artists',
          options: Options(contentType: Headers.formUrlEncodedContentType));
      return response;
    } on DioError catch (e) {
      return e.response;
    } catch (e) {
      return null;
    }
  }
}