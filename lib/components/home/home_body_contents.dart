import 'package:flutter/material.dart';
import 'package:test/size.dart';
import 'package:test/styles.dart';

import 'home_body_projectList.dart';

class HomeBodyContents extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double bodyHeight = getBodyWidth(context);
    //getBodyHeight(context);
    double bodyWidth = getBodyWidth(context);
    return Container(
      alignment: Alignment.center,
      //width: bodyHeight * 0.8,
      child: Wrap(

        direction: Axis.horizontal, // 나열 방향
        alignment: WrapAlignment.start,
        children: [
          ProjectList(),
          ProjectList(),
          ProjectList(),
          ProjectList(),
        ],
      ),
    );
  }
}
