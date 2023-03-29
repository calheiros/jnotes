import 'package:flutter/material.dart';
import 'package:jnotes/database/note_model.dart';
import 'package:jnotes/database/notes_database.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../screen/notes_editor_screen.dart';

class NotesGridView extends StatefulWidget {
  const NotesGridView({Key? key}) : super(key: key);
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
        body: GridView.builder(
      itemCount: items.length,
      padding: const EdgeInsets.all(10.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: buildItem,
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
        child: Card(
            child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          ListTile(
            title: Text(items[index].title),
            subtitle: Text(items[index].content),
          )
        ])));
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
      Fluttertoast.showToast(msg: "added note: $newNote");
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
