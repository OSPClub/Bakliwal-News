import 'package:bakliwal_news/models/all_read_articles.dart';
import 'package:bakliwal_news/models/bookmarks.dart';
import 'package:bakliwal_news/models/user_article.dart';

class UserInformation {
  String? userId;
  bool? isBlocked;
  String? userName;
  String? fullName;
  String? emailId;
  DateTime? joined;
  String? profilePicture;
  String? biography;
  String? companyName;
  String? jobTitle;
  String? githubUsername;
  String? linkedin;
  String? twitter;
  String? instagram;
  String? facebook;
  String? websiteURL;
  Map? allPublishedArticles;
  List<AllReadArticles>? articlesRead;
  List<Comments>? allPostedComments;
  List<Bookmarks>? allBookmarkedArticles;
  List<String>? blockedUsers;

  UserInformation({
    required this.userId,
    required this.isBlocked,
    required this.userName,
    required this.emailId,
    required this.fullName,
    required this.joined,
    this.profilePicture,
    this.biography,
    this.companyName,
    this.jobTitle,
    this.githubUsername,
    this.linkedin,
    this.twitter,
    this.instagram,
    this.facebook,
    this.websiteURL,
    this.articlesRead,
    this.allPublishedArticles,
    this.allPostedComments,
    this.allBookmarkedArticles,
    this.blockedUsers,
  });
}
