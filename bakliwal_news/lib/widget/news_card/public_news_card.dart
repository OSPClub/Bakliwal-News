import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import 'package:bakliwal_news/style/shimmers_effect.dart';
import 'package:bakliwal_news/models/user_information.dart';
import 'package:bakliwal_news/models/screen_enums.dart';
import 'package:bakliwal_news/style/style_declaration.dart';
import 'package:bakliwal_news/models/public_article_model.dart';
import 'package:bakliwal_news/widget/view/custome_snackbar.dart';
import 'package:bakliwal_news/providers/news/public_articles.dart';
import 'package:bakliwal_news/screens/secondary_screens/public_article_canonical.dart';

class PublicNewsCard extends StatefulWidget {
  final PublicArticle newsArticle;
  final UserInformation? userInformation;
  final ScreenType screenName;
  const PublicNewsCard({
    super.key,
    required this.userInformation,
    required this.newsArticle,
    required this.screenName,
  });

  @override
  State<PublicNewsCard> createState() => _PublicNewsCardState();
}

class _PublicNewsCardState extends State<PublicNewsCard> {
  late int? upVoteCount = widget.newsArticle.publicReactionsCount;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final currentArticle = widget.newsArticle;

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
          onTap: () async {
            PublicArticleCanonicalModel? canonicalNewsArticle;
            final articleProviderRef =
                Provider.of<PublicArticles>(context, listen: false);

            // articleProviderRef.switchUniversalLoading(true);

            canonicalNewsArticle = await articleProviderRef
                .fetchCanonicalArticle(widget.newsArticle.articleId);
            // ignore: use_build_context_synchronously
            Navigator.of(context).pushNamed(
              PublicArticleCanonical.routeName,
              arguments: canonicalNewsArticle,
            );
            // articleProviderRef.switchUniversalLoading(false);
          },
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
                      widget.newsArticle.user.profileImage == null ||
                              widget.newsArticle.user.profileImage!.isEmpty
                          ? const CircleAvatar(
                              radius: 15,
                              backgroundImage: AssetImage(
                                "assets/images/profilePlaceholder.jpeg",
                              ),
                            )
                          : CircleAvatar(
                              radius: 15,
                              backgroundImage: NetworkImage(
                                widget.newsArticle.user.profileImage!,
                              ),
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
                  child: Image.network(
                    widget.newsArticle.newsImageURL!,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.network(
                        "https://upload.wikimedia.org/wikipedia/commons/thumb/d/d1/Image_not_available.png/800px-Image_not_available.png",
                      );
                    },
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
                                CustomSnackBar.showErrorSnackBar(
                                  milliseconds: 1000,
                                  context,
                                  message:
                                      "Not Available! This is a Public Data",
                                );
                              },
                              icon: const Icon(
                                Icons.arrow_upward_rounded,
                                color: AppColors.secondary,
                                size: 25,
                              ),
                            ),
                            Text(
                              upVoteCount == null || upVoteCount == 0
                                  ? ""
                                  : "$upVoteCount",
                              style: const TextStyle(
                                fontSize: 20,
                                color: AppColors.secondary,
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
                                CustomSnackBar.showErrorSnackBar(
                                  milliseconds: 1000,
                                  context,
                                  message:
                                      "Not Available! This is a Public Data",
                                );
                              },
                              icon: const Icon(
                                Icons.comment_outlined,
                                color: AppColors.secondary,
                                size: 25,
                              ),
                            ),
                            Text(
                              // ignore: unnecessary_null_comparison
                              currentArticle.commentsCount == null ||
                                      currentArticle.commentsCount == 0
                                  ? ""
                                  : currentArticle.commentsCount.toString(),
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
                        onPressed: () async {
                          await Share.share(
                            widget.newsArticle.articleUrl,
                            subject:
                                "Hello, check out this amazing article! via Bakliwal News",
                          );
                        },
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
