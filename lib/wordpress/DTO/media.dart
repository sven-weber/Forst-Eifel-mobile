class Media
{
  /// Media Id provided by WordPress
  int id; 

  /// Target Url from where to get the media file
  String sourceUrl; 

  /// Create new Media Object from json
  Media.fromJson(Map<String, dynamic> json)
  {
      id = json['id'];
      sourceUrl = json['source_url'];
  }
}