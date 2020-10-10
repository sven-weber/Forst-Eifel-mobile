import 'DTO/post.dart';

export 'DTO/post.dart';
export 'DTO/rederObject.dart';

abstract class WordPress {

  Future<List<Post>> getPosts();
}