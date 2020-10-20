import 'package:forst_eifel/di.dart' as di;
import 'package:forst_eifel/extensions/httpExtensions.dart';
import 'package:http/http.dart' as http;

import 'dart:async';

// *****************************************
// ******** Library In- & Exports **********
// *****************************************
import 'constants.dart';
import 'wordPress.dart';
import 'DTO/post.dart';
import 'DTO/wordPressError.dart';
import 'DTO/postCollection.dart'; 
import 'DTO/media.dart'; 
import 'DTO/author.dart'; 

export 'DTO/post.dart';
export 'DTO/rederObject.dart';
export 'DTO/wordPressError.dart';
export 'DTO/postCollection.dart'; 
export 'DTO/media.dart'; 
export 'DTO/author.dart'; 

class WordPressImpl implements WordPress {
  // ******** Private Properties **********
  String _host;
  String _scheme;
  http.Client _client;

  // ******** Constructor **********
  WordPressImpl({String basePath, http.Client httpClient}) {
    Uri tmp = Uri.parse(basePath);
    _host = tmp.host;
    _scheme = tmp.scheme;
    _client = httpClient ?? di.get<http.Client>();
  }

  // ******** private Methods  **********
  Uri _getUri(String path, Map<String, dynamic> queryParameters) {
    return Uri(
        host: _host,
        scheme: _scheme,
        path: path,
        queryParameters: queryParameters);
  }

  /// Trys to read the total pages header from the response
  /// Returns List in the format [int, String]
  /// If sucessfull, Int containes the number of pages. 
  /// Otherwise the Int is -1 and the String contains a corresponding message
  List _tryReadTotalPages(http.Response response)
  {
      try
      {
        //Be carefull here, regarding to flutter spec all header values are lowercase!
        return [int.parse(response.headers[TOTALPAGES_HEADER]), ''];
      } catch (e)
      {
        return [-1, e.toString()];
      }
  }

  /// Performs get request for the provided Target and 
  /// decodes json if possible. 
  /// Result has structure [http.Response, dynamic]
  Future<List> tryGetAndParseJson(Uri target) async
  {
    // Perform request and check for failure
    var request = await _client.tryGet(target);
    if (request[0] == null) throw WordPressError(message: request[1]);
    http.Response response = request[0];

    // Try to decode json, check for failure
    var decode = response.tryDecodeJson(response);
    if (decode[0] == null) throw WordPressError(message: decode[1]);

    //Return result
    return [response, decode[0]]; 
  }

  /// Adds Media Objects to all posts in the provided List
  Future<void> _fetchMediaForPosts(List<Post> posts) async {
    var media = await getMedia(posts.map((Post post) => post.featuredMediaId).toSet());
    //Add the media to all Posts it occures
    for(Media m in media)
    {
      posts.where((element) => element.featuredMediaId == m.id)
           .forEach((element) {element.featuredMedia = m;});
    }
  }

  /// Adds Author Objects to all posts in the provided List
  Future<void> _fetchAuthorForPosts(List<Post> posts) async {
    var authors = await getAuthors(posts.map((Post post) => post.authorId).toSet());

    //Add the author to all Posts
    for(Author author in authors)
    {
      posts.where((element) => element.authorId == author.id)
           .forEach((element) {element.author = author;});
    }
  }

  // ******** public Methods  **********
  /// Returns a List of Media Elements for the provided ids
  Future<List<Media>> getMedia(Set<int> ids) async { 
    Uri target = _getUri('/$URL_MEDIA', {
      '_fields': Media.usedFields.join(','), 
      'include' : ids.join(',')
    });

    //Perform request, Parse json
    var res = await tryGetAndParseJson(target); 
    http.Response response = res[0];
    var json = res[1];

    if(response.isSuccessful())
    {
      List<Media> media = List<Media>();
      for(final medium in json)
      {
        media.add(Media.fromJson(medium));
      }
      return media; 
    } else {
      throw WordPressError.fromJson(json);
    }
  }

  /// Returns a List of Authors for the provided ids
  Future<List<Author>> getAuthors(Set<int> ids) async { 
    Uri target = _getUri('/$URL_AUTHOR', {
      '_fields': Author.usedFields.join(','), 
      'include' : ids.join(',')
    });

    //Perform request, Parse json
    var res = await tryGetAndParseJson(target); 
    http.Response response = res[0];
    var json = res[1];

    if(response.isSuccessful())
    {
      List<Author> authors = List<Author>();
      for(final author in json)
      {
        authors.add(Author.fromJson(author));
      }
      return authors; 
    } else {
      throw WordPressError.fromJson(json);
    }
  }

  /// Returns a specific post by its id
  Future<Post> getPost(int id) async {
    Uri target = _getUri('/$URL_POSTS/$id', {
      '_fields': Post.usedFields.join(',')
    });

    //Perform request, Parse json
    var res = await tryGetAndParseJson(target); 
    http.Response response = res[0];
    var json = res[1];

    if (response.isSuccessful()) {
      //Handle Successfull request
      return Post.fromJson(json);
    } else {
      throw WordPressError.fromJson(json);
    }
  }

  /// Returns a Collection of Posts for the give page number when 
  /// using perPage number of posts per Page. 
  /// The post Collection also contains the total number of pages
  /// [perPage] musst be in interval [1, ..., 100]
  /// [fetchMedia] describes if the corresponding media objects 
  /// should also be fetched for the posts. Default: true
  /// [fetchAuthor] describes wheter the corresponding author objects
  /// should also be fetched for the posts. Default: true
  Future<PostCollection> getPosts(int perPage, int page, {bool fetchMedia = true, bool fetchAuthor = true}) async {
    Uri target = _getUri('/$URL_POSTS', {
      '_fields': Post.usedFields.join(','), 
      'page': '$page', 
      'per_page' : '$perPage' 
    });

    //Perform request, Parse json
    var res = await tryGetAndParseJson(target); 
    http.Response response = res[0];
    var json = res[1];

    //Get total number of pages
    var pages = _tryReadTotalPages(response); 
    if (pages[0] == -1) throw WordPressError(message: pages[1]); 
    int totalPages = pages[0]; 

    if (response.isSuccessful()) {
      //Handle successfull request
      List<Post> posts = List();
      for (final post in json) {
        posts.add(Post.fromJson(post));
      }
      if(fetchMedia) await _fetchMediaForPosts(posts);
      if(fetchAuthor) await _fetchAuthorForPosts(posts);
      return PostCollection(posts, page, totalPages); 
    } else {
      throw WordPressError.fromJson(json);
    }
  }
}
