import 'package:flutter/material.dart';

class NoteCard extends Card {
  final String title;
  final String content;
  final Color cardColor;
  final bool isPinned;
  final VoidCallback togglePinned;
  const NoteCard(
      {super.key,
      required this.content,
      required this.title,
      required this.cardColor,
      required this.isPinned,
      required this.togglePinned});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
              padding:
                  const EdgeInsets.only(right: 8, left: 14, bottom: 5, top: 8),
              child: Row(children: [
                Expanded(
                    child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 18, decorationStyle: TextDecorationStyle.solid),
                )),
                IconButton (
                onPressed: togglePinned, icon:
                Icon(
                  isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                  color: Colors.white, // Altere a cor conforme necessário
                ))
              ])),
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
