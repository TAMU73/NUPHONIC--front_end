import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:nuphonic_front_end/src/app_logics/models/song_model.dart';

class NowPlayingBloc with ChangeNotifier {
  bool _isRepeating = false;
  SongModel _song;
  AudioPlayer _audioPlayer;

  bool get isRepeating => _isRepeating;
  set isRepeating(bool isRepeating) {
    _isRepeating = isRepeating;
    notifyListeners();
  }

  SongModel get song => _song;
  set song(SongModel song) {
    _song = song;
    notifyListeners();
  }

  AudioPlayer get audioPlayer => _audioPlayer;
  set audioPlayer(AudioPlayer audioPlayer) {
    _audioPlayer = audioPlayer;
    notifyListeners();
  }
}