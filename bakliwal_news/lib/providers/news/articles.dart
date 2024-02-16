// ignore_for_file: unnecessary_null_comparison, use_build_context_synchronously, avoid_print
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/widgets.dart';

import 'package:bakliwal_news/package_service/locator_service.dart';
import 'package:bakliwal_news/repository/auth_repo.dart';
import 'package:bakliwal_news/models/user_information.dart';
import 'package:bakliwal_news/models/article_upvotes.dart';
import 'package:bakliwal_news/models/news_article.dart';

class Articles with ChangeNotifier {
  int _rawSizeOfArticles = 0;
  List<NewsArticle> _newsArticles = [];
  int articlesPerPage = 5;
  List<NewsArticle> fetchedArticles = [];
  DocumentSnapshot? _lastDoucmentSnapShot;

  bool _gettingMoreArticles = false;
  bool _moreArticlesAvailable = true;

  int get rawSizeOfArticles {
    return _rawSizeOfArticles;
  }

  List<NewsArticle> get newsArticles {
    return [..._newsArticles];
  }

  bool get gettingMoreArticles {
    return _gettingMoreArticles;
  }

  bool get moreArticlesAvailable {
    return _moreArticlesAvailable;
  }

  void setFetchLogicToDefault() {
    _gettingMoreArticles = false;
    _moreArticlesAvailable = true;
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

    _rawSizeOfArticles = allArticles.length;
    _lastDoucmentSnapShot = allArticles[_rawSizeOfArticles - 1];

    fetchedArticles = await articleConversion(allArticles);

    _newsArticles = fetchedArticles;

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
              commentId: key,
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
      fetchedArticles.sort(
          (b, a) => a.publishedDate!.compareTo(b.publishedDate as DateTime));
    }

    return fetchedArticles;
  }

  Future<void> addComment(
    String articleId,
    UserInformation user,
    Comments comment,
  ) async {
    final commentSetRef =
        FirebaseDatabase.instance.ref().child("comments/$articleId/").push();
    final commentSetUniqueKey = commentSetRef.key;
    await commentSetRef.set({
      "commentWritten": comment.commentWritten,
      "timeOfComment": comment.timeOfComment.toString(),
      "commentorUserId": comment.commentorUserId,
      "commentId": commentSetUniqueKey.toString(),
    });
    await FirebaseDatabase.instance
        .ref()
        .child("users/${comment.commentorUserId}/comments/$commentSetUniqueKey")
        .set({
      "articleId": articleId,
      "commentId": commentSetUniqueKey,
    });

    comment = Comments(
      commentId: commentSetUniqueKey.toString(),
      timeOfComment: comment.timeOfComment,
      commentWritten: comment.commentWritten,
      commentorUserName: user.fullName,
      commentorUserId: comment.commentorUserId,
      upVotes: "",
      articleId: articleId,
      commentorUserProfilePicture: user.profilePicture,
    );
    int articleIndex =
        _newsArticles.indexWhere((article) => article.articleId == articleId);
    _newsArticles[articleIndex].comments!.insert(0, comment);
    notifyListeners();
  }

  Future<void> removeComment(
    String articleId,
    UserInformation user,
    Comments comment,
  ) async {
    await FirebaseDatabase.instance
        .ref()
        .child("comments/$articleId/${comment.commentId}")
        .remove()
        .onError((error, stackTrace) => print(error));

    await FirebaseDatabase.instance
        .ref()
        .child("users/${user.userId}/comments/${comment.commentId}")
        .remove()
        .onError((error, stackTrace) => print(error));
    int articleIndex =
        _newsArticles.indexWhere((article) => article.articleId == articleId);
    _newsArticles[articleIndex].comments!.removeWhere(
        (fetchedcomment) => fetchedcomment.commentId == comment.commentId);
    notifyListeners();
  }

  Future<void> setReadArticle(
    UserInformation userInformation,
    NewsArticle newsArticle,
    int readFunctionFired,
    BuildContext context,
  ) async {
    if (readFunctionFired == 0) {
      DataSnapshot data = await FirebaseDatabase.instance
          .ref()
          .child(
              "users/${userInformation.userId}/articlesRead/${newsArticle.articleId}")
          .get();
      if (!data.exists) {
        FirebaseDatabase.instance
            .ref()
            .child(
                "users/${userInformation.userId}/articlesRead/${newsArticle.articleId}")
            .set({
          "profilePictureUrlOfPublisher": newsArticle.userProfilePicture,
          "userNameOfPublisher": newsArticle.username,
          "titleOfArticle": newsArticle.title,
          "articleReadDateTime": DateTime.now().toString(),
          "articlespublishedDate": newsArticle.publishedDate.toString(),
          "articleImageUrl": newsArticle.newsImageURL,
          "idOfArticle": newsArticle.articleId,
        });
        locator.get<AuthRepo>().fetchAndSetUser(context: context);
      }
    }
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
      );

      notifyListeners();
      return fetchedSpecificArticles;
    }
    notifyListeners();
    return null;
  }
}
