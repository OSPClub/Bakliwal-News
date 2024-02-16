// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:bakliwal_news_admin/providers/articles.dart';
import 'package:bakliwal_news_admin/widgets/view/custome_snackbar.dart';
import 'package:bakliwal_news_admin/package_service/locator_service.dart';
import 'package:bakliwal_news_admin/repository/auth_repo.dart';
import 'package:bakliwal_news_admin/models/user_information.dart';
import 'package:bakliwal_news_admin/providers/user_account/user_account.dart';
import 'package:bakliwal_news_admin/widgets/view/article_discription_appbar.dart';
import 'package:bakliwal_news_admin/style/style_declaration.dart';
import 'package:bakliwal_news_admin/models/news_articles.dart';

// ignore: must_be_immutable
class ArticleDiscriptionScreen extends StatefulWidget {
  const ArticleDiscriptionScreen({super.key});

  static const routeName = "./article-discription-screen";

  @override
  State<ArticleDiscriptionScreen> createState() =>
      _ArticleDiscriptionScreenState();
}

class _ArticleDiscriptionScreenState extends State<ArticleDiscriptionScreen> {
  int readFunctionFired = 0;

  final commentFormKey = GlobalKey<FormState>();

  TextEditingController commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    NewsArticle newsArticle =
        ModalRoute.of(context)!.settings.arguments as NewsArticle;

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: MainDescriptionContent(
        constNewsArticle: newsArticle,
      ),
    );
  }
}

class MainDescriptionContent extends StatelessWidget {
  const MainDescriptionContent({
    super.key,
    required this.constNewsArticle,
  });
  final NewsArticle constNewsArticle;

  @override
  Widget build(
    BuildContext context,
  ) {
    NewsArticle newsArticle = constNewsArticle;
    List<Comments>? allComments = constNewsArticle.comments;
    allComments!.sort(
        (a, b) => b.timeOfComment!.compareTo(a.timeOfComment as DateTime));
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding:
              const EdgeInsets.only(top: 15, left: 25, right: 25, bottom: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ArticleDiscriptionAppBar(
                newsArticle: newsArticle,
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                newsArticle.title!,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  wordSpacing: 5,
                  fontFamily: AppFonts.cabin,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                padding: const EdgeInsets.only(left: 5),
                decoration: const BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      width: 3,
                      color: AppColors.accent,
                    ),
                  ),
                ),
                child: DescriptionTextWidget(text: newsArticle.discription!),
              ),
              const SizedBox(
                height: 20,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Hero(
                  tag: newsArticle.articlesId,
                  child: Image(
                    image: NetworkImage(
                      newsArticle.newsImageURL!,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Row(
                children: [
                  Text(
                    "${newsArticle.upVotes!.length} Upvotes",
                    style: const TextStyle(
                      color: AppColors.secondary,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    "${newsArticle.comments!.length} Comments",
                    style: const TextStyle(
                      color: AppColors.secondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              const Divider(
                color: AppColors.secondary,
              ),
              const SizedBox(
                height: 15,
              ),
              if (newsArticle.comments != null)
                ...allComments.map((comment) {
                  return ArticleComments(
                    comment: comment,
                    newsArticle: newsArticle,
                  );
                }),
            ],
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class ArticleComments extends StatefulWidget {
  ArticleComments({
    super.key,
    required this.comment,
    required this.newsArticle,
  });

  final Comments comment;
  NewsArticle newsArticle;

  @override
  State<ArticleComments> createState() => _ArticleCommentsState();
}

class _ArticleCommentsState extends State<ArticleComments> {
  @override
  Widget build(BuildContext context) {
    // ignore: avoid_unnecessary_containers
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 40.0,
                    width: 40.0,
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.all(
                        Radius.circular(7),
                      ),
                    ),
                    child: widget.comment.commentorUserProfilePicture == null ||
                            widget.comment.commentorUserProfilePicture!.isEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(7),
                            child: const Image(
                              fit: BoxFit.cover,
                              image: AssetImage(
                                  "assets/images/profilePlaceholder.jpeg"),
                            ),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(7),
                            child: Image(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                widget.comment.commentorUserProfilePicture!,
                              ),
                            ),
                          ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.comment.commentorUserName!,
                        style: const TextStyle(color: Colors.white),
                      ),
                      Text(
                        DateFormat("MMMd").format(
                          widget.comment.timeOfComment!,
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
              Expanded(
                child: Container(),
              ),
              CustomePopupMenue(
                context: context,
                authRepo: locator.get<AuthRepo>(),
                comment: widget.comment,
                tabColor: AppColors.secondary,
              ),
            ],
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey[900],
            ),
            margin: const EdgeInsets.symmetric(vertical: 10),
            padding: const EdgeInsets.all(15),
            child: Text(
              widget.comment.commentWritten!,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          // Row(
          //   children: [
          //     IconButton(onPressed: () {}, icon: const Icon(Icons.add))
          //   ],
          // )
        ],
      ),
    );
  }
}

class DescriptionTextWidget extends StatefulWidget {
  final String text;

  const DescriptionTextWidget({
    super.key,
    required this.text,
  });

  @override
  // ignore: library_private_types_in_public_api
  _DescriptionTextWidgetState createState() => _DescriptionTextWidgetState();
}

class _DescriptionTextWidgetState extends State<DescriptionTextWidget> {
  String? firstHalf;
  String? secondHalf;

  bool flag = true;

  @override
  void initState() {
    super.initState();

    if (widget.text.length > 500) {
      firstHalf = widget.text.substring(0, 500);
      secondHalf = widget.text.substring(500, widget.text.length);
    } else {
      firstHalf = widget.text;
      secondHalf = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
      child: secondHalf!.isEmpty
          ? Text(
              firstHalf!,
              style: TextStyle(
                color: Colors.grey[350]!,
                fontFamily: AppFonts.cabin,
                fontSize: 16,
              ),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  flag ? ("${firstHalf!}...") : (firstHalf! + secondHalf!),
                  style: TextStyle(
                    color: Colors.grey[350]!,
                    fontFamily: AppFonts.cabin,
                    fontSize: 16,
                  ),
                ),
                InkWell(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        flag ? "show more" : "show less",
                        style: const TextStyle(color: Colors.blue),
                      ),
                    ],
                  ),
                  onTap: () {
                    setState(() {
                      flag = !flag;
                    });
                  },
                ),
              ],
            ),
    );
  }
}

