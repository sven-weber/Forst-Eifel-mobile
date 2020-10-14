import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:forst_eifel/wordpress/wordPressImpl.dart';

class MockClient extends Mock implements http.Client {}

void main() {
  String hasePath = "https://test.de";
  group('getPosts', () {
    test('Not Found should throw exception', () {
      //Arrange
      final client = MockClient();
      WordPressImpl wp = WordPressImpl(basePath: hasePath, httpClient: client);

      when(client.get(any)).thenAnswer((_) async => http.Response(
          '{"code":"rest_post_invalid_id","message":"Ungültige Beitrags-ID.","data":{"status":404}}',
          404));

      //Assert
      expect(wp.getPosts(), throwsException);
    });

    test('Invalid Json should throw exception', () {
      //Arrange
      final client = MockClient();
      WordPressImpl wp = WordPressImpl(basePath: hasePath, httpClient: client);

      when(client.get(any)).thenAnswer((_) async => http.Response('{', 200));

      //Assert
      expect(wp.getPosts(), throwsException);
    });

    test('Successfull Request should return List of Posts', () async {
      //Arrange
      final client = MockClient();
      WordPressImpl wp = WordPressImpl(basePath: hasePath, httpClient: client);
      String json =
          '[{"id":756,"date":"2020-10-11T10:55:45","link":"https://forst-eifel.de","title":{"rendered":"sd"},"content":{"rendered":"sd","protected":false},"author":1,"featured_media":758}]';
      when(client.get(any)).thenAnswer((_) async => http.Response(json, 200));
      //Act
      List<Post> posts = await wp.getPosts();

      //Assert
      expect(posts, isNotEmpty);
      expect(posts.length, 1);
    });
  });
}
