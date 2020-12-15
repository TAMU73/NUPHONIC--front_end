class SongModel {
  final String songName;
  final String publishedDate;
  final String songURL;
  final String songImage;
  final String genreName;
  final String artistName;
  final String albumName;
  final String songDescription;
  final String songLyrics;

  SongModel({
    this.songName,
    this.publishedDate,
    this.songURL,
    this.songImage,
    this.genreName,
    this.artistName,
    this.albumName,
    this.songDescription,
    this.songLyrics,
  });

  factory SongModel.fromJson(Map<String, dynamic> data) {
    return SongModel(
        songName: data['song_name'],
        publishedDate: data['published_date'],
        songURL: data['song_url'],
        songImage: data['song_cover_url'],
        genreName: data['genre_name'],
        artistName: data['artist_id'],
        albumName: data['album_id'],
        songDescription: data['song_description'],
        songLyrics: data['song_lyrics']);
  }

  Map<String, dynamic> toJson() {
    return {
      'song_name': songName,
      'published_date': publishedDate,
      'song_url': songURL,
      'song_cover_url': songImage,
      'genre_name': genreName,
      'artist_id': artistName,
      'album_id': albumName,
      'song_description': songDescription,
      'song_lyrics': songLyrics
    };
  }
}
