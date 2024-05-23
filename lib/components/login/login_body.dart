import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'package:test/pages/home_page.dart';

import '../../pages/signup_page.dart';

class LoginBody extends StatefulWidget {
  @override
  _LoginBodyState createState() => _LoginBodyState();
}

class _LoginBodyState extends State<LoginBody> {
  final TextEditingController idController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Garmisch1968",
            style: TextStyle(
              fontFamily: 'Bebas Neue',
              fontSize: 50,
            ),
          ),
          SizedBox(height: 20),
          TextField(
            controller: idController,
            decoration: InputDecoration(
              labelText: '아이디',
            ),
          ),
          SizedBox(height: 10),
          TextField(
            controller: passwordController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: '비밀번호',
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              final url = Uri.parse(
                'http://localhost:8080/signin?username=${idController.text}&password=${passwordController.text}',
              );
              final response = await http.get(url);

              print('Response status: ${response.statusCode}');
              print('Response body: ${response.body}');
              if (response.statusCode == 200) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MyHomePage(
                            title: 'bbbb',
                          )),
                );
                print(
                    'Logging in with ID: ${idController.text} and Password: ${passwordController.text}');
              } else { print(
                  'ERROR Status code: ${response.statusCode}');
              }
            },
            child: Text('로그인'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SignUpPage(
                      title: 'bbbb',
                    )),
              );
            },
            child: Text('회원가입'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }
}
