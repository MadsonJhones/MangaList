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
        scaffoldBackgroundColor: Colors.grey[900], // Fundo escuro
        primaryColor: Colors.blueGrey, // Cor primária
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.blueGrey,
        ),
        textTheme: ThemeData.dark().textTheme.apply(
          bodyColor: Colors.white, // Configura a cor do texto do corpo
          displayColor: Colors.blueGrey[600], // Cor para textos de display
        ),
      ),
      home: MangaListScreen(),
    );
  }
}
