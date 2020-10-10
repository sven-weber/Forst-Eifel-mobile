import 'dart:convert';

import 'package:http/http.dart' as http;

// *****************************************
// *********** In- & Exports ***************
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
  WordPressImpl(String basePath) {
    this._basePath = basePath.endsWith('/')
        ? basePath.substring(0, basePath.length - 1)
        : basePath;
  }

  Future<List<Post>> getPosts() async {
    final response = await http.get('$_basePath$URL_PAGES');
    if (response.statusCode == 200) {
      List<Post> posts = List();
      final list = json.decode(response.body);
      for (final post in list) {
        posts.add(Post.fromJson(post));
      }
      return posts;
    }
    return null;
  }
}
