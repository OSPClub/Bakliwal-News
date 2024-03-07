import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:bakliwal_news/screens/primary_screen/public_feed_screen.dart';
import 'package:bakliwal_news/screens/auth_screen/login.dart';
import 'package:bakliwal_news/screens/secondary_screens/reading_history_screen.dart';
import 'package:bakliwal_news/widget/view/bottom_navigation.dart';
import 'package:bakliwal_news/widget/view/burger_menue.dart';
import 'package:bakliwal_news/providers/view/page_transiction_provider.dart';
import 'package:bakliwal_news/screens/primary_screen/bookmark_screen.dart';
import 'package:bakliwal_news/screens/primary_screen/user_feed_screen.dart';
import 'package:bakliwal_news/screens/primary_screen/profile_screen.dart';
import 'package:bakliwal_news/screens/secondary_screens/changelog_screen.dart';

class HomeViewScreen extends StatefulWidget {
  const HomeViewScreen({super.key});

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
      {"screen": const ProfileScreen(), "title": "Profile"},
      {"screen": const UserFeedScreen(), "title": "Bakliwal News"},
      {"screen": const BookmarkScreen(), "title": "Bookmarks"},
      {"screen": const PublicFeedScreen(), "title": "Bakliwal News"},
      {"screen": const ChangelogeScreen(), "title": "Bakliwal News"},
      {"screen": const ReadingHistoryScreen(), "title": "Bakliwal News"},
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
