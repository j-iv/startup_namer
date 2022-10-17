import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Startup name generator',
      home: const RandomWords(),
      theme: ThemeData(
          appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      )),
    );
  }
}

class RandomWords extends StatefulWidget {
  const RandomWords({Key? key}) : super(key: key);

  @override
  State<RandomWords> createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _biggerFont = const TextStyle(fontSize: 18);
  final _saved = <WordPair>{};
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Startup names'),
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: _pushSaved,
          )
        ],
      ),
      body: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemBuilder: (context, i) {
            if (i.isOdd) {
              return const Divider();
            }
            final index = i ~/ 2;
            if (index >= _suggestions.length) {
              _suggestions.addAll(generateWordPairs().take(1));
            }
            final alreadySaved = _saved.contains(_suggestions[index]);
            return ListTile(
              title: Text(
                _suggestions[index].asCamelCase,
                style: _biggerFont,
              ),
              trailing: Icon(
                  semanticLabel: alreadySaved ? 'Remove from saved' : 'Save',
                  color: alreadySaved ? Colors.red : null,
                  alreadySaved ? Icons.favorite : Icons.favorite_border),
              onTap: () {
                setState(() {
                  if (alreadySaved) {
                    _saved.remove(_suggestions[index]);
                  } else {
                    _saved.add(_suggestions[index]);
                  }
                });
              },
            );
          }),
    );
  }

  void _pushSaved() {
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (context) {
      final tiles = _saved.map(
        (pair) {
          return ListTile(
            title: Text(
              pair.asPascalCase,
              style: _biggerFont,
            ),
          );
        },
      );
      final divided = tiles.isNotEmpty
          ? ListTile.divideTiles(tiles: tiles, context: context).toList()
          : <Widget>[];
      return Scaffold(
        appBar: AppBar(title: const Text('Saved suggestions')),
        body: ListView(children: divided),
      );
    }));
  }
}
