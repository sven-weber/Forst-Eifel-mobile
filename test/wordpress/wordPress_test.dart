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
      expect(wp.getPosts(1,1), throwsException);
    });

    test('Invalid Json should throw exception', () {
      //Arrange
      final client = MockClient();
      WordPressImpl wp = WordPressImpl(basePath: hasePath, httpClient: client);

      when(client.get(any)).thenAnswer((_) async => http.Response('{', 200));

      //Assert
      expect(wp.getPosts(1,1), throwsException);
    });

    test('Successfull Request should return List of Posts', () async {
      //Arrange
      final client = MockClient();
      WordPressImpl wp = WordPressImpl(basePath: hasePath, httpClient: client);
      String json = '[{"id":756,"date":"2020-10-11T10:55:45","link":"https://forst-eifel.de","title":{"rendered":"sd"},"content":{"rendered":"sd","protected":false},"author":1,"featured_media":758}]';
      Map<String, String> header = {"x-wp-totalpages": "3"}; 
      when(client.get(any)).thenAnswer((_) async => http.Response(json, 200, headers: header));
      
      //Act
      PostCollection res = await wp.getPosts(1,1);

      //Assert
      expect(res.posts, isNotEmpty);
      expect(res.posts.length, 1);
      expect(res.availablePages, 3);
    });

    //TODO: Media and Author Tests when calling
  });
}
