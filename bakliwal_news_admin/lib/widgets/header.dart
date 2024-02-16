import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import 'package:bakliwal_news_admin/custome_icons_icons.dart';
import 'package:bakliwal_news_admin/models/user_information.dart';
import 'package:bakliwal_news_admin/providers/user_account/user_account.dart';
import 'package:bakliwal_news_admin/screens/profile/profile_screen.dart';
import 'package:bakliwal_news_admin/controllers/menu_controller.dart' as menu;
import 'package:bakliwal_news_admin/responsive.dart';
import 'package:bakliwal_news_admin/constants.dart';

class Header extends StatelessWidget {
  const Header({
    super.key,
    required this.pageType,
    required this.needSearchBar,
  });
  final String pageType;
  final bool needSearchBar;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (!Responsive.isDesktop(context))
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: context.read<menu.MenuController>().controlMenu,
          ),
        if (!Responsive.isMobile(context))
          Text(
            pageType,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        if (!Responsive.isMobile(context))
          Spacer(flex: Responsive.isDesktop(context) ? 2 : 1),
        // if (needSearchBar) const Expanded(child: SearchField()),
        ProfileCard(needSearchBar: needSearchBar),
      ],
    );
  }
}

class ProfileCard extends StatelessWidget {
  const ProfileCard({
    super.key,
    required this.needSearchBar,
  });

  final bool needSearchBar;

  @override
  Widget build(BuildContext context) {
    UserInformation userInformation =
        Provider.of<UserAccount>(context).personalInformation;
    return InkWell(
      onTap: () => _CustomePopupState,
      child: Container(
        margin: const EdgeInsets.only(left: defaultPadding),
        padding: const EdgeInsets.symmetric(
          horizontal: defaultPadding,
          vertical: defaultPadding / 2,
        ),
        decoration: BoxDecoration(
          color: secondaryColor,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border.all(color: Colors.white10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            userInformation.profilePicture == null
                ? Image.asset(
                    "assets/images/profilePlaceholder.jpeg",
                    height: 38,
                  )
                : CircleAvatar(
                    backgroundColor: secondaryColor,
                    backgroundImage: NetworkImage(
                      userInformation.profilePicture!,
                    ),
                  ),
            // if (!needSearchBar)
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: defaultPadding / 2),
              child: userInformation.profilePicture == null
                  ? const Text("Bakliwal Foundation")
                  : Text(userInformation.fullName!),
            ),
            const CustomePopup(),
          ],
        ),
      ),
    );
  }
}

class SearchField extends StatelessWidget {
  const SearchField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: "Search",
        fillColor: secondaryColor,
        filled: true,
        border: const OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        suffixIcon: InkWell(
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.all(defaultPadding * 0.75),
            margin: const EdgeInsets.symmetric(horizontal: defaultPadding / 2),
            decoration: const BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: SvgPicture.asset("assets/icons/Search.svg"),
          ),
        ),
      ),
    );
  }
}

class CustomePopup extends StatefulWidget {
  const CustomePopup({
    super.key,
  });

  @override
  State<CustomePopup> createState() => _CustomePopupState();
}

class _CustomePopupState extends State<CustomePopup> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      splashRadius: 20,
      elevation: 20,
      offset: const Offset(-12, 40),
      icon: const Icon(
        Icons.keyboard_arrow_down,
      ),
      color: secondaryColor,
      onSelected: (value) async {
        if (value == 1) {
          Navigator.of(context).pushNamed(ProfileScreen.routeName);
        } else if (value == 2) {
          await FirebaseAuth.instance.signOut();
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 1,
          child: Row(
            children: [
              Icon(
                CustomeIcons.user,
                color: Colors.white,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                "Profile",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 2,
          child: Row(
            children: [
              Icon(
                Icons.local_gas_station_outlined,
                color: Colors.red,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                "Logout",
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
