import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:bakliwal_news/style/style_declaration.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  static const routeName = "/about-us";

  @override
  Widget build(BuildContext context) {
    TextStyle defaultText = const TextStyle(
      color: AppColors.textColor,
    );
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            color: AppColors.primary,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: AppColors.secondary,
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        const url = "https://github.com/OSPClub/Bakliwal-News";
                        await launchUrl(
                          Uri.parse(url),
                          mode: LaunchMode.externalApplication,
                        );
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: const Image(
                          fit: BoxFit.contain,
                          height: 25,
                          width: 25,
                          image: AssetImage(
                            "assets/images/github-logo.png",
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () async {
                    const url = "https://github.com/OSPClub";
                    await launchUrl(
                      Uri.parse(url),
                      mode: LaunchMode.externalApplication,
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: const Image(
                      fit: BoxFit.cover,
                      height: 100,
                      width: 100,
                      image: NetworkImage(
                        "https://avatars.githubusercontent.com/u/122848676",
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Open Source Programming",
                  overflow: TextOverflow.clip,
                  style: TextStyle(
                    color: AppColors.textColor,
                    fontSize: 20,
                  ),
                ),
                const Text(
                  "Committee",
                  style: TextStyle(
                    color: AppColors.textColor,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                customAccentBar(
                  Text(
                    "Open Source Programming Committee is a Bakliwal Foundation's student committee. OSPC's mission is to encourage its members to contribute to the Open Source Projects that help society. OSP Committee also encourages its members to learn new skills that will be essential to real-world obstacles. The OSP committee also helps its members with communication skills and presentation skills.",
                    style: defaultText,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                customAccentBar(
                  Text(
                    "Bakliwal News is a unique technology news application, which is entirely user-generated, and anyone can contribute to it. The application is a committee project. The committee's primary objective is to support open source, and this project is going to be open source, which means anyone can use the code for free. This approach makes Bakliwal News a community-driven platform that encourages users to share their latest tech news and developments.",
                    style: defaultText,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                const Text(
                  "Useful Links",
                  style: TextStyle(
                    color: AppColors.textColor,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                customAccentBar(
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(style: defaultText, text: "Detailed Info: "),
                        TextSpan(
                          style: const TextStyle(color: Colors.lightBlue),
                          text:
                              "https://github.com/OSPClub/Bakliwal-News/blob/main/README.md",
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              const url =
                                  "https://github.com/OSPClub/Bakliwal-News/blob/main/README.md";
                              await launchUrl(
                                Uri.parse(url),
                                mode: LaunchMode.externalApplication,
                              );
                            },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                customAccentBar(
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                            style: defaultText, text: "Bakliwal Foundation: "),
                        TextSpan(
                          style: const TextStyle(color: Colors.lightBlue),
                          text: "https://www.bakliwalfoundation.in",
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              const url = "https://www.bakliwalfoundation.in";
                              await launchUrl(
                                Uri.parse(url),
                                mode: LaunchMode.externalApplication,
                              );
                            },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                customAccentBar(
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(style: defaultText, text: "Privacy Policy: "),
                        TextSpan(
                          style: const TextStyle(color: Colors.lightBlue),
                          text:
                              "https://github.com/OSPClub/Bakliwal-News/blob/main/privacy-policy.md",
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              const url =
                                  "https://github.com/OSPClub/Bakliwal-News/blob/main/privacy-policy.md";
                              await launchUrl(
                                Uri.parse(url),
                                mode: LaunchMode.externalApplication,
                              );
                            },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                customAccentBar(
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                            style: defaultText, text: "Contribution Info: "),
                        TextSpan(
                          style: const TextStyle(color: Colors.lightBlue),
                          text:
                              "https://github.com/OSPClub/Bakliwal-News/blob/main/CONTRIBUTING.md",
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              const url =
                                  "https://github.com/OSPClub/Bakliwal-News/blob/main/CONTRIBUTING.md";
                              await launchUrl(
                                Uri.parse(url),
                                mode: LaunchMode.externalApplication,
                              );
                            },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                customAccentBar(
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(style: defaultText, text: "MIT License: "),
                        TextSpan(
                          style: const TextStyle(color: Colors.lightBlue),
                          text:
                              "https://github.com/OSPClub/Bakliwal-News/blob/main/LICENSE",
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              const url =
                                  "https://github.com/OSPClub/Bakliwal-News/blob/main/LICENSE";
                              await launchUrl(
                                Uri.parse(url),
                                mode: LaunchMode.externalApplication,
                              );
                            },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                const Text(
                  "Bakliwal News v2.0.1",
                  style: TextStyle(color: AppColors.substituteColor),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container customAccentBar(Widget child) {
    return Container(
      padding: const EdgeInsets.only(left: 10),
      decoration: const BoxDecoration(
        border: Border(
          left: BorderSide(
            width: 3,
            color: AppColors.accent,
          ),
        ),
      ),
      child: child,
    );
  }
}
