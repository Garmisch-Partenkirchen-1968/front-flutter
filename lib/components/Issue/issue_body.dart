import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:http/http.dart' as http;
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
  // late List<Issue> filteredIssues = [];
  bool isIssueLoading = true;
  // bool isProjectLoading = true;
  // final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String content = '';
  bool isDescription = true;
  // String searchField = 'Title';
  // String searchKeyword = '';
  //
  late Issue currentIssue;
  // String name = '';
  // String description = '';
  // List<int> members = [];


  getIssueCommentsData() async {
    final url = Uri.parse(
      'http://localhost:8080/projects/${widget.projectId}/issues/${widget.issueId}?username=${context.read<profile>().username}&password=${context.read<profile>().password}',
    );
    final response = await http.get(url);
    print(response.body);

    final parsed = jsonDecode(response.body).cast<Map<String, dynamic>>();
    currentIssue =
        parsed.map<Issue>((json) => Issue.fromJson(json)).toList();

    setState(() {
      isIssueLoading = false;
    });
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
  }



  @override
  void initState() {
    super.initState();

    getIssueCommentsData();
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
            SizedBox(height: 10),
            _buildFormField(context),
            SizedBox(
              height: 20,
            ),
            // CreateIssueButton(),
            SizedBox(height: 20),
            CreateCommentButton(),

            Text('comments:', style: subtitle1()),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final comment = Comments[index];
                return Card(
                  elevation: 4,
                  margin: EdgeInsets.symmetric(vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('commentId: ${comment.id}',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 8),
                        Text('content: ${comment.content}'),
                        SizedBox(height: 4),
                        Text('commenter: ${comment.commenter}'),
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
          ],
        ),
      ),
    );
  }



  // Widget CreateCommentButton() {
  //   return ElevatedButton.icon(
  //     onPressed: () async {
  //       if (this.formKey.currentState!.validate()) {
  //         this.formKey.currentState?.save();
  //       }
  //
  //       print(context.read<profile>());
  //
  //       final response = await http.post(
  //           Uri.parse('http://localhost:8080/projects/${widget.issueId}/issues'),
  //           headers: <String, String>{
  //             'Content-Type': 'application/json; charset=UTF-8',
  //           },
  //           body: jsonEncode(<String, String>{
  //             "username": context.read<profile>().username,
  //             "password": context.read<profile>().password,
  //             // "username": "12",
  //             // "password": "12",
  //             "title": title,
  //             "priority": priority,
  //           }));
  //
  //       print(jsonEncode(<String, String>{
  //         "username": context.read<profile>().username,
  //         "password": context.read<profile>().password,
  //         // "username": "12",
  //         // "password": "12",
  //         "title": title,
  //         "priority": priority,
  //       }));
  //       if (response.statusCode == 201) {
  //         FlutterDialog(context, '프로젝트 생성 완료');
  //         print('project created: ');
  //       } else {
  //         FlutterDialog(context, '프로젝트 생성 에러');
  //
  //         print('ERROR Status code: ${response.statusCode}');
  //       }
  //       setState(() {
  //         isIssueLoading = false;
  //       });
  //     },
  //     icon: Icon(Icons.add, size: 18),
  //     label: Text("새 이슈 생성"),
  //   );
  // }
  //
  // Widget IssueDescription() {
  //   return Container(
  //     width: MediaQuery.of(context).size.width,
  //     color: Colors.lime[50],
  //     child: Padding(
  //       padding: EdgeInsets.all(gap_s),
  //       child: Column(
  //         children: [
  //           Text('Issue ID: ${currentProject.id}',
  //               style: TextStyle(fontWeight: FontWeight.bold)),
  //           SizedBox(height: 8),
  //           Text('Title: ${currentProject.name}'),
  //           SizedBox(height: 4),
  //           Text('Reporter: ${currentProject.description}'),
  //           SizedBox(height: 4),
  //           Text('Assigned to: ${currentProject.members}'),
  //         ],
  //       ),
  //     ),
  //   );
  // }
  Widget CreateCommentButton() {
    return ElevatedButton.icon(
      onPressed: () async {
        if (formKey.currentState!.validate()) {
          formKey.currentState?.save();
        }

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
              "content": "content",
              "isDescription": true,
            }));
        print(jsonEncode(<String, dynamic>{
          "username": context.read<profile>().username,
          "password": context.read<profile>().password,
          "content":" content",
          "isDescription": isDescription,
        }));


        if (response.statusCode == 201) {
          FlutterDialog(context, '댓글 작성 완료');
          print('project created: ');
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
                label: ' 댓글 내용 ',
                onSaved: (val) {
                  this.content = val;
                },
                validator: (val) {
                  return null;
                },
              ),
              renderTextFormField(
                label: 'priority pick one from true or false',
                onSaved: (val) {
                  this.isDescription = val;
                },
                validator: (val) {
                  if (val == "true" ||
                      val == "false"
                     )
                    return null;
                  else
                    return "Write true or false";
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
