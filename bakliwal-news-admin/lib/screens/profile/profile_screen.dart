// ignore_for_file: unnecessary_null_comparison

import 'package:bakliwal_news_admin/constants.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:profanity_filter/profanity_filter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';

import 'package:bakliwal_news_admin/models/news_articles.dart';
import 'package:bakliwal_news_admin/custome_icons_icons.dart';
import 'package:bakliwal_news_admin/models/user_information.dart';
import 'package:bakliwal_news_admin/providers/user_account/user_account.dart';
import 'package:bakliwal_news_admin/style/style_declaration.dart';
import 'package:bakliwal_news_admin/screens/profile/account_details_screen.dart';

// ignore: must_be_immutable
class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});
  static const routeName = "./profile-screen";
  List<Comments> fetchedcomments = [];

  Future<void> allcomments(UserInformation? userInformation) async {
    fetchedcomments = [];
    final userExtraDataComments = await FirebaseDatabase.instance
        .ref()
        .child("users/${userInformation!.userId}/comments")
        .limitToFirst(10)
        .get();
    Map? allcomments = userExtraDataComments.value as Map;

    if (allcomments != null) {
      allcomments.forEach((_, commentsData) async {
        final extraDataCommentsRef = await FirebaseDatabase.instance
            .ref()
            .child(
                "comments/${commentsData['articleId']}/${commentsData['commentId']}")
            .get();
        final extraDataComments = extraDataCommentsRef.value as Map;
        if (extraDataComments != null) {
          fetchedcomments.add(
            Comments(
              timeOfComment:
                  DateTime.parse(extraDataComments['timeOfComment'].toString()),
              commentWritten: extraDataComments['commentWritten'],
              upVotes: extraDataComments['upVotes'],
              commentorUserName: userInformation.fullName,
              commentorUserId: userInformation.userId,
              commentorUserProfilePicture: userInformation.profilePicture,
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
          // const Text(
          //   "Bio",
          //   style: TextStyle(
          //     color: Color.fromARGB(255, 141, 144, 146),
          //     fontSize: 12,
          //   ),
          // ),
          // const SizedBox(
          //   height: 5,
          // ),
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
        color: secondaryColor,
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
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      );
    }

    var accountDetailsButton = ElevatedButton(
      onPressed: () => Navigator.of(context).pushNamed(
        AccountDetailsScreen.routeName,
        arguments: userInformation,
      ),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(bgColor),
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
        shadowColor: bgColor,
        backgroundColor: bgColor,
      ),
      backgroundColor: bgColor,
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
                          userInformation.profilePicture == null
                      ? const CircleAvatar(
                          radius: 20,
                          backgroundImage: AssetImage(
                              "assets/images/profilePlaceholder.jpeg"),
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
    final cleanComentWritten =
        ProfanityFilter().censor(comment.commentWritten!);
    return Container(
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
                      cleanComentWritten,
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
    );
  }
}
