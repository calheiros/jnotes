import 'package:flutter/material.dart';
import 'package:jnotes/database/note_model.dart';
import 'package:jnotes/database/notes_database.dart';
import 'package:jnotes/widget/card.dart';
import 'package:jnotes/widget/notes_empty_view.dart';
import '../screen/notes_editor.dart';

class NotesGridView extends StatefulWidget {
  const NotesGridView({super.key});
  static var notesGridKey = GlobalKey<NotesGridViewState>();

  @override
  State<NotesGridView> createState() => NotesGridViewState();
}

class NotesGridViewState extends State<NotesGridView> {
  NotesDbProvider db = NotesDbProvider();
  List<NoteModel> items = [];

  @override
  void initState() {
    super.initState();
    fetchNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: IndexedStack(
      index: items.isEmpty ? 1 : 0,
      children: [
        GridView.builder(
          itemCount: items.length,
          padding: const EdgeInsets.all(10.0),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            childAspectRatio: 1,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemBuilder: buildItem,
        ),
        const NotesEmptyGrid()
      ],
    ));
  }

  void fetchNotes() async {
    final notes = await db.fetchNotes();
    setState(() {
      items = notes;
    });
  }

  Widget buildItem(BuildContext context, int index) {
    return GestureDetector(
        onTap: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => NotesEditorScreen(items[index])),
          );
          if (result != null) {
            updateNote(result);
          }
        },
        onLongPress: () => deleteDialog(context, index),
        child: NoteCard(
          title: items[index].title,
          content: items[index].content,
          cardColor: const Color.fromARGB(255, 138, 81, 214),
        ));
  }

  void removeNote(NoteModel noteModel) {
    setState(() {
      items.remove(noteModel);
    });
  }

  void updateNote(NoteModel noteModel) {
    final index = items.indexWhere((element) => element.id == noteModel.id);
    if (index != -1) {
      setState(() {
        items[index] = noteModel;
      });
    }
  }

  void addNote(NoteModel newNote) {
    setState(() {
      items.add(newNote);
    });
  }

  Future<int> _deleteNote(context, index) async {
    final model = items[index];
    final db = NotesDbProvider();
    int result = await db.deleteNote(model.id);
    removeNote(model);
    Navigator.pop(context);
    return result;
  }

  void deleteDialog(context, index) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: const Text("Delete note?"),
            actions: <Widget>[
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("No")),
              TextButton(
                  onPressed: () => _deleteNote(context, index),
                  child: const Text("Yes"))
            ],
          );
        });
  }
}
