import 'package:flutter/material.dart';

import 'package:forst_eifel/wordpress/wordPress.dart';
import 'di.dart' as di;
import 'widgets/homeScreen.dart'; 

class App extends StatelessWidget {
  //WordPress API client that is used
  WordPress wp;

  ///Constructor for the App Widget
  App({WordPress wp}) {
    this.wp = wp ?? di.get<WordPress>();
  }

  // All Theme Settings
  final theme = ThemeData(primaryColor: Color(0xFF6B717E));

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Forst (Eifel)', 
        theme: theme, 
        home: HomeScreen(wp)
    );
  }
}