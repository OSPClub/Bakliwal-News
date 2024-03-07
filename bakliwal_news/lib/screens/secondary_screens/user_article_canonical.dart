// ignore_for_file: use_build_context_synchronously
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:profanity_filter/profanity_filter.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:bakliwal_news/providers/news/user_articles.dart';
import 'package:bakliwal_news/models/settings_model.dart';
import 'package:bakliwal_news/providers/settings_const.dart';
import 'package:bakliwal_news/widget/view/custome_snackbar.dart';
import 'package:bakliwal_news/package_service/locator_service.dart';
import 'package:bakliwal_news/repository/auth_repo.dart';
import 'package:bakliwal_news/widget/view/comment_box.dart';
import 'package:bakliwal_news/models/user_information.dart';
import 'package:bakliwal_news/providers/user_account/user_account.dart';
import 'package:bakliwal_news/widget/view/article_discription_appbar.dart';
import 'package:bakliwal_news/style/style_declaration.dart';
import 'package:bakliwal_news/models/user_article.dart';

// ignore: must_be_immutable
class UserArticleCanonical extends StatefulWidget {
  const UserArticleCanonical({super.key});

  static const routeName = "./user-article-canonical";

  @override
  State<UserArticleCanonical> createState() => _UserArticleCanonicalState();
}

class _UserArticleCanonicalState extends State<UserArticleCanonical> {
  Timer? _timer;
  int _setReadSeconds = 8;
  int readFunctionFired = 0;
  UserArticle? newsArticle;

  final commentFormKey = GlobalKey<FormState>();

  TextEditingController commentController = TextEditingController();

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    newsArticle = ModalRoute.of(context)!.settings.arguments as UserArticle;

    final listOfWords = newsArticle!.discription!.split(" ");

    _setReadSeconds =
        ((listOfWords.length ~/ 2.9) > 25 ? 17 : listOfWords.length ~/ 2.9);

    UserInformation userInformation = Provider.of<UserAccount>(
      context,
      listen: false,
    ).personalInformation;

    void setRead() async {
      final allPublishedArticles = userInformation.articlesRead;
      if (userInformation.userId != "default") {
        if ((allPublishedArticles!.where(
                (element) => element.idOfArticle == newsArticle!.articleId))
            .isEmpty) {
          Provider.of<UserArticles>(context, listen: false).setReadArticle(
            userInformation,
            newsArticle!,
            readFunctionFired,
            context,
          );
          readFunctionFired = 1;
          if (kDebugMode) {
            print("================== SetRead Fired ======================");
          }
        }
      }
    }

    if (readFunctionFired < 1) {
      _timer = Timer(Duration(seconds: _setReadSeconds), () {
        setRead();
      });
    }

    final userInformaion =
        Provider.of<UserAccount>(context, listen: false).personalInformation;
    final isUser = userInformaion.userId != "default";

    Appsettings settings = Provider.of<ConstSettings>(context).constSettings;
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: isUser && settings.enableComments!
          ? CommentBox(
              userImage: userInformaion.profilePicture,
              labelText: 'Start the discussion...',
              withBorder: false,
              enabled: settings.enableComments!,
              errorText: 'Comment cannot be blank',
              sendButtonMethod: () async {
                if (commentFormKey.currentState!.validate()) {
                  Provider.of<UserArticles>(context, listen: false).addComment(
                    newsArticle!.articleId,
                    userInformaion,
                    Comments(
                      commentId: "",
                      timeOfComment: DateTime.now(),
                      commentWritten: commentController.text,
                      commentorUserName: '',
                      commentorUserId: userInformaion.userId,
                      upVotes: "",
                    ),
                  );
                  FocusScope.of(context).unfocus();
                  commentController.clear();
                } else {
                  throw Exception("Not validated");
                }
              },
              formKey: commentFormKey,
              commentController: commentController,
              backgroundColor: AppColors.accent,
              textColor: Colors.white,
              sendWidget: const Icon(
                Icons.whatshot_outlined,
                size: 30,
                color: AppColors.secondary,
              ),
              child: MainDescriptionContent(
                constNewsArticle: newsArticle!,
                setRead: setRead,
              ),
            )
          : MainDescriptionContent(
              constNewsArticle: newsArticle!,
              setRead: setRead,
            ),
    );
  }
}

class MainDescriptionContent extends StatelessWidget {
  const MainDescriptionContent({
    super.key,
    required this.constNewsArticle,
    required this.setRead,
  });
  final void Function() setRead;
  final UserArticle constNewsArticle;

  @override
  Widget build(
    BuildContext context,
  ) {
    UserArticle newsArticle = constNewsArticle;
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
                userArticle: newsArticle,
                publicArticle: null,
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
                child: DescriptionTextWidget(
                    text: newsArticle.discription!, setRead: setRead),
              ),
              const SizedBox(
                height: 20,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image(
                  image: NetworkImage(
                    newsArticle.newsImageURL!,
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
  UserArticle newsArticle;

  @override
  State<ArticleComments> createState() => _ArticleCommentsState();
}

class _ArticleCommentsState extends State<ArticleComments> {
  @override
  Widget build(BuildContext context) {
    Appsettings settings = Provider.of<ConstSettings>(context).constSettings;
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
              settings.enableProfanity!
                  ? ProfanityFilter().censor(widget.comment.commentWritten!)
                  : widget.comment.commentWritten!,
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
  final VoidCallback setRead;

  const DescriptionTextWidget({
    super.key,
    required this.text,
    required this.setRead,
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
            Provider.of<UserArticles>(context, listen: false).removeComment(
              comment.articleId!,
              user,
              comment,
            );
            Navigator.of(context).pop();
            CustomSnackBar.showSuccessSnackBar(
              context,
              message: "Comment Deleted!",
            );
          }
        } else if (value == 2) {
          await FirebaseDatabase.instance.ref('reports/comments').push().set({
            "userId": user.userId,
            "articleId": comment.articleId,
            "usersName": user.fullName,
            "commentId": comment.commentId,
            "writtenComment": comment.commentWritten,
            "reportedTime": DateTime.now().toString(),
          });
          CustomSnackBar.showSuccessSnackBar(
            context,
            message: "REST EASY, Comment is reported!",
          );
        }
      },
      itemBuilder: (context) => [
        if (user.userId == comment.commentorUserId)
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
