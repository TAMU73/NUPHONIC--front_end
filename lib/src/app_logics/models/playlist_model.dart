import 'package:nuphonic_front_end/src/app_logics/models/song_model.dart';

class PlaylistModel {
  final String playlistId;
  final String playlistName;
  final List playlistSongs;
  List<SongModel> playlistSongModel;
  final String userID;

  PlaylistModel({
    this.playlistId,
    this.playlistName,
    this.playlistSongs,
    this.userID,
    this.playlistSongModel,
  });

  factory PlaylistModel.fromJson(Map<String, dynamic> data) {
    return PlaylistModel(
      playlistSongs: data['playlist_songs'],
      playlistName: data['playlist_name'],
      playlistId: data['_id'],
      userID: data['user_id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['playlist_songs'] = this.playlistSongs;
    data['_id'] = this.playlistId;
    data['playlist_name'] = this.playlistName;
    data['user_id'] = this.userID;
    return data;
  }
}
