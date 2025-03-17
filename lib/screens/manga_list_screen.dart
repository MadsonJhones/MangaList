// lib/screens/manga_list_screen.dart
import 'package:flutter/material.dart';
import '../models/manga_entry.dart';
import '../services/storage_service.dart';

class MangaListScreen extends StatefulWidget {
  const MangaListScreen({Key? key}) : super(key: key);

  @override
  _MangaListScreenState createState() => _MangaListScreenState();
}

class _MangaListScreenState extends State<MangaListScreen> {
  List<MangaEntry> mangaList = [];
  List<MangaEntry> filteredList = [];
  final StorageService storageService = StorageService();

  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadMangaList();
    searchController.addListener(_filterList);
  }

  Future<void> _loadMangaList() async {
    final loadedList = await storageService.readMangaList();
    setState(() {
      mangaList = loadedList;
      filteredList = loadedList;
    });
  }

  void _addOrUpdateManga(String name, int chapter) {
    setState(() {
      int existingIndex = mangaList.indexWhere((entry) => entry.name.toLowerCase() == name.toLowerCase());
      if (existingIndex != -1) {
        mangaList[existingIndex] = MangaEntry(name, chapter, DateTime.now());
      } else {
        mangaList.add(MangaEntry(name, chapter, DateTime.now()));
      }
      _filterList();
    });
    storageService.writeMangaList(mangaList);
  }

  void _deleteManga(int index) {
    setState(() {
      mangaList.removeAt(index);
      _filterList();
    });
    storageService.writeMangaList(mangaList);
  }

  void _showAddMangaDialog() {
    String name = '';
    String chapter = '';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Adicionar/Atualizar Mangá'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Nome do mangá'),
              onChanged: (value) => name = value,
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Capítulo'),
              keyboardType: TextInputType.number,
              onChanged: (value) => chapter = value,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (name.isNotEmpty && chapter.isNotEmpty) {
                _addOrUpdateManga(name, int.parse(chapter));
                Navigator.pop(context);
              }
            },
            child: Text('Salvar'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog(MangaEntry manga, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirmar Exclusão'),
        content: Text('Deseja realmente apagar "${manga.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Cancela
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              _deleteManga(index); // Confirma exclusão
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${manga.name} removido')),
              );
            },
            child: Text('Apagar'),
          ),
        ],
      ),
    );
  }

  void _filterList() {
    String searchQuery = searchController.text.toLowerCase();

    setState(() {
      filteredList = mangaList.where((manga) {
        bool matchesName = manga.name.toLowerCase().contains(searchQuery);
        bool matchesChapter = manga.chapter.toString().contains(searchQuery);
        bool matchesDate = _formatDate(manga.date).toLowerCase().contains(searchQuery);
        return searchQuery.isEmpty || matchesName || matchesChapter || matchesDate;
      }).toList();
    });
  }

  void _sortByName() {
    setState(() {
      filteredList.sort((a, b) => a.name.compareTo(b.name));
    });
  }

  void _sortByChapter() {
    setState(() {
      filteredList.sort((a, b) => a.chapter.compareTo(b.chapter));
    });
  }

  void _sortByDate() {
    setState(() {
      filteredList.sort((a, b) => a.date.compareTo(b.date));
    });
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${_twoDigits(date.month)}-${_twoDigits(date.day)} '
        '${_twoDigits(date.hour)}:${_twoDigits(date.minute)}:${_twoDigits(date.second)}';
  }

  String _twoDigits(int n) {
    return n.toString().padLeft(2, '0');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MangaList'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'name') _sortByName();
              if (value == 'chapter') _sortByChapter();
              if (value == 'date') _sortByDate();
            },
            itemBuilder: (context) => [
              PopupMenuItem(value: 'name', child: Text('Ordenar por Nome')),
              PopupMenuItem(value: 'chapter', child: Text('Ordenar por Capítulo')),
              PopupMenuItem(value: 'date', child: Text('Ordenar por Data')),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Buscar (nome, capítulo ou data)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredList.length,
              itemBuilder: (context, index) {
                final manga = filteredList[index];
                return Dismissible(
                  key: Key(manga.name + manga.date.toString()), // Chave única
                  direction: DismissDirection.endToStart, // Deslizar da direita para a esquerda
                  background: Container(
                    color: Colors.grey[900], // Mesma cor do fundo escuro
                    alignment: Alignment.centerRight, // Botão alinhado à direita
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Icon(Icons.delete, color: Colors.white), // Ícone branco
                  ),
                  confirmDismiss: (direction) async {
                    // Impede a exclusão automática e mostra o diálogo
                    _showDeleteConfirmationDialog(manga, mangaList.indexOf(manga));
                    return false; // Não remove até a confirmação
                  },
                  child: ListTile(
                    title: Text('${manga.name} - Capítulo ${manga.chapter}'),
                    subtitle: Text('Lido em: ${_formatDate(manga.date)}'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddMangaDialog,
        child: Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}