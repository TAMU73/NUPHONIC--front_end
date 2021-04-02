import 'package:dio/dio.dart';

class FavouriteServices {
  Dio dio = Dio();

  Future<dynamic> addFavouriteSongs(String songID, String userID) async {
    try {
      Response response = await dio.patch(
          'https://nuphonic--backend.herokuapp.com/add_favourite_songs',
          data: {"song_id": songID, "user_id": userID},
          options: Options(contentType: Headers.formUrlEncodedContentType));
      return response;
    } on DioError catch (e) {
      return e.response;
    } catch (e) {
      return null;
    }
  }

  Future<dynamic> removeFavouriteSongs(String songID, String userID) async {
    try {
      Response response = await dio.patch(
          'https://nuphonic--backend.herokuapp.com/remove_favourite_songs',
          data: {"song_id": songID, "user_id": userID},
          options: Options(contentType: Headers.formUrlEncodedContentType));
      return response;
    } on DioError catch (e) {
      return e.response;
    } catch (e) {
      return null;
    }
  }

  Future<dynamic> getFavouriteSongs(String userID) async {
    try {
      Response response = await dio.get(
          'https://nuphonic--backend.herokuapp.com/get_favourite_songs/$userID',
          options: Options(contentType: Headers.formUrlEncodedContentType));
      return response;
    } on DioError catch (e) {
      return e.response;
    } catch (e) {
      return null;
    }
  }

  Future<dynamic> addFavouriteArtists(String artistID, String userID) async {
    try {
      Response response = await dio.patch(
          'https://nuphonic--backend.herokuapp.com/add_favourite_artists',
          data: {"artist_id": artistID, "user_id": userID},
          options: Options(contentType: Headers.formUrlEncodedContentType));
      return response;
    } on DioError catch (e) {
      return e.response;
    } catch (e) {
      return null;
    }
  }

  Future<dynamic> removeFavouriteArtists(String artistID, String userID) async {
    try {
      Response response = await dio.patch(
          'https://nuphonic--backend.herokuapp.com/remove_favourite_artists',
          data: {"artist_id": artistID, "user_id": userID},
          options: Options(contentType: Headers.formUrlEncodedContentType));
      return response;
    } on DioError catch (e) {
      return e.response;
    } catch (e) {
      return null;
    }
  }

  Future<dynamic> getFavouriteArtists(String userID) async {
    try {
      Response response = await dio.get(
          'https://nuphonic--backend.herokuapp.com/get_favourite_artists/$userID',
          options: Options(contentType: Headers.formUrlEncodedContentType));
      return response;
    } on DioError catch (e) {
      return e.response;
    } catch (e) {
      return null;
    }
  }
}