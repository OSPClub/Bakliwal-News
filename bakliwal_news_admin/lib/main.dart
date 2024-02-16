import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:bakliwal_news_admin/constants.dart';
import 'package:bakliwal_news_admin/providers/users.dart';
import 'package:bakliwal_news_admin/firebase_options.dart';
import 'package:bakliwal_news_admin/providers/articles.dart';
import 'package:bakliwal_news_admin/repository/auth_repo.dart';
import 'package:bakliwal_news_admin/screens/main/main_screen.dart';
import 'package:bakliwal_news_admin/screens/auth_screen/login.dart';
import 'package:bakliwal_news_admin/controllers/menu_controller.dart' as menu;
import 'package:bakliwal_news_admin/screens/profile/profile_screen.dart';
import 'package:bakliwal_news_admin/package_service/locator_service.dart';
import 'package:bakliwal_news_admin/providers/user_account/user_account.dart';
import 'package:bakliwal_news_admin/providers/user_account/reports_provider.dart';
import 'package:bakliwal_news_admin/screens/profile/account_details_screen.dart';
import 'package:bakliwal_news_admin/screens/secondary_screens/submit_article_screen.dart';
import 'package:bakliwal_news_admin/screens/secondary_screens/article_discription_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupServices();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const BakliwalNewsAdmin());
}

class BakliwalNewsAdmin extends StatelessWidget {
  const BakliwalNewsAdmin({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => menu.MenuController(),
        ),
        ChangeNotifierProvider(
          create: (context) => Articles(),
        ),
        ChangeNotifierProvider(
          create: (context) => Users(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => UserAccount(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => ReportsProvider(),
        ),
      ],
      child: ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Admin Panel',
            theme: ThemeData.dark().copyWith(
              scaffoldBackgroundColor: bgColor,
              textTheme:
                  GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
                      .apply(bodyColor: Colors.white),
              canvasColor: secondaryColor,
            ),
            home: StreamBuilder(
              stream: FirebaseAuth.instance.userChanges(),
              builder: ((ctx, userSnapshot) {
                if (userSnapshot.hasData) {
                  locator.get<AuthRepo>().fetchAndSetUser(context: context);
                  return const MainScreen();
                }
                return const LoginScreen();
              }),
            ),
            routes: {
              LoginScreen.routeName: (ctx) => const LoginScreen(),
              MainScreen.routeName: (ctx) => const MainScreen(),
              ArticleDiscriptionScreen.routeName: (ctx) =>
                  const ArticleDiscriptionScreen(),
              SubmitArticleScreen.routeName: (ctx) =>
                  const SubmitArticleScreen(),
              ProfileScreen.routeName: (ctx) => const ProfileScreen(),
              AccountDetailsScreen.routeName: (ctx) =>
                  const AccountDetailsScreen(),
            },
          );
        },
      ),
    );
  }
}
