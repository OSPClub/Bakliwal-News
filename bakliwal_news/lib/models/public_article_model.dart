class PublicUser {
  final String? userId;
  final String? name;
  final String? username;
  final String? twitterUsername;
  final String? githubUsername;
  final String? websiteUrl;
  final String? profileImage;
  final String? profileImage90;

  PublicUser({
    required this.userId,
    required this.name,
    required this.username,
    required this.twitterUsername,
    required this.githubUsername,
    required this.websiteUrl,
    required this.profileImage,
    required this.profileImage90,
  });

  factory PublicUser.fromJson(Map<String, dynamic> json) {
    return PublicUser(
      userId: json['user_id'].toString(),
      name: json['name'].toString(),
      username: json['username'].toString(),
      twitterUsername: json['twitter_username'].toString(),
      githubUsername: json['github_username'].toString(),
      websiteUrl: json['website_url'].toString(),
      profileImage: json['profile_image'].toString(),
      profileImage90: json['profile_image_90'].toString(),
    );
  }
}

class PublicComments {
  final String commentId;
  final String commentBody;
  final DateTime createdAt;
  final PublicUser user;
  final List<PublicComments> children;

  PublicComments({
    required this.commentId,
    required this.commentBody,
    required this.createdAt,
    required this.user,
    required this.children,
  });

  factory PublicComments.fromJson(Map<String, dynamic> json) {
    List<PublicComments> sortComments(List childerenData) {
      List<PublicComments> comments = [];
      for (var element in childerenData) {
        comments.add(
          PublicComments(
            commentId: element['id_code'].toString(),
            commentBody: element['body_html'].toString(),
            createdAt: DateTime.parse(element['created_at'].toString()),
            user: PublicUser.fromJson(element['user']),
            children: sortComments(element['children']),
          ),
        );
      }
      return comments;
    }

    return PublicComments(
      commentId: json['id_code'].toString(),
      commentBody: json['body_html'].toString(),
      createdAt: DateTime.parse(json['created_at'].toString()),
      user: PublicUser.fromJson(json['user']),
      children: sortComments(json['children']),
    );
  }
}

class PublicArticle {
  final String articleId;
  final String? title;
  final String? newsImageURL;
  final String? description;
  final DateTime? publishedDate;
  final String? tags;
  final String articleUrl;
  final String readTime;
  final int commentsCount;
  final int publicReactionsCount;
  final PublicUser user;

  PublicArticle({
    required this.articleId,
    required this.title,
    required this.newsImageURL,
    required this.description,
    required this.publishedDate,
    this.tags,
    required this.articleUrl,
    required this.readTime,
    required this.commentsCount,
    required this.publicReactionsCount,
    required this.user,
  });

  factory PublicArticle.fromJson(Map<String, dynamic> json) {
    return PublicArticle(
      articleId: json['id'].toString(),
      title: json['title'].toString(),
      newsImageURL: json['social_image'].toString(),
      description: json['body_markdown'].toString(),
      user: PublicUser.fromJson(json['user']),
      publishedDate: DateTime.parse(json['published_at']),
      tags: json['tag_list'].toString(),
      articleUrl: json['canonical_url'].toString(),
      readTime: json['reading_time_minutes'].toString(),
      commentsCount: json['comments_count'] as int,
      publicReactionsCount: json['public_reactions_count'] as int,
    );
  }
}

class PublicArticleCanonicalModel {
  final String articleId;
  final String? title;
  final String? description;
  final String? url;
  final int? commentsCount;
  final int? publicReactionsCount;
  final DateTime? publishedTimestamp;
  final String? coverImage;
  final String? readingTimeMinutes;
  final List? tags;
  final String? bodyHtml;
  final PublicUser user;
  final List<PublicComments> comments;

  PublicArticleCanonicalModel({
    required this.articleId,
    required this.title,
    required this.description,
    required this.url,
    required this.commentsCount,
    required this.publicReactionsCount,
    required this.publishedTimestamp,
    required this.coverImage,
    required this.readingTimeMinutes,
    required this.tags,
    required this.bodyHtml,
    required this.user,
    required this.comments,
  });

  factory PublicArticleCanonicalModel.fromJson(
      Map<String, dynamic> json, List<PublicComments> comments) {
    List tags = [];
    tags = json['tag_list'].toString().split(',');
    return PublicArticleCanonicalModel(
      articleId: json['id'].toString(),
      title: json['title'].toString(),
      description: json['body_markdown'].toString(),
      url: json['url'].toString(),
      commentsCount: json['comments_count'] as int,
      publicReactionsCount: json['public_reactions_count'] as int,
      publishedTimestamp: DateTime.parse(json['published_timestamp']),
      coverImage: json['cover_image'].toString(),
      readingTimeMinutes: json['reading_time_minutes'].toString(),
      tags: tags,
      bodyHtml: json['body_html'],
      user: PublicUser.fromJson(json['user']),
      comments: comments,
    );
  }
}

class ArticleTags {
  final String id;
  final String name;
  final String? bgColorHex;
  final String? textColorHex;

  ArticleTags({
    required this.id,
    required this.name,
    required this.bgColorHex,
    required this.textColorHex,
  });

  factory ArticleTags.fromJson(Map<String, dynamic> json) {
    return ArticleTags(
      id: json['id'].toString(),
      name: json['name'].toString(),
      bgColorHex: json['bg_color_hex'].toString(),
      textColorHex: json['text_color_hex'].toString(),
    );
  }
}

class Filter {
  String label;
  bool isSelected;
  Filter({
    required this.label,
    required this.isSelected,
  });
}
