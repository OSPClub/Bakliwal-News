import 'package:bakliwal_news_admin/models/user_information.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Users with ChangeNotifier {
  List<UserInformation> _allUsers = [];
  int _rawSizeOfusers = 0;

  List<UserInformation> get allUsers {
    return [..._allUsers];
  }

  int get rawSizeOfusers {
    return _rawSizeOfusers;
  }

  Future<void> fetchAndSetUserData() async {
    _allUsers = [];

    final usersRef = await FirebaseDatabase.instance.ref("users/").get();
    final allusers = usersRef.value as Map;
    _rawSizeOfusers = allusers.length;
    List<UserInformation> fetchedArticles = [];

    allusers.forEach((id, user) async {
      fetchedArticles.add(
        UserInformation(
          userId: id,
          isBlocked: user["isBlocked"],
          userName: user['userName'],
          emailId: user['emailId'],
          fullName: user['fullName'],
          joined: DateTime.parse(user['joiningDate']),
          profilePicture: user['profilePicture'],
          companyName: user['companyName'],
          jobTitle: user['jobTitle'],
          biography: user['biography'],
          facebook: user['facebook'],
          githubUsername: user['githubUsername'],
          instagram: user['instagram'],
          twitter: user['twitter'],
          websiteURL: user['websiteURL'],
        ),
      );

      _allUsers = fetchedArticles;
      notifyListeners();
    });
  }

  Future<void> updateUserData(UserInformation userInformation) async {
    final usersIndex =
        _allUsers.indexWhere((user) => user.userId == userInformation.userId);

    _allUsers[usersIndex] = userInformation;
    notifyListeners();
  }
}
