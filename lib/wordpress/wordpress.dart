// This class represents functions to call the wordpress api
// All Methods can be called directly and no class or object ist needed

import 'package:flutter_wordpress/flutter_wordpress.dart' as wp;

// *****************************************
// **************** Exports ****************
// *****************************************
export 'DTO/post.dart';
export 'DTO/rederObject.dart';

// *****************************************
// ********** Global Variables *************
// *****************************************
wp.WordPress _wordPress = wp.WordPress(baseUrl: 'https://forst-eifel.de');

// *****************************************
// ********** Global Methods *************
// *****************************************
Future<List<wp.Post>> getPosts() {
  return _wordPress.fetchPosts(
      postParams: wp.ParamsPostList(
        context: wp.WordPressContext.view,
        pageNum: 1,
        perPage: 5,
        order: wp.Order.desc,
        orderBy: wp.PostOrderBy.date,
      ),
      fetchAuthor: true,
      fetchFeaturedMedia: true,
      fetchComments: false);
}

// *****************************************
// ************ Data Classes ***************
// *****************************************