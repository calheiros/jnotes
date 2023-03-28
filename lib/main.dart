import 'package:flutter/material.dart';
import 'package:flutter_application/database/note_model.dart';
import 'view/notes_grid_view.dart';
import 'screen/notes_editor_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter app',
      theme: ThemeData(
          pageTransitionsTheme: const PageTransitionsTheme(builders: {
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder()
          }),
          useMaterial3: true,
          brightness: Brightness.dark,
          colorScheme: const ColorScheme.dark(
              primary: Color.fromARGB(248, 127, 15, 192))),
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
  late NotesGridView gridView;

  @override
  void initState() {
    super.initState();
    gridView = const NotesGridView();
  }

  void createNewNote() {
    setState(() {
      NoteModel note = NoteModel(title: "New note", content: "");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => NotesEditorScreen(note)),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: gridView,
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.white,
        onPressed: createNewNote,
        tooltip: 'New note',
        child: const Icon(Icons.add),
      ),
    );
  }
}
