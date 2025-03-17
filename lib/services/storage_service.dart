// lib/services/storage_service.dart
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/manga_entry.dart';

class StorageService {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/manga_list.json');
  }

  Future<List<MangaEntry>> readMangaList() async {
    try {
      final file = await _localFile;
      final contents = await file.readAsString();
      final List<dynamic> jsonData = jsonDecode(contents);
      return jsonData.map((json) => MangaEntry.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<File> writeMangaList(List<MangaEntry> mangaList) async {
    final file = await _localFile;
    final jsonData = mangaList.map((entry) => entry.toJson()).toList();
    return file.writeAsString(jsonEncode(jsonData));
  }
}