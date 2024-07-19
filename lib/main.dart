import 'dart:io';

import 'package:flutter/material.dart';
import 'package:jnotes/database/note_model.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'widget/notes_grid_view.dart';
import 'screen/notes_editor.dart';
import 'theme.dart';

void main() {
  if (Platform.isWindows || Platform.isLinux) {
    // Initialize FFI
    sqfliteFfiInit();
    // Change the default factory
    databaseFactory = databaseFactoryFfi;
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jnotes',
      theme: MyTheme.themeDark,
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
    final note = NoteModel(title: "", content: "");
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
