import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:bakliwal_news_app/screens/auth_screen/login.dart';
import 'package:bakliwal_news_app/screens/secondary_screens/most_upvoted_screen.dart';
import 'package:bakliwal_news_app/screens/secondary_screens/reading_history_screen.dart';
import 'package:bakliwal_news_app/widget/view/bottom_navigation.dart';
import 'package:bakliwal_news_app/widget/view/burger_menue.dart';
import 'package:bakliwal_news_app/providers/view/page_transiction_provider.dart';
import 'package:bakliwal_news_app/screens/primary_screen/bookmark_screen.dart';
import 'package:bakliwal_news_app/screens/primary_screen/my_feed_screen.dart';
import 'package:bakliwal_news_app/screens/primary_screen/profile_screen.dart';
import 'package:bakliwal_news_app/screens/primary_screen/search_screen.dart';
import 'package:bakliwal_news_app/screens/secondary_screens/changelog_screen.dart';

class HomeViewScreen extends StatefulWidget {
  const HomeViewScreen({Key? key}) : super(key: key);

  static const routeName = "./home-view-screen";

  @override
  State<HomeViewScreen> createState() => _HomeViewScreenState();
}

class _HomeViewScreenState extends State<HomeViewScreen> {
  @override
  Widget build(BuildContext context) {
    int index = Provider.of<PageTransictionIndex>(context).index;
    void switchIndex(int index) {
      if (index == 0) {
        Navigator.of(context).pushNamed(ProfileScreen.routeName);
      }
      if (index == 7) {
        Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
      }
      setState(() {
        Provider.of<PageTransictionIndex>(
          context,
          listen: false,
        ).changeIndex(index);
      });
    }

    final screens = [
      {"screen": ProfileScreen(), "title": "Profile"},
      {"screen": MyFeedScreen(), "title": "Bakliwal News"},
      {"screen": const BookmarkScreen(), "title": "Bookmarks"},
      {"screen": const ChangelogeScreen(), "title": "Bakliwal News"},
      {"screen": MostUpvotedScreen(), "title": "Bakliwal News"},
      {"screen": const ReadingHistoryScreen(), "title": "Bakliwal News"},
      {"screen": const SearchScreen(), "title": "Search"},
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(screens[index]["title"] as String),
      ),
      drawer: const BurgerMennueDrawer(),
      body: screens[index]["screen"] as Widget,
      bottomNavigationBar: CustomBottomNavigation(
        switchIndex: switchIndex,
        index: index == 3 || index == 4 || index == 5 || index == 7 ? 1 : index,
      ),
    );
  }
}
