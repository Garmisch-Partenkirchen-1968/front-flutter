import 'package:flutter/material.dart';
import 'package:test/components/home/home_body.dart';
import 'package:test/components/home/home_header.dart';
import 'package:test/pages/createproject_page.dart';
import 'package:test/styles.dart';

import 'drawer.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Garmisch1968',style: h4(),),
        flexibleSpace: Image(
          image: AssetImage('assets/background_Image.jpg'),
          fit: BoxFit.cover,
        ),
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu,color: Colors.white),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      drawer: CustomDrawer(title: 'cccc',),
      body: HomeBody(),
    );
  }
}
