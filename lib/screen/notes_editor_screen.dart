import 'package:flutter/material.dart';
import 'package:jnotes/database/note_model.dart';
import 'package:jnotes/database/notes_database.dart';
import 'package:jnotes/utils/utils.dart';
import 'package:share_plus/share_plus.dart';

class NotesEditorScreen extends StatefulWidget {
  final NoteModel note;
  const NotesEditorScreen(this.note, {super.key});

  @override
  State createState() => _NotesEditorState();
}

class _NotesEditorState extends State<NotesEditorScreen> {
  late TextEditingController _textEditingController;
  late TextEditingController _titleEditingController;
  late NoteModel _note;

  @override
  void initState() {
    super.initState();
    _note = widget.note;
    _textEditingController = TextEditingController(text: _note.content);
    _titleEditingController = TextEditingController(text: _note.title);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          if (_textEditingController.text != _note.content ||
              _titleEditingController.text != _note.title) {
            _showConfirmationDialog(context);
            return false;
          }
          return true;
        },
        child: Scaffold(
            appBar: AppBar(
              actions: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: GestureDetector(
                    onTap: () {
                      _shareNote();
                    },
                    child: const Icon(
                      Icons.share_rounded,
                      size: 24,
                    ),
                  ),
                )
              ],
            ),
            body: Column(
              children: [
                Padding(
                    padding: const EdgeInsets.only(right: 14, left: 14),
                    child: TextField(
                      style: const TextStyle(fontSize: 20),
                      controller: _titleEditingController,
                      decoration: const InputDecoration(
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          hintText: "Title"),
                    )),
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
    NoteModel? newNote;
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
                  onPressed: () async => newNote = await _saveNote(context),
                  child: const Text("Yes"))
            ],
          );
        });

    if (result == true) {
      Navigator.of(context).pop(newNote);
    }
  }

  void _shareNote() async {
    final filePath = await Utils.saveNoteToFile(_note);
    if (filePath != null) {
      Share.shareXFiles([XFile(filePath.path)], subject: 'Check out my note!');
    }
  }

  Future<NoteModel> _saveNote(context) async {
    final db = NotesDbProvider();
    final String content = _textEditingController.text;
    final String title = _titleEditingController.text;
    final newNote = NoteModel(id: _note.id, title: title, content: content);

    int result = (newNote.id == -1)
        ? await db.addNote(newNote)
        : await db.updateNote(newNote, newNote.id);
    if (newNote.id == -1) newNote.id = result;

    Navigator.of(context).pop(true);
    return newNote;
  }
}
