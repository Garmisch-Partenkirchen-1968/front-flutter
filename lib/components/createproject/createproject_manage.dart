import 'package:flutter/material.dart';

import '../../styles.dart';



class ProjectMemberPage extends StatefulWidget {
  @override
  _ProjectMemberPageState createState() => _ProjectMemberPageState();
}

class _ProjectMemberPageState extends State<ProjectMemberPage> {
  TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> members = [
    {
      'nickname': '@규성의닉네임(나)',
      'roles': ['admin']
    },
    {
      'nickname': '@예은예은',
      'roles': ['projectleader']
    },
    {
      'nickname': '@재오재오',
      'roles': ['dev']
    },
    {
      'nickname': '@영호영호',
      'roles': ['dev', 'tester']
    },
    {
      'nickname': '@닉네임임1',
      'roles': ['tester']
    },
  ];

  final List<String> availableRoles = [
    'admin',
    'projectleader',
    'dev',
    'tester'
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: SizedBox(
        height: 400,
      child: Column(
        children: [
          SizedBox(
            height: 50, child:
          Row(
            children: [
              Text("프로젝트 멤버 추가", style: subtitle1(),),
              SizedBox(width: 300,),
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: '닉네임으로 검색',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.search),
                  ),
                ),
              ),
            ],
          ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: SizedBox(width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              child: DataTable(
                columns: [
                  DataColumn(label: Text('닉네임')),
                  DataColumn(label: Text('역할 추가')),
                ],
                rows: members.map((member) {
                  return DataRow(cells: [
                    DataCell(Text(member['nickname'])),
                    DataCell(
                      Row(
                        children: [
                          DropdownButton<String>(
                            value: null,
                            hint: Text('역할 추가'),
                            onChanged: (String? newRole) {
                              setState(() {
                                if (newRole != null &&
                                    !member['roles'].contains(newRole)) {
                                  member['roles'].add(newRole);
                                }
                              });
                            },
                            items: availableRoles
                                .map<DropdownMenuItem<String>>((String role) {
                              return DropdownMenuItem<String>(
                                value: role,
                                child: Text(role),
                              );
                            }).toList(),
                          ),
                          Wrap(
                            children: member['roles'].map<Widget>((role) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4.0),
                                child: Chip(
                                  label: Text(role),
                                  onDeleted: () {
                                    setState(() {
                                      member['roles'].remove(role);
                                    });
                                  },
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ]);
                }).toList(),
              ),
            ),
          ),),
        ],
      ),
      ),
    );
  }
}
