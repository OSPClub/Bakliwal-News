// ignore_for_file: use_build_context_synchronously

import 'package:bakliwal_news_admin/providers/articles.dart';
import 'package:bakliwal_news_admin/providers/user_account/reports_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:bakliwal_news_admin/constants.dart';
import 'package:bakliwal_news_admin/models/report_model.dart';
import 'package:bakliwal_news_admin/screens/secondary_screens/article_discription_screen.dart';
import 'package:bakliwal_news_admin/style/style_declaration.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class ReportInfoCardGridView extends StatefulWidget {
  ReportInfoCardGridView({
    super.key,
    this.crossAxisCount = 4,
    this.childAspectRatio = 1,
    required this.allReports,
  });

  final int crossAxisCount;
  final double childAspectRatio;
  List<ArticleReport>? allReports;

  @override
  State<ReportInfoCardGridView> createState() => _ReportInfoCardGridViewState();
}

class _ReportInfoCardGridViewState extends State<ReportInfoCardGridView> {
  @override
  Widget build(BuildContext context) {
    void rebuiltState(ArticleReport articleReport) {
      setState(() {
        widget.allReports!.remove(articleReport);
      });
    }

    return widget.allReports!.isEmpty || widget.allReports == null
        ? const Center(
            child: Text("There are no reports. hurray! "),
          )
        : GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: widget.allReports!.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: widget.crossAxisCount,
              crossAxisSpacing: defaultPadding,
              mainAxisSpacing: defaultPadding,
              childAspectRatio: widget.childAspectRatio,
            ),
            itemBuilder: (context, index) => ReportInfoCard(
              isSuggested: false,
              info: widget.allReports![index],
              rebuiltState: rebuiltState,
            ),
          );
  }
}

class ReportInfoCard extends StatelessWidget {
  const ReportInfoCard({
    super.key,
    required this.info,
    this.isSuggested = false,
    required this.rebuiltState,
  });

