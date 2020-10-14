class WordPressError implements Exception {
  ///Error code
  String code;

  /// Error message
  String message;

  WordPressError({this.code, this.message});

  WordPressError.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
  }

  @override
  String toString() {
    return 'WordPress API error. Code: $code, message. $message';
  }
}
