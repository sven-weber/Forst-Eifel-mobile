import 'package:flutter/material.dart';
import 'package:forst_eifel/wordpress/wordPress.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share/share.dart'; 

class PostDetailsWidget extends StatelessWidget {
  //Post that should be displayed in the Widget
  Post _post;
  //Snackbar to show when opening the link in browser failed
  SnackBar browserError;
  //Key for the Scaffold to access in this class
  GlobalKey<ScaffoldState> _scaffoldKey;
  
  /// Create new Details widget for the provided post
  PostDetailsWidget(this._post) {
    browserError = SnackBar(content: Text('Link konnte nicht geöffnet werden'));
    _scaffoldKey = GlobalKey<ScaffoldState>(); 
  }

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
      padding: const EdgeInsets.only(left: 20, right:20, top: 10, bottom: 60), 
      child: Html(data: _post.content?.rendered)
    ); 
  
    //Bottom Section that displays a share Button
    Widget bottomSection = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () => _sharePost(),
            child: Container(
                padding: const EdgeInsets.only(top: 5, bottom: 5), 
                child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.share,
                    color: Colors.white,
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    child: Text(
                      'Teilen',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w400
                      ),
                    ),
                  ),
                ],
              )
            )
          )
        ],
    );
    
    //Return Scaffold containing all Sections
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

  void _sharePost()
  {
     Share.share('Sieh dir diese Ankündigung von Forst (Eifel) an! \n ${_post.link}', subject: _post.title?.rendered); 
  }
}
