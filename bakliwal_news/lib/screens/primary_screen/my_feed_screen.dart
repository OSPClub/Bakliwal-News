// ignore_for_file: use_build_context_synchronously, must_be_immutable

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:bakliwal_news/custome_icons_icons.dart';
import 'package:bakliwal_news/models/settings_model.dart';
import 'package:bakliwal_news/providers/settings_const.dart';
import 'package:bakliwal_news/style/style_declaration.dart';
import 'package:bakliwal_news/models/user_information.dart';
import 'package:bakliwal_news/package_service/locator_service.dart';
import 'package:bakliwal_news/providers/user_account/user_account.dart';
import 'package:bakliwal_news/repository/auth_repo.dart';
import 'package:bakliwal_news/models/screen_enums.dart';
import 'package:bakliwal_news/view/news_card_shimmer.dart';
import 'package:bakliwal_news/widget/news_card/news_card.dart';
import 'package:bakliwal_news/models/news_article.dart';
import 'package:bakliwal_news/providers/news/articles.dart';

class MyFeedScreen extends StatefulWidget {
  const MyFeedScreen({super.key});

  @override
  State<MyFeedScreen> createState() => _MyFeedScreenState();
}

class _MyFeedScreenState extends State<MyFeedScreen> {
  UserInformation? userInformation;
  Appsettings? settings;
  ScrollController paginationScrollController = ScrollController();
  List<NewsArticle> allArticles = [];
  bool gettingMoreArticles = false;
  bool moreArticlesAvailable = true;

  Future<void> loadData(context) async {
    settings = Provider.of<ConstSettings>(context, listen: false).constSettings;
    if (!settings!.enableLogin!) {
      FirebaseAuth.instance.signOut();
      Provider.of<UserAccount>(context, listen: false)
          .resetDefaultAccountData();
    }
    await locator.get<AuthRepo>().fetchAndSetUser(context: context);
    userInformation =
        Provider.of<UserAccount>(context, listen: false).personalInformation;
    final articlesDataRef = Provider.of<Articles>(context, listen: false);
    articlesDataRef.setFetchLogicToDefault();
    await articlesDataRef.fetchAndSetInitArticles();
  }

  @override
  void initState() {
    paginationScrollController.addListener(() {
      double maxScroll = paginationScrollController.position.maxScrollExtent;
      double currentScroll = paginationScrollController.position.pixels;
      double threshold = MediaQuery.of(context).size.height * 0.25;

      if (maxScroll - currentScroll <= threshold) {
        final articlesDataRef = Provider.of<Articles>(context, listen: false);
        articlesDataRef.fetchAndSetMoreArticles();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: FutureBuilder(
        future: loadData(context),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          allArticles = Provider.of<Articles>(context).newsArticles;
          moreArticlesAvailable =
              Provider.of<Articles>(context).moreArticlesAvailable;
          gettingMoreArticles =
              Provider.of<Articles>(context).gettingMoreArticles;

          return snapshot.connectionState == ConnectionState.waiting ||
                  allArticles.isEmpty
              ? SafeArea(
                  child: progressShimer(),
                )
              : allArticles.isEmpty
                  ? ifArticlesEmpty(context)
                  : ifArticlesPresent(
                      loadData, context, paginationScrollController);
        },
      ),
    );
  }

  SingleChildScrollView progressShimer() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 20.0, top: 30),
            child: Text(
              "My Feed",
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
          const SizedBox(
            height: 25,
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
    );
  }

  Widget ifArticlesPresent(
      loadData, context, ScrollController paginationScrollController) {
    return RefreshIndicator(
      onRefresh: () => loadData(context),
      child: SingleChildScrollView(
        controller: paginationScrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 20.0, top: 30),
              child: Text(
                "My Feed",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: allArticles.length,
              itemBuilder: ((ctx, index) {
                return NewsCard(
                  key: UniqueKey(),
                  newsArticle: allArticles[index],
                  userInformation: userInformation,
                  screenName: ScreenType.myFeeds,
                );
              }),
            ),
            if (gettingMoreArticles) const NewsCardShimmer(),
            if (!moreArticlesAvailable)
              const Padding(
                padding: EdgeInsets.all(30),
                child: Center(
                    child: Text(
                  "No More Articles!!",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                )),
              ),
          ],
        ),
      ),
    );
  }

  Widget ifArticlesEmpty(BuildContext ctx) {
    return const SizedBox(
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.only(top: 40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              CustomeIcons.home,
              size: 90,
              color: AppColors.secondary,
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.0),
              child: Text(
                "The Feed is Empty.",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 35,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.0),
              child: Text(
                "Something went wrong or there are no feed to show you for this movement.",
                style: TextStyle(
                  color: AppColors.secondary,
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
