import 'package:flutter/material.dart';
import 'package:piano_tiles/note.dart';
import 'package:piano_tiles/tile.dart';

class Line extends AnimatedWidget {
  final int line_Number;
  final List<Note> current_Notes;
  final Function(Note) TileTap;

  const Line(
      {Key? key,
      required this.current_Notes,
      required this.TileTap,
      required this.line_Number,
      required Animation<double> animation})
      : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    Animation<double> animation = super.listenable as Animation<double>;
    double height = MediaQuery.of(context).size.height;
    double tileHeight = height / 4;

    List<Note> particularLine =
        current_Notes.where((note) => note.line == line_Number).toList();

    List<Widget> tiles = particularLine.map((note) {
      int index = current_Notes.indexOf(note);
      double offset = (3 - index + animation.value) * tileHeight;

      return Transform.translate(
        offset: Offset(0, offset),
        child: Tile(
          height: tileHeight,
          state: note.state,
          onTap: () => TileTap(note),
        ),
      );
    }).toList();

    return SizedBox.expand(
      child: Stack(
        children: tiles,
      ),
    );
  }
}
