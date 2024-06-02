import 'dart:math';

import 'package:intl/intl.dart';

class Project {
  final int id;
  final String name;
  final String description;
  final List<Member> members;

  Project({
    this.id = 0,
    this.name = '',
    this.description = '',
    this.members = const [],
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    List<Member> membersList = [];
    if (json['members'] != null) {
      json['members'].forEach((key, value) {
        membersList.add(Member.fromJson({
          'id': key.split('=')[1].split(', ')[0],
          'username': key.split('=')[2].split(', ')[0],
          'password': key.split('=')[3].split(')')[0],
          'role': value,
        }));
      });
    }

    return Project(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      members: membersList,
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, int> membersJson = {};
    for (var member in members) {
      membersJson['User(id=${member.id}, username=${member.username}, password=${member.password})'] = member.role;
    }

    return {
      'id': id,
      'name': name,
      'description': description,
      'members': membersJson,
    };
  }
}

class Member {
  final int id;
  final String username;
  final String password;
  final int role;

  Member({
    this.id = 0,
    this.username = '',
    this.password = '',
    this.role = 0,
  });

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      id: json['id'] != null ? int.parse(json['id']) : 0,
      username: json['username'] ?? '',
      password: json['password'] ?? '',
      role: json['role'] ?? 0,
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'password': password,
      'role': role,
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
  final User fixer;
  final User assignee;
  final String priority;
  final String status;
  final List<Comment> comments;

  Issue({
    this.issueId = 0,
    this.title = '',
    User? reporter,
    this.reportedDate = '',
    User? fixer,
    User? assignee,
    this.priority = '',
    this.status = '',
    List<Comment>? comments,
  })  : this.reporter = reporter ?? User(),
        this.fixer = fixer ?? User(),
        this.assignee = assignee ?? User(),
        this.comments = comments ?? [];

  factory Issue.fromJson(Map<String, dynamic> json) {
    var commentsFromJson = json['comments'] as List? ?? [];
    List<Comment> commentsList = commentsFromJson.isNotEmpty
        ? commentsFromJson.map((comment) => Comment.fromJson(comment)).toList()
        : [
      Comment(
        id: 999999,
        content: 'No comments available',
        commenter: User(
          id: 999999,
          username: '?',
          password: '?',
        ),
        commentedDate: DateFormat('yyyy-MM-dd').format(generateRandomDate()),
        isDescription: false,
      )
    ];

    return Issue(
      issueId: json['id'] ?? 0,
      title: json['title'] ?? '',
      reporter: User.fromJson(json['reporter'] ?? {}),
      reportedDate: json['reportedDate'] ?? '',
      fixer: User.fromJson(json['fixer'] ?? {}),
      assignee: User.fromJson(json['assignee'] ?? {}),
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
      'fixer': fixer.toJson(),
      'assignee': assignee.toJson(),
      'priority': priority,
      'status': status,
      'comments': comments.map((comment) => comment.toJson()).toList(),
    };
  }
}
class IssueStatistics {
  final String status;
  final int count;

  IssueStatistics(this.status, this.count);
}


DateTime generateRandomDate() {
  final random = Random();
  final now = DateTime.now();
  final int randomDays = random.nextInt(365); // 0부터 364까지의 랜덤한 일 수
  final generatedDate = now.subtract(Duration(days: randomDays));


    DateTime randomDate;
    return randomDate = generatedDate;

}
class RecommendDeveloper {
  final String username;
  final String priority;
  final int numberOfFixed;

  RecommendDeveloper({
    required this.username,
    required this.priority,
    required this.numberOfFixed,
  });

  factory RecommendDeveloper.fromJson(Map<String, dynamic> json) {
    return RecommendDeveloper(
      username: json['username'] ?? '',
      priority: json['priority'] ?? '',
      numberOfFixed: json['numberOfFixed'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'priority': priority,
      'numberOfFixed': numberOfFixed,
    };
  }
}
