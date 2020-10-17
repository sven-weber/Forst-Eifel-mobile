import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Custom Cache Manager with custom limits for number of files
/// And the duration on how long to keep the files
/// Implementation Based in DefaultCacheManager
class CustomCacheManager extends BaseCacheManager {
  static const key = 'forst_eifel_cache';
  
  /// Singleton Instance of the Cache Manager for access
  static BaseCacheManager instance = CustomCacheManager(); 
  
  // Constructor for the custom Configuration
  CustomCacheManager() : super(
    key, 
    maxNrOfCacheObjects: 50, 
    maxAgeCacheObject: Duration(days: 14)
  );

  @override
  Future<String> getFilePath() async {
    var directory = await getTemporaryDirectory();
    return p.join(directory.path, key);
  }
}
