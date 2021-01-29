class SongModel {
  final String songID;
  final String songName;
  final String publishedDate;
  final String songURL;
  final String songImage;
  final String genreName;
  final String artistID;
  final String artistName;
  final String albumID;
  final String albumName;
  final String songDescription;
  final String songLyrics;
  final String songListens;

  SongModel({
    this.songID,
    this.songName,
    this.publishedDate,
    this.songURL,
    this.songImage,
    this.genreName,
    this.artistID,
    this.artistName,
    this.albumID,
    this.albumName,
    this.songDescription,
    this.songLyrics,
    this.songListens
  });

  factory SongModel.fromJson(Map<String, dynamic> data) {
    return SongModel(
        songID: data['_id'],
        songName: data['song_name'],
        publishedDate: data['published_date'],
        songURL: data['song_url'],
        songImage: data['song_picture_url'],
        genreName: data['genre_name'],
        artistID: data['artist_id'],
        artistName: data['artist_name'],
        albumID: data['album_id'],
        albumName: data['album_name'],
        songDescription: data['song_description'],
        songLyrics: data['song_lyrics'],
        songListens: data['listens'].toString()
    );

  }

  Map<String, dynamic> toJson() {
    return {
      '_id': songID,
      'song_name': songName,
      'published_date': publishedDate,
      'song_url': songURL,
      'song_cover_url': songImage,
      'genre_name': genreName,
      'artist_id': artistID,
      'artist_name': artistName,
      'album_id': albumID,
      'album_name': albumName,
      'song_description': songDescription,
      'song_lyrics': songLyrics,
      'listens': songListens,
    };
  }
}
