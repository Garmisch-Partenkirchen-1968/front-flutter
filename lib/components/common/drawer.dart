import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../pages/createproject_page.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key, required this.title});

  final String title;

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
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
  Widget build(BuildContext) {
    return Drawer(
      child: ListView(
// Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text('Drawer Header'),
          ),
          ListTile(
            title: const Text('My project'),
            selected: _selectedIndex == 0,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CreateProjectPage(
                          title: 'bbbb',
                        )),
              );
            },
          ),
          ListTile(
            title: const Text('Add project'),
            onTap: () {
// Update the state of the app
              _onItemTapped(0);
// Then close the drawer
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}
