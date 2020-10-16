import 'package:flutter/material.dart';
import 'package:forst_eifel/widgets/postDetailsWidget.dart';
import 'package:forst_eifel/wordpress/wordPress.dart';
import 'package:html/parser.dart';

class PostWidget extends StatelessWidget {
  //Post to be displayed in the Widget
  Post _post;

  //Create a new Post Widget, provide the post that should be displayed
  PostWidget(this._post);

  // Naviages to the Detailed page for this Post
  void _routeToDetails(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => PostDetailsWidget(_post)));
  }

  @override
  Widget build(BuildContext context) {

    //First Build the Text Section
    Widget textSection = Container(
        padding: const EdgeInsets.only(top: 8, left: 5, right: 5, bottom: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              _post.title.rendered,
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)
            ),
            Container(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                getContentPreview(_post),
                softWrap: true
              )
            )
          ],
        )
    );

    //Then return the actual Card holding all Information
    return GestureDetector(
        onTap: () => _routeToDetails(context),
        child: Card(
            margin: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.asset(
                    'images/test.jpg',
                    width: 550,
                    height: 220,
                    fit: BoxFit.cover
                  ),
                  textSection
                ]
            )
        )
      );
  }

  String getContentPreview(Post post) {
    RegExp removeNewlines = RegExp('[\t\n]+');
    //Parse the content as html
    final document = parse(post.content?.rendered);
    String text = parse(document.body.text).documentElement.text;
    //If the text if only short return
    if (text.length == 0) return 'Kein Vorschautext verfügbar.';
    if (text.length < 150) return text.replaceAll(removeNewlines, ' ');
    //Else cut to 50 characters
    //get the first space from index 50 backwards
    int lastIndex = text.lastIndexOf(' ', 149);
    //Return maximum 150 chars of the string with '...' at the end
    //Also replace one or more newlines with a space characeter
    return '${text.substring(0, lastIndex)} ...'.replaceAll(removeNewlines, ' ');
  }
}
