_- by Anil Karaniya_

<br><br>

<p align="center">
  <img src="https://github.com/OSPClub/Bakliwal-News/blob/main/screenshots/cover.png">
</p>
<br>

# Bakliwal News

Bakliwal News is a unique technology news application, which is entirely user-generated, and anyone can contribute to it. The application is a committee project.
The committee's primary objective is to support open source, and this project is going to be open source, which means anyone can use the code for free. This approach makes Bakliwal News a community-driven platform that encourages users to share their latest tech news and developments.

The application is user-friendly and easy to navigate.The homepage displays the trending news of the day, ensuring users stay up-to-date with the latest tech trends. The unique aspect of Bakliwal News is its user-generated content feature. Users can share their articles, images, and other related content, which other users can comment, like, and share. An admin approves the posts, ensuring the content is of high quality and relevant to the tech industry. This feature creates a community of tech enthusiasts, fostering discussions and debates about the latest developments and trends in the industry.
One of the significant advantages of Bakliwal News is that it provides users with news that is not typically covered by traditional news outlets. Users can share news about the latest startups, technological innovations, and other niche areas that are not usually reported by mainstream news sources. This unique feature makes Bakliwal News a must-have app for tech enthusiasts who want to stay up-to-date with the latest and most innovative technologies.

<br>
<p align="center">
  <img src="https://github.com/OSPClub/Bakliwal-News/blob/main/screenshots/phone-screens.gif">
</p>
<br>

<p align="center">
<img src="https://github.com/OSPClub/Bakliwal-News/blob/main/screenshots/main_feed.png" width="10%"> <img src="https://github.com/OSPClub/Bakliwal-News/blob/main/screenshots/profile.png" width="10%"> <img src="https://github.com/OSPClub/Bakliwal-News/blob/main/screenshots/account_details.png" width="10%"> <img src="https://github.com/OSPClub/Bakliwal-News/blob/main/screenshots/read_history.png" width="10%"> <img src="https://github.com/OSPClub/Bakliwal-News/blob/main/screenshots/submit_screen.png" width="10%"> <img src="https://github.com/OSPClub/Bakliwal-News/blob/main/screenshots/bookmarks.png" width="10%"> <img src="https://github.com/OSPClub/Bakliwal-News/blob/main/screenshots/burgermenu.png" width="10%"> <img src="https://github.com/OSPClub/Bakliwal-News/blob/main/screenshots/login.png" width="10%"> <img src="https://github.com/OSPClub/Bakliwal-News/blob/main/screenshots/signup.png" width="10%">
</p>

# Table of contents

