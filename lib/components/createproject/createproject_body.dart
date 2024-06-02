import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:test/size.dart';
import 'package:test/styles.dart';

import '../../login_session.dart';

import '../../pages/home_page.dart';
import '../common/popup.dart';

class CreateProjectBody extends StatefulWidget {
  final String username;

  final String password;

  const CreateProjectBody({super.key, required this.username,required this.password });

  @override
  State<CreateProjectBody> createState() => _CreateProjectBodyState();
}

class _CreateProjectBodyState extends State<CreateProjectBody> {


  String projectName = '';
  String projectDescription = '';
  final List<String> roles = ['admin', 'pl', 'tester', 'dev'];
  final Map<String, bool> selectedRoles = {
    'admin': false,
    'pl': false,
    'tester': false,
    'dev': false
  };
  int createdProjectId = 999999;

  // final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Container(
              height: 50,
              width: getBodyWidth(context),
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  "새 프로젝트를 생성합니다",
                  style: subtitle1(),
                ),
              ),
            ),
            _buildFormField(context),
            //_buildRoleCheckboxes(),
            // ProjectMemberPage(),

            _buildButtonSubmit(context),
          ],
        ),
      ),
    );
  }

  Widget _buildButtonSubmit(context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Container(
        height: getBodyHeight(context) * 0.2,
        width: getBodyWidth(context),
        alignment: Alignment.centerRight,
        decoration: BoxDecoration(
          color: Colors.white12,
        ),
        child: ElevatedButton.icon(
          onPressed: () async {
            if (this.formKey.currentState!.validate()) {
              this.formKey.currentState?.save();
            }


            final response =
                await http.post(Uri.parse('http://localhost:8080/projects'),
                    headers: <String, String>{
                      'Content-Type': 'application/json; charset=UTF-8',
                    },
                    body: jsonEncode(<String, String>{
                      "username": widget.username,
                      "password": widget.password,

                      "name": projectName,
                      "description": projectDescription,
                    }));


            print("dddddddddddddddddd");
            print(widget.password);
            print(jsonEncode(<String, String>{
              "username": widget.username,
              "password": widget.password,

              "name": projectName,
              "description": projectDescription,
            }));
            print(response.body);

            if (response.statusCode == 201) {
              final responseBody = jsonDecode(response.body);
              createdProjectId = responseBody['id'];

              final permissionResponse = await http.patch(
                Uri.parse(
                    'http://localhost:8080/projects/$createdProjectId/permissions/1'),// userid 수정필요
                //_______________________________
                headers: <String, String>{
                  'Content-Type': 'application/json; charset=UTF-8',
                },
                body: jsonEncode(<String, dynamic>{
                  "username": widget.username,
                  "password": widget.password,
                  "permissions": [true, true, true, true]
                }),
              );

              if (permissionResponse.statusCode == 200) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MyHomePage(
                        title: 'eeee',
                      )),
                );
              }
              FlutterDialog(context, '프로젝트 생성 완료');
              print('project created: ');
            } else {
              FlutterDialog(context, '프로젝트 생성 에러');

              print('ERROR Status code: ${response.statusCode}');
            }
          },
          icon: Icon(Icons.add, size: 18),
          label: Text("새 프로젝트"),
        ),
      ),
    );
  }

  Widget _buildRoleCheckboxes() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: roles.map((role) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Checkbox(
                value: selectedRoles[role],
                onChanged: (bool? value) {
                  setState(() {
                    selectedRoles[role] = value!;
                  });
                },
              ),
              Text(role),
              SizedBox(width: 10), // Add spacing between checkboxes if needed
            ],
          );
        }).toList(),
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
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              renderTextFormField(
                label: '프로젝트 이름 * ',
                onSaved: (val) {
                  this.projectName = val;
                },
                validator: (val) {
                  return null;
                },
              ),
              renderTextFormField(
                label: '프로젝트 설명',
                onSaved: (val) {
                  this.projectDescription = val;
                },
                validator: (val) {
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
