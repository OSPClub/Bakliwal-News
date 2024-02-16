import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:bakliwal_news_admin/controllers/menu_controller.dart' as menu;
import 'package:bakliwal_news_admin/screens/reports/report_screen.dart';
import 'package:bakliwal_news_admin/responsive.dart';
import 'package:bakliwal_news_admin/screens/settings/settings_screen.dart';
import 'package:bakliwal_news_admin/screens/suggestions/suggestion_screen.dart';
import 'package:bakliwal_news_admin/screens/users/users_screen.dart';
import 'package:bakliwal_news_admin/screens/articles/article_screen.dart';
import 'package:bakliwal_news_admin/screens/dashboard/dashboard_screen.dart';
import 'package:bakliwal_news_admin/screens/main/components/side_menu.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  static const routeName = "/main-screen";

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentPage = 1;
  List<Widget> screens = [
    const DashboardScreen(),
    const ArticlesScreen(),
    const SuggestedArticlesScreen(),
    const UsersScreen(),
    const ReportScreen(),
    const SettingsScreen(),
  ];

  void currentPageIndex(int pageIndex) {
    setState(() {
      currentPage = pageIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: context.read<menu.MenuController>().scaffoldKey,
      drawer: SideMenu(
        currentPage: currentPage,
        changePage: currentPageIndex,
        isMobileMenue: true,
      ),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (Responsive.isDesktop(context))
              Expanded(
                child: SideMenu(
                  currentPage: currentPage,
                  changePage: currentPageIndex,
                  isMobileMenue: false,
                ),
              ),
            Expanded(
              flex: 5,
              child: screens[currentPage],
            ),
          ],
        ),
      ),
    );
  }
}
