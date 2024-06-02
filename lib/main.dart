import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test/pages/login_page.dart';
import 'package:test/login_session.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => profile()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: CreateProjectPage(title: 'aaaaaa',),
      home: LoginPage(title: 'aaaaaa',),
    );
  }
}