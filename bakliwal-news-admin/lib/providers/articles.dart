// ignore_for_file: unnecessary_null_comparison, avoid_print
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/widgets.dart';
import 'package:profanity_filter/profanity_filter.dart';

import 'package:bakliwal_news_admin/models/article_upvotes.dart';
import 'package:bakliwal_news_admin/models/news_articles.dart';

class Articles with ChangeNotifier {
  int _rawSizeOfArticles = 0;
  int _rawSizeOfSuggestedArticles = 0;

  List<NewsArticle> _newsArticles = [];
  List<NewsArticle> _suggestedNewsArticles = [];

  int get rawSizeOfArticles {
    return _rawSizeOfArticles;
  }

  int get rawSizeOfSuggestedArticles {
    return _rawSizeOfSuggestedArticles;
  }

  List<NewsArticle> get newsArticles {
    return [..._newsArticles];
  }

  List<NewsArticle> get suggestedNewsArticles {
    return [..._suggestedNewsArticles];
  }

  Future<void> fetchAndSetArticles() async {
    _newsArticles = [];
    // final filter = ProfanityFilter();
    final articlesRef = await FirebaseDatabase.instance.ref("articles/").get();
    final allArticles = articlesRef.value;
    if (allArticles != null) {
      allArticles as Map;
      _rawSizeOfArticles = allArticles.length;
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
        final allComments = commentsRef.value;

        if (commentsRef.exists) {
          allComments as Map;
          allComments.forEach((key, comment) async {
            final commentorsDataRef = await FirebaseDatabase.instance
                .ref("users/${comment["commentorUserId"]}/")
                .get();
            final commentorsData = commentorsDataRef.value as Map;
            // String cleanString = filter.censor(comment["commentWritten"]);
            fetchedComments.add(
              Comments(
                commentorUserName: commentorsData["fullName"],
                timeOfComment: DateTime.parse(comment['timeOfComment']),
                commentWritten: comment["commentWritten"],
                commentorUserId: comment["commentorUserId"],
                commentorUserProfilePicture: commentorsData["profilePicture"],
                upVotes: comment['upVotes'],
              ),
            );
            notifyListeners();
          });
        }

        Map? articleUpvotePointer = article["upVotes"];
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
            articlesId: id.toString(),
            title: article["title"].toString(),
            comments: fetchedComments,
            newsImageURL: article["newsImageURL"].toString(),
            discription: article["discription"].toString(),
            username: userInformation["fullName"].toString(),
            userProfilePicture: userInformation["profilePicture"].toString(),
            publishedDate: DateTime.parse(article["publishedDate"]),
            upVotes: fetchedUpvotes,
            articleViews: article["articleViews"],
            userId: article["userId"],
          ),
        );

        _newsArticles = fetchedArticles;
        notifyListeners();
      });
    }
  }

  Future<void> fetchAndSetSuggestedArticles() async {
    _newsArticles = [];
    final filter = ProfanityFilter();
    final articlesRef =
        await FirebaseDatabase.instance.ref("article_sugestions/").get();
    final allArticles = articlesRef.value;
    if (allArticles != null) {
      allArticles as Map;
      _rawSizeOfSuggestedArticles = allArticles.length;
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
        final allComments = commentsRef.value;

        if (commentsRef.exists) {
          allComments as Map;
          allComments.forEach((key, comment) async {
            final commentorsDataRef = await FirebaseDatabase.instance
                .ref("users/${comment["commentorUserId"]}/")
                .get();
            final commentorsData = commentorsDataRef.value as Map;
            String cleanString = filter.censor(comment["commentWritten"]);
            fetchedComments.add(
              Comments(
                commentorUserName: commentorsData["fullName"],
                timeOfComment: DateTime.parse(comment['timeOfComment']),
                commentWritten: cleanString,
                commentorUserId: comment["commentorUserId"],
                commentorUserProfilePicture: commentorsData["profilePicture"],
                upVotes: comment['upVotes'],
              ),
            );
            notifyListeners();
          });
        }

        Map? articleUpvotePointer = article["upVotes"];
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
            articlesId: id.toString(),
            title: article["title"].toString(),
            comments: fetchedComments,
            newsImageURL: article["newsImageURL"].toString(),
            discription: article["discription"].toString(),
            username: userInformation["fullName"].toString(),
            userProfilePicture: userInformation["profilePicture"].toString(),
            publishedDate: DateTime.parse(article["publishedDate"]),
            upVotes: fetchedUpvotes,
            articleViews: article["articleViews"],
            userId: article["userId"],
          ),
        );

        _suggestedNewsArticles = fetchedArticles;
        notifyListeners();
      });
    }
  }

  Future<void> updateArticles(NewsArticle newsArticle) async {
    final articleIndex = _newsArticles
        .indexWhere((article) => article.articlesId == newsArticle.articlesId);

    _newsArticles[articleIndex] = newsArticle;
    print(newsArticle.title);
    notifyListeners();
  }

  Future<void> updateSuggestedArticles(NewsArticle newsArticle) async {
    final articleIndex = _suggestedNewsArticles
        .indexWhere((article) => article.articlesId == newsArticle.articlesId);

    _suggestedNewsArticles[articleIndex] = newsArticle;
    notifyListeners();
  }
}
