import 'package:forst_eifel/app.dart';
import 'package:forst_eifel/wordpress/wordPress.dart';
import 'package:forst_eifel/wordpress/wordPressImpl.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import 'settings.dart';

final _getIt = GetIt.instance;

// Dart instance that handles everything regarding dependency injection
// using getIt
void setupDI() {
  //Register all dependencies that are needed in the App
  _getIt.registerFactory<http.Client>(() => http.Client());
  _getIt.registerLazySingleton<WordPress>(() => WordPressImpl(basePath: WordPressBaseURL));
  _getIt.registerSingleton<App>(App());
}

/// Returns an instance of T
T get<T>() {
  return _getIt.get<T>();
}
