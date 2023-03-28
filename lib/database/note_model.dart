class NoteModel {
  late int id;
  final String title;
  final String content;

  NoteModel({this.id = -1, required this.title, required this.content});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "title": title,
      "content": content,
    };
  }
}
