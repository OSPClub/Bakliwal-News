// ignore_for_file: use_build_context_synchronously, must_be_immutable
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import 'package:bakliwal_news/models/public_article_model.dart';
import 'package:bakliwal_news/widget/news_card/public_news_card.dart';
import 'package:bakliwal_news/models/settings_model.dart';
import 'package:bakliwal_news/providers/settings_const.dart';
import 'package:bakliwal_news/style/style_declaration.dart';
import 'package:bakliwal_news/models/user_information.dart';
import 'package:bakliwal_news/view/news_card_shimmer.dart';
import 'package:bakliwal_news/providers/news/public_articles.dart';
import 'package:bakliwal_news/providers/user_account/user_account.dart';
import 'package:bakliwal_news/models/screen_enums.dart';

class PublicFeedScreen extends StatefulWidget {
  const PublicFeedScreen({super.key});

  @override
  State<PublicFeedScreen> createState() => _PublicFeedScreenState();
}

class _PublicFeedScreenState extends State<PublicFeedScreen> {
  UserInformation? userInformation;
  Appsettings? settings;
  List<PublicArticle> allArticles = [];
  List<ArticleTags> fetchedTags = [];
  bool gettingMoreArticles = false;
  bool moreArticlesAvailable = true;
  ScrollController paginationScrollController = ScrollController();
  TextEditingController tagSerachPlaceHolder = TextEditingController();

  // bool selected = false;
  final List<Filter> chipsList = [
    Filter(label: "Popular", isSelected: true),
    Filter(label: "Latest", isSelected: false),
  ];

  Future<void> loadData(context) async {
    settings = Provider.of<ConstSettings>(context, listen: false).constSettings;
    if (!settings!.enableLogin!) {
      FirebaseAuth.instance.signOut();
      Provider.of<UserAccount>(context, listen: false)
          .resetDefaultAccountData();
    }
    userInformation =
        Provider.of<UserAccount>(context, listen: false).personalInformation;
    final articlesDataRef = Provider.of<PublicArticles>(context, listen: false);
    articlesDataRef.setFetchLogicToDefault();
    await articlesDataRef.fetchAndSetInitArticles();
    await Provider.of<PublicArticles>(context, listen: false)
        .fetchAndSetArticleTags();
    fetchedTags =
        Provider.of<PublicArticles>(context, listen: false).fetchedArticleTags;
  }

