import 'dart:io';
import 'dart:convert';

import 'package:test/test.dart';
import 'package:forst_eifel/wordpress/DTO/rederObject.dart';
import 'package:forst_eifel/wordpress/DTO/post.dart';
import 'package:forst_eifel/wordpress/DTO/wordPressError.dart';
import 'package:forst_eifel/wordpress/DTO/media.dart';

import 'common.dart' as common;

void main() async {
  String postJson = await File('${common.assetsPath}post.json').readAsString();
  String objectJson = await File('${common.assetsPath}object.json').readAsString();
  String errorJson = await File('${common.assetsPath}error.json').readAsString();
  String mediaJson = await File('${common.assetsPath}media.json').readAsString();

  group('DTO Tests', () {
    test('Json Redered Object Parsing', () {
      //Act
      RenderObject object = RenderObject.fromJson(json.decode(objectJson));
      //Assert
      expect(object.rendered, 'https://forst-eifel.de/?p=751');
    });

    test('Json Post Parsing', () {
      //Act
      Post post = Post.fromJson(json.decode(postJson));
      //Assert
      expect(post.id, 751);
      expect(post.date.day, 5);
      expect(post.date.month, 10); 
      expect(post.date.year, 2020); 
      expect(post.date.hour, 17); 
      expect(post.date.minute, 39); 
      expect(post.date.second, 33);
      expect(post.authorId, 1);
      expect(post.link, 'https://forst-eifel.de/2020/10/05/st-martin-2020/');
      expect(post.title?.rendered, 'St. Martin 2020');
      expect(post.content?.rendered,
          'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor');
    });

    test('WordPressError Parsing', () {
      //Act
      WordPressError err = WordPressError.fromJson(json.decode(errorJson));
      //Assert
      expect(err.code, 'rest_post_invalid_id');
      expect(err.message, 'Ungültige Beitrags-ID.');
    });

    test('Media Parsing', ()
    { 
      //Act
      Media media = Media.fromJson(json.decode(mediaJson)); 

      //Assert
      expect(media.id, 759); 
      expect(media.sourceUrl, 'https://forst-eifel.de/wp-content/uploads/2020/10/Rueckseite-1.jpg');
    });
  });
}
