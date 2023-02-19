// ignore_for_file: use_build_context_synchronously, must_be_immutable

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:bakliwal_news_app/custome_icons_icons.dart';
import 'package:bakliwal_news_app/providers/news/most_upvoted.dart';
import 'package:bakliwal_news_app/providers/view/page_transiction_provider.dart';
import 'package:bakliwal_news_app/style/style_declaration.dart';
import 'package:bakliwal_news_app/models/user_information.dart';
import 'package:bakliwal_news_app/providers/user_account/user_account.dart';
import 'package:bakliwal_news_app/models/screen_enums.dart';
import 'package:bakliwal_news_app/view/news_card_shimmer.dart';
import 'package:bakliwal_news_app/widget/news_card/news_card.dart';
import 'package:bakliwal_news_app/models/news_article.dart';

class MostUpvotedScreen extends StatelessWidget {
  MostUpvotedScreen({super.key});

  UserInformation? userInformation;

  List<NewsArticle> mostUpvotedArticles = [];

  Future<void> loadData(context) async {
    final mostUpvotedDataRef = Provider.of<MostUpvoted>(context, listen: false);
    userInformation =
        Provider.of<UserAccount>(context, listen: false).personalInformation;
    await mostUpvotedDataRef.fetchAndSetmostUpvotedArticles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: FutureBuilder(
        future: loadData(context),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          mostUpvotedArticles = Provider.of<MostUpvoted>(context).mostUpvoted;
          return snapshot.connectionState == ConnectionState.waiting
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
              : mostUpvotedArticles.isEmpty
                  ? ifMostUpvotedEmpty(context)
                  : ifMostUpvotedNotEmpty();
        },
      ),
    );
  }

  Widget ifMostUpvotedNotEmpty() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 20.0, top: 30),
            child: Text(
              "Most Upvoted",
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: mostUpvotedArticles.length,
            itemBuilder: ((ctx, index) {
              return NewsCard(
                newsArticle: mostUpvotedArticles[index],
                userInformation: userInformation!,
                screenName: ScreenType.bookmarks,
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget ifMostUpvotedEmpty(BuildContext ctx) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(top: 40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              CustomeIcons.thumbs_up,
              size: 90,
              color: AppColors.secondary,
            ),
            const SizedBox(
              height: 20,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.0),
              child: Text(
                "Most Upvoted list is empty.",
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
                "There is no article with upvotes that can match the criteria or there is some problem while conneting database!.",
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
