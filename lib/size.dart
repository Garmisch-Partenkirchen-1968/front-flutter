import 'package:flutter/cupertino.dart';

// 간격
const double gap_xl = 40;
const double gap_l = 30;
const double gap_m = 20;
const double gap_s = 10;
const double gap_xs = 5;

// 헤더 높이
const double header_height = 80;
const double sidebar_width = 300;

const double body_projectList_height = 300;
const double body_projectList_width = 500;

// MediaQuery 클래스로 화면 사이즈를 받을 수 있다.
double getBodyWidth(BuildContext context) {
  return MediaQuery.of(context).size.width ;
}
double getBodyHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}