import 'package:flutter/material.dart';
import 'package:test/pages/createproject_page.dart';
import 'package:test/pages/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: CreateProjectPage(title: 'aaaaaa',),
      home: MyHomePage(title: 'aaaaaa',),
    );
  }
}