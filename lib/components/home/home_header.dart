import 'package:flutter/material.dart';
import 'package:test/components/home/home_header_appbar.dart';
import 'package:test/size.dart';

class HomeHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: header_height,
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background.jpeg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            HomeHeaderAppBar(),

          ],
        ),
      ),
    );
  }
}
