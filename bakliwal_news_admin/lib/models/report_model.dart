import 'package:bakliwal_news_admin/models/news_articles.dart';

class ArticleReport {
  final String reportId;
  final String userId;
  final String articleId;
  final String usersName;
  final DateTime reportedTime;
  NewsArticle? reportedArticle;

  ArticleReport({
    required this.reportId,
    required this.userId,
    required this.articleId,
    required this.usersName,
    required this.reportedTime,
    required this.reportedArticle,
  });
}

class CommentReport {
  final String reportId;
  final String userId;
  final String articleId;
  final String commentId;
  final String usersName;
  final String writtenComment;
  final DateTime reportedTime;
  NewsArticle? reportedArticle;

  CommentReport({
    required this.reportId,
    required this.userId,
    required this.articleId,
    required this.commentId,
    required this.usersName,
    required this.writtenComment,
    required this.reportedTime,
    required this.reportedArticle,
  });
}
