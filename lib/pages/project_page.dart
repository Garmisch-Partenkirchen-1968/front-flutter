import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import '../components/common/AppBar.dart';
import '../components/common/drawer.dart';

//http://localhost:8080/h2-console/login.do?jsessionid=780d3785e2e6a2dec31f39a0ada107ba


class IssueDescriptionPage extends StatefulWidget {
  @override
  _IssueDescriptionPageState createState() => _IssueDescriptionPageState();
}

class _IssueDescriptionPageState extends State<IssueDescriptionPage> {



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
        title: 'dddd',
      ),
      body: SingleChildScrollView(

        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Project Summary', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Container(
                width: MediaQuery.of(context).size.width,
                child: Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Text("asdfasd"),
                        ElevatedButton(
                          onPressed: () async {
                            final url = Uri.parse(
                              'http://localhost:8080/projects',
                            );
                            final response = await http.get(url);

                            print('Response status: ${response.statusCode}');
                            print('Response body: ${response.body}');

                            // final uri =
                            // Uri.https('http://localhost:8080.com', '/projects');
                            // final response = await http.get(uri, headers: {
                            //   //HttpHeaders.authorizationHeader: 'Token $token',
                            //   HttpHeaders.contentTypeHeader: 'application/json',
                            // });
                            // debugPrint('Status code: ${response.statusCode}');
                            // debugPrint('Response body: ${response.body}');


                          },
                          child: Text('로그인'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                          ),
                        ),
                        ],

                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text('Sort Issues By:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

              SizedBox(height: 20),
              Text('Issue Descriptions:', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),

            ],
          ),
        ),
      ),
    );
  }
}
