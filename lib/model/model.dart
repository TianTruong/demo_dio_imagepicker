class Post {
  final int userId;
  final int id;
  final String title;
  final String body;

  const Post({
    required this.userId,
    required this.id,
    required this.title,
    required this.body,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
        userId: json['userId'],
        id: json['id'],
        title: json['title'],
        body: json['body']);
  }

  Map<String, dynamic> toJson() =>
      {'userId': userId, 'id': id, 'title': title, 'body': body};

  static List<Post> listFromJson(List<dynamic> list) =>
      List<Post>.from(list.map((e) => Post.fromJson(e)));
}

// Dùng để update
class PostInfo {
  String title;
  String body;
  int? id;

  PostInfo({
    required this.title,
    required this.body,
    this.id,
  });

  factory PostInfo.fromJson(Map<String, dynamic> json) {
    return PostInfo(
      title: json['title'],
      body: json['body'],
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'body': body,
        'id': id,
      };
}
