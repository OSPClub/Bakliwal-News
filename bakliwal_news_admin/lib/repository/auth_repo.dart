// ignore_for_file: unnecessary_null_comparison

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'package:bakliwal_news_admin/models/all_read_articles.dart';
import 'package:bakliwal_news_admin/models/bookmarks.dart';
import 'package:bakliwal_news_admin/models/user_information.dart';
import 'package:bakliwal_news_admin/providers/user_account/user_account.dart';

class AuthRepo {
  Future<void> fetchAndSetUser({BuildContext? context}) async {
    User? userCredential = FirebaseAuth.instance.currentUser;

    if (userCredential != null) {
      final data = await FirebaseDatabase.instance
          .ref("users/${userCredential.uid}")
          .get();

      final userExtraData = data.value as Map;
      final userData = userExtraData;

      Map? allReadArticles = userExtraData["articlesRead"];
      List<AllReadArticles> fetchedAllReadArticles = [];
      if (allReadArticles != null) {
        allReadArticles.forEach((articleId, readData) {
          fetchedAllReadArticles.add(
            AllReadArticles(
              profilePictureUrlOfPublisher:
                  readData['profilePictureUrlOfPublisher'],
              userNameOfPublisher: readData['userNameOfPublisher'],
              titleOfArticle: readData['titleOfArticle'],
              articlePublishDate:
                  DateTime.parse(readData['articlespublishedDate']),
              articleReadDateTime:
                  DateTime.parse(readData['articleReadDateTime']),
              articleImageUrl: readData['articleImageUrl'],
              idOfArticle: readData['idOfArticle'],
            ),
          );
        });
      }

      Map? allbookmarks = userExtraData["bookmarks"];
      List<Bookmarks> fetchedbookmarks = [];

      if (allbookmarks != null) {
        allbookmarks.forEach((articleId, bookmarkedArticleTime) {
          fetchedbookmarks.add(
            Bookmarks(
              articleId: articleId.toString(),
              bookmarkedDateTime:
                  DateTime.parse(bookmarkedArticleTime["bookmarkedDateTime"]),
            ),
          );
        });
      }

      UserInformation fetchedInformation = UserInformation(
          userId: userCredential.uid,
          isBlocked: userData["isBlocked"] ?? false,
          userName: userData["userName"].isEmpty ? null : userData["userName"],
          emailId: userCredential.email,
          fullName: userCredential.displayName!.isEmpty
              ? null
              : userCredential.displayName,
          joined: userCredential.metadata.creationTime,
          profilePicture:
              // ignore: prefer_if_null_operators
              userCredential.photoURL == null ? null : userCredential.photoURL,
          biography:
              userData["biography"].isEmpty ? null : userData["biography"],
          companyName:
              userData["companyName"].isEmpty ? null : userData["companyName"],
          jobTitle: userData["jobTitle"].isEmpty ? null : userData["jobTitle"],
          githubUsername: userData["githubUsername"].isEmpty
              ? null
              : userData["githubUsername"],
          linkedin: userData["linkedin"].isEmpty ? null : userData["linkedin"],
          twitter: userData["twitter"].isEmpty ? null : userData["twitter"],
          instagram:
              userData["instagram"].isEmpty ? null : userData["instagram"],
          facebook: userData["facebook"].isEmpty ? null : userData["facebook"],
          websiteURL:
              userData["websiteURL"].isEmpty ? null : userData["websiteURL"],
          articlesRead: fetchedAllReadArticles,
          allBookmarkedArticles: fetchedbookmarks,
          allPublishedArticles: userData["articles"]);

      // ignore: use_build_context_synchronously
      Provider.of<UserAccount>(context!, listen: false)
          .setAccountData(fetchedInformation);
    }
  }

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    // ignore: use_build_context_synchronously
    Provider.of<UserAccount>(context, listen: false).resetDefaultAccountData();
  }
}
