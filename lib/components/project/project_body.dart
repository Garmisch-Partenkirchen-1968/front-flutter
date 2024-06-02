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
import 'package:charts_flutter/flutter.dart' as charts;

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

  // Project currentProject={9999, "example", "description", [1, 3, 7, 8, 4]} as Project;
  late Project currentProject;
  String name = '';
  String description = '';
  List<int> members = [];
  List<IssueStatistics> data = [];
  String assignee = '';
  List<String> assigneeOptions = [];
  late List<User> Users = [];
  String fixer = '';

  int countStatus(List<Issue> Issues , String status){
    int count = 0;
    for (int i=0; i<Issues.length;i++){
      if (Issues[i].status == status) {
        count++;
      }
    }
    return count;

  }
  Future<void> getIssueData() async {
    final url = Uri.parse(
      'http://localhost:8080/projects/${widget.projectId}/issues?username=${context.read<profile>().username}&password=${context.read<profile>().password}',
    );
    final response = await http.get(url);

    print('Response body: ${response.body}');
    if (response.statusCode == 200) {
      final List<dynamic> parsed = jsonDecode(response.body);
      print(parsed);
      setState(() {
        Issues = parsed.map<Issue>((json) => Issue.fromJson(json)).toList();

        data = [
          new IssueStatistics('NEW', countStatus(Issues,'NEW')),
          new IssueStatistics('CLOSED', countStatus(Issues,'CLOSED')),
          new IssueStatistics('ASSIGNED', countStatus(Issues,'ASSIGNED')),
          new IssueStatistics('RESOLVED', countStatus(Issues,'RESOLVED')),
          new IssueStatistics('FIXED', countStatus(Issues,'FIXED')),
        ];

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
      'http://localhost:8080/projects/$projectId?username=${context.read<profile>().username}&password=${context.read<profile>().password}',
    );
    final response = await http.get(url);
    print("eeeeeeeeeeeeeeeeee");
    print(response.body);

    if (response.statusCode == 200) {
      final parsed = jsonDecode(response.body) as Map<String, dynamic>;
      currentProject = Project.fromJson(parsed);

      setState(() {
        isProjectLoading = false;
      });
    } else {
      print('Failed to load project data');
    }

    print("dddddddddddddddddd");
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
            return -1; // null values go to the end
          } else if (b.assignee == null) {
            return 1; // null values go to the end
          } else {
            return -1*(a.assignee.username!.compareTo(b.assignee.username!));
          }
        });
      }
      else if (criteria == 'reporter') {
        Issues.sort((a, b) {
          if (a.reporter == null && b.reporter == null) {
            return 0;
          } else if (a.reporter == null) {
            return -1; // null values go to the end
          } else if (b.reporter == null) {
            return 1; // null values go to the end
          } else {
            return -1*(a.reporter.username!.compareTo(b.reporter.username!));
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

            return issue.assignee.username
                .toLowerCase()
                .contains(searchKeyword.toLowerCase());
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
  List<String> permission = [];
  List<String> permissionOptions = ['admin', 'pl', 'tester', 'dev'];
  List<bool> permissionRequest = [];

  List<bool> convertPermissionToRequest(List<String> permission) {
    // [ 'pl', 'tester'] 이거를 [ false, true, true, false ] 이런 식으로 바꾸어서 요청 보낼 때 편하게 하는 거
    List<String> allPermissions = ['admin', 'pl', 'tester', 'dev'];
    List<bool> permissionRequest = [];

    for (String perm in allPermissions) {
      if (permission.contains(perm)) {
        permissionRequest.add(true);
      } else {
        permissionRequest.add(false);
      }
    }

    return permissionRequest;
  }
  List<String> extractUserIds(List<User> userList) {
    return userList.map((user) => user.username).toList();
  }
  getAllUsers() async {
    final url = Uri.parse(
        'http://localhost:8080/users?username=${context.read<profile>().username}&password=${context.read<profile>().password}');
    final response = await http.get(url);
    final parsed = jsonDecode(utf8.decode(response.bodyBytes))
        .cast<Map<String, dynamic>>();
    print('Response body: ${response.body}');
    Users = parsed.map<User>((json) => User.fromJson(json)).toList();
    assigneeOptions = extractUserIds(Users);
    print("ppppppppppp");
    print(assigneeOptions);
    setState(() {
      null;
    });
  }

  @override
  void initState() {
    super.initState();
    getIssueData();
    getProjectData(widget.projectId);
    getAllUsers();
    filteredIssues = Issues;
  }

  Widget build(BuildContext context) {
    // if (Issues.isEmpty) {
    //   return Column(children: [
    //     SizedBox(
    //       height: 20,
    //     ),
    //     CircularProgressIndicator(),
    //     SizedBox(
    //       height: 20,
    //     ),
    //     _buildFormField(context),
    //     SizedBox(
    //       height: 20,
    //     ),
    //     CreateIssueButton(),
    //   ]);
    // }
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Project Summary', style: subtitle1()),
            _buildProjectInfo(context),
            SizedBox(height: 20),
            Text('Issue Statistics', style: subtitle1()),
            SizedBox(height: 20),
            _buildIssueStatistics(context,data), // 통계 차트 추가

            SizedBox(height: 20),
            // ProjectDescription(),
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
                ElevatedButton(
                  onPressed: () => _sortIssues('reporter'),
                  child: Text('reporter'),
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
                    _filterIssues();
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
                      print(filteredIssues);
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

            PrintIssue(),


            Divider(),
            Text('Change Member permission:', style: subtitle2()),
            DropdownButtonFormField<String>(
              //project assign part
              value: assignee.isNotEmpty ? assignee : null,
              decoration: InputDecoration(labelText: 'All users'),
              items: assigneeOptions.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  assignee = newValue!;
                });
              },
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: permissionOptions.map((String value) {
                return CheckboxListTile(
                  // project role assign part
                  title: Text(value),
                  value: permission.contains(value),
                  onChanged: (bool? newValue) {
                    setState(() {
                      if (newValue == true) {
                        permission.add(value);
                      } else {
                        permission.remove(value);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            AddMemberButton(),
            Divider(),
            SizedBox(height: 10),
            Text('Add Issues:', style: subtitle2()),
            _buildFormField(context),
            SizedBox(
              height: 20,
            ),
            CreateIssueButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        SizedBox(height: 10),
        Text('${currentProject.name}'),
        SizedBox(height: 4),
        Text('Project description: ${currentProject.description ?? 'None'}'),
        SizedBox(height: 4),
        //Text('members: ${currentProject.members}'),

      ],
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
            Text('${issue.title}'),
            SizedBox(height: 4),
            Text('Reporter: ${issue.reporter}'),
            SizedBox(height: 4),
            Text('Assigned to: ${issue.assignee.username}'),
            SizedBox(height: 4),
            Text('Fixed by: ${issue.fixer.username}'),
            SizedBox(height: 4),
            Text('Priority: ${issue.priority}'),
            SizedBox(height: 4),
            Text('Status: ${issue.status}'),
          ],
        ),
      ),
    );
  }

  Widget PrintIssue() {
    if (Issues.isEmpty){
      return Text("No Issues");
    }
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: filteredIssues.length,
      //-------------------------
      itemBuilder: (context, index) {
        final issue = filteredIssues[index];
        //-------------------------
        return Card(
          elevation: 4,
          margin: EdgeInsets.symmetric(vertical: 8),
          child: InkWell(
            onTap: () {
              print('Issue #${index} clicked!');
              Navigator.pushReplacement(
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
                  Text('${issue.title}',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text('Issue ID: ${issue.issueId}'),
                  SizedBox(height: 4),
                  Text('Reporter: ${issue.reporter.username}'),
                  SizedBox(height: 4),
                  Text('Assigned to: ${issue.assignee.username}'),
                  SizedBox(height: 4),
                  Text('Fixed by: ${issue.fixer.username}'),
                  SizedBox(height: 4),
                  Text('Priority: ${issue.priority}'),
                  SizedBox(height: 4),
                  Text('Status: ${issue.status}'),
                ],
              ),
            ),),
        );
      },
    );


  }

  Widget AddMemberButton() {
    return ElevatedButton.icon(
      onPressed: () async {
        int addMemberId=0;
        if (this.formKey.currentState!.validate()) {
          this.formKey.currentState?.save();
        }
        for(int i=0;i<Users.length;i++){

          if (Users[i].username==assignee){
            addMemberId = Users[i].id;
          }
        }
        print("|||||||||||||||||||||");

        print(addMemberId);
        permissionRequest =convertPermissionToRequest(permission);


        final url = Uri.parse(
          'http://localhost:8080/projects/${widget.projectId}/permissions/${addMemberId}',
        );
        final response = await http.post(
          url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, dynamic>{
            "username" : context.read<profile>().username,
            "password" : context.read<profile>().password,
            "permissions" : permissionRequest,
          })
        );
        print(jsonEncode(<String, dynamic>{
          "username" : context.read<profile>().username,
          "password" : context.read<profile>().password,
          "permissions" : permissionRequest,
        }));
        print(response.body);
        if (response.statusCode == 201) {

          FlutterDialog(context, 'Member assigned as ${permission.join(",")}');
          getIssueData();
        } else {
          FlutterDialog(context, 'Member assigned as ${permission.join(",")}');
//_________________________________ 멤버 배정 에러
          print('ERROR Status code: ${response.statusCode}');
        }
        setState(() {
          isIssueLoading = false;
        });
      },
      icon: Icon(Icons.add, size: 18),
      label: Text("Add member"),
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

              "title": title,
              "priority": priority,
            }));

        print(jsonEncode(<String, String>{
          "username": context.read<profile>().username,
          "password": context.read<profile>().password,

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
            Text(' ${currentProject.name}'),
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
                label: 'Write MAJOR or BLOCKER or MINOR or CRITICAL or TRIVIAL',
                onSaved: (val) {
                  this.priority = val;
                },
                validator: (val) {
                  if (val == "MAJOR" ||
                      val == "BLOCKER" ||
                      val == "MINOR" ||
                      val == "CRITICAL" ||
                      val == "TRIVIAL")
                    return null;
                  else
                    return "Write MAJOR or BLOCKER or MINOR or CRITICAL or TRIVIAL";
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildIssueStatistics(BuildContext context ,var data) {
    // var data = [
    //   new IssueStatistics('NEW', 5),
    //   new IssueStatistics('CLOSED', 3),
    //   new IssueStatistics('ASSIGNED', 2),
    //   new IssueStatistics('RESOLVED', 4),
    //   new IssueStatistics('FIXED', 1),
    // ];


    var series = [
      new charts.Series(
        id: 'Issues',
        domainFn: (IssueStatistics stats, _) => stats.status,
        measureFn: (IssueStatistics stats, _) => stats.count,
        data: data,
      ),
    ];

    var chart = new charts.BarChart(
      series,
      animate: true,
    );

    return new SizedBox(
      height: 200.0,
      child: chart,
    );
  }

}
