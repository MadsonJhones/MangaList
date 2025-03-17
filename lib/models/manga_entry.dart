// lib/models/manga_entry.dart
class MangaEntry {
  final String name;
  final int chapter;
  final DateTime date;

  MangaEntry(this.name, this.chapter, this.date);

  Map<String, dynamic> toJson() => {
    'name': name,
    'chapter': chapter,
    'date': date.toIso8601String(),
  };

  factory MangaEntry.fromJson(Map<String, dynamic> json) => MangaEntry(
    json['name'],
    json['chapter'],
    DateTime.parse(json['date']),
  );
}