import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

typedef void OnError(Exception exception);

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _duration = "00:00";
  String _position = "00:00";
  Duration currentTime = Duration();
  Duration completeTime = Duration();
  AudioPlayer _audioPlayer;
  AudioCache _audioCache;
  int status = 0;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    initPlayer();
  }

  void initPlayer() {
    _audioPlayer = AudioPlayer();
    _audioCache = AudioCache(fixedPlayer: _audioPlayer);

    _audioPlayer.onAudioPositionChanged.listen((Duration duration) {
      setState(() {
        _position = duration.toString().split(".")[0];
        });
    });

    _audioPlayer.onDurationChanged.listen((Duration duration) {
      setState(() {
        _duration = duration.toString().split(".")[0];
      });
    });

    _audioPlayer.durationHandler = (d) => setState(() {
          completeTime = d;
        });

    _audioPlayer.positionHandler = (p) => setState(() {
          currentTime = p;
        });
  }

  Widget _tab(List<Widget> children) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(5.0),
          child: Column(
            children: children
                .map((w) => Container(
                      child: w,
                      padding: EdgeInsets.all(1.0),
                    ))
                .toList(),
          ),
        )
      ],
    );
  }

  Widget _btn(IconData iconData, VoidCallback onPressed) {
    return ButtonTheme(
      child: Container(
        width: 45,
        height: 45,
        child: RaisedButton(
          padding: EdgeInsets.all(8),
          elevation: 8,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            child: Icon(iconData),
            color: Colors.black,
            textColor: Colors.white,
            onPressed: onPressed,
            onLongPress: () {
              _audioPlayer.stop();
            },
            ),
      ),
    );
  }

  // Widget onLongPressed(){
  //     _btn(Icons.stop, () {
  //       _audioPlayer.stop();
  //     }),
  // }

  Widget slider() {
    return Slider(
      activeColor: Colors.pink,
      inactiveColor: Colors.grey,
      value: currentTime.inSeconds.toDouble(),
      min: 0.0,
      max: completeTime.inSeconds.toDouble(),
      onChanged: (double value) {
        setState(() {
          seekToSecond(value.toInt());
          value = value;
        });
      },
    );
  }

  Widget timeDuration() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text("$_position"),
          Text("$_duration"),
        ],
      ),
    );
  }

  Widget localAudio() {
    return _tab([
      _btn(isPlaying ? Icons.pause : Icons.play_arrow, () {
        if (isPlaying) {
          _audioPlayer.pause();
          setState(() {
            isPlaying = false;
          });
        } else {
          _audioPlayer.resume();
          setState(() {
            isPlaying = true;
          });
        }
      }),
      // _btn(Icons.play_arrow, () {
      //   _audioCache.play('audios/LiSA_-_Gurenge.mp3');
      // }),
      slider(),
      timeDuration(),
    ]);
  }

  void seekToSecond(int second) {
    Duration newDuration = Duration(seconds: second);
    _audioPlayer.seek(newDuration);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: TabBarView(children: <Widget>[
          localAudio(),
        ]),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.audiotrack),
          onPressed: () async {
            String filepath = await FilePicker.getFilePath();

            status = await _audioPlayer.play(filepath, isLocal: true);

            if (status == 1) {
              setState(() {
                isPlaying = true;
              });
            }
          },
        ),
      ),
    );
  }
}
