import 'package:flutter/material.dart';
import 'package:test/components/home/home_body_sidebar.dart';
import 'package:test/components/home/home_body_contents.dart';
import 'package:test/components/home/home_body_popular.dart';
import 'package:test/components/home/home_body_banner.dart';
import 'package:test/size.dart';

class HomeBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {


    return Container(
      alignment: Alignment.center,
        child:

        HomeBodyContents(),
    );
  }
}
