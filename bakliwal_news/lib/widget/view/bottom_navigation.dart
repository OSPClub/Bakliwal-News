import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:bakliwal_news/models/settings_model.dart';
import 'package:bakliwal_news/providers/settings_const.dart';
import 'package:bakliwal_news/widget/view/custome_snackbar.dart';
import 'package:bakliwal_news/models/user_information.dart';
import 'package:bakliwal_news/providers/user_account/user_account.dart';

class CustomBottomNavigation extends StatelessWidget {
  final Function switchIndex;
  final int index;
  const CustomBottomNavigation({
    super.key,
    required this.switchIndex,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    UserInformation? userInformation =
        Provider.of<UserAccount>(context).personalInformation;
    Appsettings settings = Provider.of<ConstSettings>(context).constSettings;
    return Container(
      decoration: const BoxDecoration(
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Color.fromARGB(255, 97, 97, 97),
            spreadRadius: 1,
          ),
        ],
      ),
      child: BottomNavigationBar(
        selectedFontSize: 0,
        unselectedFontSize: 0,
        elevation: 1,
        backgroundColor: Colors.black,
        type: BottomNavigationBarType.fixed,
        unselectedIconTheme: IconThemeData(color: Colors.blueGrey[200]),
        selectedIconTheme: const IconThemeData(color: Colors.white),
        onTap: (value) {
          if (value == 0 && userInformation.userId == "default") {
            if (!settings.enableLogin!) {
              CustomSnackBar.showErrorSnackBar(
                context,
                message: "Login & signup are disable!",
              );
            } else {
              switchIndex(7);
            }
          } else if (value == 2) {
            if (userInformation.userId == "default") {
              CustomSnackBar.showErrorSnackBar(
                context,
                message: "Please Login or SignUp!",
              );
            } else if (!settings.enableBookmarks!) {
              CustomSnackBar.showErrorSnackBar(
                context,
                message: "Bookmarks are disable!",
              );
            } else {
              switchIndex(value);
            }
          } else {
            switchIndex(value);
          }
        },
        currentIndex: index,
        items: <BottomNavigationBarItem>[
          userInformation.userId == "default" ||
                  userInformation.profilePicture == null ||
                  userInformation.profilePicture!.isEmpty
              ? const BottomNavigationBarItem(
                  icon: CircleAvatar(
                    radius: 20,
                    backgroundImage:
                        AssetImage("assets/images/profilePlaceholder.jpeg"),
                  ),
                  label: "",
                )
              : BottomNavigationBarItem(
                  icon: Hero(
                    tag: "personalProfile",
                    child: CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(
                        userInformation.profilePicture!,
                      ),
                    ),
                  ),
                  label: "",
                ),
          BottomNavigationBarItem(
            icon: const Icon(
              Icons.home_outlined,
              size: 26.5,
            ),
            activeIcon: Container(
              height: 40,
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.white,
                    width: 2.00,
                  ),
                ),
              ),
              child: const Icon(
                Icons.home,
                size: 26.5,
              ),
            ),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: const Icon(
              Icons.bookmark_border_rounded,
              size: 26.5,
            ),
            activeIcon: Container(
              height: 40,
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.white,
                    width: 2.00,
                  ),
                ),
              ),
              child: const Icon(
                Icons.bookmark,
                size: 26.5,
              ),
            ),
            label: "",
          ),
          // BottomNavigationBarItem(
          //   icon: const Icon(
          //     Icons.search,
          //     size: 26.5,
          //   ),
          //   activeIcon: Container(
          //     height: 40,
          //     decoration: const BoxDecoration(
          //       border: Border(
          //         bottom: BorderSide(
          //           color: Colors.white,
          //           width: 2.00,
          //         ),
          //       ),
          //     ),
          //     child: const Icon(
          //       Icons.search,
          //       size: 26.5,
          //     ),
          //   ),
          //   label: "",
          // ),
        ],
      ),
    );
  }
}
