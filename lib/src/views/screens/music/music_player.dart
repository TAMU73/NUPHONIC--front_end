import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nuphonic_front_end/src/app_logics/blocs/now_playing_bloc.dart';
import 'package:nuphonic_front_end/src/app_logics/models/song_model.dart';
import 'package:nuphonic_front_end/src/app_logics/services/api_services/favourite_services.dart';
import 'package:nuphonic_front_end/src/app_logics/services/api_services/song_service.dart';
import 'package:nuphonic_front_end/src/app_logics/services/shared_pref_services/shared_pref_service.dart';
import 'package:nuphonic_front_end/src/views/reusable_widgets/custom_snackbar.dart';
import 'package:nuphonic_front_end/src/views/screens/music/add_to_playlist.dart';
import 'package:nuphonic_front_end/src/views/screens/music/more_option.dart';
import 'package:nuphonic_front_end/src/views/screens/super_support/give_super_support.dart';
import 'package:nuphonic_front_end/src/views/utils/consts.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class MusicPlayer extends StatefulWidget {
  final SongModel song;

  MusicPlayer({this.song});

  @override
  _MusicPlayerState createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  PanelController moreController = PanelController();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  AudioPlayer audioPlayer = AudioPlayer();
  SongService _song = SongService();
  CustomSnackBar _customSnackBar = CustomSnackBar();
  FavouriteServices _favouriteServices = FavouriteServices();
  SharedPrefService _sharedPrefService = SharedPrefService();

  List<PaletteColor> colors = [];

  Duration duration = new Duration();
  Duration position = new Duration();

  var nowPlaying;

  bool isPlaying = false;
  bool isFavourite = false;

  void generateColor() async {
    ImageProvider image = NetworkImage('${widget.song.songImage}');
    PaletteGenerator generator =
        await PaletteGenerator.fromImageProvider(image);
    colors.add(generator.lightMutedColor != null
        ? generator.lightMutedColor
        : PaletteColor(Color(0xffCAB8FF), 2));
    colors.add(generator.darkMutedColor != null
        ? generator.darkMutedColor
        : PaletteColor(darkGreyColor.withOpacity(0.6), 2));
    setState(() {});
  }

  Widget slider() {
    return SliderTheme(
      data: SliderThemeData(
        trackShape: CustomTrackShape(),
      ),
      child: Slider.adaptive(
        inactiveColor: whitishColor.withOpacity(0.3),
        activeColor: mainColor,
        min: 0.0,
        value: position.inSeconds.toDouble() != null
            ? position.inSeconds.toDouble()
            : 0.0,
        max: duration.inSeconds.toDouble() != null
            ? duration.inSeconds.toDouble()
            : 0.0,
        onChanged: (double val) {
          setState(() {
            audioPlayer.seek(Duration(seconds: val.toInt()));
          });
        },
      ),
    );
  }

  void play() async {
    var result = await audioPlayer.play(
      widget.song.songURL,
    );
    if (result == 1) {
      setState(() {
        isPlaying = true;
      });
    }
  }

  void pause() async {
    var result = await audioPlayer.pause();
    if (result == 1) {
      setState(() {
        isPlaying = false;
      });
    }
  }

  Future manageAudioPlayer() async {
    final nowPlayingBloc = Provider.of<NowPlayingBloc>(context, listen: false);
    if (nowPlayingBloc.song != null) {
      if (widget.song.songID == nowPlayingBloc.song.songID) {
        setState(() {
          audioPlayer = nowPlayingBloc.audioPlayer;
        });
      } else {
        nowPlayingBloc.audioPlayer.dispose();
      }
    }
    nowPlayingBloc.song = widget.song;
    nowPlayingBloc.audioPlayer = audioPlayer;
  }

  void getAudio() async {
    await manageAudioPlayer();
    if (isPlaying) {
      pause();
    } else {
      play();
    }
    audioPlayer.onDurationChanged.listen((Duration d) {
      setState(() {
        duration = d;
      });
    });
    audioPlayer.onAudioPositionChanged.listen((Duration d) {
      setState(() {
        position = d;
      });
    });
    audioPlayer.onPlayerCompletion.listen((event) {
      audioPlayer.stop();
      if (nowPlaying.isRepeating) {
        play();
      } else {
        setState(() {
          isPlaying = false;
        });
      }
    });
  }

  Future<void> addToFavourite() async {
    setState(() {
      isFavourite = true;
    });
    var userID = await _sharedPrefService.read(id: 'user_id');
    dynamic result =
        await _favouriteServices.addFavouriteSongs(widget.song.songID, userID);
    if (result == null) {
      _customSnackBar.buildSnackBar(
          'Cannot add to favourite songs, please try again!!', false);
      setState(() {
        isFavourite = false;
      });
    } else {
      setState(() {
        isFavourite = true;
      });
    }
  }

  Future<void> removeFromFavourite() async {
    setState(() {
      isFavourite = false;
    });
    var userID = await _sharedPrefService.read(id: 'user_id');
    dynamic result = await _favouriteServices.removeFavouriteSongs(
        widget.song.songID, userID);
    if (result == null) {
      _customSnackBar.buildSnackBar(
          'Cannot remove from favourite songs, please try again!!', false);
      setState(() {
        isFavourite = true;
      });
    } else {
      setState(() {
        isFavourite = false;
      });
    }
  }

  Future<void> getFavouriteStatus() async {
    var userID = await _sharedPrefService.read(id: 'user_id');
    dynamic result = await _favouriteServices.getFavouriteSongs(userID);
    if (result == null) {
      _customSnackBar.buildSnackBar('Network Error, please try again!!', false);
    } else {
      List songList = result.data["song_list"]["song_list"];
      if (songList.contains(widget.song.songID)) {
        setState(() {
          isFavourite = true;
        });
      } else {
        setState(() {
          isFavourite = false;
        });
      }
    }
  }

  Future<void> addListen() async {
    dynamic result = await _song.addListen(widget.song.songID);
  }

  void atStart() async {
    generateColor();
    getAudio();
    addListen();
    getFavouriteStatus();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nowPlaying = Provider.of<NowPlayingBloc>(context, listen: false);
    atStart();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  colors.isEmpty ? Color(0xffCAB8FF) : colors[0].color,
                  Colors.black
                ],
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Container(
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(
                            Icons.hourglass_empty,
                            color: Colors.transparent,
                          ),
                          InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child: SvgPicture.asset(
                              'assets/icons/arrow_down.svg',
                              color: colors.isEmpty
                                  ? darkGreyColor.withOpacity(0.6)
                                  : colors[1].color.withOpacity(0.6),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              moreController.open();
                            },
                            child: SvgPicture.asset(
                              'assets/icons/more.svg',
                              color: colors.isEmpty
                                  ? darkGreyColor.withOpacity(0.6)
                                  : colors[1].color.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            height: width - 60,
                            width: width - 60,
                            child: Stack(
                              children: [
                                Container(
                                  color: textFieldColor,
                                  child: Center(
                                    child: Icon(
                                      Icons.image,
                                      color: mainColor,
                                      size: 50,
                                    ),
                                  ),
                                ),
                                Image.network(
                                  widget.song.songImage,
                                  fit: BoxFit.cover,
                                  height: width - 60,
                                  width: width - 60,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                widget.song.songName,
                                style: normalFontStyle.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: whitishColor,
                                    fontSize: 24,
                                    letterSpacing: 0.5),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                widget.song.artistName,
                                style: normalFontStyle.copyWith(
                                  fontSize: 15,
                                  color: whitishColor.withOpacity(0.7),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                child: Icon(
                                  Icons.circle,
                                  size: 5,
                                  color: whitishColor.withOpacity(0.7),
                                ),
                              ),
                              Text(
                                widget.song.albumName,
                                style: normalFontStyle.copyWith(
                                  fontSize: 15,
                                  color: whitishColor.withOpacity(0.7),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 10),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              nowPlaying.isRepeating = !nowPlaying.isRepeating;
                            },
                            child: Consumer<NowPlayingBloc>(
                              builder: (context, now, child) {
                                return Column(
                                  children: [
                                    SvgPicture.asset('assets/icons/repeat.svg',
                                        color: now.isRepeating
                                            ? mainColor
                                            : lightGreyColor),
                                    SizedBox(
                                      height: 2,
                                    ),
                                    now.isRepeating
                                        ? Icon(
                                            Icons.circle,
                                            size: 4,
                                            color: mainColor,
                                          )
                                        : SizedBox()
                                  ],
                                );
                              },
                            ),
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: () {
                                    double val =
                                        position.inSeconds.toDouble() - 10;
                                    if (val > 0) {
                                      setState(() {
                                        audioPlayer.seek(
                                            Duration(seconds: val.toInt()));
                                      });
                                    } else {
                                      setState(() {
                                        audioPlayer.seek(Duration(seconds: 0));
                                      });
                                    }
                                  },
                                  child: SvgPicture.asset(
                                      'assets/icons/fast_backward.svg'),
                                ),
                                SizedBox(
                                  width: 30,
                                ),
                                InkWell(
                                  onTap: () {
                                    getAudio();
                                  },
                                  child: SvgPicture.asset(isPlaying
                                      ? 'assets/icons/pause_song.svg'
                                      : 'assets/icons/play_song.svg'),
                                ),
                                SizedBox(
                                  width: 30,
                                ),
                                InkWell(
                                  onTap: () {
                                    double val =
                                        position.inSeconds.toDouble() + 10;
                                    if (val < duration.inSeconds.toDouble()) {
                                      setState(() {
                                        audioPlayer.seek(
                                            Duration(seconds: val.toInt()));
                                      });
                                    } else {
                                      setState(() {
                                        audioPlayer.seek(Duration(
                                            seconds: duration.inSeconds));
                                      });
                                    }
                                  },
                                  child: SvgPicture.asset(
                                      'assets/icons/fast_forward.svg'),
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                              onTap: () {
                                if (isFavourite)
                                  removeFromFavourite();
                                else
                                  addToFavourite();
                              },
                              child: SvgPicture.asset(isFavourite
                                  ? 'assets/icons/loved.svg'
                                  : 'assets/icons/love.svg')),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${position.inSeconds.toDouble() != null ? '${position.inMinutes}:${(position.inSeconds % 60).toString().padLeft(2, '0')}' : '0:00'}',
                              style: normalFontStyle,
                            ),
                            Text(
                              '${duration.inSeconds.toDouble() != null ? '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}' : '0:00'}',
                              style: normalFontStyle,
                            )
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                          height: 10,
                          child: slider(),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 45, horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () async {
                              Get.to(GiveSuperSupport(
                                song: widget.song,
                              ));
                            },
                            child: Container(
                              width: 127,
                              height: 40,
                              decoration: BoxDecoration(
                                  color: whitishColor.withOpacity(0.05),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                      'assets/icons/support.svg'),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'Super Support',
                                    style: normalFontStyle.copyWith(
                                        fontSize: 10,
                                        color: Color(0xff817E7D)),
                                  )
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Get.to(AddToPlaylist(
                                song: widget.song,
                              ));
                            },
                            child: Container(
                              width: 127,
                              height: 40,
                              decoration: BoxDecoration(
                                  color: whitishColor.withOpacity(0.05),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Add to Playlist',
                                    style: normalFontStyle.copyWith(
                                        fontSize: 10,
                                        color: Color(0xff817E7D)),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  SvgPicture.asset('assets/icons/add.svg'),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          MoreOption(
            controller: moreController,
            song: widget.song,
          )
        ],
      ),
    );
  }
}

class CustomTrackShape extends RoundedRectSliderTrackShape {
  Rect getPreferredRect({
    @required RenderBox parentBox,
    Offset offset = Offset.zero,
    @required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = 2;
    final double trackLeft = offset.dx;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}
