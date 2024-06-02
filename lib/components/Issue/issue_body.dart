import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:http/http.dart' as http;
import 'package:test/pages/project_page.dart';
import 'package:test/size.dart';
import 'package:test/styles.dart';
import '../../classes.dart';
import '../../login_session.dart';
import '../common/popup.dart';

class IssueBody extends StatefulWidget {
  const IssueBody({super.key, required this.projectId, required this.issueId});

  final int projectId;
  final int issueId;
  @override
  State<IssueBody> createState() => _IssueBodyState();
}

class _IssueBodyState extends State<IssueBody> {
  late List<Comment> Comments = [];
  late List<User> Users = [];
  // late List<Issue> filteredIssues = [];
  bool isIssueLoading = true;
  // bool isProjectLoading = true;
  // final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String content = '';
  bool isDescription = true;

  late Issue currentIssue;
  late Project currentProject;

  String title = '';
  String assignee = '';
  String status = '';
  List<String> permission = [];
  List<String> assigneeOptions = [];
  List<String> statusOptions = [
    'NEW',
    'CLOSED',
    'ASSIGNED',
    'RESOLVED',
    'FIXED'
  ];
  String recommendUser= ' ';
  List<RecommendDeveloper> RecommendDevelopers = [];

  getRecommendUser() async {
    final url = Uri.parse(
      'http://localhost:8080/projects/${widget.projectId}/recommend-assignee?username=${context.read<profile>().username}&password=${context.read<profile>().password}&priority=MAJOR',
    );
    final response = await http.get(url);
    print("ddddd");
    print(response.body);


    final List<dynamic> parsedRecommendDeveloper = jsonDecode(response.body);
    RecommendDevelopers = parsedRecommendDeveloper.map((json) => RecommendDeveloper.fromJson(json)).toList();


    recommendUser = [RecommendDevelopers[0].username,RecommendDevelopers[1].username,RecommendDevelopers[2].username].join(",");
    print(recommendUser);
  }

  getCommentsData() async {
    final url = Uri.parse(
      'http://localhost:8080/projects/${widget.projectId}/issues/${widget.issueId}?username=${context.read<profile>().username}&password=${context.read<profile>().password}',
    );
    final response = await http.get(url);
    print(response.body);

    final parsed = jsonDecode(response.body);

    if (parsed is Map<String, dynamic>) {
      currentIssue = Issue.fromJson(parsed);
      Comments = currentIssue.comments;
      Comments.sort((a, b) {
        if (a.isDescription && !b.isDescription) {
          return -1;
        } else if (!a.isDescription && b.isDescription) {
          return 1;
        } else {
          return 0;
        }
      });
      title = currentIssue.title;
      assignee = currentIssue.assignee.username ?? '';
      status = currentIssue.status;
    } else {
      print('Unexpected response format');
      return;
    }

    setState(() {
      isIssueLoading = false;
    });

    print('Response body: ${response.body}');
    print('Response comments: ${Comments[0].content}');
  }

