import 'package:flutter/widgets.dart';

import 'package:bakliwal_news/models/news_article.dart';

class Changelogs with ChangeNotifier {
  // ignore: prefer_final_fields
  List<NewsArticle> _changelogs = [];

  List<NewsArticle> get changelogs {
    return [..._changelogs];
  }

  void addChangelogs(NewsArticle article) {
    if (_changelogs.contains(article)) {
      return;
    } else {
      _changelogs.add(article);
      notifyListeners();
    }
  }

  void removeChangelogs(NewsArticle article, Function reload) {
    if (_changelogs.contains(article)) {
      _changelogs.remove(article);
      reload();
      notifyListeners();
    } else {
      return;
    }
  }
}
