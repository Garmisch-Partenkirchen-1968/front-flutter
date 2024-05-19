import 'package:flutter/material.dart';
import 'package:test/components/home/home_body.dart';
import 'package:test/components/home/home_header.dart';

import '../components/createproject/createproject_body.dart';
import 'drawer.dart';


class CreateProjectPage extends StatefulWidget {
  const CreateProjectPage({super.key, required this.title});

  final String title;

  @override
  State<CreateProjectPage> createState() => _CreateProjectPagePageState();
}
class _CreateProjectPagePageState extends State<CreateProjectPage> {
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Home',
    ),
    Text(
      'Index 1: Business',
    ),
    Text(
      'Index 2: School',
    ),
  ];

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
      appBar: AppBar(
        title: const Text('Garmisch1968'),
        flexibleSpace: Image(
          image: AssetImage('assets/background.jpeg'),
          fit: BoxFit.cover,
        ),
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      drawer: CustomDrawer(title: 'cccc',),
      body:
      CreateProjectBody(),
    );
  }


}
