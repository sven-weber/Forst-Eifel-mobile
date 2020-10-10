import 'package:forst_eifel/wordpress/DTO/rederObject.dart';

class Post {
  /// Id of the Post
  int id;

  /// Date the Post was published in the sides Timezone
  String date;

  /// Weblink to the Post (For opening in a browser)
  String link;

  /// Title of the Post
  RenderObject title;

  /// Post Content
  RenderObject content;

  /// Id of the Autor that created the Post
  int authorId;

  /// ID of the Media Image featured in the Post
  int featuredMediaId;

  // *****************************************
  // ************ Deserialization ************
  // *****************************************
  Post.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    link = json['link'];
    title = RenderObject.fromJson(json['title']);
    content = RenderObject.fromJson(json['content']);
    authorId = json['author'];
    featuredMediaId = json['featured_media'];
  }
}
