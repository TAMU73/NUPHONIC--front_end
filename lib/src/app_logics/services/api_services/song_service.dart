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

}