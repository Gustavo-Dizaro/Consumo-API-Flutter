import 'package:flutter/material.dart';
import 'dart:convert'; // Para decodificar JSON
import 'package:http/http.dart' as http; // Para requisições HTTP

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App de Músicas',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        fontFamily: 'Roboto',
      ),
      home: const MusicListScreen(),
    );
  }
}

class MusicListScreen extends StatefulWidget {
  const MusicListScreen({super.key});

  @override
  State<MusicListScreen> createState() => _MusicListScreenState();
}

class _MusicListScreenState extends State<MusicListScreen> {
  List<dynamic> _musics = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchMusicData();
  }

  Future<void> fetchMusicData() async {
    const url = 'https://arquivos.ectare.com.br/musicas.json';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        setState(() {
          _musics = json.decode(response.body);
          _isLoading = false;
        });
      } else {
        throw Exception('Erro ao carregar dados da API');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      debugPrint('Erro: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Músicas'),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _musics.isEmpty
              ? const Center(child: Text('Nenhuma música encontrada.'))
              : ListView.builder(
                  itemCount: _musics.length,
                  itemBuilder: (context, index) {
                    final music = _musics[index];
                    return MusicCard(
                      nome: music['nome'],
                      artista: music['artista'],
                      genero: music['genero'],
                      ano: music['ano'].toString(),
                    );
                  },
                ),
    );
  }
}

class MusicCard extends StatelessWidget {
  final String nome;
  final String artista;
  final String genero;
  final String ano;

  const MusicCard({
    super.key,
    required this.nome,
    required this.artista,
    required this.genero,
    required this.ano,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: const Icon(Icons.music_note, color: Colors.deepPurple),
        title: Text(
          nome,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          'Artista: $artista\nGênero: $genero\nAno: $ano',
          style: const TextStyle(fontSize: 14),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }
}
