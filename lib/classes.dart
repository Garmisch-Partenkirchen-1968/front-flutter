class Project {
  final int id;
  final String name;
  final String description;

  Project({required this.id, required this.name, required this.description});

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'],
      name: json['name'],
      description: json['description'],
    );
  }
}
class Issue {
  final int issueId;
  final String title;
  final String reporter;
  final String reportedDate; // 날짜 형식이 명확해지면 DateTime으로 변경 가능
  final String fixer;
  final String assignee;
  final String priority;
  final String status;

  Issue({
    required this.issueId,
    required this.title,
    required this.reporter,
    required this.reportedDate,
    required this.fixer,
    required this.assignee,
    required this.priority,
    required this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      'issueId': this.issueId,
      'title': this.title,
      'reporter': this.reporter,
      'reportedDate': this.reportedDate,
      'fixer': this.fixer,
      'assignee': this.assignee,
      'priority': this.priority,
      'status': this.status,
    };
  }
  factory Issue.fromJson(Map<String, dynamic> json) {
    return Issue(
      issueId: json['id'] as int,
      title: json['title'] as String,
      reporter: json['reporter']['username'] as String,
      reportedDate: json['reportedDate'] as String,
      fixer: json['fixer'] as String? ?? '',
      assignee: json['assignee'] as String? ?? '',
      priority: json['priority'] as String,
      status: json['status'] as String,
    );
  }
}
