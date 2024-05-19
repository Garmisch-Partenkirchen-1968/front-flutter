import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../components/common/AppBar.dart';
import '../components/common/drawer.dart';

class IssueDescriptionPage extends StatefulWidget {
  final Project project;

  IssueDescriptionPage({required this.project});

  @override
  _IssueDescriptionPageState createState() => _IssueDescriptionPageState();
}

class _IssueDescriptionPageState extends State<IssueDescriptionPage> {
  String _sortCriteria = 'Title';

  void _sortIssues(String criteria) {
    setState(() {
      _sortCriteria = criteria;
      switch (criteria) {
        case 'Title':
          widget.project.issues.sort((a, b) => a.title.compareTo(b.title));
          break;
        case 'Description':
          widget.project.issues.sort((a, b) => a.description.compareTo(b.description));
          break;
        case 'Date':
          widget.project.issues.sort((a, b) => a.reportedDate.compareTo(b.reportedDate));
          break;
        case 'Priority':
          widget.project.issues.sort((a, b) => a.priority.compareTo(b.priority));
          break;
        default:
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: CustomAppBar(
          title: "appbar",
        ),
      ),
      drawer: CustomDrawer(
        title: 'dddd',
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Project Summary', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Container(
                width: MediaQuery.of(context).size.width,
                child: Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Days since start: ${widget.project.daysSinceStart}', style: TextStyle(fontSize: 18)),
                        Text('Total issues: ${widget.project.totalIssues}', style: TextStyle(fontSize: 18)),
                        Text('Completed issues: ${widget.project.completedIssues}', style: TextStyle(fontSize: 18)),
                        Text('Remaining issues: ${widget.project.remainingIssues}', style: TextStyle(fontSize: 18)),
                        Text('Completion percentage: ${widget.project.completionPercentage.toStringAsFixed(2)}%', style: TextStyle(fontSize: 18)),
                        Text('Issues per day: ${widget.project.issuesPerDay.toStringAsFixed(2)}', style: TextStyle(fontSize: 18)),
                        Text('Issues per month: ${widget.project.issuesPerMonth.toStringAsFixed(2)}', style: TextStyle(fontSize: 18)),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text('Sort Issues By:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              DropdownButton<String>(
                value: _sortCriteria,
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    _sortIssues(newValue);
                  }
                },
                items: <String>['Title', 'Description', 'Date', 'Priority']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
              Text('Issue Descriptions:', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              Container(
                height: MediaQuery.of(context).size.height * 0.6, // Adjust the height as needed
                child: ListView.builder(
                  itemCount: widget.project.issues.length,
                  itemBuilder: (context, index) {
                    final issue = widget.project.issues[index];
                    return Card(
                      elevation: 4,
                      margin: EdgeInsets.symmetric(vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(issue.title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                            SizedBox(height: 8),
                            Text(issue.description),
                            SizedBox(height: 8),
                            Text('Reporter: ${issue.reporter}', style: TextStyle(fontSize: 16)),
                            Text('Reported Date: ${DateFormat.yMd().format(issue.reportedDate)}', style: TextStyle(fontSize: 16)),
                            Text('Fixer: ${issue.fixer}', style: TextStyle(fontSize: 16)),
                            Text('Assignee: ${issue.assignee}', style: TextStyle(fontSize: 16)),
                            Text('Priority: ${issue.priority}', style: TextStyle(fontSize: 16, color: issue.priority == 'HIGH' ? Colors.red : Colors.orange)),
                            SizedBox(height: 8),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Icon(
                                issue.isCompleted ? Icons.check_circle : Icons.pending,
                                color: issue.isCompleted ? Colors.green : Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Project {
  final DateTime startDate;
  final List<Issue> issues;

  Project({required this.startDate, required this.issues});

  int get daysSinceStart {
    return DateTime.now().difference(startDate).inDays;
  }

  int get totalIssues {
    return issues.length;
  }

  int get completedIssues {
    return issues.where((issue) => issue.isCompleted).length;
  }

  int get remainingIssues {
    return totalIssues - completedIssues;
  }

  double get completionPercentage {
    if (totalIssues == 0) return 0;
    return (completedIssues / totalIssues) * 100;
  }

  double get issuesPerDay {
    if (daysSinceStart == 0) return double.nan;
    return totalIssues / daysSinceStart;
  }

  double get issuesPerMonth {
    final monthsSinceStart = daysSinceStart / 30.0;
    if (monthsSinceStart == 0) return double.nan;
    return totalIssues / monthsSinceStart;
  }
}

class Issue {
  final String title;
  final String description;
  final bool isCompleted;
  final String reporter;
  final DateTime reportedDate;
  final String fixer;
  final String assignee;
  final String priority;

  Issue({
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.reporter,
    required this.reportedDate,
    required this.fixer,
    required this.assignee,
    required this.priority,
  });
}
