class Project {
  final int id;
  final String name;
  final String description;
  final List<int> members;

  Project({
    required this.id,
    required this.name,
    required this.description,
    required this.members,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      members: json['members'] != null ? List<int>.from(json['members']) : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'members': members,
    };
  }
}

class User {
  final int id;
  final String username;
  final String password;

  const User({
    this.id = 0,
    this.username = '',
    this.password = '',
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      username: json['username'] ?? '',
      password: json['password'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'password': password,
    };
  }
}

class Comment {
  final int id;
  final String content;
  final User commenter;
  final String commentedDate;
  final bool isDescription;

  Comment({
    this.id = 0,
    this.content = '',
    User? commenter,
    this.commentedDate = '',
    this.isDescription = false,
  }) : this.commenter = commenter ?? User(); // 기본값 설정

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'] ?? 0,
      content: json['content'] ?? '',
      commenter: User.fromJson(json['commenter'] ?? {}),
      commentedDate: json['commentedDate'] ?? '',
      isDescription: json['isDescription'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'commenter': commenter.toJson(),
      'commentedDate': commentedDate,
      'isDescription': isDescription,
    };
  }
}

class Issue {
  final int issueId;
  final String title;
  final User reporter;
  final String reportedDate;
  final String? fixer;
  final String? assignee;
  final String priority;
  final String status;
  final List<Comment> comments;

  Issue({
    this.issueId = 0,
    this.title = '',
    User? reporter,
    this.reportedDate = '',
    this.fixer,
    this.assignee,
    this.priority = '',
    this.status = '',
    List<Comment>? comments,
  })  : this.reporter = reporter ?? User(), // 기본값 설정
        this.comments = comments ?? []; // 기본값 설정

  factory Issue.fromJson(Map<String, dynamic> json) {
    var commentsFromJson = json['comments'] as List? ?? [];
    List<Comment> commentsList = commentsFromJson.isNotEmpty
        ? commentsFromJson.map((comment) => Comment.fromJson(comment)).toList()
        : [
      Comment(
        id: 99999,
        content: 'No comments available',
        commenter: User(
          id: 999999,
          username: '?',
          password: '?',
        ),
        commentedDate: '',
        isDescription: false,
      )
    ];

    return Issue(
      issueId: json['id'] ?? 0,
      title: json['title'] ?? '',
      reporter: User.fromJson(json['reporter'] ?? {}),
      reportedDate: json['reportedDate'] ?? '',
      fixer: json['fixer'],
      assignee: json['assignee'],
      priority: json['priority'] ?? '',
      status: json['status'] ?? '',
      comments: commentsList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': issueId,
      'title': title,
      'reporter': reporter.toJson(),
      'reportedDate': reportedDate,
      'fixer': fixer,
      'assignee': assignee,
      'priority': priority,
      'status': status,
      'comments': comments.map((comment) => comment.toJson()).toList(),
    };
  }
}
