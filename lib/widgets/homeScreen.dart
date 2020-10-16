import 'package:flutter/material.dart';
import 'package:after_layout/after_layout.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:forst_eifel/widgets/postWidget.dart';
import 'package:forst_eifel/wordpress/wordPress.dart';

class HomeScreen extends StatefulWidget {
  WordPress wp;

  HomeScreen(this.wp);

  @override
  _HomeScreenState createState() {
    return _HomeScreenState(wp);
  }
}

class _HomeScreenState extends State<HomeScreen> with AfterLayoutMixin<HomeScreen> {
  // Properites used for the state
  WordPress _wp;
  bool _loading;
  List<PostWidget> _postWidgets;
  int _totalPages; 
  int _currentPage; 
  GlobalKey<ScaffoldState> _scaffoldKey; 
  SnackBar postError; 

  _HomeScreenState(this._wp)
  {
    _scaffoldKey = GlobalKey<ScaffoldState>();
    postError = SnackBar(
      content: Text('Beim Laden der Ankündigungen ist ein Fehler aufgetreten.'), 
      action: SnackBarAction(label: 'Erneut versuchen', onPressed: () => loadNextPosts())
    );
    //App Starts with loading
    _loading = true; 
    _postWidgets = List<PostWidget>();
    _totalPages = 1; 
    _currentPage = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(title: Text('Wordpress Article')),
        body: ListView.builder(
          itemCount: _postWidgets.length + 1,
          itemBuilder: (BuildContext context, int index)
          {
            if(index < _postWidgets.length)
            {
              return _postWidgets[index]; 
            } else //Last Element
            {
              //Create Column with Loading Animation and 'Load' Button
              return Column
              (
                children: [
                  Visibility(
                    visible: _loading, 
                    child: CircularProgressIndicator()
                  ),
                  Visibility(
                    visible: (_totalPages > _currentPage) && !_loading, 
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

  // Calls the initial Method to load posts
  @override
  void afterFirstLayout(BuildContext context) {
    // Calling the same function "after layout" to resolve the issue.
    loadNextPosts();
  }

  /// Loads the next Page of Posts
  void loadNextPosts() async
  {
    setState(() => _loading = true);
    _currentPage += 1;
    PostCollection res; 
    
    try {
      //Load Posts
      res = await _wp.getPosts(3, _currentPage);
    } catch(e)
    {
      //TODO: Log error
      //Loading failed: Show Error
      _currentPage -= 1;
      _scaffoldKey.currentState.showSnackBar(postError);

      setState(() => _loading = false);
    }

    //Something went wrong
    if(res == null) return;

    //Create Widget for Each post
    List<PostWidget> widgets = List<PostWidget>();
    res.posts.forEach((Post post) => widgets.add(PostWidget(post)));

    //Update state
    setState(() {
      _postWidgets.addAll(widgets);
      _totalPages = res.availablePages; 
      _currentPage = res.pageNumber; 
      _loading = false;
    }); 
  }
}