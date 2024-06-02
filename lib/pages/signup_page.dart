import 'package:flutter/material.dart';
import 'package:test/components/common/AppBar.dart';
import 'package:test/components/signup/signup_body.dart';


import '../components/common/drawer.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key, required this.title});

  final String title;

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
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
      body: SignupBody(),
    );
  }
}
