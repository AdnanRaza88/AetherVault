class Note {
  final String id;
  final String title;
  final String path;
  String content;
  List<String> links;
  List<String> backlinks;
  List<String> unlinkedMentions;

  Note({
    required this.id,
    required this.title,
    required this.path,
    required this.content,
    this.links = const [],
    this.backlinks = const [],
    this.unlinkedMentions = const [],
  });

  Note copyWith({
    String? content,
    List<String>? links,
    List<String>? backlinks,
    List<String>? unlinkedMentions,
  }) {
    return Note(
      id: id,
      title: title,
      path: path,
      content: content ?? this.content,
      links: links ?? this.links,
      backlinks: backlinks ?? this.backlinks,
      unlinkedMentions: unlinkedMentions ?? this.unlinkedMentions,
    );
  }
}
