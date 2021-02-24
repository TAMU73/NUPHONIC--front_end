import 'package:dio/dio.dart';

class PlaylistServices {
  Dio dio = Dio();

  Future<dynamic> deletePlaylistSongs(String songID, String playlistID) async {
    try {
      Response response = await dio.delete(
          'https://nuphonic--backend.herokuapp.com/delete_playlist_song',
          data: {
            "song_id": songID,
            "playlist_id": playlistID
          },
          options: Options(contentType: Headers.formUrlEncodedContentType));
      return response;
    } on DioError catch (e) {
      return e.response;
    } catch (e) {
      return null;
    }
  }

  Future<dynamic> deletePlaylists(String playlistID) async {
    try {
      Response response = await dio.delete(
          'https://nuphonic--backend.herokuapp.com/delete_playlist/$playlistID',
          options: Options(contentType: Headers.formUrlEncodedContentType));
      return response;
    } on DioError catch (e) {
      return e.response;
    } catch (e) {
      return null;
    }
  }

  Future<dynamic> getUserPlaylists(String userID) async {
    try {
      Response response = await dio.get(
          'https://nuphonic--backend.herokuapp.com/user_playlists/$userID',
          options: Options(contentType: Headers.formUrlEncodedContentType));
      return response;
    } on DioError catch (e) {
      return e.response;
    } catch (e) {
      return null;
    }
  }

  Future<dynamic> addPlaylistSongs(String songID, String playlistID) async {
    try {
      Response response = await dio.post(
          'https://nuphonic--backend.herokuapp.com/add_playlist_songs',
          data: {
            "song_id": songID,
            "playlist_id": playlistID
          },
          options: Options(contentType: Headers.formUrlEncodedContentType));
      return response;
    } on DioError catch (e) {
      return e.response;
    } catch (e) {
      return null;
    }
  }

  Future<dynamic> getPlaylistDetails(String playlistID) async {
    try {
      Response response = await dio.get(
          'https://nuphonic--backend.herokuapp.com/playlist_detail/$playlistID',
          options: Options(contentType: Headers.formUrlEncodedContentType));
      return response;
    } on DioError catch (e) {
      return e.response;
    } catch (e) {
      return null;
    }
  }

  Future<dynamic> createPlaylist(String playlistName, String userID) async {
    try {
      Response response = await dio.post(
          'https://nuphonic--backend.herokuapp.com/create_playlist',
          data: {
            "playlist_name": playlistName,
            "user_id": userID,
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