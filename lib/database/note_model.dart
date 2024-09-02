
class NoteModel {
  late int id;
  final String title;
  final String content;
  bool isPinned;
  int pinnedAt;

  NoteModel({this.id = -1, required this.title, required this.content, this.isPinned = false, this.pinnedAt = 0});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "title": title,
      "content": content,
      "is_pinned": isPinned ? 1 : 0,
      "pinned_at": pinnedAt
    };
  }

  @override
  String toString() {
    return "$title\n\n$content";
  }

  bool isNew() {
    return id == -1;
  }
}
