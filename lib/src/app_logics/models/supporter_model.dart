import 'package:nuphonic_front_end/src/app_logics/models/song_model.dart';

class SupporterModel {
  final String supportID;
  final String supporterId;
  final String supporterName;
  final String supporterProfilePicture;
  final String message;
  final double supportedAmount;
  final String supportedDate;
  final String paymentMethod;
  final SongModel supportedSong;

  SupporterModel({
    this.message,
    this.paymentMethod,
    this.supportID,
    this.supporterName,
    this.supporterProfilePicture,
    this.supporterId,
    this.supportedAmount,
    this.supportedDate,
    this.supportedSong,
  });

  factory SupporterModel.fromJson(Map<String, dynamic> data) {
    return SupporterModel(
        supportID: data['_id'],
        supporterId: data['supporter_id'],
        supporterName: data['supporter_name'],
        supporterProfilePicture: data['supporter_profile_picture'],
        supportedAmount: data['supported_amount'].toDouble(),
        supportedDate: data['supported_date'],
        supportedSong: SongModel.fromJson(
          data['supported_song'],
        ),
        message: data['message'],
        paymentMethod: data['payment_method']);
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': supportID,
      'supporter_id': supporterId,
      'supporter_name': supporterName,
      'supporter_profile_picture': supporterProfilePicture,
      'supported_amount': supportedAmount,
      'supported_date': supportedDate,
      'supported_song': supportedSong,
      'message': message,
      'payment_method': paymentMethod,
    };
  }
}
