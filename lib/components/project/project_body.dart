import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:http/http.dart' as http;
import 'package:test/size.dart';
import 'package:test/styles.dart';
import '../../classes.dart';
import '../../login_session.dart';
import '../../pages/issue_page.dart';
import '../common/popup.dart';

class ProjectBody extends StatefulWidget {
  const ProjectBody({super.key, required this.projectId});

  final int projectId;
  @override
  State<ProjectBody> createState() => _ProjectBodyState();
}

class _ProjectBodyState extends State<ProjectBody> {
  late List<Issue> Issues = [];
  late List<Issue> filteredIssues = [];
  bool isIssueLoading = true;
  bool isProjectLoading = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String title = '';
  String priority = '';
  String searchField = 'Title';
  String searchKeyword = '';

  late Project currentProject;
  String name = '';
  String description = '';
  List<int> members = [];

  // getIssueData(int projectId) async {
  //   final url = Uri.parse(
  //     'http://localhost:8080/projects/${widget.projectId}/issues?username=${context.read<profile>().username}&password=${context.read<profile>().password}',
  //   );
  //   final response = await http.get(url);
  //   print("ppppppppppppppppppp");
  //   print(widget.projectId);
  //
  //   final parsed = jsonDecode(response.body).cast<Map<String, dynamic>>();
  //   Issues = parsed.map<Issue>((json) => Issue.fromJson(json)).toList();
  //
  //   setState(() {
  //     isIssueLoading = false;
  //     filteredIssues = Issues;
  //   });
  //   print('Response status: ${response.statusCode}');
  //   print('Response body: ${response.body}');
  // }
  Future<void> getIssueData() async {
    final url = Uri.parse(
      'http://localhost:8080/projects/${widget.projectId}/issues?username=${context.read<profile>().username}&password=${context.read<profile>().password}',
    );
    final response = await http.get(url);
    print('Response body: ${response.body}');
    if (response.statusCode == 200) {
      final List<dynamic> parsed = jsonDecode(response.body);
      setState(() {
        Issues = parsed.map<Issue>((json) => Issue.fromJson(json)).toList();
        isIssueLoading = false;
      });
    } else {
      setState(() {
        isIssueLoading = false;
      });
      print('Failed to load issues');
    }

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
  }

  getProjectData(int projectId) async {
    final url = Uri.parse(
      'http://localhost:8080/projects/${widget.projectId}?username=${context.read<profile>().username}&password=${context.read<profile>().password}',
    );
    final response = await http.get(url);
    print(response.body);

    final parsed = jsonDecode(response.body).cast<Map<String, dynamic>>();
    currentProject =
        parsed.map<Project>((json) => Project.fromJson(json)).toList();

    setState(() {
      isProjectLoading = false;
    });
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
  }

  void _sortIssues(String criteria) {
    setState(() {
      if (criteria == 'priority') {
        Issues.sort((a, b) => a.priority.compareTo(b.priority));
      } else if (criteria == 'status') {
        Issues.sort((a, b) => a.status.compareTo(b.status));
      } else if (criteria == 'assignee') {
        Issues.sort((a, b) {
          if (a.assignee == null && b.assignee == null) {
            return 0;
          } else if (a.assignee == null) {
            return 1; // null values go to the end
          } else if (b.assignee == null) {
            return -1; // null values go to the end
          } else {
            return a.assignee!.compareTo(b.assignee!);
          }
        });
      }
    });
  }

