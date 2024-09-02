import 'dart:async';

import 'package:jnotes/database/note_model.dart';
import 'package:jnotes/database/notes_database.dart';
import 'package:jnotes/fragment/notes_grid_view.dart';
import 'package:jnotes/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// ignore: must_be_immutable
class NotesEditorScreen extends StatefulWidget {
  final NoteModel note;
  NotesGridViewState gridKey;
  NotesEditorScreen(this.note, this.gridKey, {super.key});

  @override
  State createState() => _NotesEditorState();
}

class _NotesEditorState extends State<NotesEditorScreen> {
  late TextEditingController _textController;
  late TextEditingController _titleController;
  late NoteModel _note;
  late AppLocalizations loc;
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
    loc = AppLocalizations.of(context);
    return PopScope(
        canPop: true,
        onPopInvoked: (_) => {_onWillPop(context)},
        child: Scaffold(
            appBar: AppBar(
              actions: <Widget>[
                IconButton(
                    onPressed: () {
                      _shareNote();
                    },
                    icon: const Icon(
                      Icons.share_rounded,
                      size: 24,
                    )),
              ],
            ),
            body: Column(
              children: [
                Padding(
                    padding: const EdgeInsets.only(
                        top: 10, bottom: 5, left: 10, right: 10),
                    child: TextField(
                        onSubmitted: (_) => _textFocusNode.requestFocus(),
                        controller: _titleController,
                        decoration: _textFildDecoration(loc.enterTitle))),
                Expanded(
                    child: Padding(
                  padding:
                      const EdgeInsets.only(right: 10, left: 10, bottom: 10),
                  child: TextField(
                      textAlignVertical: TextAlignVertical.top,
                      focusNode: _textFocusNode,
                      controller: _textController,
                      expands: true,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      minLines: null,
                      decoration: _textFildDecoration(loc.startWriting)),
                )),
              ],
            )));
  }

  void _onWillPop(context) async {
    if (_textController.text != _note.content ||
        _titleController.text != _note.title) {
        var isNewNote = _note.isNew();
        var result = await _saveNote();

        if (isNewNote) {
          widget.gridKey.addItem(result);
        } else {
          widget.gridKey.updateItem(result);
        }
    }
  }

  InputDecoration _textFildDecoration(hintMessage) {
    return InputDecoration(
      filled: true,
      contentPadding: const EdgeInsets.all(15.0),
      hintText: hintMessage,
      fillColor: const Color.fromARGB(50, 0, 0, 0),
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

  void _shareNote() async {
    final filePath = await Utils.saveNoteToFile(_note);
    if (filePath != null) {
      Share.shareXFiles([XFile(filePath.path)], subject: 'Check out my note!');
    }
  }

  Future<NoteModel> _saveNote() async {
    final db = NotesDbProvider();
    final String content = _textController.text;
    final String title = _titleController.text;
    final newNote = NoteModel(id: _note.id, title: title, content: content);

    int result = (newNote.id == -1)
        ? await db.addNote(newNote)
        : await db.updateNote(newNote);

    if (newNote.id == -1) newNote.id = result;

    return newNote;
  }
}
