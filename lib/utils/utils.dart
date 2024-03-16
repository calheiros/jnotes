import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:jnotes/database/note_model.dart';
import 'package:path_provider/path_provider.dart';

class Utils {
  static Future<File?> saveNoteToFile(NoteModel note) async {
    File? file;
    try {
      final directory = await getTemporaryDirectory();
      file = File('${directory.path}/note.txt');
      await file.writeAsString(note.toString());
    } catch (e) {
      if (kDebugMode) {
        print('Error saving note to file: $e');
      }
    }
    return file;
  }
}
