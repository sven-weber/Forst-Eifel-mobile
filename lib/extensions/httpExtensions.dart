import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'intExtensions.dart';

extension AdditionalRequests on HttpClient {
  Future<HttpClientResponse> getUrlWithoutHeader(Uri uri) async {
    return await this
        .getUrl(uri)
        .then((HttpClientRequest request) => request.close());
  }
}

extension BodyParsing on HttpClientResponse {
  Future<String> readAsString() {
    final completer = Completer<String>();
    final contents = StringBuffer();
    this.transform(utf8.decoder).listen((data) {
      contents.write(data);
    }, onDone: () => completer.complete(contents.toString()));
    return completer.future;
  }

  bool isSuccessful() {
    return this.statusCode.inRange(200, 299);
  }
}
