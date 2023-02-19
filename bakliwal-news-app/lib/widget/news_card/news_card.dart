import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:bakliwal_news_app/models/settings_model.dart';
import 'package:bakliwal_news_app/widget/view/custome_snackbar.dart';
import 'package:bakliwal_news_app/providers/settings_const.dart';
import 'package:bakliwal_news_app/models/article_upvotes.dart';
import 'package:bakliwal_news_app/style/shimmers_effect.dart';
import 'package:bakliwal_news_app/models/user_information.dart';
import 'package:bakliwal_news_app/models/screen_enums.dart';
import 'package:bakliwal_news_app/style/style_declaration.dart';
import 'package:bakliwal_news_app/screens/secondary_screens/article_discription_screen.dart';
import 'package:bakliwal_news_app/widget/view/common_article_popmenue.dart';
import 'package:bakliwal_news_app/models/news_article.dart';

class NewsCard extends StatefulWidget {
  final NewsArticle newsArticle;
  final UserInformation? userInformation;
  final ScreenType screenName;
  const NewsCard({
    super.key,
    required this.userInformation,
    required this.newsArticle,
    required this.screenName,
  });

  @override
  State<NewsCard> createState() => _NewsCardState();
}

class _NewsCardState extends State<NewsCard> {
  bool isUpvoted = false;
  bool? isUser;
  late List<ArticleUpvotes>? upVotes = widget.newsArticle.upVotes;
  late int? upVoteCount = widget.newsArticle.upVotes!.length;

  @override
  void initState() {
    isUser = widget.userInformation?.userId == "default" ? false : true;
    if (isUser!) {
      if (upVotes != null) {
        if (upVotes!.any((element) =>
            element.userUpVoted == widget.userInformation?.userId)) {
          isUpvoted = true;
        }
      }
      if (widget.userInformation?.allBookmarkedArticles != null) {
        if (widget.userInformation!.allBookmarkedArticles!.any(
            (element) => element.articleId == widget.newsArticle.articleId)) {
          widget.newsArticle.isBookmarked = true;
        }
      }
    }
    super.initState();
  }

  Future<void> upVote() async {
    if (isUpvoted) {
      await FirebaseDatabase.instance
          .ref()
          .child(
              "articles/${widget.newsArticle.articleId}/upVotes/${widget.userInformation?.userId}")
          .remove();
      setState(() {
        isUpvoted = false;
        upVoteCount = upVoteCount! - 1;
      });
    } else {
      await FirebaseDatabase.instance
          .ref()
          .child(
              "articles/${widget.newsArticle.articleId}/upVotes/${widget.userInformation?.userId}")
          .set({
        "upVotedUser": widget.userInformation?.userId,
        "dateOfUpvote": DateTime.now().toString(),
      });
      setState(() {
        isUpvoted = true;
        upVoteCount = (upVoteCount! + 1);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // List<NewsArticle> allArticles = Provider.of<Articles>(context).newsArticles;
    final currentArticle = widget.newsArticle;
    Settings settings = Provider.of<ConstSettings>(context).constSettings;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Card(
        key: UniqueKey(),
        shadowColor: AppColors.shadowColors,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(13),
          ),
        ),
        color: Theme.of(context).colorScheme.secondary,
        child: InkWell(
          onTap: () => Navigator.of(context).pushNamed(
            ArticleDiscriptionScreen.routeName,
            arguments: widget.newsArticle,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      widget.newsArticle.userProfilePicture == null ||
                              widget.newsArticle.userProfilePicture!.isEmpty
                          ? const CircleAvatar(
                              radius: 15,
                              backgroundImage: AssetImage(
                                  "assets/images/profilePlaceholder.jpeg"),
                            )
                          : CircleAvatar(
                              radius: 15,
                              backgroundImage: NetworkImage(
                                widget.newsArticle.userProfilePicture!,
                              ),
                            ),
                      CommonArticlePopMenue(
                        newsArticle: widget.newsArticle,
                        iconSize: 25,
                        screenName: widget.screenName,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    right: 20.0,
                    left: 15.0,
                  ),
                  child: Text(
                    widget.newsArticle.title!,
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20.0, left: 15.0),
                  child: Text(
                    DateFormat("yMMMd")
                        .format(widget.newsArticle.publishedDate!),
                    style: TextStyle(fontSize: 15, color: Colors.blueGrey[200]),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Hero(
                    tag: widget.newsArticle.articleId,
                    child: Image.network(
                      widget.newsArticle.newsImageURL!,
                      frameBuilder:
                          (context, child, frame, wasSynchronouslyLoaded) {
                        return child;
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        } else {
                          return CustomShimmerEffect.rectangular(
                            height: 150,
                          );
                        }
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5.0, right: 15, left: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 90,
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                if (isUser!) {
                                  if (settings.enableUpvotes!) {
                                    upVote();
                                  } else {
                                    CustomSnackBar.showErrorSnackBar(
                                      context,
                                      message: "Upvotes are disable!",
                                    );
                                  }
                                } else {
                                  CustomSnackBar.showErrorSnackBar(
                                    context,
                                    message: "Please Login or Signup!",
                                  );
                                }
                              },
                              icon: Icon(
                                Icons.arrow_upward_rounded,
                                color: isUpvoted
                                    ? Colors.green
                                    : AppColors.secondary,
                                size: 25,
                              ),
                            ),
                            Text(
                              upVoteCount == null || upVoteCount == 0
                                  ? ""
                                  : "$upVoteCount",
                              style: TextStyle(
                                fontSize: 20,
                                color: isUpvoted
                                    ? Colors.green
                                    : AppColors.secondary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 80,
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                if (isUser!) {
                                  if (settings.enableComments!) {
                                    Navigator.of(context).pushNamed(
                                      ArticleDiscriptionScreen.routeName,
                                      arguments: widget.newsArticle,
                                    );
                                  } else {
                                    CustomSnackBar.showErrorSnackBar(
                                      context,
                                      message: "Comments are disable!",
                                    );
                                  }
                                } else {
                                  CustomSnackBar.showErrorSnackBar(
                                    context,
                                    message: "Please Login or Signup!",
                                  );
                                }
                              },
                              icon: const Icon(
                                Icons.comment_outlined,
                                color: AppColors.secondary,
                                size: 25,
                              ),
                            ),
                            Text(
                              currentArticle.comments!.isEmpty
                                  ? ""
                                  : currentArticle.comments!.length.toString(),
                              style: const TextStyle(
                                fontSize: 20,
                                color: AppColors.secondary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.send,
                          color: AppColors.secondary,
                          size: 25,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
