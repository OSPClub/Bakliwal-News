// ignore_for_file: use_build_context_synchronously

import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'package:bakliwal_news/models/all_read_articles.dart';
import 'package:bakliwal_news/package_service/locator_service.dart';
import 'package:bakliwal_news/providers/user_account/user_account.dart';
import 'package:bakliwal_news/repository/auth_repo.dart';

class ReadingHistory with ChangeNotifier {
  // ignore: prefer_final_fields
  List<AllReadArticles> _readingHistory = [];

  List<AllReadArticles> get readingHistory {
    return [..._readingHistory];
  }

  Future<void> fetchAndSetReadingHistory(BuildContext context) async {
    await locator.get<AuthRepo>().fetchAndSetUser();
    final readingHistoryRef = Provider.of<UserAccount>(
      context,
      listen: false,
    ).personalInformation.articlesRead!;
    _readingHistory = readingHistoryRef;
    notifyListeners();
  }
}
