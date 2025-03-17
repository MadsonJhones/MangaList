// lib/main.dart
import 'package:flutter/material.dart';
import 'screens/manga_list_screen.dart';

void main() {
  runApp(MangaListApp());
}

class MangaListApp extends StatelessWidget {
  const MangaListApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MangaList',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.grey[900], // Fundo bem escuro
        primaryColor: Colors.blueGrey, // Cor primária suave
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.blueGrey, // Botão flutuante em tom escuro
        ),
      ),
      home: MangaListScreen(),
    );
  }
}