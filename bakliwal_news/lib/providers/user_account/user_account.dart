import 'package:flutter/widgets.dart';

import 'package:bakliwal_news/models/user_information.dart';

class UserAccount with ChangeNotifier {
  UserInformation _personalInformation = UserInformation(
    userId: "default",
    isBlocked: false,
    emailId: "default@gmail.com",
    userName: "Login",
    fullName: "Go ahead and Signin or Signup",
    joined: DateTime(2022),
    profilePicture:
        "https://www.pngitem.com/pimgs/m/30-307416_profile-icon-png-image-free-download-searchpng-employee.png",
  );

  UserInformation get personalInformation {
    return _personalInformation;
  }

  void setAccountData(UserInformation fetchedInformation) {
    _personalInformation = fetchedInformation;
    notifyListeners();
  }

  void resetDefaultAccountData() {
    _personalInformation = UserInformation(
      userId: "default",
      isBlocked: false,
      emailId: "default@gmail.com",
      userName: "Login",
      fullName: "Go ahead and Signin or Signup",
      joined: DateTime(2022),
      profilePicture:
          "https://www.pngitem.com/pimgs/m/30-307416_profile-icon-png-image-free-download-searchpng-employee.png",
    );
    notifyListeners();
  }
}
