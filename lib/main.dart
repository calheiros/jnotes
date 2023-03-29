import 'package:flutter/material.dart';
import 'package:jnotes/database/note_model.dart';
import 'widget/notes_grid_view.dart';
import 'screen/notes_editor_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jnotes',
      theme: ThemeData(
          pageTransitionsTheme: const PageTransitionsTheme(builders: {
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder()
          }),
          useMaterial3: true,
          brightness: Brightness.dark,
          colorScheme: const ColorScheme.dark(
              primary: Color.fromARGB(255, 0, 168, 180))),
      home: const MyHomePage(title: 'Notes'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  GlobalKey<NotesGridViewState> gridKey = GlobalKey<NotesGridViewState>();

  void createNewNote() async {
    NoteModel note = NoteModel(title: "New note", content: "");
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NotesEditorScreen(note)),
    );
    if (result != null) {
      gridKey.currentState?.addNote(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: NotesGridView(key: gridKey),
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.white,
        onPressed: createNewNote,
        tooltip: 'New note',
        child: const Icon(Icons.add),
      ),
    );
  }
}
