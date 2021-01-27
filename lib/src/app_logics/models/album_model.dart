class AlbumModel {
  final String albumID;
  final String artistID;
  final String artistName;
  final String albumName;
  final String albumPicture;
  final List albumSongs;
  final String description;
  AlbumModel({
    this.albumID,
    this.artistID,
    this.artistName,
    this.albumName,
    this.albumPicture,
    this.albumSongs,
    this.description,
  });

  factory AlbumModel.fromJson(Map<String, dynamic> data) {
    return AlbumModel(
      albumID: data['album_id'],
      artistID: data['artist_id'],
      artistName: data['artist_name'],
      albumName: data['album_name'],
      albumPicture: data['album_picture'],
      albumSongs: data['album_songs'],
      description: data['album_description']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'album_id': albumID,
      'artist_id': artistID,
      'artist_name': artistName,
      'album_name': albumName,
      'album_picture': albumPicture,
      'album_songs': albumSongs,
      'album_description': description,
    };
  }
}
