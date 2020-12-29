import 'package:dio/dio.dart';

class GenreService {
  Dio dio = Dio();

  Future<dynamic> getGenreSongs(String genreName) async {
    try {
      Response response = await dio.post(
          'https://nuphonic--backend.herokuapp.com/genre_songs',
          data: {
            "genre_name": genreName
          },
          options: Options(contentType: Headers.formUrlEncodedContentType));
      return response;
    } on DioError catch (e) {
      return e.response;
    } catch (e) {
      return null;
    }
  }

  Future<dynamic> getBrowseGenres() async {
    try {
      Response response = await dio.get(
          'https://nuphonic--backend.herokuapp.com/browse_genres',
          options: Options(contentType: Headers.formUrlEncodedContentType));
      return response;
    } on DioError catch (e) {
      return e.response;
    } catch (e) {
      return null;
    }
  }

  Future<dynamic> suggestGenre(String genreName, String genreDescription, String suggestedBy) async {
    try {
      Response response = await dio.post(
          'https://nuphonic--backend.herokuapp.com/suggest_genre',
          data: {
            "genre_name": genreName,
            "genre_description": genreDescription,
            "user_id": suggestedBy,
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