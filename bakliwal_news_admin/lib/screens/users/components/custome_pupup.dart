import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'package:bakliwal_news_admin/constants.dart';
import 'package:bakliwal_news_admin/custome_icons_icons.dart';
import 'package:bakliwal_news_admin/models/user_information.dart';
import 'package:bakliwal_news_admin/screens/profile/account_details_screen.dart';

class UserCustomePopup extends StatefulWidget {
  const UserCustomePopup({
    super.key,
    required this.userInformation,
  });
  final UserInformation userInformation;
  @override
  State<UserCustomePopup> createState() => _UserCustomePopupState();
}

class _UserCustomePopupState extends State<UserCustomePopup> {
  @override
  Widget build(BuildContext context) {
    bool isBlocked = widget.userInformation.isBlocked ?? false;
    return PopupMenuButton<int>(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      splashRadius: 20,
      elevation: 20,
      offset: const Offset(-12, 40),
      icon: Icon(
        Icons.more_vert_outlined,
        color: isBlocked ? Colors.red : Colors.white,
      ),
      color: secondaryColor,
      onSelected: (value) async {
        if (value == 1) {
          Navigator.of(context).pushNamed(
            AccountDetailsScreen.routeName,
            arguments: widget.userInformation,
          );
        } else if (value == 2) {
          if (isBlocked) {
            await FirebaseDatabase.instance
                .ref("users/${widget.userInformation.userId}")
                .update(
              {
                "isBlocked": null,
              },
            );
            setState(() {
              widget.userInformation.isBlocked = false;
            });
          } else {
            await FirebaseDatabase.instance
                .ref("users/${widget.userInformation.userId}")
                .update({
              "isBlocked": true,
            });

            setState(() {
              widget.userInformation.isBlocked = true;
            });
          }
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
                "Edit User",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: 2,
          child: Row(
            children: [
              Icon(
                CustomeIcons.stop,
                color: isBlocked ? Colors.green : Colors.red,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                isBlocked ? "Unblock User" : "Block User",
                style: TextStyle(color: isBlocked ? Colors.green : Colors.red),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
