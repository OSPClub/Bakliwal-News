// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/widgets.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:profanity_filter/profanity_filter.dart';

import 'package:bakliwal_news_app/models/article_upvotes.dart';
import 'package:bakliwal_news_app/models/news_article.dart';

class MostUpvoted with ChangeNotifier {
  // ignore: prefer_final_fields
  List<NewsArticle> _mostUpvoted = [];

  List<NewsArticle> get mostUpvoted {
    return [..._mostUpvoted];
  }

  Future<void> fetchAndSetmostUpvotedArticles() async {
    _mostUpvoted = [];
    final filter = ProfanityFilter();
    final articlesRef = await FirebaseDatabase.instance
        .ref("articles/")
        .orderByChild("upVotes/")
        .limitToFirst(10)
        .get();
    final allArticles = articlesRef.value as Map;
    List<NewsArticle> fetchedArticles = [];

    allArticles.forEach((id, article) async {
      final userRef = await FirebaseDatabase.instance
          .ref("users/${article["userId"]}")
          .get();
      final userInformation = userRef.value as Map;

      List<Comments> fetchedComments = [];
      List<ArticleUpvotes> fetchedUpvotes = [];

      final commentsRef =
          await FirebaseDatabase.instance.ref("comments/$id/").get();

      if (commentsRef.exists) {
      final allComments = commentsRef.value as Map;
        allComments.forEach((key, comment) async {
          final commentorsDataRef = await FirebaseDatabase.instance
              .ref("users/${comment["commentorUserId"]}/")
              .get();
          final commentorsData = commentorsDataRef.value as Map;
          String cleanString = filter.censor(comment["commentWritten"]);
          fetchedComments.indexOf(
            Comments(
              commentId: comment["commentId"],
              commentorUserName: commentorsData["fullName"],
              timeOfComment: DateTime.parse(comment['timeOfComment']),
              commentWritten: cleanString,
              commentorUserId: comment["commentorUserId"],
              commentorUserProfilePicture: commentorsData["profilePicture"],
              upVotes: comment['upVotes'],
            ),
            0,
          );
          notifyListeners();
        });
      }

      Map? articleUpvotePointer = article["upVotes"] as Map;
      if (articleUpvotePointer != null) {
        articleUpvotePointer.forEach((userId, upVoteData) {
          fetchedUpvotes.add(
            ArticleUpvotes(
              userUpVoted: userId.toString(),
              upvotedTime: DateTime.parse(upVoteData['dateOfUpvote']),
            ),
          );
        });
      }

      fetchedArticles.add(
        NewsArticle(
          articleId: id.toString(),
          title: article["title"].toString(),
          comments: fetchedComments,
          newsImageURL: article["newsImageURL"].toString(),
          discription: article["discription"].toString(),
          username: userInformation["fullName"].toString(),
          userProfilePicture: userInformation["profilePicture"].toString(),
          publishedDate: DateTime.parse(article["publishedDate"]),
          upVotes: fetchedUpvotes,
          articleViews: article["articleViews"],
        ),
      );
      _mostUpvoted = fetchedArticles;
      notifyListeners();
    });
  }
}
