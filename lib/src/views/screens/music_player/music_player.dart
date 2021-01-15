import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nuphonic_front_end/src/app_logics/models/song_model.dart';
import 'package:nuphonic_front_end/src/views/utils/consts.dart';
import 'package:palette_generator/palette_generator.dart';

class MusicPlayer extends StatefulWidget {
  final SongModel song;

  MusicPlayer({this.song});

  @override
  _MusicPlayerState createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  String url = "https://luan.xyz/files/audio/ambient_c_motion.mp3";
  AudioPlayer audioPlayer = new AudioPlayer();
  List<PaletteColor> colors = [];

  Duration duration = new Duration();
  Duration position = new Duration();

  bool isPlaying = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    generateColor();
    getAudio();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    audioPlayer.dispose();
  }

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
    return Slider.adaptive(
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
    );
  }

  void getAudio() async {
    if (isPlaying) {
      var result = await audioPlayer.pause();
      if (result == 1) {
        setState(() {
          isPlaying = false;
        });
      }
    } else {
      var result = await audioPlayer.play(url);
      if (result == 1) {
        setState(() {
          isPlaying = true;
        });
      }
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
      setState(() {
        isPlaying = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
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
                      SvgPicture.asset(
                        'assets/icons/arrow_down.svg',
                        color: colors.isEmpty
                            ? darkGreyColor.withOpacity(0.6)
                            : colors[1].color.withOpacity(0.6),
                      ),
                      SvgPicture.asset(
                        'assets/icons/more.svg',
                        color: colors.isEmpty
                            ? darkGreyColor.withOpacity(0.6)
                            : colors[1].color.withOpacity(0.6),
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
                        child: Image.network(
                          widget.song.songImage,
                          fit: BoxFit.cover,
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
                                fontSize: 20,
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
                            padding: const EdgeInsets.symmetric(horizontal: 5),
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
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset('assets/icons/skip_back.svg'),
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
                      SvgPicture.asset('assets/icons/skip_forward.svg'),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${position.inSeconds.toDouble() != null ? position.inSeconds.toDouble() : 0.0}',
                          style: normalFontStyle,
                        ),
                        Text(
                          '${duration.inSeconds.toDouble() != null ? duration.inSeconds.toDouble() : 0.0}',
                          style: normalFontStyle,
                        )
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    slider()
                  ],
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 45, horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SvgPicture.asset('assets/icons/love_song.svg'),
                      SvgPicture.asset('assets/icons/add_to_playlist.svg'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
