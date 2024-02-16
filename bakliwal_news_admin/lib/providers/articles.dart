// ignore_for_file: unnecessary_null_comparison, avoid_print
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/widgets.dart';

import 'package:bakliwal_news_admin/models/article_upvotes.dart';
import 'package:bakliwal_news_admin/models/news_articles.dart';

class Articles with ChangeNotifier {
  int _rawSizeOfArticles = 0;
  int _rawSizeOfSuggestedArticles = 0;
  int articlesPerPage = 5;
  List<NewsArticle> fetchedArticles = [];
  DocumentSnapshot? _lastDoucmentSnapShot;

  bool _gettingMoreArticles = false;
  bool _moreArticlesAvailable = true;

  List<NewsArticle> _newsArticles = [];
  List<NewsArticle> _suggestedNewsArticles = [];
  final List<NewsArticle> _specificArticle = [];

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

  List<NewsArticle> get specificArticle {
    return [..._specificArticle];
  }

  bool get gettingMoreArticles {
    return _gettingMoreArticles;
  }

  bool get moreArticlesAvailable {
    return _moreArticlesAvailable;
  }

  Future<void> fetchAndSetInitArticles() async {
    _newsArticles = [];
    // final filter = ProfanityFilter();
    CollectionReference articlesRef =
        FirebaseFirestore.instance.collection("articles");

    final snapshot = await articlesRef
        .orderBy("timestamp", descending: true)
        .limit(articlesPerPage)
        .get();
    final allArticles = snapshot.docs;
    if (allArticles.isNotEmpty) {
      _rawSizeOfArticles = allArticles.length;
      _lastDoucmentSnapShot = allArticles[_rawSizeOfArticles - 1];

      fetchedArticles = await articleConversion(allArticles);

      _newsArticles = fetchedArticles;
    }

    notifyListeners();
  }

  Future<void> fetchAndSetMoreArticles() async {
    // final filter = ProfanityFilter();
    if (_moreArticlesAvailable == false) {
      return;
    }

    if (_gettingMoreArticles == true) {
      return;
    }

    _gettingMoreArticles = true;
    notifyListeners();

    CollectionReference articlesRef =
        FirebaseFirestore.instance.collection("articles");

    final snapshot = await articlesRef
        .orderBy("timestamp", descending: true)
        .startAfter([(_lastDoucmentSnapShot!.data() as Map)["timestamp"]])
        .limit(articlesPerPage)
        .get();
    final allArticles = snapshot.docs;

    _rawSizeOfArticles = allArticles.length;
    _lastDoucmentSnapShot = allArticles[_rawSizeOfArticles - 1];
    final listofconvertedArticles = await articleConversion(allArticles);

    _newsArticles.addAll(listofconvertedArticles);
    if (_rawSizeOfArticles < articlesPerPage) {
      _moreArticlesAvailable = false;
      notifyListeners();
    }
    _gettingMoreArticles = false;
    notifyListeners();
  }

