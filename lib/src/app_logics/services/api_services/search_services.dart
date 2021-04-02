import 'package:dio/dio.dart';

class SearchService {
  Dio dio = Dio();

  Future<dynamic> searchSongs(String name) async {
    try {
      Response response = await dio.get(
          'https://nuphonic--backend.herokuapp.com/search_songs/$name',
          options: Options(contentType: Headers.formUrlEncodedContentType));
      return response;
    } on DioError catch (e) {
      return e.response;
    } catch (e) {
      return null;
    }
  }

  Future<dynamic> searchArtists(String name) async {
    try {
      Response response = await dio.get(
          'https://nuphonic--backend.herokuapp.com/search_artists/$name',
          options: Options(contentType: Headers.formUrlEncodedContentType));
      return response;
    } on DioError catch (e) {
      return e.response;
    } catch (e) {
      return null;
    }
  }
}
