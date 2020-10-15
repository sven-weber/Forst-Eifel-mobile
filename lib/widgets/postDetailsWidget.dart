import 'package:flutter/material.dart';
import 'package:forst_eifel/wordpress/wordPress.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';

class PostDetailsWidget extends StatelessWidget {
  //Post that should be displayed in the Widget
  Post _post;
  //Snackbar to show when opening the link in browser failed
  final browserError = SnackBar(content: Text('Link konnte nicht geöffnet werden'));
  //Key for the Scaffold to access in this class
  final _scaffoldKey = GlobalKey<ScaffoldState>(); 
  
    /// Create new Details widget for the provided post
  PostDetailsWidget(this._post);

  @override
  Widget build(BuildContext context) {
    //First build the title section
    Widget titleSection = Container(
      padding: const EdgeInsets.only(left: 20, top: 15),
      child: Text(
        _post.title?.rendered, 
        softWrap: true,
        style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
      ),
    );

    //Then the user section
    Widget userSection = Container(
      padding: const EdgeInsets.only(top: 10, left: 20, right:20),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Icon(Icons.account_box_rounded),
                Text('Weber Webdesign')
              ],
            ) 
          ), 
          Text('${_post.date.day}.${_post.date.month}.${_post.date.year}') 
        ]
      )
    ); 

    //Finally the text section
    Widget textSection = Container(
      padding: const EdgeInsets.only(left: 20, right:20, top: 10), 
      child: Html(data: _post.content?.rendered)
    ); 
  
    //Bottom Section that displays a share Button
    Widget bottomSection = Row(

    );

    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          actions: [
            PopupMenuButton(
              itemBuilder: (context) => [PopupMenuItem(value: 1, child: Text("Im Browser öffnen"))], 
              onSelected: (value) => _launchURL()
            )
          ]
        ),
        bottomSheet: bottomSection,
        body: ListView(
          children: [
            Image.asset(
              'images/test.jpg',
              width: 550, 
              height: 220, 
              fit: BoxFit.cover
            ),
            titleSection, 
            userSection, 
            textSection
          ]
        )
    );
  }

  /// Opens the Post in the Browser
  void _launchURL() async {
    if (await canLaunch(_post.link)) {
      await launch(_post.link);
    } else {
      //TODO: Log that opening failed
      _scaffoldKey.currentState.showSnackBar(browserError);
    }
  }
}
