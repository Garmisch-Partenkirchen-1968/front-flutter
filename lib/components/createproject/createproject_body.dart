import 'package:flutter/material.dart';

import 'package:test/size.dart';
import 'package:test/styles.dart';

class CreateProjectBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: [
          Container(
            height: getBodyHeight(context) * 0.2,
            width: getBodyWidth(context),
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              color: Colors.black12,
            ),
            child : Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                "새 프로젝트를 생성합니다",
                style: h4(),
              ),
            ),

          ),
          Padding(
              padding: EdgeInsets.all(20),
              child: Container(
                height: getBodyHeight(context) * 0.2,
                width: getBodyWidth(context),
                alignment: Alignment.centerRight,
                decoration: BoxDecoration(
                  color: Colors.white12,
                ),
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Respond to button press
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.add, size: 18),
                  label: Text("새 프로젝트"),
                ),
              )),
        ],
      ),
    );
  }
}
