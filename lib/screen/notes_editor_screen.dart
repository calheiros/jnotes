import 'package:flutter/material.dart';
import 'package:flutter_application/database/note_model.dart';
import 'package:flutter_application/database/notes_database.dart';
import 'package:fluttertoast/fluttertoast.dart';

class NotesEditorScreen extends StatefulWidget {
  final NoteModel note;
  const NotesEditorScreen(this.note, {super.key});

  @override
  NotesEditorState createState() => NotesEditorState(note: note);
}

class NotesEditorState extends State<NotesEditorScreen> {
  late TextEditingController _textEditingController;
  final NoteModel note;
  NotesEditorState({required this.note});

  @override
  void initState() {
    super.initState();
    Fluttertoast.showToast(msg: "id: ${note.id}");
    _textEditingController = TextEditingController(text: note.content);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          if (_textEditingController.text != note.content) {
            _showConfirmationDialog(context);
            return false;
          } else {
            return true;
          }
        },
        child: Scaffold(
            appBar: AppBar(
              title: const Text('New note'),
            ),
            body: Column(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textEditingController,
                    expands: true,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    minLines: null,
                    decoration: const InputDecoration(
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        hintText: "Your notes here",
                        filled: true),
                  ),
                ),
              ],
            )));
  }

  void _showConfirmationDialog(context) async {
    final result = await showDialog<bool>(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: const Text("Save note?"),
            actions: <Widget>[
              TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text("No")),
              TextButton(
                  onPressed: () => saveNote(context), child: const Text("Yes"))
            ],
          );
        });

    if (result == true) {
      Navigator.of(context).pop();
    }
  }

  void saveNote(context) async {
    final db = NotesDbProvider();
    final String content = _textEditingController.text;
    final newNote = NoteModel(id: note.id, title: note.title, content: content);

    int result = (newNote.id == -1)
        ? await db.addNote(note)
        : await db.updateNote(newNote, newNote.id);

    Fluttertoast.showToast(
        msg: "notes saves result: $result", toastLength: Toast.LENGTH_SHORT);
    return Navigator.of(context).pop(true);
  }
}
