// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:bakliwal_news_app/models/settings_model.dart';
import 'package:bakliwal_news_app/providers/settings_const.dart';
import 'package:bakliwal_news_app/screens/secondary_screens/submit_article_screen.dart';
import 'package:bakliwal_news_app/widget/view/custome_snackbar.dart';
import 'package:bakliwal_news_app/view/home_view_screen.dart';
import 'package:bakliwal_news_app/package_service/locator_service.dart';
import 'package:bakliwal_news_app/repository/auth_repo.dart';
import 'package:bakliwal_news_app/custome_icons_icons.dart';
import 'package:bakliwal_news_app/screens/auth_screen/login.dart';
import 'package:bakliwal_news_app/screens/primary_screen/profile_screen.dart';
import 'package:bakliwal_news_app/screens/primary_screen/aboutus_screen.dart';
import 'package:bakliwal_news_app/screens/secondary_screens/account_details_screen.dart';
import 'package:bakliwal_news_app/models/user_information.dart';
import 'package:bakliwal_news_app/providers/view/page_transiction_provider.dart';
import 'package:bakliwal_news_app/providers/user_account/user_account.dart';
import 'package:bakliwal_news_app/style/style_declaration.dart';

class BurgerMennueDrawer extends StatelessWidget {
  const BurgerMennueDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    UserInformation? userInformation =
        Provider.of<UserAccount>(context).personalInformation;
    Settings settings = Provider.of<ConstSettings>(context).constSettings;
    AuthRepo _authRepo = locator.get<AuthRepo>();
    double tabsFontSize = 20;
    double spaceBetweenTabs = 12;
    Color tabColor = Colors.white70;

