import 'package:flutter/material.dart';
import 'package:test_enseval/home_page.dart';
import 'package:test_enseval/login_page.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // home: LoginPage(),
      routes: {
        '/' : (BuildContext context) => LoginPage(),
        '/home' : (BuildContext context) => HomePage()
      },
    );
  }
}
