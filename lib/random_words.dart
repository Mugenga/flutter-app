import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

class RandomWords extends StatefulWidget {
  const RandomWords({Key? key}) : super(key: key);

  @override
  RandomWordsState createState() => RandomWordsState();
}

class RandomWordsState extends State<RandomWords> {
  final _randomWordPairs = <WordPair>[];
  final _savedWordPais = Set<WordPair>();

  Widget _buildList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, item) {
        if (item.isOdd) return const Divider();

        final index = item ~/ 2;

        if (index >= _randomWordPairs.length) {
          _randomWordPairs.addAll(generateWordPairs().take(10));
        }

        return _buildRow(_randomWordPairs[index]);
      },
    );
  }

  Widget _buildRow(WordPair pair) {
    final alreadySaved = _savedWordPais.contains(pair);

    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: const TextStyle(fontSize: 18.0),
      ),
      trailing: Icon(alreadySaved ? Icons.favorite : Icons.favorite_border,
          color: alreadySaved ? Colors.red : null),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _savedWordPais.remove(pair);
          } else {
            _savedWordPais.add(pair);
          }
        });
      },
    );
  }

  void _pushSaved() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      final Iterable<ListTile> tiles = _savedWordPais.map((pair) {
        return ListTile(
          title: Text(
            pair.asPascalCase,
            style: const TextStyle(fontSize: 16.0),
          ),
        );
      });
      final List<Widget> divided =
          ListTile.divideTiles(context: context, tiles: tiles).toList();
      return Scaffold(
          appBar: AppBar(title: const Text('Saved WordPairs')),
          body: ListView(children: divided));
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:
            AppBar(title: const Text('Word Pair Generator'), actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: _pushSaved,
          )
        ]),
        body: _buildList());
  }
}