class CustomePopupMenue extends StatelessWidget {
  const CustomePopupMenue({
    super.key,
    required this.context,
    required this.authRepo,
    required this.comment,
    required this.tabColor,
  });

  final BuildContext context;
  final AuthRepo authRepo;
  final Comments comment;
  final Color tabColor;

  @override
  Widget build(BuildContext context) {
    UserInformation user =
        Provider.of<UserAccount>(context, listen: false).personalInformation;
    return PopupMenuButton<int>(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      splashRadius: 20,
      elevation: 20,
      offset: const Offset(-12, 40),
      icon: Icon(
        Icons.more_vert,
        color: tabColor,
      ),
      iconSize: 25,
      color: tabColor,
      onSelected: (value) async {
        if (value == 1) {
          if (user.userId == comment.commentorUserId) {
            Provider.of<Articles>(context, listen: false).removeComment(
              comment.articleId!,
              comment.commentorUserId!,
              comment.commentId,
            );
            CustomSnackBar.showSuccessSnackBar(
              context,
              message: "Comment Deleted!",
            );
          }
        } else if (value == 2) {
          await FirebaseDatabase.instance.ref('reports/comments').push().set({
            "userId": user.userId.toString(),
            "articleId": comment.articleId.toString(),
            "commentId": comment.commentId.toString(),
            "reportedTime": DateTime.now().toString(),
          });
          CustomSnackBar.showSuccessSnackBar(
            context,
            message: "REST EASY, Comment is reported!",
          );
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 1,
          child: Row(
            children: [
              Icon(
                Icons.close,
                size: 15,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                "Delete comment",
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 2,
          child: Row(
            children: [
              Icon(
                Icons.flag,
                size: 15,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                "Report",
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
