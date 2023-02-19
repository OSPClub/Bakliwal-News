import 'package:bakliwal_news_admin/models/news_articles.dart';

class Report {
  final String reportId;
  final String userId;
  final String articleId;
  final String usersName;
  final DateTime reportedTime;
  NewsArticle? reportedArticle;

  Report({
    required this.reportId,
    required this.userId,
    required this.articleId,
    required this.usersName,
    required this.reportedTime,
    required this.reportedArticle,
  });
}
