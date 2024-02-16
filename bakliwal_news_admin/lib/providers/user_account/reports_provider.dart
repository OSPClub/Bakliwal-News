// ignore_for_file: use_build_context_synchronously

import 'package:bakliwal_news_admin/models/news_articles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:bakliwal_news_admin/providers/articles.dart';
import 'package:bakliwal_news_admin/models/report_model.dart';

class ReportsProvider with ChangeNotifier {
  List<ArticleReport> _allArticleReports = [];
  List<CommentReport> _allCommentsReports = [];

  List<ArticleReport> get allArticleReports {
    return [..._allArticleReports];
  }

  List<CommentReport> get allCommentsReports {
    return [..._allCommentsReports];
  }

  Future<void> fetchAndSetArticleReportData(BuildContext context) async {
    _allArticleReports = [];

    final reportRef =
        await FirebaseDatabase.instance.ref("reports/articles").get();
    final allReports = reportRef.value;
    List<ArticleReport> fetchedReports = [];

    // ignore: unnecessary_null_comparison
    if (allReports != null) {
      allReports as Map;
      allReports.forEach((id, report) async {
        NewsArticle? reportedArticle =
            await Provider.of<Articles>(context, listen: false)
                .fetchAndSetSpecificArticle(report['articleId']);
        fetchedReports.add(
          ArticleReport(
            reportId: id,
            userId: report['userId'],
            articleId: report['articleId'],
            usersName: report['usersName'],
            reportedTime: DateTime.parse(report['reportedTime'].toString()),
            reportedArticle: reportedArticle,
          ),
        );

        _allArticleReports = fetchedReports;
        notifyListeners();
      });
    }
  }

  Future<void> fetchAndSetCommentReportData(BuildContext context) async {
    _allCommentsReports = [];

    final reportRef =
        await FirebaseDatabase.instance.ref("reports/comments").get();
    final allReports = reportRef.value;
    List<CommentReport> fetchedReports = [];

    // ignore: unnecessary_null_comparison
    if (allReports != null) {
      allReports as Map;
      allReports.forEach((id, report) async {
        NewsArticle? reportedArticle =
            await Provider.of<Articles>(context, listen: false)
                .fetchAndSetSpecificArticle(report['articleId']);
        fetchedReports.add(
          CommentReport(
            reportId: id,
            userId: report['userId'],
            articleId: report['articleId'],
            usersName: report['usersName'],
            commentId: report['commentId'],
            writtenComment: report['writtenComment'],
            reportedTime: DateTime.parse(report['reportedTime'].toString()),
            reportedArticle: reportedArticle,
          ),
        );

        _allCommentsReports = fetchedReports;
        notifyListeners();
      });
    }
  }
}
