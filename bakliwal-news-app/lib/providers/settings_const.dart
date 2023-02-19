import 'package:flutter/widgets.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:bakliwal_news_app/models/settings_model.dart';

class ConstSettings with ChangeNotifier {
  Settings _constSettings = Settings(
    enableComments: true,
    enableUpvotes: true,
    enableSuggestions: true,
    enableBookmarks: true,
    enableProfileUpdate: true,
    enableLogin: true,
    enableSignUp: true,
    enableProfanity: true,
    enableBlocking: false,
    enableSearch: false,
    enableChats: false,
  );

  Settings get constSettings {
    return _constSettings;
  }

  Future<void> fetchAndSetConstSettings() async {
    final settingsRef = await FirebaseDatabase.instance.ref("settings").get();
    final data = settingsRef.value as Map;

    _constSettings = Settings(
      enableComments: data['enableComments'],
      enableUpvotes: data['enableUpvotes'],
      enableSuggestions: data['enableSuggestions'],
      enableBookmarks: data['enableBookmarks'],
      enableProfileUpdate: data['enableProfileUpdate'],
      enableLogin: data['enableLogin'],
      enableSignUp: data['enableSignUp'],
      enableProfanity: data['enableProfanity'],
      enableBlocking: data['enableBlocking'],
      enableSearch: data['enableSearch'],
      enableChats: data['enableChats'],
    );

    notifyListeners();
  }
}
