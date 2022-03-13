import 'package:flutter/material.dart';
import 'package:piano_tiles/note.dart';

class Tile extends StatelessWidget {
  final NoteState state;
  final double height;
  final VoidCallback onTap;

  const Tile(
      {Key? key,
      required this.height,
      required this.state,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: GestureDetector(
          onTapDown: (_) => onTap(), child: Container(color: color)),
    );
  }

  Color get color {
    switch (state) {
      case NoteState.ready:
        return Colors.blue;
      case NoteState.missed:
        return Colors.red;
      case NoteState.tapped:
        return Colors.transparent;
      default:
        return Colors.black;
    }
  }
}