  @override
  void initState() {
    paginationScrollController.addListener(() {
      double maxScroll = paginationScrollController.position.maxScrollExtent;
      double currentScroll = paginationScrollController.position.pixels;
      double threshold = MediaQuery.of(context).size.height * 0.40;

      if (maxScroll - currentScroll <= threshold) {
        final articlesDataRef =
            Provider.of<PublicArticles>(context, listen: false);
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
          allArticles = Provider.of<PublicArticles>(context).newsArticles;
          moreArticlesAvailable =
              Provider.of<PublicArticles>(context).moreArticlesAvailable;
          gettingMoreArticles =
              Provider.of<PublicArticles>(context).gettingMoreArticles;

          return SingleChildScrollView(
            controller: paginationScrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 20.0, top: 30),
                  child: Text(
                    "Public Feed",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        ...techChips(),
                        const SizedBox(
                          width: 8,
                        ),
                        TypeAheadField<ArticleTags>(
                          hideKeyboardOnDrag: true,
                          suggestionsCallback: (search) {
                            List<ArticleTags> result = [];

                            result = fetchedTags
                                .where((tag) => tag.name
                                    .toLowerCase()
                                    .contains(search.toLowerCase()))
                                .toList();
                            return result;
                          },
                          builder: (context, controller, focusNode) {
                            tagSerachPlaceHolder = controller;
                            return SizedBox(
                              width: 130,
                              child: TextField(
                                controller: controller,
                                autofocus: false,
                                focusNode: focusNode,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide:
                                        const BorderSide(color: Colors.white),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: const BorderSide(
                                        color: AppColors.accent),
                                  ),
                                  labelText: 'Tag',
                                  labelStyle: const TextStyle(
                                    color: Colors.white,
                                  ),
                                  suffixIcon: focusNode.hasFocus ||
                                          controller.text.isNotEmpty
                                      ? IconButton(
                                          color: Colors.white,
                                          onPressed: () {
                                            controller.clear();
                                            tagSerachPlaceHolder.clear();
                                            FocusScopeNode currentFocus =
                                                FocusScope.of(context);

                                            if (!currentFocus.hasPrimaryFocus) {
                                              currentFocus.unfocus();
                                            }
                                            setState(() {
                                              Provider.of<PublicArticles>(
                                                      context,
                                                      listen: false)
                                                  .switchApiTag('');
                                            });
                                            chipsList[0].isSelected = true;
                                          },
                                          icon: const Icon(Icons.clear),
                                        )
                                      : null,
                                ),
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                                strutStyle: const StrutStyle(
                                  height: 0.5,
                                  forceStrutHeight: true,
                                ),
                              ),
                            );
                          },
                          itemBuilder: (context, tag) {
                            return ListTile(
                              title: Text(tag.name),
                            );
                          },
                          onSelected: (tag) {
                            FocusScopeNode currentFocus =
                                FocusScope.of(context);

                            if (!currentFocus.hasPrimaryFocus) {
                              currentFocus.unfocus();
                            }
                            tagSerachPlaceHolder.text = tag.name;

                            setState(() {
                              Provider.of<PublicArticles>(context,
                                      listen: false)
                                  .switchApiTag(tag.name);
                            });
                            chipsList[0].isSelected = false;
                            chipsList[1].isSelected = false;
                          },
                          emptyBuilder: (context) {
                            return InkWell(
                              onTap: () {
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());

                                setState(() {
                                  Provider.of<PublicArticles>(context,
                                          listen: false)
                                      .switchApiTag(tagSerachPlaceHolder.text);
                                });
                                chipsList[0].isSelected = false;
                                chipsList[1].isSelected = false;
                              },
                              child: ListTile(
                                title: Text(tagSerachPlaceHolder.text),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ), // ),
                snapshot.connectionState == ConnectionState.waiting
                    ? SafeArea(
                        child: progressShimer(),
                      )
                    : allArticles.isEmpty
                        ? ifArticlesEmpty(context)
                        : ifArticlesPresent(
                            loadData, context, paginationScrollController),
              ],
            ),
          );
        },
      ),
    );
  }

  ListView progressShimer() {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 2,
      itemBuilder: ((ctx, index) {
        return const NewsCardShimmer();
      }),
    );
  }

  Widget ifArticlesPresent(
      loadData, context, ScrollController paginationScrollController) {
    return RefreshIndicator(
      onRefresh: () => loadData(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: allArticles.length,
            itemBuilder: ((ctx, index) {
              return PublicNewsCard(
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
              Icons.public,
              size: 90,
              color: AppColors.secondary,
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.0),
              child: Text(
                "No article to show.",
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
                "Something went wrong or there are no article available.",
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

  List<Widget> techChips() {
    List<Widget> chips = [];
    for (int i = 0; i < chipsList.length; i++) {
      Widget item = Padding(
        padding: const EdgeInsets.only(left: 5, right: 2.5),
        child: FilterChip(
          label: Text(chipsList[i].label),
          labelStyle: const TextStyle(color: Colors.white),
          backgroundColor: AppColors.shadowColors,
          disabledColor: AppColors.accent,
          selected: chipsList[i].isSelected,
          onSelected: (bool value) {
            setState(() {
              final publicProviderRef =
                  Provider.of<PublicArticles>(context, listen: false);
              if (i != 0) {
                chipsList[0].isSelected = false;
                chipsList[1].isSelected = true;
                publicProviderRef.setFetchLogicToDefault;
                publicProviderRef.switchApiPath('articles/latest');
                publicProviderRef.switchApiTag('');
              } else if (i != 1) {
                chipsList[1].isSelected = false;
                chipsList[0].isSelected = true;
                Provider.of<PublicArticles>(context, listen: false)
                    .switchApiPath('articles');
                publicProviderRef.switchApiTag('');
              } else {
                chipsList[0].isSelected = true;
                Provider.of<PublicArticles>(context, listen: false)
                    .switchApiPath('articles');
                publicProviderRef.switchApiTag('');
              }
            });
          },
        ),
      );
      chips.add(item);
    }
    return chips;
  }
}
