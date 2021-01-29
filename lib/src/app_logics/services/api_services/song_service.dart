import 'package:dio/dio.dart';

class SongService {
  Dio dio = Dio();

  Future<dynamic> getSongDetails(String id) async {
    try {
      Response response = await dio.get(
          'https://nuphonic--backend.herokuapp.com/song_detail/$id',
          options: Options(contentType: Headers.formUrlEncodedContentType));
      return response;
    } on DioError catch (e) {
      return e.response;
    } catch (e) {
      return null;
    }
  }

  Future<dynamic> getBrowseSongs() async {
    try {
      Response response = await dio.get(
          'https://nuphonic--backend.herokuapp.com/browse_songs',
          options: Options(contentType: Headers.formUrlEncodedContentType));
      return response;
    } on DioError catch (e) {
      return e.response;
    } catch (e) {
      return null;
    }
  }

  Future<dynamic> getArtistSongs(String id) async {
    try {
      Response response = await dio.get(
          'https://nuphonic--backend.herokuapp.com/artist_songs/$id',
          options: Options(contentType: Headers.formUrlEncodedContentType));
      return response;
    } on DioError catch (e) {
      return e.response;
    } catch (e) {
      return null;
    }
  }

  Future<dynamic> addListen(String id) async {
    try {
      Response response = await dio.patch(
          'https://nuphonic--backend.herokuapp.com/add_listen/$id',
          options: Options(contentType: Headers.formUrlEncodedContentType));
      return response;
    } on DioError catch (e) {
      return e.response;
    } catch (e) {
      return null;
    }
  }

}