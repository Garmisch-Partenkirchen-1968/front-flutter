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

  factory Issue.fromJson(Map<String, dynamic> json) {
    return Issue(
      issueId: json['issueId'],
      title: json['title'],
      reporter: json['reporter'],
      reportedDate: json['reportedDate'] ?? "", // JSON에 값이 없는 경우 빈 문자열로 처리
      fixer: json['fixer'] ?? "", // 값이 없는 경우 빈 문자열로 처리
      assignee: json['assignee'],
      priority: json['prioriry'], // 오타가 있으니 주의 ('priority'가 맞는 표기)
      status: json['status'],
    );
  }
}
