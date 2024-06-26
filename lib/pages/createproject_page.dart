import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import '../components/common/AppBar.dart';
import '../components/createproject/createproject_body.dart';
import '../components/common/drawer.dart';
import '../login_session.dart';

class CreateProjectPage extends StatefulWidget {
  const CreateProjectPage({super.key, required this.title});

  final String title;

  @override
  State<CreateProjectPage> createState() => _CreateProjectPagePageState();
}

class _CreateProjectPagePageState extends State<CreateProjectPage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {

    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }

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
        title: 'cccc',
      ),
      body:CreateProjectBody(username: context.read<profile>().username,password: context.read<profile>().password,),

    );
  }
}
