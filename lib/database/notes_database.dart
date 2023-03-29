import 'dart:io';
import 'package:jnotes/database/note_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class NotesDbProvider {
  Future<Database> init() async {
    Directory directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, "notes.db");

    return await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(
          "CREATE TABLE Notes(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, content TEXT)");
    });
  }

  Future<int> addNote(NoteModel newNote) async {
    final db = await init();
    return await db.insert("Notes", newNote.toMap(),
        conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  Future<List<NoteModel>> fetchNotes() async {
    final db = await init();
    final maps = await db.query("Notes");

    return List.generate(maps.length, (index) {
      final note = maps[index];
      return NoteModel(
          id: note['id'] as int,
          title: note['title'] as String,
          content: note['content'] as String);
    });
  }

  Future<int> deleteNote(int id) async {
    final db = await init();
    int result = await db.delete("Notes", where: "id = ?", whereArgs: [id]);
    return result;
  }

  Future<int> updateNote(NoteModel newNote, int id) async {
    final db = await init();
    int result = await db
        .update("Notes", newNote.toMap(), where: "id = ?", whereArgs: [id]);
    return result;
  }
}
