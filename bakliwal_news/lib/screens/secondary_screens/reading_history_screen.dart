// ignore_for_file: use_build_context_synchronously, unnecessary_null_comparison

import 'package:bakliwal_news/providers/news/articles.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:bakliwal_news/package_service/locator_service.dart';
import 'package:bakliwal_news/repository/auth_repo.dart';
import 'package:bakliwal_news/screens/secondary_screens/article_discription_screen.dart';
import 'package:bakliwal_news/models/all_read_articles.dart';
import 'package:bakliwal_news/models/user_information.dart';
import 'package:bakliwal_news/providers/user_account/user_account.dart';
import 'package:bakliwal_news/custome_icons_icons.dart';
import 'package:bakliwal_news/style/style_declaration.dart';
import 'package:bakliwal_news/view/news_card_shimmer.dart';
import 'package:bakliwal_news/providers/view/page_transiction_provider.dart';

class ReadingHistoryScreen extends StatefulWidget {
  const ReadingHistoryScreen({super.key});

  @override
  State<ReadingHistoryScreen> createState() => _ReadingHistoryScreenState();
}

class _ReadingHistoryScreenState extends State<ReadingHistoryScreen> {
  UserInformation? userInformation;

  List<AllReadArticles> readingHistoryArticles = [];

  Future<void> loadData(context) async {
    readingHistoryArticles = Provider.of<UserAccount>(context, listen: false)
        .personalInformation
        .articlesRead!;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: FutureBuilder(
        future: loadData(context),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          readingHistoryArticles.sort((a, b) => b.articleReadDateTime!
              .compareTo(a.articleReadDateTime as DateTime));
          return snapshot.connectionState == ConnectionState.waiting
              ? RefreshIndicator(
                  onRefresh: () => loadData(context),
                  child: SafeArea(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: 2,
                            itemBuilder: ((ctx, index) {
                              return const NewsCardShimmer();
                            }),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : readingHistoryArticles.isEmpty
                  ? ifReadingHistoryEmpty(context)
                  : ifReadingHistoryNotEmpty();
        },
      ),
    );
  }

  Widget ifReadingHistoryNotEmpty() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 20.0, top: 30),
            child: Text(
              "Reading History",
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: readingHistoryArticles.length,
            itemBuilder: ((ctx, index) {
              return ListTile(
                onTap: () async {
                  final article =
                      await Provider.of<Articles>(context, listen: false)
                          .fetchAndSetSpecificArticle(
                              readingHistoryArticles[index].idOfArticle!);
                  Navigator.of(context).pushNamed(
                      ArticleDiscriptionScreen.routeName,
                      arguments: article);
                },
                contentPadding: const EdgeInsets.all(10),
                leading: Stack(
                  alignment: AlignmentDirectional.centerStart,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 15),
                      width: 70,
                      height: 80,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                            readingHistoryArticles[index].articleImageUrl!,
                          ),
                        ),
                      ),
                    ),
                    Stack(
                      alignment: AlignmentDirectional.center,
                      children: [
                        const CircleAvatar(
                          radius: 16,
                          backgroundColor: AppColors.primary,
                        ),
                        readingHistoryArticles[index]
                                        .profilePictureUrlOfPublisher ==
                                    null ||
                                readingHistoryArticles[index]
                                    .profilePictureUrlOfPublisher!
                                    .isEmpty
                            ? const CircleAvatar(
                                radius: 12,
                                backgroundImage: AssetImage(
                                    "assets/images/profilePlaceholder.jpeg"),
                              )
                            : CircleAvatar(
                                radius: 12,
                                backgroundImage: NetworkImage(
                                  readingHistoryArticles[index]
                                      .profilePictureUrlOfPublisher!,
                                ),
                              ),
                      ],
                    )
                  ],
                ),
                title: Text(
                  readingHistoryArticles[index].titleOfArticle!,
                  style: const TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  DateFormat("yMMMd").format(
                    readingHistoryArticles[index].articlePublishDate!,
                  ),
                  style: const TextStyle(color: AppColors.secondary),
                ),
                trailing: CustomePopupMenue(
                  context: context,
                  authRepo: locator.get<AuthRepo>(),
                  articleId: readingHistoryArticles[index].idOfArticle!,
                  tabColor: AppColors.secondary,
                  loadData: loadData,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget ifReadingHistoryEmpty(BuildContext ctx) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(top: 40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              CustomeIcons.eye,
              size: 90,
              color: AppColors.secondary,
            ),
            const SizedBox(
              height: 20,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.0),
              child: Text(
                "Reading History list is empty.",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 35,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.0),
              child: Text(
                "You've not read any articles. Go ahead to the main feed and check some articles out!.",
                style: TextStyle(
                  color: AppColors.secondary,
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
              onPressed: () => Provider.of<PageTransictionIndex>(
                ctx,
                listen: false,
              ).changeIndex(1),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white),
                padding: MaterialStateProperty.all(
                  const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                ),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                )),
              ),
              child: const Text(
                "Back to feed",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomePopupMenue extends StatelessWidget {
  const CustomePopupMenue({
    super.key,
    required this.context,
    required this.authRepo,
    required this.articleId,
    required this.tabColor,
    required this.loadData,
  });

  final BuildContext context;
  final AuthRepo authRepo;
  final String articleId;
  final Color tabColor;
  final Future<void> Function(dynamic) loadData;

  @override
  Widget build(BuildContext context) {
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
          String? userId = Provider.of<UserAccount>(context, listen: false)
              .personalInformation
              .userId;
          await FirebaseDatabase.instance
              .ref()
              .child("users/$userId/articlesRead/$articleId")
              .remove();
          await authRepo.fetchAndSetUser(context: context);
          await loadData(context);
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
                "Remove article",
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
