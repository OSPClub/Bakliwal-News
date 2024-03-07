import 'package:bakliwal_news/screens/secondary_screens/public_article_canonical.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:bakliwal_news/firebase_options.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:bakliwal_news/providers/news/public_articles.dart';
import 'package:bakliwal_news/screens/primary_screen/aboutus_screen.dart';
import 'package:bakliwal_news/package_service/locator_service.dart';
import 'package:bakliwal_news/providers/settings_const.dart';
import 'package:bakliwal_news/providers/news/changelogs.dart';
import 'package:bakliwal_news/providers/news/reading_history.dart';
import 'package:bakliwal_news/providers/user_account/user_account.dart';
import 'package:bakliwal_news/providers/view/page_transiction_provider.dart';
import 'package:bakliwal_news/providers/news/user_articles.dart';
import 'package:bakliwal_news/providers/news/user_bookmarks.dart';
import 'package:bakliwal_news/view/home_view_screen.dart';
import 'package:bakliwal_news/screens/secondary_screens/submit_article_screen.dart';
import 'package:bakliwal_news/screens/auth_screen/login.dart';
import 'package:bakliwal_news/screens/secondary_screens/account_details_screen.dart';
import 'package:bakliwal_news/screens/primary_screen/profile_screen.dart';
import 'package:bakliwal_news/screens/secondary_screens/user_article_canonical.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupServices();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const BakliwalNews());
}

class BakliwalNews extends StatelessWidget {
  const BakliwalNews({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => PageTransictionIndex(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => UserArticles(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => UserBookmarks(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Changelogs(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => ReadingHistory(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => UserAccount(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => ConstSettings(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => PublicArticles(),
        ),
      ],
      child: ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          Provider.of<ConstSettings>(
            context,
            listen: false,
          ).fetchAndSetConstSettings();
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              textTheme:
                  GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
              appBarTheme: AppBarTheme(
                elevation: 1,
                shadowColor: Colors.grey,
                centerTitle: true,
                iconTheme: IconThemeData(color: Colors.blueGrey[200]),
                titleTextStyle: const TextStyle(
                  color: Colors.white,
                  fontFamily: "Silkscreen",
                  fontWeight: FontWeight.w400,
                ),
                color: const Color.fromARGB(255, 0, 0, 0),
              ),
              primaryTextTheme: const TextTheme(
                displayMedium: TextStyle(
                  fontFamily: "Silkscreen",
                ),
              ),
              colorScheme: ColorScheme.fromSwatch(
                accentColor: Colors.purple,
              ).copyWith(
                primary: const Color.fromARGB(255, 0, 0, 0),
                secondary: const Color.fromARGB(255, 54, 54, 54),
              ),
            ),
            title: "Bakliwal News",
            initialRoute: HomeViewScreen.routeName,
            routes: {
              HomeViewScreen.routeName: (ctx) => const HomeViewScreen(),
              UserArticleCanonical.routeName: (ctx) =>
                  const UserArticleCanonical(),
              PublicArticleCanonical.routeName: (ctx) =>
                  const PublicArticleCanonical(),
              ProfileScreen.routeName: (ctx) => const ProfileScreen(),
              AccountDetailsScreen.routeName: (ctx) =>
                  const AccountDetailsScreen(),
              LoginScreen.routeName: (ctx) => const LoginScreen(),
              SubmitArticleScreen.routeName: (ctx) =>
                  const SubmitArticleScreen(),
              AboutUsScreen.routeName: (ctx) => const AboutUsScreen(),
            },
          );
        },
      ),
    );
  }
}