  void _filterIssues() {
    setState(() {
      if (searchKeyword.isEmpty) {
        filteredIssues = Issues;
      } else {
        filteredIssues = Issues.where((issue) {
          if (searchField == 'Title') {
            return issue.title
                .toLowerCase()
                .contains(searchKeyword.toLowerCase());
          } else if (searchField == 'Reporter') {
            return issue.reporter.username
                .toLowerCase()
                .contains(searchKeyword.toLowerCase());
          } else if (searchField == 'Assignee') {

            return issue.assignee?.toLowerCase().contains(searchKeyword.toLowerCase()) ?? false;
          } else if (searchField == 'Priority') {
            return issue.priority
                .toLowerCase()
                .contains(searchKeyword.toLowerCase());
          }
          return false;
        }).toList();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getIssueData();
    getProjectData(widget.projectId);
  }

  Widget build(BuildContext context) {
    if (Issues.isEmpty) {
      return Column(children: [
        SizedBox(
          height: 20,
        ),
        CircularProgressIndicator(),
        SizedBox(
          height: 20,
        ),
        _buildFormField(context),
        SizedBox(
          height: 20,
        ),
        CreateIssueButton(),
      ]);
    }
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Project Summary', style: subtitle1()),
            SizedBox(height: 10),
            _buildFormField(context),
            SizedBox(
              height: 20,
            ),
            CreateIssueButton(),
            SizedBox(height: 20),
            Text('Sort Issues By:', style: subtitle2()),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () => _sortIssues('priority'),
                  child: Text('Priority'),
                ),
                ElevatedButton(
                  onPressed: () => _sortIssues('status'),
                  child: Text('Status'),
                ),
                ElevatedButton(
                  onPressed: () => _sortIssues('assignee'),
                  child: Text('Assignee'),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text('Search Issues:', style: subtitle2()),
            Row(
              children: [
                DropdownButton<String>(
                  value: searchField,
                  onChanged: (String? newValue) {
                    setState(() {
                      searchField = newValue!;
                    });
                  },
                  items: <String>['Title', 'Reporter', 'Assignee', 'Priority']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      searchKeyword = value;
                      _filterIssues();
                    },
                    decoration: InputDecoration(
                      labelText: 'Search',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text('Issue Descriptions:', style: subtitle1()),

            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: Issues.length,
              itemBuilder: (context, index) {
                final issue = Issues[index];
                return Card(
                  elevation: 4,
                  margin: EdgeInsets.symmetric(vertical: 8),
                    child: InkWell(
                    onTap: () {
                  print('Issue #${index} clicked!');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => IssuePage(projectId: widget.projectId, issueId: issue.issueId,),
                    ),
                  );
                },

                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
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
                  ),),
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

  Widget CreateIssueButton() {
    return ElevatedButton.icon(
      onPressed: () async {
        if (this.formKey.currentState!.validate()) {
          this.formKey.currentState?.save();
        }

        print(context.read<profile>());

        final response = await http.post(
            Uri.parse(
                'http://localhost:8080/projects/${widget.projectId}/issues'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, String>{
              "username": context.read<profile>().username,
              "password": context.read<profile>().password,
              // "username": "12",
              // "password": "12",
              "title": title,
              "priority": priority,
            }));

        print(jsonEncode(<String, String>{
          "username": context.read<profile>().username,
          "password": context.read<profile>().password,
          // "username": "12",
          // "password": "12",
          "title": title,
          "priority": priority,
        }));

        if (response.statusCode == 201) {

          FlutterDialog(context, '이슈 생성 완료');

          print('project created: ');
          getIssueData();
        } else {
          FlutterDialog(context, '이슈 생성 에러');

          print('ERROR Status code: ${response.statusCode}');
        }
        setState(() {
          isIssueLoading = false;
        });
      },
      icon: Icon(Icons.add, size: 18),
      label: Text("New Issue"),
    );
  }

  Widget ProjectDescription() {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.lime[50],
      child: Padding(
        padding: EdgeInsets.all(gap_s),
        child: Column(
          children: [
            Text('Issue ID: ${currentProject.id}',
                style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Title: ${currentProject.name}'),
            SizedBox(height: 4),
            Text('Reporter: ${currentProject.description}'),
            SizedBox(height: 4),
            Text('Assigned to: ${currentProject.members}'),
          ],
        ),
      ),
    );
  }

  Widget renderTextFormField({
    required String label,
    required FormFieldSetter onSaved,
    required FormFieldValidator validator,
  }) {
    assert(onSaved != null);
    assert(validator != null);

    return Column(
      children: [
        Row(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        TextFormField(
          onSaved: onSaved,
          validator: validator,
        ),
        Container(width: 16.0),
      ],
    );
  }

  final formKey = GlobalKey<FormState>();
  Widget _buildFormField(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.lime[50],
      child: Form(
        key: this.formKey,
        child: Padding(
          padding: EdgeInsets.all(gap_s),
          child: Column(
            children: [
              renderTextFormField(
                label: 'Issue title * ',
                onSaved: (val) {
                  this.title = val;
                },
                validator: (val) {
                  return null;
                },
              ),
              renderTextFormField(
                label: 'priority pick one from HIGH, LOW, MEDIUM, CRITICAL',
                onSaved: (val) {
                  this.priority = val;
                },
                validator: (val) {
                  if (val == "HIGH" ||
                      val == "LOW" ||
                      val == "MEDIUM" ||
                      val == "CRITICAL")
                    return null;
                  else
                    return "Write HIGH or LOW or MEDIUM or CRITICAL ";
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
