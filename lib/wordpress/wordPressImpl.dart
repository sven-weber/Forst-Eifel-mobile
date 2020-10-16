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

export 'DTO/post.dart';
export 'DTO/rederObject.dart';
export 'DTO/wordPressError.dart';
export 'DTO/postCollection.dart'; 

class WordPressImpl implements WordPress {
  // ******** Private Properties **********
  String _host;
  String _scheme;
  http.Client _client;
  //TODO: Add other method to provide properties
  List<String> test = [
    'id',
    'date',
    'link',
    'title',
    'content',
    'author',
    'featured_media'
  ];

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

  // ******** public Methods  **********
  Future<Post> getPost(int id) async {
    Uri target = _getUri('/$URL_POSTS/$id', {'_fields': test.join(',')});

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
  Future<PostCollection> getPosts(int perPage, int page) async {
    Uri target = _getUri('/$URL_POSTS', {'_fields': test.join(','), 'page': page, 'per_page' : perPage });

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
      return PostCollection(posts, page, totalPages); 
    } else {
      throw WordPressError.fromJson(json);
    }
  }
}
