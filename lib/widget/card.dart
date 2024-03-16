import 'package:flutter/material.dart';

class NoteCard extends Card {
  final String title;
  final String content;
  final Color cardColor;

  const NoteCard(
      {super.key,
      required this.content,
      required this.title,
      required this.cardColor});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.only(
                  right: 14, left: 14, bottom: 5, top: 10),
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontSize: 18, decorationStyle: TextDecorationStyle.solid),
              )),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.only(left: 15, right: 14, bottom: 10),
            child: Text(
              content,
              overflow: TextOverflow.fade,
              style: const TextStyle(fontSize: 14),
            ),
          )),
        ],
      ),
    );
  }
}
