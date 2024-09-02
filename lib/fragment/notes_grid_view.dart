import 'package:flutter/material.dart';
import 'package:jnotes/database/note_model.dart';
import 'package:jnotes/database/notes_database.dart';
import 'package:jnotes/widget/card.dart';
import 'package:jnotes/fragment/notes_empty_view.dart';
import '../screen/notes_editor.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NotesGridView extends StatefulWidget {
  const NotesGridView({super.key});

  @override
  State<NotesGridView> createState() => NotesGridViewState();
}

class NotesGridViewState extends State<NotesGridView> {
  NotesDbProvider db = NotesDbProvider();
  List<NoteModel> items = [];
  late AppLocalizations loc;

  @override
  void initState() {
    super.initState();
    fetchNotes();
  }

  @override
  Widget build(BuildContext context) {
    loc = AppLocalizations.of(context);
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
    NoteModel note = items[index];
    return GestureDetector(
        onTap: () async {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => NotesEditorScreen(items[index], this)),
          );
        },
        onLongPress: () => optionsDialog(context, index),
        child: NoteCard(
          title: note.title,
          content: note.content,
          isPinned: note.isPinned,
          togglePinned: () {
            togglePinned(note);
          },
          cardColor: const Color.fromARGB(255, 138, 81, 214),
        ));
  }

  void removeItem(NoteModel noteModel) {
    setState(() {
      items.remove(noteModel);
    });
  }

  void updateItem(NoteModel noteModel) {
    final index = items.indexWhere((element) => element.id == noteModel.id);
    if (index != -1) {
      setState(() {
        items[index] = noteModel;
      });
    }
  }

  void addItem(NoteModel newNote) {
    setState(() {
      items.add(newNote);
    });
  }

  Future<int> _deleteNote(context, index) async {
    final model = items[index];
    int result = await db.deleteNote(model.id);
    removeItem(model);
    Navigator.pop(context);
    return result;
  }

  void togglePinned(NoteModel note) async {
    note.isPinned = !note.isPinned;
    note.pinnedAt = note.isPinned
        ? note.pinnedAt = DateTime.now().millisecondsSinceEpoch
        : 0;
    await db.updateNote(note);
    fetchNotes();
  }

  void optionsDialog(context, int index) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: Icon(
                    items[index].isPinned
                        ? Icons.push_pin_outlined
                        : Icons.push_pin,
                  ),
                  title: Text(items[index].isPinned ? loc.unpinNote : loc.pinNote),
                  onTap: () {
                    togglePinned(items[index]);
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.delete),
                  title: Text(loc.delete),
                  onTap: () {
                    Navigator.of(context).pop();
                    deleteDialog(context, index);
                  },
                )
              ],
            ),
          );
        });
  }

  void deleteDialog(context, int index) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            icon: const Icon(Icons.delete_forever, color: Color.fromARGB(255, 190, 0, 16), size: 30,),
            title: Text(loc.confirmDeleteNote),
            content: Text(loc.deleteWarning),
            actions: <Widget>[
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(loc.no,)),
              TextButton(
                  onPressed: () => _deleteNote(context, index),
                  child: Text(loc.yes))
            ],
          );
        });
  }
  
}
