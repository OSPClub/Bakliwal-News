// ignore_for_file: use_build_context_synchronously, must_be_immutable

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:bakliwal_news_app/custome_icons_icons.dart';
import 'package:bakliwal_news_app/models/settings_model.dart';
import 'package:bakliwal_news_app/providers/settings_const.dart';
import 'package:bakliwal_news_app/style/style_declaration.dart';
import 'package:bakliwal_news_app/models/user_information.dart';
import 'package:bakliwal_news_app/package_service/locator_service.dart';
import 'package:bakliwal_news_app/providers/user_account/user_account.dart';
import 'package:bakliwal_news_app/repository/auth_repo.dart';
import 'package:bakliwal_news_app/models/screen_enums.dart';
import 'package:bakliwal_news_app/view/news_card_shimmer.dart';
import 'package:bakliwal_news_app/widget/news_card/news_card.dart';
import 'package:bakliwal_news_app/models/news_article.dart';
import 'package:bakliwal_news_app/providers/news/articles.dart';

class MyFeedScreen extends StatelessWidget {
  MyFeedScreen({super.key});

  UserInformation? userInformation;
  Settings? settings;

  List<NewsArticle> allArticles = [];

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
    await articlesDataRef.fetchAndSetArticles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: FutureBuilder(
        future: loadData(context),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          allArticles = Provider.of<Articles>(context).newsArticles;
          return snapshot.connectionState == ConnectionState.waiting ||
                  allArticles.isEmpty
              ? SafeArea(
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
                )
              : allArticles.isEmpty
                  ? ifArticlesEmpty(context)
                  : ifArticlesNotEmpty(loadData, context);
        },
      ),
    );
  }

  Widget ifArticlesNotEmpty(loadData, context) {
    return RefreshIndicator(
      onRefresh: () => loadData(context),
      child: SingleChildScrollView(
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
          ],
        ),
      ),
    );
  }

  Widget ifArticlesEmpty(BuildContext ctx) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(top: 40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
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
