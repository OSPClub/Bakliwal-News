import 'package:flutter/widgets.dart';

import 'package:bakliwal_news/models/user_article.dart';

class Changelogs with ChangeNotifier {
  // ignore: prefer_final_fields
  List<UserArticle> _changelogs = [];

  List<UserArticle> get changelogs {
    return [..._changelogs];
  }

  void addChangelogs(UserArticle article) {
    if (_changelogs.contains(article)) {
      return;
    } else {
      _changelogs.add(article);
      notifyListeners();
    }
  }

  void removeChangelogs(UserArticle article, Function reload) {
    if (_changelogs.contains(article)) {
      _changelogs.remove(article);
      reload();
      notifyListeners();
    } else {
      return;
    }
  }
}
