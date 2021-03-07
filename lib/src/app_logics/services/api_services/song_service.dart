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

  Future<dynamic> deleteSong(String userId, String songId) async {
    try {
      Response response = await dio.delete(
          'https://nuphonic--backend.herokuapp.com/delete_song',
          options: Options(contentType: Headers.formUrlEncodedContentType),
          data: {'song_id': songId, 'user_id': userId});
      return response;
    } on DioError catch (e) {
      return e.response;
    } catch (e) {
      return null;
    }
  }

  Future<dynamic> uploadSong({
    String songName,
    String songDescription,
    String songURL,
    String songPictureURL,
    String genreName,
    String artistID,
    String artistName,
    String albumID,
    String albumName,
    String songLyrics,
  }) async {
    try {
      Response response = await dio.post(
        'https://nuphonic--backend.herokuapp.com/upload_song',
        data: {
          'song_name': songName,
          'song_description': songDescription,
          'song_url': songURL,
          'song_picture_url': songPictureURL,
          'genre_name': genreName,
          'artist_id': artistID,
          'artist_name': artistName,
          if (albumID != '') 'album_id': albumID,
          if (albumName != '') 'album_name': albumName,
          if (songLyrics != '') 'song_lyrics': songLyrics
        },
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );
      return response;
    } on DioError catch (e) {
      return e.response;
    } catch (e) {
      return null;
    }
  }
}
