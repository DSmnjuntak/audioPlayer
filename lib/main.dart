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
                    filepath = await FilePicker.getFilePath(
                        allowedExtensions: ['.mp3']);
                    status = await _audioPlayer.play(filepath, isLocal: true);
                    if (status == 1) {
                      setState(() {
                        isPlaying = true;
                      });
                    }
                  },
                  iconData: Icons.add,
                  size: 50,
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
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  radius: 90,
                  backgroundImage:
                      AssetImage("assets/images/LiSA_-_Gurenge.jpg"),
                ),
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
                "Title",
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
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(5, 0, 5, 5),
                    child: ActionButton(
                      onPressed: () {
                        print("Play");
                        if (isPlaying) {
                          _audioPlayer.pause();
                          setState(() {
                            isPlaying = false;
                          });
                        } else if (status != 1) {
                          setState(() {
                            _audioPlayer
                                .play("assets/audios/LiSA_-_Gurenge.mp3");
                          });
                        } else {
                          _audioPlayer.resume();
                          setState(() {
                            isPlaying = true;
                          });
                        }
                      },
                      iconData: (isPlaying) ? Icons.pause : Icons.play_arrow,
                      size: 80,
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
  });
  final GestureTapCallback onPressed;
  IconData iconData;
  double size;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      constraints: BoxConstraints.tight(Size(size, size)),
      fillColor: Colors.white,
      splashColor: Colors.amber,
      elevation: 2,
      child: Center(
          child: Icon(
        iconData,
        color: Colors.amber,
        size: size / 2,
      )),
      shape: StadiumBorder(),
      onPressed: onPressed,
    );
  }
}