    return SafeArea(
      child: Drawer(
        width: MediaQuery.of(context).size.width * 0.8,
        backgroundColor: AppColors.accent,
        child: Padding(
          padding: const EdgeInsets.only(
            left: 20,
            top: 18.0,
            bottom: 20,
            right: 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  userInformation.userId != "default"
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                userInformation.profilePicture == null ||
                                        userInformation.profilePicture!.isEmpty
                                    ? ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: const Image(
                                          fit: BoxFit.cover,
                                          height: 50,
                                          width: 50,
                                          image: AssetImage(
                                              "assets/images/profilePlaceholder.jpeg"),
                                        ),
                                      )
                                    : ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: Image(
                                          fit: BoxFit.cover,
                                          height: 50,
                                          width: 50,
                                          image: NetworkImage(
                                            userInformation.profilePicture!,
                                          ),
                                        ),
                                      ),
                                customePopupMenue(
                                  context,
                                  userInformation,
                                  _authRepo,
                                  tabColor,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              userInformation.fullName.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(
                              height: 2,
                            ),
                            Text(
                              "@${userInformation.userName}",
                              style: const TextStyle(
                                color: Colors.white60,
                              ),
                            ),
                          ],
                        )
                      : Container(
                          padding: const EdgeInsets.only(top: 20),
                          child: ElevatedButton(
                            onPressed: () {
                              if (!settings.enableLogin!) {
                                Navigator.of(context).pop();
                                CustomSnackBar.showErrorSnackBar(context,
                                    message: "Login & signup are disable!");
                              } else {
                                Navigator.of(context).pushReplacementNamed(
                                  LoginScreen.routeName,
                                );
                              }
                            },
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(AppColors.primary),
                              padding: MaterialStateProperty.all(
                                const EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 30),
                              ),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              )),
                            ),
                            child: const Text(
                              "Sign In",
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                  const SizedBox(
                    height: 50,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                      Provider.of<PageTransictionIndex>(context, listen: false)
                          .changeIndex(1);
                    },
                    child: Row(
                      children: [
                        Icon(
                          CustomeIcons.home,
                          color: tabColor,
                          size: tabsFontSize,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          "My feed",
                          style: TextStyle(
                            color: tabColor,
                            fontSize: tabsFontSize,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // SizedBox(
                  //   height: spaceBetweenTabs,
                  // ),
                  // InkWell(
                  //   onTap: () {
                  //     Navigator.of(context).pop();
                  //     Provider.of<PageTransictionIndex>(context, listen: false)
                  //         .changeIndex(4);
                  //   },
                  //   child: Row(
                  //     children: [
                  //       Icon(
                  //         Icons.arrow_upward_rounded,
                  //         color: tabColor,
                  //         size: tabsFontSize,
                  //       ),
                  //       const SizedBox(
                  //         width: 10,
                  //       ),
                  //       Text(
                  //         "Most upvoted",
                  //         style: TextStyle(
                  //           color: tabColor,
                  //           fontSize: tabsFontSize,
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  SizedBox(
                    height: spaceBetweenTabs,
                  ),
                  InkWell(
                    onTap: () {
                      if (userInformation.userId != 'default') {
                        if (settings.enableSuggestions!) {
                          Navigator.of(context).pushNamed(
                            SubmitArticleScreen.routeName,
                          );
                        } else {
                          Navigator.of(context).pop();
                          CustomSnackBar.showErrorSnackBar(context,
                              message: "Article Submission is disable!");
                        }
                      } else {
                        Navigator.of(context).pop();
                        CustomSnackBar.showErrorSnackBar(context,
                            message: "Please Login or Signup!");
                      }
                    },
                    child: Row(
                      children: [
                        Icon(
                          CustomeIcons.link,
                          color: tabColor,
                          size: tabsFontSize,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Submit article",
                          style: TextStyle(
                            color: tabColor,
                            fontSize: tabsFontSize,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: spaceBetweenTabs,
                  ),
                  InkWell(
                    onTap: () {
                      if (userInformation.userId != 'default') {
                        Navigator.of(context).pop();
                        Provider.of<PageTransictionIndex>(context,
                                listen: false)
                            .changeIndex(5);
                      } else {
                        Navigator.of(context).pop();
                        CustomSnackBar.showErrorSnackBar(context,
                            message: "Please Login or Signup!");
                      }
                    },
                    child: Row(
                      children: [
                        Icon(
                          CustomeIcons.eye,
                          color: tabColor,
                          size: tabsFontSize,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Reading history",
                          style: TextStyle(
                            color: tabColor,
                            fontSize: tabsFontSize,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: spaceBetweenTabs,
                  ),
                ],
              ),
              Column(
                children: [
                  InkWell(
                    onTap: () {
                      Provider.of<PageTransictionIndex>(
                        context,
                        listen: false,
                      ).changeIndex(3);
                      Navigator.of(context).pop();
                    },
                    child: Row(
                      children: [
                        Icon(
                          CustomeIcons.terminal,
                          color: tabColor,
                          size: tabsFontSize,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Changelog",
                          style: TextStyle(
                            color: tabColor,
                            fontSize: tabsFontSize,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: spaceBetweenTabs,
                  ),
                  InkWell(
                    onTap: () async {
                      var url = 'https://form.jotform.com/223259339105051';

                      if (await canLaunchUrl(Uri.parse(url))) {
                        await launchUrl(
                          Uri.parse(url),
                          mode: LaunchMode.externalApplication,
                        );
                      } else {
                        throw 'There was a problem to open the url: $url';
                      }
                    },
                    child: Row(
                      children: [
                        Icon(
                          CustomeIcons.stop,
                          color: tabColor,
                          size: tabsFontSize,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Feedback",
                          style: TextStyle(
                            color: tabColor,
                            fontSize: tabsFontSize,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: spaceBetweenTabs,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pushNamed(AboutUsScreen.routeName);
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.question_mark,
                          color: tabColor,
                          size: tabsFontSize,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          "About Us",
                          style: TextStyle(
                            color: tabColor,
                            fontSize: tabsFontSize,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  PopupMenuButton<int> customePopupMenue(
    BuildContext context,
    UserInformation userInformation,
    AuthRepo _authRepo,
    tabColor,
  ) {
    return PopupMenuButton<int>(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      splashRadius: 20,
      elevation: 20,
      offset: const Offset(-12, 40),
      icon: Icon(
        CustomeIcons.cog,
        color: tabColor,
      ),
      iconSize: 25,
      color: tabColor,
      onSelected: (value) {
        if (value == 0) {
          Navigator.of(context).pushNamed(ProfileScreen.routeName);
        } else if (value == 1) {
          Navigator.of(context).pushNamed(
            AccountDetailsScreen.routeName,
            arguments: userInformation,
          );
        } else if (value == 2) {
          _authRepo.logout(context);
          Navigator.of(context).pushReplacementNamed(
            HomeViewScreen.routeName,
          );
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 0,
          child: Row(
            children: const [
              Icon(
                CustomeIcons.person,
                size: 15,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                "Profile",
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: 1,
          child: Row(
            children: const [
              Icon(
                CustomeIcons.cog,
                size: 15,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                "Account Details",
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: 2,
          child: Row(
            children: const [
              Icon(
                CustomeIcons.plug,
                size: 15,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                "Logout",
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
