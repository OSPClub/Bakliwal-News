// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:bakliwal_news/models/user_information.dart';
import 'package:bakliwal_news/providers/user_account/user_account.dart';
import 'package:bakliwal_news/models/screen_enums.dart';
import 'package:bakliwal_news/view/news_card_shimmer.dart';
import 'package:bakliwal_news/widget/news_card/user_news_card.dart';
import 'package:bakliwal_news/models/user_article.dart';
import 'package:bakliwal_news/providers/news/user_bookmarks.dart';
import 'package:bakliwal_news/providers/view/page_transiction_provider.dart';
import 'package:bakliwal_news/style/style_declaration.dart';

class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({super.key});

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  List<UserArticle> allBookmarks = [];
  UserInformation? userInformation;

  Future<void> loadData(context) async {
    userInformation =
        Provider.of<UserAccount>(context, listen: false).personalInformation;
    await Provider.of<UserBookmarks>(context, listen: false)
        .fetchAndSetBookmarks(context);
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: FutureBuilder(
        future: loadData(context),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          allBookmarks = Provider.of<UserBookmarks>(context).bookmarks;
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
              : allBookmarks.isEmpty
                  ? ifBookmarksEmpty(context)
                  : ifBookmarksNotEmpty();
        },
      ),
    );
  }

  Widget ifBookmarksNotEmpty() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: allBookmarks.length,
            itemBuilder: ((ctx, index) {
              return UserNewsCard(
                newsArticle: allBookmarks[index],
                userInformation: userInformation!,
                screenName: ScreenType.bookmarks,
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget ifBookmarksEmpty(BuildContext ctx) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(top: 40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.bookmark_border_rounded,
              size: 90,
              color: AppColors.secondary,
            ),
            const SizedBox(
              height: 20,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.0),
              child: Text(
                "Your bookmark list is empty.",
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
                "Go back to your feed and bookmark posts you'd like or read later. Each post tou bookmark will be stored here.",
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
