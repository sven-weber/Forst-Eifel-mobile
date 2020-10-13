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

export 'DTO/post.dart';
export 'DTO/rederObject.dart';

// *****************************************
// ************ Main Class ***************
// *****************************************
class WordPressImpl implements WordPress {
  String _basePath;
  HttpClient _client;

  WordPressImpl({String basePath, HttpClient httpClient}) {
    this._basePath = basePath;
    _client = httpClient ?? di.get<HttpClient>();
  }

  Future<List<Post>> getPosts() async {
    final response = await _client.getUrlWithoutHeader(Uri.parse('$_basePath/$URL_PAGES'));
    if (response.isSuccessful()) {
      List<Post> posts = List();
      final list = json.decode(await (response.readAsString()));
      for (final post in list) {
        posts.add(Post.fromJson(post));
      }
      return posts;
    }
    return null;
  }
}