  updateIssueData() async {
    final url = Uri.parse(
      'http://localhost:8080/projects/${widget.projectId}/issues/${widget.issueId}',
    );
    final response = await http.patch(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'username': context.read<profile>().username,
        'password': context.read<profile>().password,
        'title': title,
        'assignee': assignee,
        'status': status,
        "priority": null
      }),
    );
    print('Update response status: ${response.statusCode}');
    if (response.statusCode == 200) {
      FlutterDialog(context, 'Issue updated successfully');
    } else {
      FlutterDialog(context, 'Error updating issue');
    }
    getCommentsData();
  }

  updateIssueAssignee(String newAssignee) async {
    final url = Uri.parse(
      'http://localhost:8080/projects/${widget.projectId}/issues/${widget.issueId}',
    );
    final response = await http.patch(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'username': context.read<profile>().username,
        'password': context.read<profile>().password,
        'title': null,
        'assignee': newAssignee,
        'status': null,
        "priority": null
      }),
    );
    print ("|||||||||||||||||||||||||||||||||||");
    print(jsonEncode(<String, dynamic>{
      'username': context.read<profile>().username,
      'password': context.read<profile>().password,
      'title': null,
      'assignee': newAssignee,
      'status': null,
      "priority": null
    }));
    print('Update response status: ${response.statusCode}');
    if (response.statusCode == 200) {
      FlutterDialog(context, 'Issue updated successfully(newAssignee)');
    } else {
      FlutterDialog(context, 'Error updating issue');
    }
    getCommentsData();
  }

  updateIssueStatus(String status) async {
    final url = Uri.parse(
      'http://localhost:8080/projects/${widget.projectId}/issues/${widget.issueId}',
    );
    final response = await http.patch(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'username': context.read<profile>().username,
        'password': context.read<profile>().password,
        'title': null,
        'assignee': null,
        'status': status,
        "priority": null
      }),
    );


    if (response.statusCode == 200) {
      FlutterDialog(context, 'Issue updated successfully(status)');
    } else {
      FlutterDialog(context, 'Error updating issue');
    }
    getCommentsData();
  }

  List<int> extractIds(Map<String, dynamic> json) {
    List<int> ids = [];

    // 상위 레벨의 id 추출
    if (json.containsKey('id') && json['id'] != null) {
      ids.add(json['id']);
    }

    // reporter의 id 추출
    if (json.containsKey('reporter') && json['reporter']['id'] != null) {
      ids.add(json['reporter']['id']);
    }

    // comments의 각 항목에서 id와 commenter의 id 추출
    if (json.containsKey('comments') && json['comments'] is List) {
      for (var comment in json['comments']) {
        if (comment['id'] != null) {
          ids.add(comment['id']);
        }
        if (comment['commenter'] != null &&
            comment['commenter']['id'] != null) {
          ids.add(comment['commenter']['id']);
        }
      }
    }
    return ids;
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
    print(assigneeOptions);
    setState(() {
      null;
    });
  }

  @override
  void initState() {
    super.initState();
    getCommentsData();
    getAllUsers();
    getRecommendUser();
  }

  Widget build(BuildContext context) {
    if (Comments.isEmpty) {
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
        CreateCommentButton(),
        // CreateIssueButton(),
      ]);
    }
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Issue Summary', style: subtitle1()),
            _buildIssueInfo(context),
            SizedBox(height: 20),
            Divider(),
            Text('Change Issue information', style: subtitle1()),
            _buildIssueUpdateForm(context),
            SizedBox(height: 20),
            Divider(),
            Text('comments:', style: subtitle1()),
            SizedBox(height: 20),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: Comments
                  .length, // Add itemCount to specify the number of items
              itemBuilder: (context, index) {
                final comment = Comments[index];
                if(comment.id == 999999){
                  return Text("no comments");
                }
                return Card(
                  elevation: 4,
                  margin: EdgeInsets.symmetric(vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(' ${comment.content}',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 8),
                        Text('commentId: ${comment.id}'),
                        SizedBox(height: 4),
                        Text('commenter: ${comment.commenter.username}'),
                        SizedBox(height: 4),
                        Text('commentedDate: ${comment.commentedDate}'),
                        SizedBox(height: 4),
                        Text('isDescription: ${comment.isDescription}'),
                      ],
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 10),
            _buildFormField(context),
            SizedBox(
              height: 20,
            ),
            // CreateIssueButton(),
            SizedBox(height: 20),
            CreateCommentButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildIssueUpdateForm(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        renderTextFormField(
          label: 'Title',
          onSaved: (val) {
            this.title = val!;
          },
          hintText: "ex) title",
          validator: (val) {
            return null;
          },
        ),
        DropdownButtonFormField<String>(
          //project assign part
          value: assignee.isNotEmpty ? assignee : null,
          decoration: InputDecoration(labelText: 'Assignee'),
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

        Text("best candidate: ${recommendUser}"),

        DropdownButtonFormField<String>(
          value: status.isNotEmpty ? status : null,
          decoration: InputDecoration(labelText: 'Status'),
          items: statusOptions.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (newValue) {
            setState(() {
              status = newValue!;
            });
          },
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () async {
            // updateIssueData();
            updateIssueAssignee(assignee);
            updateIssueStatus(status);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => ProjectPage(
                    projectId: widget.projectId,
                  )),
            );

            // permissionRequest = convertPermissionToRequest(permission);
            // final response = await http.post(
            //   Uri.parse('http://localhost:8080/projects/${widget.projectId}/permissions/${context.read<profile>().username}'),
            //   headers: <String, String>{
            //     'Content-Type': 'application/json; charset=UTF-8',
            //   },
            //   body: jsonEncode(<String, dynamic>{
            //     'username': context.read<profile>().username,
            //     'password': context.read<profile>().password,
            //     'permissions' : permissionRequest,
            //   }),
            //
            // );
            // print("---------------------");
            // print(response.body);
            // print(response.statusCode);
            //
            // if (formKey.currentState!.validate()) {
            //   formKey.currentState?.save();
            // }
          },
          child: Text('Update Issue'),
        ),
      ],
    );
  }

  Widget _buildIssueInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Current Issue Information', style: subtitle2()),
        SizedBox(height: 10),
        Text('Title: ${currentIssue.title}'),
        SizedBox(height: 4),
        Text('Assignee: ${currentIssue.assignee.username ?? 'None'}'),
        SizedBox(height: 4),
        Text('Status: ${currentIssue.status}'),
        SizedBox(height: 4),
        Text('Reporter: ${currentIssue.reporter.username}'),
        SizedBox(height: 4),
        Text('Reported Date: ${currentIssue.reportedDate}'),
        SizedBox(height: 4),
        Text('Priority: ${currentIssue.priority}'),
      ],
    );
  }

  Widget CreateCommentButton() {
    return ElevatedButton.icon(
      onPressed: () async {
        if (formKey.currentState!.validate()) {
          formKey.currentState?.save();
        }
        print(content);
        print(isDescription);

        print(context.read<profile>());
        final response = await http.post(
            Uri.parse(
                'http://localhost:8080/projects/${widget.projectId}/issues/${widget.issueId}/comments'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, dynamic>{
              "username": context.read<profile>().username,
              "password": context.read<profile>().password,
              "content": content,
              "isDescription": isDescription,
            }));


        if (response.statusCode == 201) {
          FlutterDialog(context, 'comment registered');
          print('comment created: ');
          getCommentsData();
        } else {
          FlutterDialog(context, '댓글 작성 에러');

          print('ERROR Status code: ${response.statusCode}');
        }
        setState(() {
          isIssueLoading = false;
        });
      },
      icon: Icon(Icons.add, size: 18),
      label: Text("new comment"),
    );
  }

  Widget renderTextFormField({
    required String label,
    required FormFieldSetter onSaved,
    required FormFieldValidator validator,
    required String hintText,
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
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: hintText,
          ),
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
                  label: 'Comment contents',
                  onSaved: (val) {
                    this.content = val;
                  },
                  validator: (val) {
                    return null;
                  },
                  hintText: "content Description"),
              renderTextFormField(
                  label: 'priority pick one from true or false',
                  onSaved: (val) {
                    if (val == "true") {
                      this.isDescription = true;
                    }
                    else
                    {
                      this.isDescription = false;
                    };
                  },
                  validator: (val) {
                    if (val == "true" || val == "false")
                      return null;
                    else
                      return "Write true or false";
                  },
                  hintText: "true"),
            ],
          ),
        ),
      ),
    );
  }
}
