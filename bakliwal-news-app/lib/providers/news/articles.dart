// ignore_for_file: unnecessary_null_comparison, avoid_print
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/widgets.dart';

import 'package:bakliwal_news_app/package_service/locator_service.dart';
import 'package:bakliwal_news_app/repository/auth_repo.dart';
import 'package:bakliwal_news_app/models/user_information.dart';
import 'package:bakliwal_news_app/models/article_upvotes.dart';
import 'package:bakliwal_news_app/models/news_article.dart';

class Articles with ChangeNotifier {
  int _rawSizeOfArticles = 0;
  List<NewsArticle> _newsArticles = [];

  int get rawSizeOfArticles {
    return _rawSizeOfArticles;
  }

  List<NewsArticle> get newsArticles {
    return [..._newsArticles];
  }

  Future<void> fetchAndSetArticles() async {
    _newsArticles = [];
    // final filter = ProfanityFilter();
    final articlesRef =
        await FirebaseDatabase.instance.ref("articles/").limitToLast(30).get();
    final allArticles = articlesRef.value as Map;
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

      final articleUpvotePointer = article["upVotes"];
      if (articleUpvotePointer != null) {
        articleUpvotePointer as Map;
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
      fetchedArticles.sort(
          (b, a) => a.publishedDate!.compareTo(b.publishedDate as DateTime));
      _newsArticles = fetchedArticles;
    });
    notifyListeners();
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
}