  final ArticleReport info;
  final bool isSuggested;
  final void Function(ArticleReport) rebuiltState;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(
          ArticleDiscriptionScreen.routeName,
          arguments: info.reportedArticle,
        );
      },
      child: Container(
        padding: const EdgeInsets.all(defaultPadding),
        decoration: const BoxDecoration(
          color: secondaryColor,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          info.usersName,
                          style: const TextStyle(color: Colors.red),
                          overflow: TextOverflow.clip,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          DateFormat("yMMMd").format(info.reportedTime),
                          style: const TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ],
                ),
                customePopup(context),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 150,
              width: double.infinity,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image(
                  fit: BoxFit.fill,
                  image: NetworkImage(
                    info.reportedArticle!.newsImageURL == null
                        ? "https://www.interpeace.org/wp-content/themes/twentytwenty/img/image-placeholder.png"
                        : info.reportedArticle!.newsImageURL!,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Flexible(
              child: Text(
                info.reportedArticle!.title == null
                    ? "Unknown Error"
                    : info.reportedArticle!.title!,
                overflow: TextOverflow.clip,
              ),
            ),
            Text(
              info.reportedArticle!.publishedDate == null
                  ? "Unknown Error"
                  : DateFormat("yMMMd")
                      .format(info.reportedArticle!.publishedDate!),
              style: const TextStyle(color: Colors.white54),
            ),
          ],
        ),
      ),
    );
  }

  PopupMenuButton customePopup(BuildContext context) {
    return PopupMenuButton<int>(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      splashRadius: 20,
      elevation: 20,
      offset: const Offset(-12, 40),
      icon: const Icon(
        Icons.more_vert_sharp,
        color: AppColors.secondary,
      ),
      color: AppColors.secondary,
      onSelected: (value) async {
        if (value == 0) {
          await FirebaseDatabase.instance
              .ref("reports/articles")
              .child(info.reportId)
              .remove();
          await Provider.of<ReportsProvider>(context, listen: false)
              .fetchAndSetArticleReportData(context);
          rebuiltState(info);
        }
        if (value == 1) {
          await FirebaseDatabase.instance
              .ref("reports/articles")
              .child(info.reportId)
              .remove();
          await FirebaseFirestore.instance
              .collection("articles")
              .doc(info.articleId)
              .delete();
          await FirebaseStorage.instance
              .ref("articles/${info.articleId}")
              .delete();
          await FirebaseDatabase.instance
              .ref()
              .child("users/${info.userId}/articles/${info.articleId}")
              .remove();
          await FirebaseDatabase.instance
              .ref()
              .child("upVotes/${info.articleId}")
              .remove();
          final commentRef = await FirebaseDatabase.instance
              .ref()
              .child("comments/${info.articleId}")
              .get();
          if (commentRef.exists) {
            final allComments = commentRef.value as Map;
            allComments.forEach((key, comment) async {
              await FirebaseDatabase.instance
                  .ref(
                      "users/${comment["commentorUserId"]}/comments/${comment["commentId"]}")
                  .remove();
            });
          }
          await FirebaseDatabase.instance
              .ref()
              .child("comments/${info.articleId}")
              .remove();
          Provider.of<Articles>(context, listen: false)
              .fetchAndSetInitArticles();
          await Provider.of<ReportsProvider>(context, listen: false)
              .fetchAndSetArticleReportData(context);
          rebuiltState(info);
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 0,
          child: Row(
            children: [
              Icon(
                Icons.delete,
                color: secondaryColor,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                "Delete Report",
                style: TextStyle(color: secondaryColor),
              ),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 1,
          child: Row(
            children: [
              Icon(
                Icons.delete,
                color: secondaryColor,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                "Delete Article",
                style: TextStyle(color: secondaryColor),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ignore: must_be_immutable
class ReportCommentInfoCardGridView extends StatefulWidget {
  ReportCommentInfoCardGridView({
    super.key,
    this.crossAxisCount = 4,
    this.childAspectRatio = 1,
    required this.allComments,
  });

  final int crossAxisCount;
  final double childAspectRatio;
  List<CommentReport>? allComments;

  @override
  State<ReportCommentInfoCardGridView> createState() =>
      _ReportCommentInfoCardGridViewState();
}

class _ReportCommentInfoCardGridViewState
    extends State<ReportCommentInfoCardGridView> {
  @override
  Widget build(BuildContext context) {
    void rebuiltState(CommentReport commentReport) {
      setState(() {
        widget.allComments!.remove(commentReport);
      });
    }

    return widget.allComments!.isEmpty || widget.allComments == null
        ? const Center(
            child: Text("There are no reports. hurray! "),
          )
        : GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: widget.allComments!.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: widget.crossAxisCount,
              crossAxisSpacing: defaultPadding,
              mainAxisSpacing: defaultPadding,
              childAspectRatio: widget.childAspectRatio,
            ),
            itemBuilder: (context, index) => ReportCommentInfoCard(
              isSuggested: false,
              info: widget.allComments![index],
              rebuiltState: rebuiltState,
            ),
          );
  }
}

class ReportCommentInfoCard extends StatelessWidget {
  const ReportCommentInfoCard({
    super.key,
    required this.info,
    this.isSuggested = false,
    required this.rebuiltState,
  });

  final CommentReport info;
  final bool isSuggested;
  final void Function(CommentReport) rebuiltState;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(
          ArticleDiscriptionScreen.routeName,
          arguments: info.reportedArticle,
        );
      },
      child: Container(
        padding: const EdgeInsets.all(defaultPadding),
        decoration: const BoxDecoration(
          color: secondaryColor,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          info.usersName,
                          style: const TextStyle(color: Colors.red),
                          overflow: TextOverflow.clip,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          DateFormat("yMMMd").format(info.reportedTime),
                          style: const TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ],
                ),
                customePopup(context),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 150,
              width: double.infinity,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image(
                  fit: BoxFit.fill,
                  image: NetworkImage(
                    info.reportedArticle!.newsImageURL == null
                        ? "https://www.interpeace.org/wp-content/themes/twentytwenty/img/image-placeholder.png"
                        : info.reportedArticle!.newsImageURL!,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Flexible(
              child: Text(
                info.reportedArticle!.title == null
                    ? "Unknown Error"
                    : info.reportedArticle!.title!,
                overflow: TextOverflow.clip,
              ),
            ),
            Text(
              info.reportedArticle!.publishedDate == null
                  ? "Unknown Error"
                  : DateFormat("yMMMd")
                      .format(info.reportedArticle!.publishedDate!),
              style: const TextStyle(color: Colors.white54),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              '"${info.writtenComment}"',
              style: const TextStyle(color: Colors.red),
            ),
            Text(
              "by:  ${info.usersName}.",
              style: const TextStyle(color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }

  PopupMenuButton customePopup(BuildContext context) {
    return PopupMenuButton<int>(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      splashRadius: 20,
      elevation: 20,
      offset: const Offset(-12, 40),
      icon: const Icon(
        Icons.more_vert_sharp,
        color: AppColors.secondary,
      ),
      color: AppColors.secondary,
      onSelected: (value) async {
        if (value == 0) {
          await FirebaseDatabase.instance
              .ref("reports/comments")
              .child(info.reportId)
              .remove();
          await Provider.of<ReportsProvider>(context, listen: false)
              .fetchAndSetCommentReportData(context);
          rebuiltState(info);
        }
        if (value == 1) {
          await FirebaseDatabase.instance
              .ref("reports/comments")
              .child(info.reportId)
              .remove();
          Provider.of<Articles>(context, listen: false).removeComment(
              info.reportedArticle!.articlesId,
              info.reportedArticle!.userId!,
              info.commentId);
          await Provider.of<ReportsProvider>(context, listen: false)
              .fetchAndSetCommentReportData(context);
          rebuiltState(info);
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 0,
          child: Row(
            children: [
              Icon(
                Icons.delete,
                color: secondaryColor,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                "Delete Report",
                style: TextStyle(color: secondaryColor),
              ),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 1,
          child: Row(
            children: [
              Icon(
                Icons.delete,
                color: secondaryColor,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                "Delete Comment",
                style: TextStyle(color: secondaryColor),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
