import 'dart:async';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:characters/characters.dart';

typedef void OnError(Exception exception);

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 3),
        () => Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (BuildContext context) => HomePage())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
          child: Material(
        borderRadius: BorderRadius.circular(95),
        elevation: 5,
        child: CircleAvatar(
          radius: 95,
          backgroundColor: Colors.grey,
          backgroundImage: AssetImage("assets/images/eA_icon.jpg"),
        ),
      )),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Duration currentTime = Duration();
  Duration completeTime = Duration();
  AudioPlayer _audioPlayer;
  int status;
  bool isPlaying = false;
  String filepath;

  @override
  void initState() {
    super.initState();
    initPlayer();
  }

  void initPlayer() {
    _audioPlayer = AudioPlayer();

    _audioPlayer.durationHandler = (d) => setState(() {
          completeTime = d;
        });

    _audioPlayer.positionHandler = (p) => setState(() {
          currentTime = p;
        });
  }

  Widget slider() {
    return Slider(
      activeColor: Colors.amber,
      inactiveColor: Colors.black12,
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

  void seekToSecond(int second) {
    Duration newDuration = Duration(seconds: second);
    _audioPlayer.seek(newDuration);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
        ),
        Material(
          elevation: 5,
          shadowColor: Colors.amber,
          child: Container(
            height: MediaQuery.of(context).size.height / 3,
            width: MediaQuery.of(context).size.width,
            color: Colors.amber,
          ),
        ),
        Column(
          children: <Widget>[
            Spacer(
              flex: 2,
            ),
            Container(
              margin: EdgeInsets.all(5),
              padding: EdgeInsets.all(10),
              child: Align(
                alignment: Alignment.centerRight,
                child: ActionButton(
                  onPressed: () async {
                    filepath = await FilePicker.getFilePath();
                    status = await _audioPlayer.play(filepath, isLocal: true);
                    if (status == 1) {
                      setState(() {
                        isPlaying = true;
                      });
                    }
                  },
                  iconData: Icons.add,
                  size: 50,
                  fillColor: Colors.white,
                  splashColor: Colors.amber,
                ),
              ),
            ),
            Spacer(
              flex: 2,
            ),
            Center(
                child: Material(
              borderRadius: BorderRadius.circular(95),
              elevation: 5,
              child: CircleAvatar(
                radius: 95,
                backgroundColor: Colors.grey,
                backgroundImage: AssetImage("assets/images/eA_icon.jpg"),
              ),
            )),
            Spacer(
              flex: 2,
            ),
            Material(
              textStyle: TextStyle(
                  fontSize: 30,
                  color: Colors.black45,
                  fontWeight: FontWeight.w200),
              child: Text(
                "LiSA - Gurenge",
              ),
            ),
            Spacer(
              flex: 8,
            ),
            Material(
              child: slider(),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(10, 5, 10, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Spacer(
                    flex: 5,
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(5, 0, 5, 5),
                    child: ActionButton(
                      onPressed: () {
                        print("Previous");
                      },
                      iconData: Icons.skip_previous,
                      size: 50,
                      fillColor: Colors.amber,
                      splashColor: Colors.white,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(5, 0, 5, 5),
                    child: ActionButton(
                      onPressed: () {
                        print("Play");
                        if (!isPlaying) {
                          if (status != 1) {
                            setState(() async {
                              await _audioPlayer
                                  .play("assets/audios/LiSA_-_Gurenge.mp3");
                            });
                          } else {
                            _audioPlayer.resume();
                            setState(() {
                              isPlaying = true;
                            });
                          }
                        } else {
                          _audioPlayer.pause();
                          setState(() {
                            isPlaying = false;
                          });
                        }
                      },
                      iconData: (isPlaying) ? Icons.pause : Icons.play_arrow,
                      size: 80,
                      fillColor: Colors.amber,
                      splashColor: Colors.white,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(5, 0, 5, 5),
                    child: ActionButton(
                      onPressed: () {
                        print("Next");
                      },
                      iconData: Icons.skip_next,
                      size: 50,
                      fillColor: Colors.amber,
                      splashColor: Colors.white,
                    ),
                  ),
                  Spacer(
                    flex: 5,
                  ),
                ],
              ),
            ),
          ],
        )
      ],
    );
  }
}

class ActionButton extends StatelessWidget {
  ActionButton({
    @required this.onPressed,
    this.iconData,
    this.size,
    this.fillColor,
    this.splashColor,
  });
  final GestureTapCallback onPressed;
  IconData iconData;
  double size;
  Color fillColor;
  Color splashColor;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      constraints: BoxConstraints.tight(Size(size, size)),
      fillColor: fillColor,
      splashColor: splashColor,
      elevation: 2,
      child: Center(
          child: Icon(
        iconData,
        color: splashColor,
        size: size / 2,
      )),
      shape: StadiumBorder(),
      onPressed: onPressed,
    );
  }
}
