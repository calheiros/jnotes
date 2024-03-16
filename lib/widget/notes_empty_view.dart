import 'package:flutter/material.dart';

class NotesEmptyGrid extends StatelessWidget {
  const NotesEmptyGrid({super.key});

  @override
  Widget build(BuildContext context) {
    const whiteSemiTransparent = Color.fromARGB(120, 255, 255, 255);
    return const Scaffold(
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
          Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Text(
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: whiteSemiTransparent),
                "Your notes are empty",
                textAlign: TextAlign.center,
              )),
          Icon(
            Icons.tips_and_updates,
            size: 100,
            color: whiteSemiTransparent,
          )
        ])));
  }
}
