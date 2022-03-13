import 'package:flutter/material.dart';
import 'package:piano_tiles/song.dart';
import 'package:piano_tiles/line.dart';
import 'note.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'piano tiles',
      color: Colors.blueAccent,
      home: Homescreen(),
    );
  }
}

class Homescreen extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<Homescreen>
    with SingleTickerProviderStateMixin {
  bool hasStarted = false;
  bool isPlaying = true;
  List<Note> notes = init();
  int score = 0;
  int currentNoteIndex = 0;
  late AnimationController Device;
  AudioCache player = new AudioCache();

  void restart() {
    setState(() {
      hasStarted = false;
      isPlaying = true;
      notes = init();
      score = 0;
      currentNoteIndex = 0;
    });
    Device.reset();
  }

  void showFinish() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Your score is: $score"),
          actions: <Widget>[
            FlatButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('RETRY'),
            ),
          ],
        );
      },
    ).then((_) => restart());
  }

  @override
  void initState() {
    super.initState();
    Device = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    Device.addStatusListener((status) {
      if (status == AnimationStatus.completed && isPlaying) {
        if (notes[currentNoteIndex].state != NoteState.tapped) {
          setState(() {
            isPlaying = false;
            notes[currentNoteIndex].state = NoteState.missed;
          });
          Device.reverse().then((_) => showFinish());
        } else if (currentNoteIndex == notes.length - 5) {
          showFinish();
        } else {
          setState(() => ++currentNoteIndex);
          Device.forward(from: 0);
        }
      }
    });
  }

  @override
  void dispose() {
    Device.dispose();
    super.dispose();
  }

  void _onTap(Note note) {
    bool allprevioustapped = notes
        .sublist(0, note.orderNumber)
        .every((n) => n.state == NoteState.tapped);
    if (allprevioustapped) {
      if (!hasStarted) {
        setState(() => hasStarted = true);
        Device.forward();
      }
      playNote(note);
      setState(() {
        note.state = NoteState.tapped;
        score++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        fit: StackFit.passthrough,
        children: <Widget>[
          Image.asset(
            'assets/background.jpg',
            fit: BoxFit.cover,
          ),
          Row(
            children: <Widget>[
              drawLine(0),
              LineDivider(),
              drawLine(1),
              LineDivider(),
              drawLine(2),
              LineDivider(),
              drawLine(3),
            ],
          ),
          _drawPoints(),
        ],
      ),
    );
  }

  playNote(Note note) {
    switch (note.line) {
      case 0:
        player.play('music/a.wav');
        return;
      case 1:
        player.play('music/c.wav');
        return;
      case 2:
        player.play('music/e.wav');
        return;
      case 3:
        player.play('music/f.wav');
        return;
    }
  }

  drawLine(int lineNumber) {
    return Expanded(
      child: Line(
        line_Number: lineNumber,
        current_Notes: notes.sublist(currentNoteIndex, currentNoteIndex + 5),
        TileTap: _onTap,
        animation: Device,
      ),
    );
  }

  _drawPoints() {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.only(top: 40.0),
        child: Text(
          "$score",
          style: TextStyle(color: Colors.yellow, fontSize: 100.0),
        ),
      ),
    );
  }
}

class LineDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: 1,
      color: Colors.black,
    );
  }
}
