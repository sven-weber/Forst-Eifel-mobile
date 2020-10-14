import 'dart:async';
import 'dart:convert';
import 'intExtensions.dart';
import 'package:http/http.dart' as http;

extension AdditionalRequests on http.Client {
  /// Trys to perform a HTTP request to the provided target using the provided client
  /// Returns List [HttpClientResponse, errorMsg]
  /// On Failure response will be null and errorMsg will contain a
  /// corresponding string
  Future<List> tryGet(Uri target) async {
    try {
      return [await this.get(target), ''];
    } catch (e) {
      return [null, e.toString()];
    }
  }
}

extension BodyParsing on http.Response {
  
  /// Trys to decode the response body using json
  /// Returns list [dynamic, errorMsg] with dynamic containing the json object.
  /// If decoding failed dynamic will be null and errorMsg will contain a corresponding string
  List tryDecodeJson(http.Response response) {
    try {
      return [json.decode(response.body), ''];
    } catch (e) {
      return [null, e.toString()];
    }
  }

  bool isSuccessful() {
    return this.statusCode.inRange(200, 299);
  }
}
