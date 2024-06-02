import 'package:flutter/material.dart';



class CustomAppBar extends StatefulWidget {
  const CustomAppBar({super.key, required this.title});

  final String title;

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {


  @override
  Widget build(BuildContext) {
    return AppBar(
      title: Text(
        "Garmisch1968",
        style: TextStyle(fontFamily: 'Bebas Neue',
          fontSize: 30,
        color: Colors.white,),
      ),
      flexibleSpace: Image(
        image: AssetImage('assets/background_Image.jpg'),
        fit: BoxFit.cover,
      ),
      leading: Builder(
        builder: (context) {
          return IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          );
        },
      ),
    );
  }
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}
