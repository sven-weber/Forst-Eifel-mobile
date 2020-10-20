class Author
{
  /// Media Id provided by WordPress
  int id; 

  /// Target Url from where to get the media file
  String name; 

  /// Create new Media Object from json
  Author.fromJson(Map<String, dynamic> json)
  {
      id = json['id'];
      name = json['name'];
  }

  /// The fields that are used in this DTO
  /// This Property can be used to recude api traffic 
  /// by sending only parsed fields
  static List<String> usedFields = ['id', 'name'];
}