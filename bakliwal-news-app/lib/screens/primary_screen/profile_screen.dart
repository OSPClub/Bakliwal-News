// ignore_for_file: use_build_context_synchronously, unnecessary_null_comparison

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:profanity_filter/profanity_filter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';

import 'package:bakliwal_news_app/models/article_upvotes.dart';
import 'package:bakliwal_news_app/models/settings_model.dart';
import 'package:bakliwal_news_app/providers/settings_const.dart';
import 'package:bakliwal_news_app/screens/secondary_screens/article_discription_screen.dart';
import 'package:bakliwal_news_app/widget/view/custome_snackbar.dart';
import 'package:bakliwal_news_app/models/news_article.dart';
import 'package:bakliwal_news_app/custome_icons_icons.dart';
import 'package:bakliwal_news_app/models/user_information.dart';
import 'package:bakliwal_news_app/providers/user_account/user_account.dart';
import 'package:bakliwal_news_app/style/style_declaration.dart';
import 'package:bakliwal_news_app/screens/secondary_screens/account_details_screen.dart';

// ignore: must_be_immutable
class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});
  static const routeName = "./profile-screen";
  List<Comments> fetchedcomments = [];

  Future<void> allcomments(UserInformation? userInformation) async {
    final userExtraDataComments = await FirebaseDatabase.instance
        .ref()
        .child("users/${userInformation!.userId}/comments")
        .limitToFirst(10)
        .get();
    final allcomments = userExtraDataComments.value;

    if (allcomments != null) {
      allcomments as Map;
      allcomments.forEach((_, commentsData) async {
        final extraDataCommentsRef = await FirebaseDatabase.instance
            .ref()
            .child(
                "comments/${commentsData['articleId']}/${commentsData['commentId']}")
            .get();
        final extraDataComments = extraDataCommentsRef.value;
        if (extraDataComments != null) {
          extraDataComments as Map;
          fetchedcomments.add(
            Comments(
              commentId: commentsData['commentId'],
              timeOfComment:
                  DateTime.parse(extraDataComments['timeOfComment'].toString()),
              commentWritten: extraDataComments['commentWritten'],
              upVotes: extraDataComments['upVotes'],
              commentorUserName: userInformation.fullName,
              commentorUserId: userInformation.userId,
              commentorUserProfilePicture: userInformation.profilePicture,
              articleId: commentsData['articleId'],
            ),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    UserInformation? userInformation =
        Provider.of<UserAccount>(context).personalInformation;
    Settings settings = Provider.of<ConstSettings>(context).constSettings;

    bool socialCheck = userInformation.instagram != null ||
        userInformation.githubUsername != null ||
        userInformation.linkedin != null ||
        userInformation.twitter != null ||
        userInformation.facebook != null ||
        userInformation.websiteURL != null;

    var socialWrap = SizedBox(
      width: 300,
      child: Wrap(
        runSpacing: 5,
        children: [
          const SizedBox(
            height: 15,
          ),
          if (userInformation.githubUsername != null)
            IconButton(
              onPressed: () async {
                var url =
                    'https://github.com/${userInformation.githubUsername!.trim()}/';

                if (await canLaunchUrl(Uri.parse(url))) {
                  await launchUrl(
                    Uri.parse(url),
                    mode: LaunchMode.externalApplication,
                  );
                } else {
                  throw 'There was a problem to open the url: $url';
                }
              },
              icon: const Icon(
                CustomeIcons.github_circled_alt2,
                color: AppColors.secondary,
                size: 30,
              ),
            ),
          if (userInformation.linkedin != null)
            IconButton(
              onPressed: () async {
                var url =
                    'https://www.linkedin.com/${userInformation.linkedin!.trim()}/';

                if (await canLaunchUrl(Uri.parse(url))) {
                  await launchUrl(
                    Uri.parse(url),
                    mode: LaunchMode.externalApplication,
                  );
                } else {
                  throw 'There was a problem to open the url: $url';
                }
              },
              icon: const Icon(
                CustomeIcons.linkedin_1,
                color: AppColors.secondary,
                size: 30,
              ),
            ),
          if (userInformation.twitter != null)
            IconButton(
              onPressed: () async {
                var url =
                    'https://twitter.com/${userInformation.twitter!.trim()}/';

                if (await canLaunchUrl(Uri.parse(url))) {
                  await launchUrl(
                    Uri.parse(url),
                    mode: LaunchMode.externalApplication,
                  );
                } else {
                  throw 'There was a problem to open the url: $url';
                }
              },
              icon: const Icon(
                CustomeIcons.twitter,
                color: AppColors.secondary,
                size: 30,
              ),
            ),
          if (userInformation.instagram != null)
            IconButton(
              onPressed: () async {
                var url =
                    'https://www.instagram.com/${userInformation.instagram!.trim()}/';

                if (await canLaunchUrl(Uri.parse(url))) {
                  await launchUrl(
                    Uri.parse(url),
                    mode: LaunchMode.externalApplication,
                  );
                } else {
                  throw 'There was a problem to open the url: $url';
                }
              },
              icon: const Icon(
                CustomeIcons.instagram,
                color: AppColors.secondary,
                size: 30,
              ),
            ),
          if (userInformation.facebook != null)
            IconButton(
              onPressed: () async {
                var url =
                    'https://www.facebook.com/${userInformation.facebook!.trim()}/';

                if (await canLaunchUrl(Uri.parse(url))) {
                  await launchUrl(
                    Uri.parse(url),
                    mode: LaunchMode.externalApplication,
                  );
                } else {
                  throw 'There was a problem to open the url: $url';
                }
              },
              icon: const Icon(
                CustomeIcons.facebook,
                color: AppColors.secondary,
                size: 30,
              ),
            ),
          if (userInformation.websiteURL != null)
            InkWell(
              onTap: () async {
                var url = 'https://${userInformation.websiteURL}';

                if (await canLaunchUrl(Uri.parse(url))) {
                  await launchUrl(
                    Uri.parse(url),
                    mode: LaunchMode.externalApplication,
                  );
                } else {
                  throw 'There was a problem to open the url: $url';
                }
              },
              child: Row(children: [
                const Icon(
                  CustomeIcons.link,
                  color: AppColors.secondary,
                  size: 30,
                ),
                const SizedBox(
                  width: 5,
                ),
                Flexible(
                  child: Text(
                    userInformation.websiteURL!,
                    style: const TextStyle(
                      color: Colors.blue,
                      fontSize: 14,
                    ),
                  ),
                ),
              ]),
            ),
        ],
      ),
    );

    var biocontainer = Container(
      padding: const EdgeInsets.only(
        right: 70,
        bottom: 5,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          if (userInformation.biography != null)
            Text(
              userInformation.biography!,
              style: const TextStyle(
                color: Color.fromARGB(255, 209, 206, 206),
                fontSize: 15,
              ),
            ),
        ],
      ),
    );

    Widget statsCard(dynamic data, String label) {
      return Card(
        key: UniqueKey(),
        shadowColor: AppColors.shadowColors,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        color: Theme.of(context).colorScheme.secondary,
        child: Padding(
          padding: EdgeInsets.only(
            top: 10,
            bottom: 10,
            left: 15,
            right: MediaQuery.of(context).size.width * 0.14,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data ?? "0",
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                label,
                style: const TextStyle(
                  fontFamily: "Roboto",
                  color: AppColors.substituteColor,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      );
    }

    var accountDetailsButton = ElevatedButton(
      onPressed: () {
        if (settings.enableProfileUpdate!) {
          Navigator.of(context).pushNamed(
            AccountDetailsScreen.routeName,
            arguments: userInformation,
          );
        } else {
          CustomSnackBar.showErrorSnackBar(
            context,
            message: "Profile Update is disable!",
          );
        }
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(AppColors.primary),
        padding: MaterialStateProperty.all(
          const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
        ),
        shape: MaterialStateProperty.all(RoundedRectangleBorder(
          side: const BorderSide(color: Colors.white, width: 1.5),
          borderRadius: BorderRadius.circular(15),
        )),
      ),
      child: const Text(
        "Account Details",
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        centerTitle: true,
      ),
      backgroundColor: AppColors.primary,
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.only(
              top: 25,
              left: 25,
              right: 25,
              bottom: 30,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Hero(
                  tag: "personalProfile",
                  child: userInformation.userId == "default" ||
                          userInformation.profilePicture == null ||
                          userInformation.profilePicture!.isEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: const Image(
                            fit: BoxFit.cover,
                            height: 80,
                            width: 80,
                            image: AssetImage(
                                "assets/images/profilePlaceholder.jpeg"),
                          ),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image(
                            fit: BoxFit.cover,
                            height: 80,
                            width: 80,
                            image: NetworkImage(
                              userInformation.profilePicture!,
                            ),
                          ),
                        ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  userInformation.fullName.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(
                  height: 2,
                ),
                Text(
                  "@${userInformation.userName}",
                  style: const TextStyle(
                    color: AppColors.secondary,
                    fontSize: 15,
                  ),
                ),
                if (userInformation.biography != null) biocontainer,
                const SizedBox(
                  height: 9,
                ),
                Text(
                  "Joined ${DateFormat.yMMMM().format(userInformation.joined as DateTime)}",
                  style: const TextStyle(
                    fontFamily: "Roboto",
                    color: AppColors.substituteColor,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                if (socialCheck) socialWrap,
                const SizedBox(
                  height: 30,
                ),
                accountDetailsButton,
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Activity",
                  style: TextStyle(
                    fontFamily: ".SF UI Display",
                    color: Colors.white,
                  ),
                ),
                const Divider(
                  thickness: 0.5,
                  color: AppColors.secondary,
                ),
                const SizedBox(
                  height: 30,
                ),
                const Text(
                  "Stats",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Roboto",
                    fontSize: 20,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                statsCard(
                    userInformation.articlesRead != null
                        ? userInformation.articlesRead!.length.toString()
                        : "0",
                    "Articles Read"),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    statsCard(null, "Article views"),
                    statsCard(null, "Upvotes earned"),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    const Text(
                      "Your Articles",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: "Roboto",
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    Text(
                      "(${userInformation.allPublishedArticles == null ? "0" : userInformation.allPublishedArticles!.length})",
                      style: const TextStyle(
                        color: AppColors.substituteColor,
                        fontFamily: "Roboto",
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                userInformation.allPublishedArticles == null
                    ? const Text(
                        "No articles yet.",
                        style: TextStyle(
                            color: AppColors.substituteColor,
                            fontFamily: "Roboto"),
                      )
                    : Container(),
                const SizedBox(
                  height: 20,
                ),
                FutureBuilder(
                  future: allcomments(userInformation),
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    // fetchedcomments.sort((a, b) => a.timeOfComment!
                    //     .compareTo(b.timeOfComment as DateTime));
                    return snapshot.connectionState == ConnectionState.waiting
                        ? const CircularProgressIndicator()
                        : fetchedcomments.isEmpty
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: const [
                                      Text(
                                        "Your Comments",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: "Roboto",
                                          fontSize: 20,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 3,
                                      ),
                                      Text(
                                        "(0)",
                                        style: TextStyle(
                                          color: AppColors.substituteColor,
                                          fontFamily: "Roboto",
                                          fontSize: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Text(
                                    "You didn't comment yet.",
                                    style: TextStyle(
                                      color: AppColors.substituteColor,
                                      fontFamily: "Roboto",
                                    ),
                                  ),
                                ],
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Text(
                                        "Your Comments",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: "Roboto",
                                          fontSize: 20,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 3,
                                      ),
                                      Text(
                                        "(${fetchedcomments.isEmpty ? "0" : fetchedcomments.length})",
                                        style: const TextStyle(
                                          color: AppColors.substituteColor,
                                          fontFamily: "Roboto",
                                          fontSize: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  ...fetchedcomments
                                      .map(
                                        (comment) => ArticleComments(
                                          comment: comment,
                                        ),
                                      )
                                      .toList(),
                                  InkWell(
                                    onTap: () {},
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: const [
                                        Text(
                                          "Load more",
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.blue,
                                          ),
                                        ),
                                        Icon(
                                          Icons.arrow_drop_down_rounded,
                                          color: Colors.blue,
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ArticleComments extends StatelessWidget {
  const ArticleComments({
    Key? key,
    required this.comment,
  }) : super(key: key);

  final Comments comment;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        NewsArticle? fetchedArticleArticleForDiscription =
            await loadArticleForDiscriptionScreen(comment.articleId!);
        Navigator.of(context).pushNamed(ArticleDiscriptionScreen.routeName,
            arguments: fetchedArticleArticleForDiscription);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[900],
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.arrow_upward,
                        color: Colors.white,
                      ),
                      Text(
                        comment.upVotes == "null"
                            ? comment.upVotes.toString()
                            : "0",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.64,
                      child: Text(
                        comment.commentWritten!,
                        overflow: TextOverflow.clip,
                        style: const TextStyle(
                          fontSize: 16.5,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      DateFormat("yMMMd").format(
                        comment.timeOfComment!,
                      ),
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.blueGrey[200],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  Future<NewsArticle?> loadArticleForDiscriptionScreen(String aricleId) async {
    final filter = ProfanityFilter();
    final articlesRef =
        await FirebaseDatabase.instance.ref("articles/$aricleId").get();
    final allArticles = articlesRef.value as Map;
    NewsArticle? fetchedArticles;

    final userRef = await FirebaseDatabase.instance
        .ref("users/${allArticles["userId"]}")
        .get();
    final userInformation = userRef.value as Map;

    List<Comments> fetchedComments = [];
    List<ArticleUpvotes> fetchedUpvotes = [];

    final commentsRef =
        await FirebaseDatabase.instance.ref("comments/$aricleId/").get();

    if (commentsRef.exists) {
      final allComments = commentsRef.value as Map;
      allComments.forEach((key, comment) async {
        final commentorsDataRef = await FirebaseDatabase.instance
            .ref("users/${comment["commentorUserId"]}/")
            .get();
        final commentorsData = commentorsDataRef.value as Map;
        String cleanString = filter.censor(comment["commentWritten"]);
        fetchedComments.add(
          Comments(
            commentId: comment["commentId"],
            commentorUserName: commentorsData["fullName"],
            timeOfComment: DateTime.parse(comment['timeOfComment']),
            commentWritten: cleanString,
            commentorUserId: comment["commentorUserId"],
            commentorUserProfilePicture: commentorsData["profilePicture"],
            upVotes: comment['upVotes'],
            articleId: comment['articleId'],
          ),
        );
      });
    }

    final articleUpvotePointer = allArticles["upVotes"];
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

    fetchedArticles = NewsArticle(
      articleId: aricleId,
      title: allArticles["title"].toString(),
      comments: fetchedComments,
      newsImageURL: allArticles["newsImageURL"].toString(),
      discription: allArticles["discription"].toString(),
      username: userInformation["fullName"].toString(),
      userProfilePicture: userInformation["profilePicture"].toString(),
      publishedDate: DateTime.parse(allArticles["publishedDate"]),
      upVotes: fetchedUpvotes,
      articleViews: allArticles["articleViews"],
    );

    return fetchedArticles;
  }
}
