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

class Issue {
  final int issueId;
  final String title;
  final Reporter reporter;
  final String reportedDate;
  final String? fixer;
  final String? assignee;
  final String priority;
  final String status;
  final List<Comment> comments;

  Issue({
    required this.issueId,
    required this.title,
    required this.reporter,
    required this.reportedDate,
    required this.fixer,
    required this.assignee,
    required this.priority,
    required this.status,
    required this.comments,
  });

  factory Issue.fromJson(Map<String, dynamic> json) {
    var commentsFromJson = json['comments'] as List? ?? [];
    List<Comment> commentsList = commentsFromJson.isNotEmpty
        ? commentsFromJson.map((comment) => Comment.fromJson(comment)).toList()
        : [
            Comment(
              id: 99999,
              content: 'No comments available',
              commenter: User(
                id:  999999,
                username:  '?',
                password: '?',
              ),
              commentedDate: '',
              isDescription: false,
            )
          ];

    return Issue(
      issueId: json['id'] ?? 0,
      title: json['title'] ?? '',
      reporter: Reporter.fromJson(json['reporter'] ?? {}),
      reportedDate: json['reportedDate'] ?? '',
      fixer: json['fixer'],
      assignee: json['assignee'] ?? 'a',
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

class Comment {
  final int id;
  final String content;
  final User commenter;
  final String? commentedDate;
  final bool isDescription;

  Comment({
    required this.id,
    required this.content,
    required this.commenter,
    required this.commentedDate,
    required this.isDescription,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'] ?? 0,
      content: json['content'] ?? '',
      commenter: User.fromJson(json['commenter'] ?? {}),
      commentedDate: json['commentedDate'],
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

class User {
  final int id;
  final String username;
  final String password;

  User({
    required this.id,
    required this.username,
    required this.password,
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

class Reporter {
  final int id;
  final String username;
  final String password;

  Reporter({
    required this.id,
    required this.username,
    required this.password,
  });

  factory Reporter.fromJson(Map<String, dynamic> json) {
    return Reporter(
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
