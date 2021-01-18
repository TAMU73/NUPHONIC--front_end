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
  AudioPlayer audioPlayer = new AudioPlayer();
  List<PaletteColor> colors = [];

  Duration duration = new Duration();
  Duration position = new Duration();

  bool isPlaying = false;
  bool isRepeating = false;

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
    var result = await audioPlayer.play(widget.song.songURL);
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
  void getAudio() async {
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
      if (isRepeating) {
        play();
      } else {
        setState(() {
          isPlaying = false;
        });
      }
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
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            isRepeating = !isRepeating;
                          });
                        },
                        child: SvgPicture.asset('assets/icons/repeat.svg', color: isRepeating ? mainColor : Color(0xff817E7D)),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                double val = position.inSeconds.toDouble() - 10;
                                setState(() {
                                  audioPlayer.seek(Duration(seconds: val.toInt()));
                                });
                              },
                              child: SvgPicture.asset('assets/icons/reverse.svg'),
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
                                double val = position.inSeconds.toDouble() + 10;
                                setState(() {
                                  audioPlayer.seek(Duration(seconds: val.toInt()));
                                });
                              },
                              child: SvgPicture.asset('assets/icons/forward.svg'),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                        },
                        child: SvgPicture.asset('assets/icons/love.svg'),
                      ),
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
                  padding:
                      const EdgeInsets.symmetric(vertical: 45, horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SvgPicture.asset('assets/icons/support.svg'),
                      SvgPicture.asset('assets/icons/add.svg'),
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
