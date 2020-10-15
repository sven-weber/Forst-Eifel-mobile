import 'DTO/post.dart';

export 'DTO/post.dart';
export 'DTO/rederObject.dart';
export 'DTO/wordPressError.dart';

abstract class WordPress {
  /// Returns
  Future<List<Post>> getPosts();

  /// Returns specific Post with the provided id
  Future<Post> getPost(int id);
}
