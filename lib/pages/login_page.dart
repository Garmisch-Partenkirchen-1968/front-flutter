import 'package:flutter/material.dart';
import 'package:test/components/common/AppBar.dart';
import 'package:test/components/home/home_body.dart';
import 'package:test/components/home/home_header.dart';
import 'package:test/pages/createproject_page.dart';
import 'package:test/styles.dart';

import '../components/login/login_body.dart';
import '../components/common/drawer.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.title});

  final String title;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: CustomAppBar(
          title: "appbar",
        ),
      ),
      drawer: CustomDrawer(
        title: 'cccc',
      ),
      body: LoginBody(),
    );
  }
}