  Future<List<NewsArticle>> articleConversion(
      List<QueryDocumentSnapshot<Object?>> allArticles) async {
    List<NewsArticle> fetchedArticles = [];
    for (var rawArticle in allArticles) {
      final id = rawArticle.id;
      final article = rawArticle.data() as Map;

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
          String cleanString = comment["commentWritten"];
          fetchedComments.add(
            Comments(
              articleId: id,
              commentorUserName: commentorsData["fullName"],
              timeOfComment: DateTime.parse(comment['timeOfComment']),
              commentWritten: cleanString,
              commentorUserId: comment["commentorUserId"],
              commentorUserProfilePicture: commentorsData["profilePicture"],
              upVotes: comment['upVotes'],
              commentId: comment['commentId'],
            ),
          );
          notifyListeners();
        });
      }

      final upVotesRef =
          await FirebaseDatabase.instance.ref("upVotes/$id/").get();

      if (upVotesRef.exists) {
        final allUpVotes = upVotesRef.value as Map;
        allUpVotes.forEach((key, upvoteDate) {
          fetchedUpvotes.add(
            ArticleUpvotes(
              userUpVoted: key.toString(),
              upvotedTime: DateTime.parse(upvoteDate["dateOfUpvote"]),
            ),
          );
          notifyListeners();
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
      fetchedArticles.sort(
          (b, a) => a.publishedDate!.compareTo(b.publishedDate as DateTime));
    }

    return fetchedArticles;
  }

  Future<void> fetchAndSetSuggestedArticles() async {
    _newsArticles = [];
    final articlesRef =
        FirebaseFirestore.instance.collection("article_sugestions");

    final snapshot = await articlesRef.orderBy("timestamp").limit(30).get();
    final allArticles = snapshot.docs;

    if (allArticles != null) {
      _rawSizeOfSuggestedArticles = allArticles.length;
      List<NewsArticle> fetchedArticles = [];

      for (var rawArticle in allArticles) {
        final id = rawArticle.id;
        final article = rawArticle.data();

        final userRef = await FirebaseDatabase.instance
            .ref("users/${article["userId"]}")
            .get();
        final userInformation = userRef.value as Map;

        fetchedArticles.add(
          NewsArticle(
            articlesId: id.toString(),
            title: article["title"].toString(),
            comments: [],
            newsImageURL: article["newsImageURL"].toString(),
            discription: article["discription"].toString(),
            username: userInformation["fullName"].toString(),
            userProfilePicture: userInformation["profilePicture"].toString(),
            publishedDate: DateTime.parse(article["publishedDate"]),
            upVotes: [],
            articleViews: article["articleViews"],
            userId: article["userId"],
          ),
        );

        _suggestedNewsArticles = fetchedArticles;
        notifyListeners();
      }
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

  Future<void> removeComment(
    String articleId,
    String usersId,
    String commentId,
  ) async {
    await FirebaseDatabase.instance
        .ref()
        .child("comments/$articleId/$commentId")
        .remove()
        .onError((error, stackTrace) => print(error));

    await FirebaseDatabase.instance
        .ref()
        .child("users/$usersId/comments/$commentId")
        .remove()
        .onError((error, stackTrace) => print(error));
    int articleIndex =
        _newsArticles.indexWhere((article) => article.articlesId == articleId);
    _newsArticles[articleIndex]
        .comments!
        .removeWhere((fetchedcomment) => fetchedcomment.commentId == commentId);
    notifyListeners();
  }

  Future<NewsArticle?> fetchAndSetSpecificArticle(String articleId) async {
    Map<String, dynamic>? rawspecificArticle;
    NewsArticle fetchedSpecificArticles;
    final articlesRef =
        FirebaseFirestore.instance.collection("articles").doc(articleId);

    final snapshot = await articlesRef.get();
    rawspecificArticle = snapshot.data();
    if (rawspecificArticle != null) {
      _rawSizeOfArticles = rawspecificArticle.length;

      final id = snapshot.id;
      final article = rawspecificArticle;

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
          String cleanString = comment["commentWritten"];
          fetchedComments.add(
            Comments(
              articleId: id,
              commentorUserName: commentorsData["fullName"],
              timeOfComment: DateTime.parse(comment['timeOfComment']),
              commentWritten: cleanString,
              commentorUserId: comment["commentorUserId"],
              commentorUserProfilePicture: commentorsData["profilePicture"],
              upVotes: comment['upVotes'],
              commentId: comment['commentId'],
            ),
          );
          notifyListeners();
        });
      }

      final upVotesRef =
          await FirebaseDatabase.instance.ref("upVotes/$id/").get();

      if (upVotesRef.exists) {
        final allUpVotes = upVotesRef.value as Map;
        allUpVotes.forEach((key, upvoteDate) {
          fetchedUpvotes.add(
            ArticleUpvotes(
              userUpVoted: key.toString(),
              upvotedTime: DateTime.parse(upvoteDate["dateOfUpvote"]),
            ),
          );
          notifyListeners();
        });
      }

      fetchedSpecificArticles = NewsArticle(
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
      );

      notifyListeners();
      return fetchedSpecificArticles;
    }
    notifyListeners();
    return null;
  }
}
