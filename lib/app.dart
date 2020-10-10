import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:forst_eifel/wordpress/wordpress.dart';
import 'di.dart' as di;
import 'package:cached_network_image/cached_network_image.dart';

class App extends StatelessWidget {
  WordPress wp;

  ///Constructor for the App Widget
  App({WordPress wp}) {
    this.wp = wp ?? di.get<WordPress>();
  }

  // All Theme Settings
  final theme = ThemeData(primaryColor: Color(0xFF6B717E));

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Startup Name Generator', theme: theme, home: Test(wp));
  }
}

// *****************************************
// *************** Methods *****************
// *****************************************

class Test extends StatefulWidget {
  WordPress wp;

  Test(this.wp);

  @override
  _TestState createState() {
    return _TestState(wp);
  }
}

class _TestState extends State<Test> {
  String content = 'Hello World \n';
  bool loading = false;
  WordPress wp;

  _TestState(this.wp);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Wordpress Article')),
        body: Center(
            child: Column(children: <Widget>[
          Text(content),
          Visibility(child: CircularProgressIndicator(), visible: loading),
          FlatButton(
              child: Text('Press me!'),
              onPressed: () {
                setState(() {
                  loading = true;
                });
                String newContent = '';
                wp.getPosts().then((value) {
                  for (Post post in value) {
                    newContent += '${post.title.rendered} ${post.authorId} \n';
                  }
                }).whenComplete(() {
                  setState(() {
                    content += newContent;
                    loading = false;
                  });
                });
              })
        ])));
  }
}

class RandomWords extends StatefulWidget {
  @override
  _RandomWordsState createState() {
    return _RandomWordsState();
  }
}

class _RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _saved = Set<WordPair>();
  final _biggerFont = TextStyle(fontSize: 18.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Startup Name Generator'),
        actions: [IconButton(icon: Icon(Icons.list), onPressed: _pushSaved)],
      ),
      body: _buildSuggestions(),
    );
  }

  void _pushSaved() {
    Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (BuildContext context) {
      final tiles = _saved.map((WordPair pair) {
        return ListTile(title: Text(pair.asPascalCase, style: _biggerFont));
      });
      final divided =
          ListTile.divideTiles(context: context, tiles: tiles).toList();
      return Scaffold(
          appBar: AppBar(title: Text('Saved suggestions')),
          body: ListView(children: divided));
    }));
  }

  Widget _buildSuggestions() {
    return ListView.builder(
        padding: EdgeInsets.all(16.0),
        itemBuilder: (context, i) {
          if (i.isOdd) return Divider();

          final index = i ~/ 2;
          if (_suggestions.isEmpty) {
            _suggestions.add(WordPair('test', 'test'));
          }
          if (index >= _suggestions.length) {
            //Lets fetch the Posts
            /*
            var posts = wp.getPosts().then((value) {
              for (wordPress.Post post in value) {
                _suggestions
                    .add(WordPair(post.title.rendered, post.author.name));
              }
            });
            */

            //_suggestions.add(WordPair('test', 'test'));
          }
          if (index >= _suggestions.length)
            return null;
          else
            return _buildRow(_suggestions[index]);
        });
  }

  Widget _buildRow(WordPair pair) {
    final alreadySaved = _saved.contains(pair);

    return ListTile(
        title: Text(pair.asPascalCase, style: _biggerFont),
        trailing: Icon(alreadySaved ? Icons.favorite : Icons.favorite_border,
            color: alreadySaved ? Colors.red : null),
        onTap: () {
          setState(() {
            if (alreadySaved) {
              _saved.remove(pair);
            } else {
              _saved.add(pair);
            }
          });
        });
  }
}
