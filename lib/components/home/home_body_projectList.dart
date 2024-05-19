import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:test/constants.dart';
import 'package:test/size.dart';
import 'package:test/styles.dart';

import '../../pages/project_page.dart';

class ProjectList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: gap_s, horizontal: gap_s),
      child: Container(
        width: 400,
        //width: MediaQuery.of(context).size.width * 0.8,
        //height: MediaQuery.of(context).size.height * 0.4,
        decoration: BoxDecoration(
          color: Colors.white60,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: Colors.black, style: BorderStyle.solid, width: 1),
        ),
        child: Padding(
          padding: const EdgeInsets.all(gap_l),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildListTitle(),
              _buildListContent(),
              //_buildListAddButton(),
            ],
          ),
        ),
      ),
    );
    ;
  }

  Widget _buildListTitle() {
    return SizedBox(
      //width: 38, height: 20,
      child: FittedBox(
        fit: BoxFit.contain,
        child: AutoSizeText(
          " 나의 프로젝트  ",
          maxFontSize: 25,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          textAlign: TextAlign.left,
        ),
      ),
    );
  }

  Widget _buildListContent() {
    return Column(
      children: [
        SizedBox(
          child: _buildListButton(),
        ),
        SizedBox(height: gap_s),
        SizedBox(
          child: _buildListButton(),
        ),
        SizedBox(height: gap_s),
        SizedBox(
          child: _buildListButton(),
        ),
      ],
    );
  }

  Widget _buildListButton() {
    return LayoutBuilder(
      builder: (context, constraints) => OutlinedButton(
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.grey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 0.0,
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => IssueDescriptionPage(project: Project(
              startDate: DateTime(2024, 1, 1),
              issues: [
                Issue(
                title: 'Network Issue',
                description: 'Network connectivity is intermittent',
                isCompleted: true,
                reporter: 'Alice',
                reportedDate: DateTime(2024, 2, 14),
                fixer: 'Bob',
                assignee: 'Charlie',
                priority: 'HIGH',
              ),
                Issue(
                  title: 'UI Bug',
                  description: 'Misalignment in header section on mobile view',
                  isCompleted: false,
                  reporter: 'Dave',
                  reportedDate: DateTime(2024, 2, 15),
                  fixer: 'Eve',
                  assignee: 'Frank',
                  priority: 'MEDIUM',
                ),
                Issue(
                  title: 'Performance Issue',
                  description: 'Application load time is too long',
                  isCompleted: true,
                  reporter: 'Grace',
                  reportedDate: DateTime(2024, 2, 16),
                  fixer: 'Heidi',
                  assignee: 'Ivan',
                  priority: 'LOW',
                ),
                Issue(
                  title: 'Database Error',
                  description: 'Error in data retrieval from the database',
                  isCompleted: false,
                  reporter: 'Judy',
                  reportedDate: DateTime(2024, 2, 17),
                  fixer: 'Ken',
                  assignee: 'Leo',
                  priority: 'HIGH',
                ),
                Issue(
                  title: 'Login Issue',
                  description: 'Users unable to login with valid credentials',
                  isCompleted: false,
                  reporter: 'Mallory',
                  reportedDate: DateTime(2024, 2, 18),
                  fixer: 'Niaj',
                  assignee: 'Olivia',
                  priority: 'MEDIUM',
                ),
                Issue(
                  title: 'API Timeout',
                  description: 'API calls timeout after 30 seconds',
                  isCompleted: true,
                  reporter: 'Peggy',
                  reportedDate: DateTime(2024, 2, 19),
                  fixer: 'Quentin',
                  assignee: 'Rupert',
                  priority: 'LOW',
                ),
                // Add more issues as needed
              ],
            ),)),
          );
          debugPrint('Received click');
        },
        child: Align(
          alignment: Alignment.centerLeft,
          child: FittedBox(
            fit: BoxFit.contain,
            child: AutoSizeText(
              "[ 자료관리 1조 ] 트리메이커스",
              maxFontSize: 15,
              style: TextStyle(
                fontSize: 10,
                color: Colors.black,
              ),
              textAlign: TextAlign.left,
            ),
          ),
        ),
      ),
    );
  }
}
