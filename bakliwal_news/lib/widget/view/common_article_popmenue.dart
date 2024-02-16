// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:bakliwal_news/models/settings_model.dart';
import 'package:bakliwal_news/models/user_information.dart';
import 'package:bakliwal_news/providers/settings_const.dart';
import 'package:bakliwal_news/screens/secondary_screens/article_discription_screen.dart';
import 'package:bakliwal_news/widget/view/custome_snackbar.dart';
import 'package:bakliwal_news/models/screen_enums.dart';
import 'package:bakliwal_news/style/style_declaration.dart';
import 'package:bakliwal_news/providers/user_account/user_account.dart';
import 'package:bakliwal_news/providers/news/user_bookmarks.dart';
import 'package:bakliwal_news/models/news_article.dart';

class CommonArticlePopMenue extends StatefulWidget {
  const CommonArticlePopMenue({
    super.key,
    required this.newsArticle,
    required this.iconSize,
    required this.screenName,
  });

  final NewsArticle newsArticle;
  final double iconSize;
  final ScreenType? screenName;

  @override
  State<CommonArticlePopMenue> createState() => _CommonArticlePopMenueState();
}

class _CommonArticlePopMenueState extends State<CommonArticlePopMenue> {
  @override
  Widget build(BuildContext context) {
    final UserInformation userInformation =
        Provider.of<UserAccount>(context, listen: false).personalInformation;

    Appsettings settings = Provider.of<ConstSettings>(context).constSettings;

    return PopupMenuButton<int>(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      splashRadius: 20,
      elevation: 20,
      offset: const Offset(-12, 40),
      icon: const Icon(
        Icons.more_vert_sharp,
        color: AppColors.secondary,
      ),
      iconSize: widget.iconSize,
      color: AppColors.secondary,
      onSelected: (value) async {
        if (userInformation.userId == 'default') {
          CustomSnackBar.showErrorSnackBar(context,
              message: "Please Login or Signup!");
        } else {
          if (value == 11) {
            if (settings.enableBookmarks!) {
              await Provider.of<UserBookmarks>(
                context,
                listen: false,
              ).addBookmark(
                widget.newsArticle.articleId,
                context,
              );
              setState(() {
                widget.newsArticle.isBookmarked = true;
              });
              CustomSnackBar.showSuccessSnackBar(
                context,
                message: "Article Bookmarked :D",
                color: Colors.purple[400]!,
              );
            } else {
              CustomSnackBar.showErrorSnackBar(context,
                  message: "Bookmarks are disable!");
            }
          } else if (value == 12) {
            if (settings.enableBookmarks!) {
              await Provider.of<UserBookmarks>(
                context,
                listen: false,
              ).removeBookmark(
                widget.newsArticle,
                context,
              );
              setState(() {
                widget.newsArticle.isBookmarked = false;
              });
              CustomSnackBar.showSuccessSnackBar(
                context,
                message: "Article removed from Bookmarked :(",
                color: Colors.purple[400]!,
              );
            } else {
              CustomSnackBar.showErrorSnackBar(context,
                  message: "Bookmarks are disable!");
            }
          } else if (value == 2) {
            if (settings.enableComments!) {
              Navigator.of(context).pushNamed(
                ArticleDiscriptionScreen.routeName,
                arguments: widget.newsArticle,
              );
            } else {
              CustomSnackBar.showErrorSnackBar(context,
                  message: "Comments are disable!");
            }
          } else if (value == 3) {
          } else if (value == 4) {
            await FirebaseDatabase.instance.ref('reports/articles').push().set({
              "userId": userInformation.userId.toString(),
              "articleId": widget.newsArticle.articleId.toString(),
              "usersName": userInformation.fullName.toString(),
              "reportedTime": DateTime.now().toString(),
            });
            CustomSnackBar.showSuccessSnackBar(context,
                message: "REST EASY, Article is reported!");
          }
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: !widget.newsArticle.isBookmarked! ? 11 : 12,
          child: Row(
            children: [
              !widget.newsArticle.isBookmarked!
                  ? const Icon(Icons.bookmark_add_rounded)
                  : const Icon(Icons.bookmark_remove_rounded),
              const SizedBox(
                width: 10,
              ),
              !widget.newsArticle.isBookmarked!
                  ? const Text("Add to bookmarks")
                  : const Text("Remove from bookmarks"),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 2,
          child: Row(
            children: [
              Icon(Icons.mode_comment),
              SizedBox(
                width: 10,
              ),
              Text("Comment")
            ],
          ),
        ),
        // PopupMenuItem(
        //   value: 3,
        //   child: Row(
        //     children: [
        //       const Icon(Icons.block_rounded),
        //       const SizedBox(
        //         width: 10,
        //       ),
        //       Flexible(
        //         child: Text(
        //           "Don't show articles from ${newsArticle.username}",
        //         ),
        //       )
        //     ],
        //   ),
        // ),
        const PopupMenuItem(
          value: 4,
          child: Row(
            children: [
              Icon(Icons.flag),
              SizedBox(
                width: 10,
              ),
              Text("Report")
            ],
          ),
        ),
      ],
    );
  }
}
