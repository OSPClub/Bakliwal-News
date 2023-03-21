// ignore_for_file: use_build_context_synchronously, avoid_print
import 'package:bakliwal_news_admin/constants.dart';
import 'package:bakliwal_news_admin/widgets/view/comment_box.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:bakliwal_news_admin/providers/articles.dart';
import 'package:bakliwal_news_admin/package_service/locator_service.dart';
import 'package:bakliwal_news_admin/repository/auth_repo.dart';
import 'package:bakliwal_news_admin/models/user_information.dart';
import 'package:bakliwal_news_admin/providers/user_account/user_account.dart';
import 'package:bakliwal_news_admin/widgets/view/article_discription_appbar.dart';
import 'package:bakliwal_news_admin/style/style_declaration.dart';
import 'package:bakliwal_news_admin/models/news_articles.dart';

// ignore: must_be_immutable
class ArticleDiscriptionScreen extends StatelessWidget {
  ArticleDiscriptionScreen({super.key});

  static const routeName = "./article-discription-screen";

  int readFunctionFired = 0;
  final commentFormKey = GlobalKey<FormState>();

  TextEditingController commentController = TextEditingController();

  Future<void> reloadData(context) async {
    final articlesDataRef = Provider.of<Articles>(context, listen: false);
    await locator.get<AuthRepo>().fetchAndSetUser(context: context);
    await articlesDataRef.fetchAndSetArticles();
  }

  @override
  Widget build(BuildContext context) {
    NewsArticle newsArticle =
        ModalRoute.of(context)!.settings.arguments as NewsArticle;

    // ignore: unused_local_variable
    UserInformation userInformation = Provider.of<UserAccount>(
      context,
      listen: false,
    ).personalInformation;

    final userInformaion =
        Provider.of<UserAccount>(context, listen: false).personalInformation;
    final isUser = userInformaion.userId != "default";
    return Scaffold(
      backgroundColor: bgColor,
      body: isUser
          ? CommentBox(
              userImage: userInformaion.profilePicture,
              labelText: 'Start the discussion...',
              withBorder: false,
              errorText: 'Comment cannot be blank',
              sendButtonMethod: () async {
                if (commentFormKey.currentState!.validate()) {
                  final commentSetRef = FirebaseDatabase.instance
                      .ref()
                      .child("comments/${newsArticle.articlesId}/")
                      .push();
                  final commentSetUniqueKey = commentSetRef.key;
                  await commentSetRef.set({
                    "commentWritten": commentController.text,
                    "timeOfComment": DateTime.now().toString(),
                    "commentorUserId": userInformaion.userId,
                  });
                  await FirebaseDatabase.instance
                      .ref()
                      .child("users/${userInformaion.userId}/comments/")
                      .push()
                      .set({
                    "articleId": newsArticle.articlesId,
                    "commentId": commentSetUniqueKey,
                  });
                  await Provider.of<Articles>(context, listen: false)
                      .fetchAndSetArticles();
                  FocusScope.of(context).unfocus();
                  commentController.clear();
                } else {
                  print("Not validated");
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
                constNewsArticle: newsArticle,
                loadData: reloadData,
              ),
            )
          : MainDescriptionContent(
              constNewsArticle: newsArticle,
              loadData: reloadData,
            ),
    );
  }
}

class MainDescriptionContent extends StatelessWidget {
  const MainDescriptionContent({
    Key? key,
    required this.constNewsArticle,
    required this.loadData,
  }) : super(key: key);
  final NewsArticle constNewsArticle;
  final Future<void> Function(dynamic) loadData;

  @override
  Widget build(
    BuildContext context,
  ) {
    final newsArticle = Provider.of<Articles>(context).newsArticles.firstWhere(
        (article) => article.articlesId == constNewsArticle.articlesId,
        orElse: () => constNewsArticle);
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding:
              const EdgeInsets.only(top: 15, left: 25, right: 25, bottom: 50),
          child: Column(
            children: [
              ArticleDiscriptionAppBar(
                newsArticle: newsArticle,
                reload: loadData,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.arrow_upward_rounded,
                      color:
                          // isUpvoted
                          //     ? Colors.green
                          // :
                          AppColors.secondary,
                      size: 25,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.comment_outlined,
                      color: AppColors.secondary,
                      size: 25,
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
              const Divider(
                color: AppColors.secondary,
              ),
              const SizedBox(
                height: 15,
              ),
              if (newsArticle.comments != null)
                ...newsArticle.comments!
                    .map(
                      (comment) => ArticleComments(
                        comment: comment,
                      ),
                    )
                    .toList(),
            ],
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
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
              child: ClipRRect(
                borderRadius: BorderRadius.circular(7),
                child: Image(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                    comment.commentorUserProfilePicture!,
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
                  comment.commentorUserName!,
                  style: const TextStyle(color: Colors.white),
                ),
                Text(
                  DateFormat("MMMd").format(
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
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey[900],
          ),
          margin: const EdgeInsets.symmetric(vertical: 10),
          padding: const EdgeInsets.all(15),
          child: Text(
            comment.commentWritten!,
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
        //   children: [IconButton(onPressed: () {}, icon: const Icon(Icons.add))],
        // )
      ],
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
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  flag ? ("${firstHalf!}...") : (firstHalf! + secondHalf!),
                  style: const TextStyle(
                    color: Colors.white70,
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
