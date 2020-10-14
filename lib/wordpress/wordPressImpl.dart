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

export 'DTO/post.dart';
export 'DTO/rederObject.dart';
export 'DTO/wordPressError.dart';

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

  // ******** public Methods  **********
  Future<List<Post>> getPosts() async {
    Uri target = _getUri('/$URL_PAGES', {'_fields': test.join(',')});

    // Perform request and check for failure
    var request = await _client.tryGet(target);
    if (request[0] == null) throw WordPressError(message: request[1]);
    http.Response response = request[0];

    // Try to decode json, check for failure
    var decode = response.tryDecodeJson(response);
    if (decode[0] == null) throw WordPressError(message: decode[1]);
    var json = decode[0];

    if (response.isSuccessful()) {
      //Handle successfull request
      List<Post> posts = List();
      for (final post in json) {
        posts.add(Post.fromJson(post));
      }
      return posts;
    } else {
      throw WordPressError.fromJson(json);
    }
  }
}
