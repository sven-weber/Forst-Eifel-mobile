import 'post.dart';

class PostCollection 
{
  /// List of Posts contained in this page
  List<Post> posts; 

  /// The number of the page that was loaded
  int pageNumber; 
  
  /// The total number of available pages
  int availablePages; 

  PostCollection(this.posts, this.pageNumber, this.availablePages); 
}