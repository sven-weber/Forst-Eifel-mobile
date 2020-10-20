import 'package:forst_eifel/wordpress/DTO/rederObject.dart';
import 'media.dart';
import 'author.dart'; 

class Post {
  /// Id of the Post
  int id;

  /// Date the Post was published in the sides Timezone
  DateTime date;

  /// Weblink to the Post (For opening in a browser)
  String link;

  /// Title of the Post
  RenderObject title;

  /// Post Content
  RenderObject content;

  /// Id of the Autor that created the Post
  int authorId;

  /// Author that created the Post
  /// Will only be set when fetching Author with the Post
  Author author;

  /// ID of the Media Image featured in the Post
  int featuredMediaId;

  /// The Media that is features in the Post
  /// Will only be set when fetching media with the Post
  Media featuredMedia; 
  // *****************************************
  // ************ Deserialization ************
  // *****************************************
  Post.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = DateTime.parse(json['date']);
    link = json['link'];
    title = RenderObject.fromJson(json['title']);
    content = RenderObject.fromJson(json['content']);
    authorId = json['author'];
    featuredMediaId = json['featured_media'];
  }

  /// The fields that are used in this DTO
  /// This Property can be used to recude api traffic 
  /// by sending only parsed fields
  static List<String> usedFields = ['id', 'date', 'link', 'title', 'content', 'author', 'featured_media'];
}
