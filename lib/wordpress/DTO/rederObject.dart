class RenderObject {
  /// The rendered content of the Object
  String rendered;

  RenderObject.fromJson(Map<String, dynamic> json) {
    rendered = json['rendered'];
  }
}
