// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:bakliwal_news_admin/providers/articles.dart';
import 'package:bakliwal_news_admin/models/report_model.dart';

class ReportsProvider with ChangeNotifier {
  List<Report> _allReports = [];

  List<Report> get allReports {
    return [..._allReports];
  }

  Future<void> fetchAndSetReportData(BuildContext context) async {
    _allReports = [];

    final reportRef =
        await FirebaseDatabase.instance.ref("reports/articles").get();
    final allReports = reportRef.value;
    List<Report> fetchedReports = [];

    // ignore: unnecessary_null_comparison
    if (allReports != null) {
      allReports as Map;
      allReports.forEach((id, report) async {
        fetchedReports.add(
          Report(
            reportId: id,
            userId: report['userId'],
            articleId: report['articleId'],
            usersName: report['usersName'],
            reportedTime: DateTime.parse(report['reportedTime'].toString()),
            reportedArticle: Provider.of<Articles>(context, listen: false)
                .newsArticles
                .firstWhere(
                  (article) => article.articlesId == report['articleId'],
                ),
          ),
        );

        _allReports = fetchedReports;
        notifyListeners();
      });
    }
  }
}
