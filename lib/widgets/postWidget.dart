import 'package:flutter/material.dart';
import 'package:forst_eifel/wordpress/wordPress.dart';
import 'package:html/parser.dart';

class PostWidget extends StatelessWidget {
  //Post to be displayed in the Widget
  Post _post;

  //Create a new Post Widget, provide the post that should be displayed
  PostWidget(this._post);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset(
              'images/test.jpg',
              width: 600,
              height: 240,
              fit: BoxFit.cover
            ),
            Container(
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
                      softWrap: true,
                    )
                  )
              ],
              )  
            ),
        ])));
  }

  String getContentPreview(Post post) {
    //Parse the content as html
    final document = parse(post.content?.rendered);
    String text = parse(document.body.text).documentElement.text;
    //If the text if only short return
    if(text.length < 150) return text;
    //Else cut to 50 characters
    //get the first space from index 50 backwards
    int lastIndex = text.lastIndexOf(' ', 149);
    //Return maximum 150 chars of the string with '...' at the end
    return '${text.substring(0, lastIndex)} ...';
  }
}