- [Installation](#Installation)
- [Contribution Guidelines](#Contribution-Guidelines)
- [Project Structure](#Project-Structure)
- [Packages Used](#Packages-Used)
- [Feature List](#Feature-List)
- [Languages and Tools](#Languages-and-Tools)

# Installation

### Prerequisites

- [Android Studio](https://developer.android.com/studio) or any IDE to open Flutter project
- JDK

### Installations

1. Install Flutter by following instructions from [flutter.dev](https://flutter.dev). To summarise:

   - Select the appropriate operating system
   - Download the flutter sdk to a preferred location on your local system.

2. Fork and clone the [Bakliwal-News](https://github.com/OSPClub/Bakliwal-News) repository to your local machine.
3. Make sure to install the **Flutter** and **Dart** plugins.
   - If mentorship Flutter is the first project that you will be viewing in Android Studio then:
   - Start Android Studio
   - Open Plugin Preferences
   - Browse repositories and search for flutter
   - Install and click yes to install Dart as well if prompted.
   - Flutter and dart can also be installed after opening a project.
   - Go to File menu -> Settings -> plugins
   - Search for the plugin. In this case it would be Flutter and Dart. Install them if not done yet and click Apply.

![FlutterDartPlugin](https://github.com/anitab-org/mentorship-flutter/blob/develop/docs/images/flutter_dart_plugin.gif)

### Local Development Setup

This section will help you set up the project locally on your system.

1. Ensure that the Flutter SDK is provided the correct path. Open File menu -> Settings -> Languages & Frameworks -> Flutter.

![Flutter SDK](https://github.com/anitab-org/mentorship-flutter/blob/develop/docs/images/flutter_sdk.gif)

2. In order to run a flutter project, either a virtual device needs to be setup or a manuall device can be used. Remember to `enable Debugging` in **Developer Options** in the manual device.

3. Connect your manual device or set up the virtual device before you run the application. Ensure that the device is visible on top menu.

![Flutter Device](https://github.com/anitab-org/mentorship-flutter/blob/develop/docs/images/flutter_device.gif)

4. Connect your [Firebase Project](https://firebase.google.com/docs/flutter/setup?platform=android) and your application, which will unlock all the flutterfire packages.

5. Run the command `dart pub get` in the terminal to get all the packages needed for the project to run properly.

6. Once done, run the project by running `flutter run` in the terminal to run the app in debug mode. To build a release build, you can do the following:

_for Android app_

In the terminal, run the `flutter build apk` command. To build the apk specific to your device arch you can run `flutter build apk --split-per-abi` or `flutter build appbundle --target-platform android-arm,android-arm64,android-x64` (remove arguments which are not required) to get only your arch build. You can read more about this [here](https://flutter.dev/docs/deployment/android)

_for IOS app_

To build a release for IOS app, run `flutter build ios` from the terminal. To learn more on creating build archive, release app on TestFlight or to App Store, click [here](https://flutter.dev/docs/deployment/ios).

# Contribution Guidelines

The contribution guidelines are as per the guide [HERE](https://github.com/OSPClub/Bakliwal-News/blob/main/CONTRIBUTING.md).

### Instructions

- Fork this repository
- Clone your forked repository
- Add your changes
- Commit and push
- Create a pull request
- Star this repository
- Wait for pull request to merge
- Celebrate your first step into the open source world and contribute more

### Additional tools to help you get Started with Open-Source Contribution

- [How to Contribute to Open Source Projects – A Beginner's Guide](https://www.freecodecamp.org/news/how-to-contribute-to-open-source-projects-beginners-guide/)

# Project Structure

### Bakliwal News App

```
.
├── .dart_tool
├── .idea
├── android
├── assets
│   ├── fonts
│   │   ├── Cabin
│   │   ├── Montserrat
│   │   └── Silkscreen
│   └── images
│       └── Logos
├── build
├── ios
├── lib
│   ├── custome_icons_icons.dart
│   ├── main.dart
│   ├── models
│   │   ├── all_read_articles.dart
│   │   ├── article_upvotes.dart
│   │   ├── bookmarks.dart
│   │   ├── news_article.dart
│   │   ├── screen_enums.dart
│   │   ├── settings_model.dart
│   │   └── user_information.dart
│   ├── packages
│   │   └── pagination
│   │       ├── paginate_firestore.dart
│   │       ├── bloc
│   │       │   ├── pagination_cubit.dart
│   │       │   ├── pagination_listeners.dart
│   │       │   └── pagination_state.dart
│   │       └── widgets
│   │           ├── bottom_loader.dart
│   │           ├── empty_display.dart
│   │           ├── empty_separator.dart
│   │           ├── error_display.dart
│   │           └── initial_loader.dart
│   ├── package_service
│   │   └── locator_service.dart
│   ├── providers
│   │   ├── settings_const.dart
│   │   ├── news
│   │   │   ├── articles.dart
│   │   │   ├── changelogs.dart
│   │   │   ├── reading_history.dart
│   │   │   └── user_bookmarks.dart
│   │   ├── user_account
│   │   │   └── user_account.dart
│   │   └── view
│   │       └── page_transiction_provider.dart
│   ├── repository
│   │   └── auth_repo.dart
│   ├── screens
│   │   ├── auth_screen
│   │   │   ├── forgot_password.dart
│   │   │   ├── login.dart
│   │   │   ├── register.dart
│   │   │   └── validator.dart
│   │   ├── primary_screen
│   │   │   ├── aboutus_screen.dart
│   │   │   ├── bookmark_screen.dart
│   │   │   ├── my_feed_screen.dart
│   │   │   └── profile_screen.dart
│   │   └── secondary_screens
│   │       ├── account_details_screen.dart
│   │       ├── article_discription_screen.dart
│   │       ├── changelog_screen.dart
│   │       ├── reading_history_screen.dart
│   │       └── submit_article_screen.dart
│   ├── style
│   │   ├── shimmers_effect.dart
│   │   └── style_declaration.dart
│   ├── view
│   │   ├── home_view_screen.dart
│   │   └── news_card_shimmer.dart
│   ├── widget
│   │   ├── news_card
│   │   │   └── news_card.dart
│   │   └── view
│   │       ├── alert_dialouge_popup.dart
│   │       ├── article_discription_appbar.dart
│   │       ├── bottom_navigation.dart
│   │       ├── burger_menue.dart
│   │       ├── comment_box.dart
│   │       ├── common_article_popmenue.dart
│   │       └── custome_snackbar.dart
│   └── firebase_options.dart
├── linux
├── macos
├── test
├── web
├── windows
├── .metadata
├── pubspec.lock
└── pubspec.yaml
```

### Bakliwal News Admin

```
.
├── .dart_tool
├── .idea
├── android
├── assets
│   ├── fonts
│   │   └── CustomeIconsttf
│   ├── icons
│   │   ├── Documentssvg
│   │   ├── doc_filesvg
│   │   ├── drop_boxsvg
│   │   ├── excle_filesvg
│   │   ├── Figma_filesvg
│   │   ├── foldersvg
│   │   ├── google_drivesvg
│   │   ├── logosvg
│   │   ├── mediasvg
│   │   ├── media_filesvg
│   │   ├── menu_dashbordsvg
│   │   ├── menu_docsvg
│   │   ├── menu_notificationsvg
│   │   ├── menu_profilesvg
│   │   ├── menu_settingsvg
│   │   ├── menu_storesvg
│   │   ├── menu_tasksvg
│   │   ├── menu_transvg
│   │   ├── one_drivesvg
│   │   ├── pdf_filesvg
│   │   ├── Searchsvg
│   │   ├── sound_filesvg
│   │   ├── unknownsvg
│   │   └── xd_filesvg
│   └── images
│       ├── BakliwalNewsAdminLogojpg
│       ├── BakliwalNewsAdminLogopng
│       ├── BakliwalNewsAppLogojpg
│       ├── BakliwalNewsLogopng
│       ├── loginjpg
│       ├── logopng
│       ├── profilePlaceholderjpeg
│       ├── profile_picpng
│       └── registerjpg
├── build
├── ios
├── lib
│   ├── constants.dart
│   ├── custome_icons_icons.dart
│   ├── main.dart
│   ├── responsive.dart
│   ├── controllers
│   │   └── menu_controller.dart
│   ├── models
│   │   ├── all_read_articles.dart
│   │   ├── article_upvotes.dart
│   │   ├── bookmarks.dart
│   │   ├── my_files.dart
│   │   ├── news_articles.dart
│   │   ├── recent_file.dart
│   │   ├── report_model.dart
│   │   ├── settings_model.dart
│   │   └── user_information.dart
│   ├── package_service
│   │   └── locator_service.dart
│   ├── providers
│   │   ├── articles.dart
│   │   ├── settings_const.dart
│   │   ├── users.dart
│   │   └── user_account
│   │       ├── reports_provider.dart
│   │       └── user_account.dart
│   ├── repository
│   │   └── auth_repo.dart
│   ├── screens
│   │   ├── articles
│   │   │   └── article_screen.dart
│   │   ├── auth_screen
│   │   │   └── login.dart
│   │   ├── dashboard
│   │   │   ├── dashboard_screen.dart
│   │   │   └── components
│   │   │       ├── chart.dart
│   │   │       ├── file_info_card.dart
│   │   │       ├── my_fields.dart
│   │   │       ├── my_files.dart
│   │   │       ├── recent_file.dart
│   │   │       ├── recent_files.dart
│   │   │       ├── storage_details.dart
│   │   │       └── storage_info_card.dart
│   │   ├── main
│   │   │   ├── main_screen.dart
│   │   │   └── components
│   │   │       └── side_menu.dart
│   │   ├── profile
│   │   │   ├── account_details_screen.dart
│   │   │   └── profile_screen.dart
│   │   ├── reports
│   │   │   ├── report_screen.dart
│   │   │   └── components
│   │   │       └── report_info_card.dart
│   │   ├── secondary_screens
│   │   │   ├── article_discription_screen.dart
│   │   │   └── submit_article_screen.dart
│   │   ├── settings
│   │   │   └── settings_screen.dart
│   │   ├── suggestions
│   │   │   └── suggestion_screen.dart
│   │   └── users
│   │       ├── users_screen.dart
│   │       └── components
│   │           └── custome_pupup.dart
│   ├── style
│   │   └── style_declaration.dart
│   ├── widgets
│   │   ├── article_info_card.dart
│   │   ├── header.dart
│   │   └── view
│   │       ├── alert_dialouge_popup.dart
│   │       ├── article_discription_appbar.dart
│   │       ├── comment_box.dart
│   │       └── custome_snackbar.dart
│   └── firebase_options.dart
├── linux
├── macos
├── test
├── web
├── windows
├── .metadata
├── pubspec.lock
└── pubspec.yaml
```

# Packages Used

| Package                           | Description                                                                    |
| --------------------------------- | ------------------------------------------------------------------------------ |
| `*Old firebase-RealTime Database` | for server management                                                          |
| `firebase-fireStore`              | for server management                                                          |
| `get_it`                          | simple Service Locator                                                         |
| `provider`                        | simplified allocation/disposal of resources                                    |
| `image_picker`                    | picking images from the image library, and taking new pictures with the camera |
| `google_fonts`                    | google fonts provider                                                          |
| `profanity_filter`                | Detecting profanity in comments                                                |
| `permission_handler`              | Managing device permission                                                     |
| `url_launcher`                    | Launch different application using URL                                         |

# Feature List

- Beautiful Profile
- Pagination
- Admin Acess
- Adding Bookmarks
- Reporting Posts & comments
- Article Submission
- Like & Comments
- Read History

# Languages and Tools

<p align="left"> <a href="https://dart.dev" target="_blank" rel="noreferrer"> <img src="https://www.vectorlogo.zone/logos/dartlang/dartlang-icon.svg" alt="dart" width="40" height="40"/> </a> <a href="https://www.figma.com/" target="_blank" rel="noreferrer"> <img src="https://www.vectorlogo.zone/logos/figma/figma-icon.svg" alt="figma" width="40" height="40"/> </a> <a href="https://firebase.google.com/" target="_blank" rel="noreferrer"> <img src="https://www.vectorlogo.zone/logos/firebase/firebase-icon.svg" alt="firebase" width="40" height="40"/> </a> <a href="https://flutter.dev" target="_blank" rel="noreferrer"> <img src="https://www.vectorlogo.zone/logos/flutterio/flutterio-icon.svg" alt="flutter" width="40" height="40"/> </a> <a href="https://git-scm.com/" target="_blank" rel="noreferrer"> <img src="https://www.vectorlogo.zone/logos/git-scm/git-scm-icon.svg" alt="git" width="40" height="40"/> </a> <a href="https://www.linux.org/" target="_blank" rel="noreferrer"> <img src="https://raw.githubusercontent.com/devicons/devicon/master/icons/linux/linux-original.svg" alt="linux" width="40" height="40"/> </a> <a href="https://www.photoshop.com/en" target="_blank" rel="noreferrer"> <img src="https://raw.githubusercontent.com/devicons/devicon/master/icons/photoshop/photoshop-line.svg" alt="photoshop" width="40" height="40"/> </a> </p>
