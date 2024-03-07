// ignore_for_file: use_build_context_synchronously, unnecessary_null_comparison
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:bakliwal_news/providers/news/user_articles.dart';
import 'package:bakliwal_news/providers/user_account/user_account.dart';
import 'package:bakliwal_news/models/user_article.dart';

class UserBookmarks with ChangeNotifier {
  // ignore: prefer_final_fields
  List<UserArticle> _bookmarks = [];

  List<UserArticle> get bookmarks {
    return [..._bookmarks];
  }

  Future<void> fetchAndSetBookmarks(BuildContext ctx) async {
    _bookmarks = [];
    List<UserArticle> fetchedbookmarks = [];
    String? userId =
        Provider.of<UserAccount>(ctx, listen: false).personalInformation.userId;

    List<UserArticle> allArticles =
        Provider.of<UserArticles>(ctx, listen: false).newsArticles;
    if (userId != "default") {
      final bookmarkRef = await FirebaseDatabase.instance
          .ref()
          .child("users/$userId/bookmarks/")
          .get();

      final allBookmarks = bookmarkRef.value;
      if (allBookmarks != null) {
        allBookmarks as Map;
        allBookmarks.forEach((articleId, bookmarkData) {
          UserArticle newsArticle = allArticles
              .firstWhere((article) => article.articleId == articleId);
          fetchedbookmarks.add(
            UserArticle(
              articleId: newsArticle.articleId,
              title: newsArticle.title,
              comments: newsArticle.comments,
              newsImageURL: newsArticle.newsImageURL,
              discription: newsArticle.discription,
              username: newsArticle.username,
              userProfilePicture: newsArticle.userProfilePicture,
              publishedDate: newsArticle.publishedDate,
              upVotes: newsArticle.upVotes,
              articleViews: newsArticle.articleViews,
              isBookmarked: false,
            ),
          );

          _bookmarks = fetchedbookmarks;
          notifyListeners();
        });
      }
    }
  }

  Future<void> addBookmark(
    String articleId,
    BuildContext ctx,
  ) async {
    String? userId =
        Provider.of<UserAccount>(ctx, listen: false).personalInformation.userId;
    if (userId != "default") {
      await FirebaseDatabase.instance
          .ref()
          .child("users/$userId/bookmarks/$articleId")
          .set({
        "bookmarkedDateTime": DateTime.now().toString(),
      });
      fetchAndSetBookmarks(ctx);
    }
    notifyListeners();
  }

  Future<void> removeBookmark(
    UserArticle article,
    BuildContext ctx,
  ) async {
    String? userId =
        Provider.of<UserAccount>(ctx, listen: false).personalInformation.userId;
    if (userId != "default") {
      await FirebaseDatabase.instance
          .ref()
          .child("users/$userId/bookmarks/${article.articleId}")
          .remove();
      fetchAndSetBookmarks(ctx);
      notifyListeners();
    } else {
      return;
    }
  }
}
