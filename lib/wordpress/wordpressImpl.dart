import 'package:forst_eifel/di.dart' as di;
import 'package:forst_eifel/extensions/httpExtensions.dart';

import 'dart:convert';
import 'dart:io';
import 'dart:async';

// *****************************************
// ******** Library In- & Exports **********
// *****************************************
import 'constants.dart';
import 'wordpress.dart';
import 'DTO/post.dart';
import 'DTO/wordPressError.dart';

export 'DTO/post.dart';
export 'DTO/rederObject.dart';

class WordPressImpl implements WordPress {
  // ******** Private Properties **********
  String _host;
  String _scheme;
  HttpClient _client;
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
  WordPressImpl({String basePath, HttpClient httpClient}) {
    Uri tmp = Uri.parse(basePath);
    _host = tmp.host;
    _scheme = tmp.scheme;
    _client = httpClient ?? di.get<HttpClient>();
  }

  // ******** private Methods  **********

  Uri _getUri(String path, Map<String, dynamic> queryParameters) {
    return Uri(
        host: _host,
        scheme: _scheme,
        path: path,
        queryParameters: queryParameters);
  }

  /// Trys to decode the response body using json
  /// Returns list [jsonObject, errorMsg]
  /// If decoding failed jsonObject will be null and errorMsg will contain a
  /// corresponding string
  Future<List> tryDecodeJsonFromResponse(HttpClientResponse response) async {
    try {
      return [json.decode(await response.readAsString()), ''];
    } catch (e) {
      return [null, e.toString()];
    }
  }

  /// Trys to perform a HTTP request to the provided target using the provided client
  /// Returns List [HttpClientResponse, errorMsg]
  /// On Failure response will be null and errorMsg will contain a
  /// corresponding string
  Future<List> tryGetUrlWithoutHeader(HttpClient client, Uri target) async {
    try {
      return [await client.getUrlWithoutHeader(target), ''];
    } catch (e) {
      return [null, e.toString()];
    }
  }

  // ******** public Methods  **********
  Future<List<Post>> getPosts() async {
    Uri target = _getUri('/$URL_PAGES', {'_fields': test.join(',')});

    // Perform request and check for failure
    var request = await tryGetUrlWithoutHeader(_client, target);
    if (request[0] == null) throw WordPressError(message: request[1]);
    HttpClientResponse response = request[0];

    // Try to decode json, check for failure
    var decode = await tryDecodeJsonFromResponse(response);
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
