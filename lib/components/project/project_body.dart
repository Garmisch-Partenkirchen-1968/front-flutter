import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test/size.dart';
import 'package:test/styles.dart';
import 'package:http/http.dart' as http;
import '../../classes.dart';
import '../../login_session.dart';
import '../../pages/createproject_page.dart';
import '../../pages/project_page.dart';


class ProjectBody extends StatefulWidget {
  @override
  State<ProjectBody> createState() => _ProjectBodyState();
}

class _ProjectBodyState extends State<ProjectBody> {
  late List<Issue> Issues = [];
  bool isLoading = true;


  getData() async {
    final url = Uri.parse(
      'http://localhost:8080/projects?username=${context.read<profile>().username}&password=${context.read<profile>().password}',
    );
    final response = await http.get(url);

    List<dynamic> body = jsonDecode(response.body);

    setState(() {
      isLoading = false;
    });
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    print(context.read<profile>().password);
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  Widget build(BuildContext context) {
    if (Issues.isEmpty) {
      return CircularProgressIndicator();
    }
    return SingleChildScrollView(

      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Project Summary',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
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
                        onPressed: () {},
                        child: Text('프로젝트 로드'),
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
            Text('Sort Issues By:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            Text('Issue Descriptions:',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            ListView.builder(
              // itemCount: projects.issues.length,
              itemBuilder: (context, index) {
                final issue = Issues[index];
                return Card(
                  elevation: 4,
                  margin: EdgeInsets.symmetric(vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IssueCard(Issues[0]),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
  Widget IssueCard(Issue issue) {
    return Card(
      elevation: 2.0,
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Issue ID: ${issue.issueId}',
                style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Title: ${issue.title}'),
            SizedBox(height: 4),
            Text('Reporter: ${issue.reporter}'),
            SizedBox(height: 4),
            Text('Assigned to: ${issue.assignee}'),
            SizedBox(height: 4),
            Text('Priority: ${issue.priority}'),
            SizedBox(height: 4),
            Text('Status: ${issue.status}'),
          ],
        ),
      ),
    );
  }
}