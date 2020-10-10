import 'package:flutter/material.dart';


import 'di.dart' as di;
import 'app.dart';

void main() {
  //First initialize to Dependency Injection Container
  di.setupDI();
  //Run the App that is resolved using DI
  runApp(di.get<App>());
}
