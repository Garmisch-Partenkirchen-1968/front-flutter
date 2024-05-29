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
import 'home_body_projectList.dart';

class HomeBodyContents extends StatefulWidget {
  @override
  State<HomeBodyContents> createState() => _HomeBodyContentsState();
}

class _HomeBodyContentsState extends State<HomeBodyContents> {
  List<Project> projects = [];
  bool isLoading = true;

  getData() async {
    final url = Uri.parse(
      'http://localhost:8080/projects?username=${context.read<profile>().username}&password=${context.read<profile>().password}',
    );
    print(context.read<profile>().password);
    final response = await http.get(url);
    final parsed = jsonDecode(utf8.decode(response.bodyBytes)).cast<Map<String, dynamic>>();
    print('Response body: ${response.body}');
    projects = parsed.map<Project>((json) => Project.fromJson(json)).toList();
    setState(() {
      isLoading = false;
    });
    print(projects);

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    print(context.read<profile>().password);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  Widget build(BuildContext context) {
    if (projects.isEmpty) {
      return ElevatedButton(
        onPressed: () async {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CreateProjectPage(
                      title: 'eeee',
                    )),
          );
        },
        child: Text('프로젝트 추가'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
        ),
      );
    }

    return SingleChildScrollView( child:
      Column(
      children: [

        Container(
          alignment: Alignment.center,
          child: Wrap(
            spacing: 10.0, // 각 항목 사이의 가로 간격
            runSpacing: 10.0, // 각 항목 사이의 세로 간격
            children: projects.map((project) {
              return _buildProjectCard(project);
            }).toList(),
          ),
          ),

        ElevatedButton(
          onPressed: () async {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CreateProjectPage(
                        title: 'eeee',
                      )),
            );
          },
          child: Text('프로젝트 추가'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
          ),
        ),
      ],),
    );
  }

  Widget _buildProjectCard(Project individualProject) {
    return Card(
      elevation: 4.0, // 카드의 그림자 깊이
      margin: EdgeInsets.all(8.0), // 주변 여백
      child: InkWell(
        onTap: () {
          print('Project #${individualProject.id} clicked!');
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProjectPage(projectId: individualProject.id),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0), // 내부 여백
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Project #${individualProject.id}', // 프로젝트 ID
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple, // 글자 색상
                ),
              ),
              SizedBox(height: 10.0), // 요소 간의 간격
              Text(
                individualProject.name, // 프로젝트 이름
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5.0),
              Text(
                individualProject.description, // 프로젝트 설명
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
