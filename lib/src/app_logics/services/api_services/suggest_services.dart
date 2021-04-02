import 'package:dio/dio.dart';

class SuggestService {
  Dio dio = Dio();

  Future<dynamic> suggestFeature(String featureName, String featureDescription, String suggestedBy) async {
    try {
      Response response = await dio.post(
          'https://nuphonic--backend.herokuapp.com/suggest_feature',
          data: {
            "feature_name": featureName,
            "feature_description": featureDescription,
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