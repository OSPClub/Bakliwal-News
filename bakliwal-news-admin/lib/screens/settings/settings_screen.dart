// ignore_for_file: avoid_print

import 'package:bakliwal_news_admin/models/settings_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';

import 'package:bakliwal_news_admin/constants.dart';
import 'package:bakliwal_news_admin/widgets/header.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isLoading = false;

  Settings settings = Settings(
    enableComments: false,
    enableUpvotes: false,
    enableSuggestions: false,
    enableBookmarks: false,
    enableProfileUpdate: false,
    enableLogin: false,
    enableSignUp: false,
    enableProfanity: false,
    enableBlocking: false,
    enableSearch: false,
    enableChats: false,
  );

  final firebaseRef = FirebaseDatabase.instance.ref().child("settings/");

  Future<void> fetchAndSetSettings() async {
    setState(() {
      isLoading = true;
    });

    final data = await firebaseRef.get();

    final settingsExtraData = data.value as Map;

    final Settings fetchedSettings = Settings(
      enableComments: settingsExtraData['enableComments'],
      enableUpvotes: settingsExtraData['enableUpvotes'],
      enableBookmarks: settingsExtraData['enableBookmarks'],
      enableSuggestions: settingsExtraData['enableSuggestions'],
      enableProfileUpdate: settingsExtraData['enableProfileUpdate'],
      enableLogin: settingsExtraData['enableLogin'],
      enableSignUp: settingsExtraData['enableSignUp'],
      enableProfanity: settingsExtraData['enableProfanity'],
      enableBlocking: settingsExtraData['enableBlocking'],
      enableSearch: settingsExtraData['enableSearch'],
      enableChats: settingsExtraData['enableChats'],
    );

    settings = fetchedSettings;
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    fetchAndSetSettings();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        // primary: false,
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(defaultPadding),
              child: Header(
                pageType: "Settings",
                needSearchBar: false,
              ),
            ),
            const SizedBox(height: defaultPadding),
            isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : SettingsList(
                    darkTheme: const SettingsThemeData(
                      settingsListBackground: bgColor,
                      settingsSectionBackground: secondaryColor,
                    ),
                    lightTheme: const SettingsThemeData(
                      settingsListBackground: bgColor,
                      settingsSectionBackground: secondaryColor,
                    ),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    sections: [
                      SettingsSection(
                        title: const Text('Common'),
                        tiles: <SettingsTile>[
                          SettingsTile.switchTile(
                            onToggle: (value) async {
                              await firebaseRef.update({
                                'enableComments': value,
                              });
                              setState(() {
                                settings.enableComments = value;
                              });
                            },
                            initialValue: settings.enableComments,
                            leading: const Icon(Icons.comment),
                            title: const Text('Enable Comments'),
                          ),
                          SettingsTile.switchTile(
                            onToggle: (value) async {
                              await firebaseRef.update({
                                'enableUpvotes': value,
                              });
                              setState(() {
                                settings.enableUpvotes = value;
                              });
                            },
                            initialValue: settings.enableUpvotes,
                            leading: const Icon(Icons.arrow_upward),
                            title: const Text('Enable Upvotes'),
                          ),
                          SettingsTile.switchTile(
                            onToggle: (value) async {
                              await firebaseRef.update({
                                'enableBookmarks': value,
                              });
                              setState(() {
                                settings.enableBookmarks = value;
                              });
                            },
                            initialValue: settings.enableBookmarks,
                            leading: const Icon(Icons.bookmark),
                            title: const Text('Enable Bookmarks'),
                          ),
                        ],
                      ),
                      SettingsSection(
                        title: const Text('User'),
                        tiles: <SettingsTile>[
                          SettingsTile.switchTile(
                            onToggle: (value) async {
                              await firebaseRef.update({
                                'enableSuggestions': value,
                              });
                              setState(() {
                                settings.enableSuggestions = value;
                              });
                            },
                            initialValue: settings.enableSuggestions,
                            leading: const Icon(Icons.blur_linear),
                            title: const Text('Enable Suggestions'),
                          ),
                          SettingsTile.switchTile(
                            onToggle: (value) async {
                              await firebaseRef.update({
                                'enableProfileUpdate': value,
                              });
                              setState(() {
                                settings.enableProfileUpdate = value;
                              });
                            },
                            initialValue: settings.enableProfileUpdate,
                            leading: const Icon(Icons.update),
                            title: const Text('Enable Profile Update'),
                          ),
                          SettingsTile.switchTile(
                            onToggle: (value) async {
                              await firebaseRef.update({
                                'enableLogin': value,
                              });
                              setState(() {
                                settings.enableLogin = value;
                              });
                            },
                            initialValue: settings.enableLogin,
                            leading: const Icon(Icons.login),
                            title: const Text('Enable Login'),
                          ),
                          SettingsTile.switchTile(
                            onToggle: (value) async {
                              await firebaseRef.update({
                                'enableSignUp': value,
                              });
                              setState(() {
                                settings.enableSignUp = value;
                              });
                            },
                            initialValue: settings.enableSignUp,
                            leading: const Icon(Icons.web_rounded),
                            title: const Text('Enable SignUp'),
                          ),
                        ],
                      ),
                      SettingsSection(
                        title: const Text('Legals'),
                        tiles: <SettingsTile>[
                          SettingsTile.switchTile(
                            onToggle: (value) async {
                              await firebaseRef.update({
                                'enableProfanity': value,
                              });
                              setState(() {
                                settings.enableProfanity = value;
                              });
                            },
                            initialValue: settings.enableProfanity,
                            leading: const Icon(Icons.shield_outlined),
                            title: const Text('Enable Profanity'),
                          ),
                        ],
                      ),
                      SettingsSection(
                        title: const Text('Future *IF POSSIBLE*'),
                        tiles: <SettingsTile>[
                          SettingsTile.switchTile(
                            onToggle: (value) async {
                              await firebaseRef.update({
                                'enableBlocking': value,
                              });
                              setState(() {
                                settings.enableBlocking = value;
                              });
                            },
                            initialValue: settings.enableBlocking,
                            leading: const Icon(Icons.block),
                            title: const Text('Enable Blocking'),
                            enabled: false,
                          ),
                          SettingsTile.switchTile(
                            onToggle: (value) async {
                              await firebaseRef.update({
                                'enableSearch': value,
                              });
                              setState(() {
                                settings.enableSearch = value;
                              });
                            },
                            initialValue: settings.enableSearch,
                            leading: const Icon(Icons.search),
                            title: const Text('Enable Search'),
                            enabled: false,
                          ),
                          SettingsTile.switchTile(
                            onToggle: (value) async {
                              await firebaseRef.update({
                                'enableChats': value,
                              });
                              setState(() {
                                settings.enableChats = value;
                              });
                            },
                            initialValue: settings.enableChats,
                            leading:
                                const Icon(Icons.mark_chat_unread_outlined),
                            title: const Text('Enable Chats'),
                            enabled: false,
                          ),
                        ],
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
