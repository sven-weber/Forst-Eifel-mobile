import 'package:flutter/material.dart';
import 'package:forst_eifel/wordpress/wordPress.dart';
import 'di.dart' as di;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:forst_eifel/widgets/postWidget.dart';
import 'package:after_layout/after_layout.dart';

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

class _TestState extends State<Test> with AfterLayoutMixin<Test> {
  bool loading = true;
  WordPress wp;
  List<PostWidget> postWidgets = List<PostWidget>();
  int totalPages = 1; 
  int currentPage = 0; 

  _TestState(this.wp); 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Wordpress Article')),
        body: ListView.builder(
          itemCount: postWidgets.length + 1,
          itemBuilder: (BuildContext context, int index)
          {
            if(index < postWidgets.length)
            {
              return postWidgets[index]; 
            } else //Last Element
            {
              //Create Column with Loading Animation and 'Load' Button
              return Column
              (
                children: [
                  Visibility(
                    visible: loading, 
                    child: CircularProgressIndicator()
                  ),
                  Visibility(
                    visible: (totalPages > currentPage) && !loading, 
                    child: FlatButton(
                      child: Text('Weitere Ankündigungen laden'), 
                      onPressed: () => loadNextPosts()
                    )
                  )
                ]
              );
            }
          }
        )
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    // Calling the same function "after layout" to resolve the issue.
    loadNextPosts();
  }

  /// Loads the next Page of Posts
  void loadNextPosts() async
  {
    setState(() => loading = true);
    //TODO: catch errors
    currentPage += 1;
    wp.getPosts(3, currentPage)
      .then((PostCollection res) {
        //Create Widget for Each post
        List<PostWidget> widgets = List<PostWidget>();
        res.posts.forEach((Post post) => widgets.add(PostWidget(post)));
        //Update state
        setState(() {
          postWidgets.addAll(widgets);
          totalPages = res.availablePages; 
          currentPage = res.pageNumber; 
        }); 
      }).whenComplete(() => setState(() => loading = false));
  }
}