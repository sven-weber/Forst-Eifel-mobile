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

  /// The fields that are used in this DTO
  /// This Property can be used to recude api traffic 
  /// by sending only parsed fields
  static List<String> usedFields = ['id', 'source_url'];
}