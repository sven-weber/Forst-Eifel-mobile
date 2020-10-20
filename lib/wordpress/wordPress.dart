import 'DTO/post.dart';
import 'DTO/postCollection.dart';
import 'DTO/media.dart';
import 'DTO/author.dart'; 

export 'DTO/post.dart';
export 'DTO/rederObject.dart';
export 'DTO/wordPressError.dart';
export 'DTO/postCollection.dart'; 
export 'DTO/media.dart';
export 'DTO/author.dart'; 

abstract class WordPress {
  /// Returns a Collection of Posts for the give page number when 
  /// using perPage number of posts per Page. 
  /// The post Collection also contains the total number of pages
  /// [perPage] musst be in interval [1, ..., 100]
  /// [fetchMedia] describes if the corresponding media objects 
  /// should also be fetched for the posts. Default: true
  /// [fetchAuthor] describes wheter the corresponding author objects
  /// should also be fetched for the posts. Default: true
  Future<PostCollection> getPosts(int perPage, int page, {bool fetchMedia = true, bool fetchAuthor = true});

  /// Returns specific Post with the provided id
  Future<Post> getPost(int id);

  /// Returns a List of Media Elements for the provided ids
  Future<List<Media>> getMedia(Set<int> ids);

  /// Returns a List of Authors for the provided ids
  Future<List<Author>> getAuthors(Set<int> ids);
}
