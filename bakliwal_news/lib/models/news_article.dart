import 'package:bakliwal_news/models/article_upvotes.dart';

class Comments {
  final String commentId;
  final DateTime? timeOfComment;
  final String? commentWritten;
  final String? commentorUserName;
  final String? commentorUserProfilePicture;
  final String? commentorUserId;
  final String? upVotes;
  final String? articleId;
  Comments({
    required this.commentId,
    required this.timeOfComment,
    required this.commentWritten,
    required this.commentorUserName,
    required this.commentorUserId,
    required this.upVotes,
    this.commentorUserProfilePicture,
    this.articleId,
  });
}

class NewsArticle {
  final String articleId;
  final String? title;
  final String? newsImageURL;
  final String? discription;
  final String? username;
  final String? userProfilePicture;
  final DateTime? publishedDate;
  final List<Comments>? comments;
  final List<ArticleUpvotes>? upVotes;
  final int? articleViews;
  bool? isBookmarked;

  NewsArticle({
    required this.articleId,
    required this.title,
    required this.comments,
    required this.newsImageURL,
    required this.discription,
    required this.username,
    required this.userProfilePicture,
    required this.publishedDate,
    required this.upVotes,
    required this.articleViews,
    this.isBookmarked = false,
  });
}
