import 'dart:io';
import 'package:jnotes/database/note_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class NotesDbProvider {
  final int version = 2;
  Future<Database> init() async {
    Directory directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, "notes.db");

    return await openDatabase(path, version: version,
        onUpgrade: (db, oldVersion, newVersion) async {
      if (oldVersion < 2) {
        await db
            .execute("ALTER TABLE Notes ADD COLUMN is_pinned INTEGER DEFAULT 0;"
                "ALTER TABLE Notes ADD COLUMN pinned_at INTEGER;");
      }
    }, onCreate: (Database db, int version) async {
      await db.execute(
          "CREATE TABLE Notes(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, content TEXT, pinned_at INTEGER DEFAULT 0, is_pinned INTEGER DEFAULT 0)");
    });
  }

  Future<int> addNote(NoteModel newNote) async {
    final db = await init();
    return await db.insert("Notes", newNote.toMap(),
        conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  Future<List<NoteModel>> fetchNotes() async {
    final db = await init();
    final maps = await db.query("Notes", orderBy: "is_pinned DESC, pinned_at DESC, id ASC");

    return List.generate(maps.length, (index) {
      final note = maps[index];
      return NoteModel(
          id: note['id'] as int,
          title: note['title'] as String,
          isPinned: note['is_pinned'] == 1 ? true : false,
          pinnedAt: note['pinned_at'] as int,
          content: note['content'] as String);
    });
  }

  Future<int> deleteNote(int id) async {
    final db = await init();
    int result = await db.delete("Notes", where: "id = ?", whereArgs: [id]);
    return result;
  }

  Future<int> updateNote(NoteModel newNote) async {
    final db = await init();
    int result = await db.update("Notes", newNote.toMap(),
        where: "id = ?", whereArgs: [newNote.id]);
    return result;
  }
}
