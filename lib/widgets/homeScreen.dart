import 'package:flutter/material.dart';
import 'package:after_layout/after_layout.dart';

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
      action: SnackBarAction(label: 'Erneut versuchen', onPressed: () => _loadNextPosts())
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
        appBar: _buildAppBar(context),
        body: ListView.builder(
          padding: const EdgeInsets.only(top: 15),
          itemCount: _postWidgets.length + 1,
          itemBuilder: _buildListViewItems
        )
    );
  }

  /// Builds the AppBar for the App
  AppBar _buildAppBar(BuildContext context)
  {
    return AppBar(
      title: SizedBox(
        height: kToolbarHeight,
        child: Image.asset(
            'images/icon_with_text.png', 
            fit: BoxFit.contain,  
        )
      ), 
      actions: [
        IconButton(icon: Icon(Icons.settings, size: 30.0), onPressed: () => _routeToSettings(context))
      ],
    );
  }

  void _routeToSettings(BuildContext context)
  {

  }

  Widget _buildListViewItems(BuildContext context, int index)
  {
    if(index < _postWidgets.length) {
      return _postWidgets[index]; 
    } else { 
      //Last Element
      //Create Column with Loading Animation and 'Load' Button
      return Container(
        padding: const EdgeInsets.only( bottom: 15),
        child: Column
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
                onPressed: () => _loadNextPosts()
              )
            )
          ]
        )
      );
    }
  }

  // Calls the initial Method to load posts
  @override
  void afterFirstLayout(BuildContext context) {
    // Calling the same function "after layout" to resolve the issue.
    _loadNextPosts();
  }

  /// Loads the next Page of Posts
  void _loadNextPosts() async
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