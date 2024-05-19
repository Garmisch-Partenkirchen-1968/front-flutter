import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:test/size.dart';
import 'package:test/styles.dart';

import '../common/common_form_field.dart';
import 'createproject_manage.dart';

class CreateProjectBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Container(
              height: 50,
              width: getBodyWidth(context),
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  "새 프로젝트를 생성합니다",
                  style: subtitle1(),
                ),
              ),
            ),
            _buildFormField(context),
            ProjectMemberPage(),
            _buildButtonSubmit(context),
          ],
        ),
      ),
    );
  }

  Widget _buildButtonSubmit(context) {
    return Padding(
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
        ));
  }

  Widget renderTextFormField({
    required String label,
    required FormFieldSetter onSaved,
    required FormFieldValidator validator,
  }) {
    assert(onSaved != null);
    assert(validator != null);

    return Column(
      children: [
        Row(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        TextFormField(
          onSaved: onSaved,
          validator: validator,
        ),
        Container(width: 16.0),
      ],
    );
  }

  final formKey = GlobalKey<FormState>();
  Widget _buildFormField(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.lime[50],
      child: Form(
        key: this.formKey,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              renderTextFormField(
                label: '프로젝트 이름 * ',
                onSaved: (val) {},
                validator: (val) {
                  return null;
                },
              ),
              renderTextFormField(
                label: '프로젝트 설명',
                onSaved: (val) {},
                validator: (val) {
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
