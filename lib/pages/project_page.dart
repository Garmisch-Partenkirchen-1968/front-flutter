import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:test/login_session.dart';
import '../classes.dart';
import '../components/common/AppBar.dart';
import '../components/common/drawer.dart';
import 'package:provider/provider.dart';

import '../components/project/project_body.dart';

//http://localhost:8080/h2-console/login.do?jsessionid=780d3785e2e6a2dec31f39a0ada107ba

class ProjectPage extends StatefulWidget {
  const ProjectPage({super.key, required this.projectId});

  final int projectId;
  @override
  _ProjectPageState createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage> {


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
      body: ProjectBody(projectId: widget.projectId,),
    );
  }


}
