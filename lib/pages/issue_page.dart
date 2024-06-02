
import 'package:flutter/material.dart';

import '../components/Issue/issue_body.dart';
import '../components/common/AppBar.dart';
import '../components/common/drawer.dart';


class IssuePage extends StatefulWidget {
  const IssuePage({super.key, required this.projectId, required this.issueId,});

  final int projectId;
  final int issueId;
  // final list<int> memberList;
  @override
  _IssuePageState createState() => _IssuePageState();
}

class _IssuePageState extends State<IssuePage> {


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
      body: IssueBody(projectId: widget.projectId, issueId: widget.issueId,),
    );
  }


}
