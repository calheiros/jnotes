import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NotesEmptyGrid extends StatelessWidget {
  const NotesEmptyGrid({super.key});

  @override
  Widget build(BuildContext context) {
    const whiteSemiTransparent = Color.fromARGB(120, 255, 255, 255);
    return Scaffold(
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
          Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: whiteSemiTransparent),
                    AppLocalizations.of(context).noNotes,
                textAlign: TextAlign.center,
              )),
          const Icon(
            Icons.tips_and_updates,
            size: 100,
            color: whiteSemiTransparent,
          )
        ])));
  }
}
