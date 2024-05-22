import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'package:test/pages/home_page.dart';

class SignupBody extends StatefulWidget {
  @override
  _SignupBodyState createState() => _SignupBodyState();
}

class _SignupBodyState extends State<SignupBody> {
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
            "Garmisch1968\n회원가입",
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
              final response = await http.post(
                Uri.parse('http://localhost:8080/signup'),
                headers: <String, String>{
                  'Content-Type': 'application/json; charset=UTF-8',
                },
                body: jsonEncode(<String, String>{
                  'username': idController.text,
                  'password': passwordController.text,
                }),
              );
              // debugPrint('Status code: ${response.statusCode}');
              // debugPrint('Response body: ${response.body}');
              if (response.statusCode == 201) {
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
