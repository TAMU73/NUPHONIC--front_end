import 'package:dio/dio.dart';

class AlbumServices {
  Dio dio = Dio();

  Future<dynamic> addAlbumSongs(String songID, String albumID) async {
    try {
      Response response = await dio.patch(
          'https://nuphonic--backend.herokuapp.com/add_album_songs',
          data: {
            "song_id": songID,
            "album_id": albumID
          },
          options: Options(contentType: Headers.formUrlEncodedContentType));
      return response;
    } on DioError catch (e) {
      return e.response;
    } catch (e) {
      return null;
    }
  }

  Future<dynamic> getAlbumDetails(String albumID) async {
    try {
      Response response = await dio.get(
          'https://nuphonic--backend.herokuapp.com/album_detail/$albumID',
          options: Options(contentType: Headers.formUrlEncodedContentType));
      return response;
    } on DioError catch (e) {
      return e.response;
    } catch (e) {
      return null;
    }
  }

  Future<dynamic> createAlbum(String albumName, String artistID, String artistName, String albumPicture, String albumDescription) async {
    try {
      Response response = await dio.post(
          'https://nuphonic--backend.herokuapp.com/create_album',
          data: {
            "album_name": albumName,
            "artist_id": artistID,
            "artist_name": artistName,
            "album_picture": albumPicture,
            "album_description": albumDescription
          },
          options: Options(contentType: Headers.formUrlEncodedContentType));
      return response;
    } on DioError catch (e) {
      return e.response;
    } catch (e) {
      return null;
    }
  }

}