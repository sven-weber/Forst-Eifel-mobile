import 'dart:io';
import 'dart:convert';

import 'package:test/test.dart';
import 'package:forst_eifel/wordpress/wordpressImpl.dart' as wp;
import 'common.dart' as common;

void main() async {
  String postJson = await File('${common.assetsPath}post.json').readAsString();
  String objectJson =
      await File('${common.assetsPath}object.json').readAsString();

  group('DTO Tests', () {
    test('Json Redered Object Parsing', () {
      wp.RenderObject object = wp.RenderObject.fromJson(json.decode(objectJson));
      expect(object.rendered, 'https://forst-eifel.de/?p=751');
    });

    test('Json Post Parsing', () {
      wp.Post post = wp.Post.fromJson(json.decode(postJson));
      expect(post.id, 751);
      expect(post.date, '2020-10-05T17:39:33');
      expect(post.authorId, 1);
      expect(post.link, 'https://forst-eifel.de/2020/10/05/st-martin-2020/');
      expect(post.title?.rendered, 'St. Martin 2020');
      expect(post.content?.rendered,
          'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor');
    });
  });
}
