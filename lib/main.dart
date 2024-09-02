import 'dart:io';

import 'package:flutter/material.dart';
import 'package:jnotes/database/note_model.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'fragment/notes_grid_view.dart';
import 'screen/notes_editor.dart';
import 'theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: MyTheme.themeDark,
      supportedLocales: const [
        Locale('en'), // English
        Locale('pt'), // Portuguese
      ],
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  GlobalKey<NotesGridViewState> gridKey = GlobalKey<NotesGridViewState>();
  late AppLocalizations loc;

  void createNewNote(BuildContext context) async {
    final note = NoteModel(title: "", content: "");
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => NotesEditorScreen(note, gridKey.currentState!)),
    );
  }

  @override
  Widget build(BuildContext context) {
    loc = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(loc.notes),
        // actions: [
        //   IconButton(
        //       onPressed: () => showMenu(context),
        //       icon: const Icon(Icons.menu_rounded))
        // ],
      ),
      body: NotesGridView(key: gridKey),
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.white,
        onPressed: () => createNewNote(context),
        tooltip: 'New note',
        child: const Icon(Icons.add),
      ),
    );
  }

  Future showMenu(context) async {
    return showModalBottomSheet(
        context: context,
        isScrollControlled:
            true, // Faz o Bottom Sheet ocupar toda a tela ao deslizar
        builder: (context) {
          return DraggableScrollableSheet(
            expand: false,
            builder: (BuildContext context, ScrollController scrollController) {
              return Container(
                padding: const EdgeInsets.all(16),
                child: ListView(
                  controller: scrollController,
                  children: [
                    ListTile(
                      leading: const Icon(Icons.account_circle),
                      title: const Text('Account'),
                      onTap: () {},
                    ),
                    ListTile(
                      leading: const Icon(Icons.settings),
                      title: const Text('Settings'),
                      onTap: () {},
                    ),
                    ListTile(
                      leading: const Icon(Icons.info_outline_rounded),
                      title: const Text('About'),
                      onTap: () {},
                    ),
                  ],
                ),
              );
            },
          );
        });
  }
}
