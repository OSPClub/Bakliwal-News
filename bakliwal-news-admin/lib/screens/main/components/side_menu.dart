import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SideMenu extends StatelessWidget {
  final int? currentPage;
  final bool isMobileMenue;
  final Function(int pageIndex) changePage;

  const SideMenu({
    Key? key,
    required this.currentPage,
    required this.changePage,
    required this.isMobileMenue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Image.asset("assets/images/BakliwalNewsLogo.png"),
          ),
          // DrawerListTile(
          //   isSelected: currentPage == 0 ? true : false,
          //   title: "Dashboard",
          //   svgSrc: "assets/icons/menu_dashbord.svg",
          //   press: () {
          //     changePage(0);
          //     if (isMobileMenue) {
          //       Navigator.of(context).pop();
          //     }
          //   },
          // ),
          DrawerListTile(
            isSelected: currentPage == 1 ? true : false,
            title: "Articles",
            svgSrc: "assets/icons/menu_tran.svg",
            press: () {
              changePage(1);
              if (isMobileMenue) {
                Navigator.of(context).pop();
              }
            },
          ),
          DrawerListTile(
            isSelected: currentPage == 2 ? true : false,
            title: "Suggestions",
            svgSrc: "assets/icons/menu_task.svg",
            press: () {
              changePage(2);
              if (isMobileMenue) {
                Navigator.of(context).pop();
              }
            },
          ),
          DrawerListTile(
            isSelected: currentPage == 3 ? true : false,
            title: "Users",
            svgSrc: "assets/icons/menu_doc.svg",
            press: () {
              changePage(3);
              if (isMobileMenue) {
                Navigator.of(context).pop();
              }
            },
          ),
          // DrawerListTile(
          //   isSelected: currentPage == 4 ? true : false,
          //   title: "Comments",
          //   svgSrc: "assets/icons/menu_store.svg",
          //   press: () {
          //     changePage(4);
          //   },
          // ),
          DrawerListTile(
            isSelected: currentPage == 4 ? true : false,
            title: "Reports",
            svgSrc: "assets/icons/menu_notification.svg",
            press: () {
              changePage(4);
              if (isMobileMenue) {
                Navigator.of(context).pop();
              }
            },
          ),
          // DrawerListTile(
          //   isSelected: currentPage == 5 ? true : false,
          //   title: "Feedbacks",
          //   svgSrc: "assets/icons/menu_profile.svg",
          //   press: () {
          //     changePage(5);
          //     if (isMobileMenue) {
          //       Navigator.of(context).pop();
          //     }
          //   },
          // ),
          DrawerListTile(
            isSelected: currentPage == 5 ? true : false,
            title: "Settings",
            svgSrc: "assets/icons/menu_setting.svg",
            press: () {
              changePage(5);
              if (isMobileMenue) {
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    // For selecting those three line once press "Command+D"
    required this.title,
    required this.svgSrc,
    required this.press,
    required this.isSelected,
  }) : super(key: key);

  final String title, svgSrc;
  final VoidCallback press;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      selected: isSelected,
      selectedTileColor: Colors.black54,
      onTap: press,
      horizontalTitleGap: 0.0,
      leading: SvgPicture.asset(
        svgSrc,
        color: Colors.white54,
        height: 16,
      ),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white54),
      ),
    );
  }
}
