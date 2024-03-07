// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:bakliwal_news/models/user_information.dart';
import 'package:bakliwal_news/providers/user_account/user_account.dart';
import 'package:bakliwal_news/custome_icons_icons.dart';
import 'package:bakliwal_news/style/style_declaration.dart';
import 'package:bakliwal_news/models/screen_enums.dart';
import 'package:bakliwal_news/view/news_card_shimmer.dart';
import 'package:bakliwal_news/widget/news_card/user_news_card.dart';
import 'package:bakliwal_news/models/user_article.dart';
import 'package:bakliwal_news/providers/news/changelogs.dart';
import 'package:bakliwal_news/providers/view/page_transiction_provider.dart';

class ChangelogeScreen extends StatefulWidget {
  const ChangelogeScreen({super.key});

  @override
  State<ChangelogeScreen> createState() => _ChangelogeScreenState();
}

class _ChangelogeScreenState extends State<ChangelogeScreen> {
  bool isLoading = false;
  List<UserArticle> allChnagelogArticles = [];
  UserInformation? userInformation;

  @override
  void initState() {
    super.initState();
    loadData(context);
  }

  Future<void> loadData(context) async {
    setState(() {
      isLoading = true;
    });
    userInformation =
        Provider.of<UserAccount>(context, listen: false).personalInformation;
    await Future.delayed(const Duration(seconds: 2));

    allChnagelogArticles = Provider.of<Changelogs>(
      context,
      listen: false,
    ).changelogs;
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: isLoading
          ? SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 20.0, top: 30),
                      child: Text(
                        "Changelogs",
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
              ),
            )
          : allChnagelogArticles.isEmpty
              ? ifChangelogsEmpty(context)
              : ifChangelogsNotEmpty(),
    );
  }

  Widget ifChangelogsNotEmpty() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 20.0, top: 30),
            child: Text(
              "Changelogs",
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: allChnagelogArticles.length,
            itemBuilder: ((ctx, index) {
              return UserNewsCard(
                newsArticle: allChnagelogArticles[index],
                userInformation: userInformation!,
                screenName: ScreenType.bookmarks,
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget ifChangelogsEmpty(BuildContext ctx) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(top: 40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              CustomeIcons.terminal,
              size: 90,
              color: AppColors.secondary,
            ),
            const SizedBox(
              height: 20,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.0),
              child: Text(
                "Changelogs list is empty.",
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
                "There is no change in the Application. This could change in the future so stay tuned!.",
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
