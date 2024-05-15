import 'package:flutter/material.dart';
import 'package:test/size.dart';
import 'package:test/styles.dart';

class HomeHeaderAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(gap_m),
      child: Column(
        children: [
          Text("Project List", style: h5(mColor: Colors.black)),
          const Spacer(),
          _buildAppBarMenu(),
        ],
      ),
    );
  }


  Widget _buildAppBarMenu() {
    return Column(
      children: [
        Card(
          child: ListTile(
            leading: FlutterLogo(),
            title: Text('One-line with both widgets'),
            trailing: Icon(Icons.more_vert),
          ),
        ),
        Text("회원가입", style: subtitle1(mColor: Colors.white)),
        const SizedBox(width: gap_m),
        Text("로그인", style: subtitle1(mColor: Colors.white)),
      ],
    );
  }
}
