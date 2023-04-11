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
  late TextEditingController _textController;
  late TextEditingController _titleController;
  late NoteModel _note;

  final FocusNode _textFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _note = widget.note;
    _textController = TextEditingController(text: _note.content);
    _titleController = TextEditingController(text: _note.title);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          if (_textController.text != _note.content ||
              _titleController.text != _note.title) {
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
                    padding: const EdgeInsets.all(5),
                    child: TextField(
                        onSubmitted: (_) => _textFocusNode.requestFocus(),
                        style: const TextStyle(fontSize: 18),
                        controller: _titleController,
                        decoration: decoration("Your title"))),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.only(right: 5, left: 5, bottom: 5),
                  child: TextField(
                      textAlignVertical: TextAlignVertical.top,
                      focusNode: _textFocusNode,
                      controller: _textController,
                      expands: true,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      minLines: null,
                      decoration: decoration("Your notes here")),
                )),
              ],
            )));
  }

  InputDecoration decoration(hintMessage) {
    return InputDecoration(
      filled: true,
      contentPadding: const EdgeInsets.all(15.0),
      hintText: hintMessage,
      fillColor: const Color.fromARGB(22, 255, 255, 255),
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(15.0),
        ),
        borderSide: BorderSide(
          width: 0,
          style: BorderStyle.none,
        ),
      ),
    );
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
    final String content = _textController.text;
    final String title = _titleController.text;
    final newNote = NoteModel(id: _note.id, title: title, content: content);

    int result = (newNote.id == -1)
        ? await db.addNote(newNote)
        : await db.updateNote(newNote, newNote.id);
    if (newNote.id == -1) newNote.id = result;

    Navigator.of(context).pop(true);
    return newNote;
  }
}
