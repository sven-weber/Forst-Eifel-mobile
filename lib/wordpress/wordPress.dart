import 'DTO/post.dart';
import 'DTO/postCollection.dart';

export 'DTO/post.dart';
export 'DTO/rederObject.dart';
export 'DTO/wordPressError.dart';
export 'DTO/postCollection.dart'; 

abstract class WordPress {
  /// Returns 
  Future<PostCollection> getPosts(int perPage, int page);

  /// Returns specific Post with the provided id
  Future<Post> getPost(int id);
}
