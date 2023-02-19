// ignore_for_file: unnecessary_null_comparison, avoid_print

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import 'package:bakliwal_news_app/package_service/locator_service.dart';
import 'package:bakliwal_news_app/providers/user_account/user_account.dart';
import 'package:bakliwal_news_app/repository/auth_repo.dart';
import 'package:bakliwal_news_app/custome_icons_icons.dart';
import 'package:bakliwal_news_app/models/user_information.dart';
import 'package:bakliwal_news_app/style/style_declaration.dart';

class AccountDetailsScreen extends StatefulWidget {
  const AccountDetailsScreen({super.key});
  static const routeName = "./account-details-screen";

  @override
  State<AccountDetailsScreen> createState() => _AccountDetailsScreenState();
}

class _AccountDetailsScreenState extends State<AccountDetailsScreen> {
  final _personalDataSetKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String errorMessage = '';
  double progress = 0;
  bool isUploading = false;
  String profilePictureUploadStatus = "";
  ImageProvider? altImageWidget;
  String? rawProfilePictureUrl;

  String? userName;
  String? fullName;
  String? emailId;
  DateTime? joined;
  String? profilePicture;
  String? biography;
  String? companyName;
  String? jobTitle;
  String? githubUsername;
  String? linkedin;
  String? twitter;
  String? instagram;
  String? facebook;
  String? websiteURL;

  @override
  Widget build(BuildContext context) {
    UserInformation? userInformation =
        ModalRoute.of(context)!.settings.arguments as UserInformation;

    userName = userInformation.userName;
    fullName = userInformation.fullName;
    emailId = userInformation.emailId;
    joined = userInformation.joined;
    profilePicture = userInformation.profilePicture;
    biography = userInformation.biography;
    companyName = userInformation.companyName;
    jobTitle = userInformation.jobTitle;
    githubUsername = userInformation.githubUsername;
    linkedin = userInformation.linkedin;
    twitter = userInformation.twitter;
    instagram = userInformation.instagram;
    facebook = userInformation.facebook;
    websiteURL = userInformation.websiteURL;

    void saveData() async {
      final isValid = _personalDataSetKey.currentState!.validate();
      if (!isValid) {
        return;
      }
      _personalDataSetKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });
      try {
        if (userInformation != null) {
          FocusManager.instance.primaryFocus?.unfocus();
          await FirebaseDatabase.instance
              .ref("users/${userInformation.userId}")
              .update(
            {
              "userId": userInformation.userId,
              "userName": userName ?? userInformation.userName,
              "emailId": userInformation.emailId,
              "fullName": fullName ?? userInformation.userName,
              "joiningDate": userInformation.joined.toString(),
              "profilePicture": rawProfilePictureUrl ?? profilePicture,
              "biography": biography,
              "companyName": companyName,
              "jobTitle": jobTitle,
              "githubUsername": githubUsername,
              "linkedin": linkedin,
              "twitter": twitter,
              "instagram": instagram,
              "facebook": facebook,
              "websiteURL": websiteURL,
            },
          );
        }
      } on FirebaseAuthException catch (error) {
        setState(() {
          errorMessage = error.message.toString();
          _isLoading = false;
        });
        print("${error.message} : Code ${error.code}");
      } finally {
        await locator.get<AuthRepo>().fetchAndSetUser(context: context);
        // ignore: use_build_context_synchronously
        Navigator.of(context).pop();
      }
    }

    Future<void> uploadFile(File file) async {
      profilePictureUploadStatus = "";
      final FirebaseStorage storage = FirebaseStorage.instance;

      final user =
          Provider.of<UserAccount>(context, listen: false).personalInformation;
      var userId = user.userId;

      var storageRef = storage.ref().child("users/$userId");
      var uploadTask = storageRef.putFile(file);

      uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) async {
        switch (taskSnapshot.state) {
          case TaskState.running:
            setState(() {
              isUploading = true;
              progress =
                  (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
            });
            break;
          case TaskState.paused:
            setState(() {
              profilePictureUploadStatus = "Upload is paused.";
            });
            break;
          case TaskState.canceled:
            setState(() {
              profilePictureUploadStatus = "Upload was canceled";
            });
            break;
          case TaskState.error:
            setState(() {
              errorMessage = "Unknown Error! Failed to upload the file!";
            });
            break;
          case TaskState.success:
            String? urlDownload = await FirebaseStorage.instance
                .ref()
                .child("users/$userId")
                .getDownloadURL();

            await FirebaseDatabase.instance
                .ref("users/${userInformation.userId}")
                .update({
              "profilePicture": urlDownload,
            });
            await FirebaseAuth.instance.currentUser!
                .updatePhotoURL(urlDownload);
            await locator.get<AuthRepo>().fetchAndSetUser(context: context);
            setState(() {
              rawProfilePictureUrl = urlDownload;
              isUploading = false;
              profilePictureUploadStatus = "Upload is 100% complete.";
            });
            break;
        }
      });
    }

    Widget customeFormField(String? initvalue, Widget? icon, String hint,
        {void Function(String?)? onSaved,
        String? Function(String?)? validator,
        void Function(String)? onChanged}) {
      return TextFormField(
        cursorColor: Colors.blueAccent,
        style: const TextStyle(color: Colors.white),
        initialValue: initvalue,
        decoration: InputDecoration(
          prefixIcon: icon,
          labelText: hint,
          labelStyle:
              const TextStyle(color: Color.fromARGB(255, 194, 187, 187)),
          filled: true,
          fillColor: const Color.fromARGB(255, 58, 53, 53),
          border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(15)),
        ),
        validator: validator,
        onSaved: onSaved,
        onChanged: onChanged,
      );
    }

    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        title: const Text(
          "Account Details",
          style: TextStyle(fontFamily: "Roboto"),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 20,
            right: 30,
            top: 25,
            bottom: 30,
          ),
          child: Form(
            key: _personalDataSetKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                titleText("Profile Picture"),
                const SizedBox(
                  height: 3,
                ),
                const Text(
                  "Upload a picture to make your profile stand out and let people recognize your comments and cotributions easily!",
                  style: TextStyle(
                    color: AppColors.substituteColor,
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                InkWell(
                  onTap: () async {
                    await _getPermission();
                    final XFile? image = await ImagePicker().pickImage(
                      source: ImageSource.gallery,
                      imageQuality: 10,
                    );
                    setState(() {
                      altImageWidget = FileImage(
                        File(image!.path),
                      );
                    });
                    await uploadFile(File(image!.path));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: userInformation.userId == "default" ||
                            userInformation.profilePicture == null ||
                            userInformation.profilePicture!.isEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image(
                              fit: BoxFit.cover,
                              height: 80,
                              width: 80,
                              image: altImageWidget ??
                                  const AssetImage(
                                      "assets/images/profilePlaceholder.jpeg"),
                            ),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image(
                              fit: BoxFit.cover,
                              height: 80,
                              width: 80,
                              image: NetworkImage(
                                rawProfilePictureUrl ?? profilePicture!,
                              ),
                            ),
                          ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                if (profilePictureUploadStatus.isNotEmpty)
                  Text(
                    profilePictureUploadStatus,
                    style: const TextStyle(
                      color: AppColors.substituteColor,
                    ),
                  ),
                const SizedBox(
                  height: 10,
                ),
                if (isUploading)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: SizedBox(
                      height: 20,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          LinearProgressIndicator(
                            value: progress,
                            backgroundColor: AppColors.secondary,
                            color: AppColors.accent,
                          ),
                          Center(
                            child: Text(
                              "${(100 * progress).roundToDouble()}%",
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(
                  height: 25,
                ),
                titleText("Account Information"),
                const SizedBox(
                  height: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    customeFormField(
                        userInformation.fullName,
                        const Icon(
                          CustomeIcons.person,
                          color: Colors.white,
                        ),
                        "Full Name", validator: (value) {
                      if (value == null) {
                        return 'Please Enter Full Name.';
                      }
                      if (value.isEmpty) {
                        return 'Please Enter Full Name.';
                      }
                      return null;
                    }, onSaved: (value) async {
                      fullName = value;
                      await FirebaseAuth.instance.currentUser!
                          .updateDisplayName(
                              fullName ?? userInformation.userName);
                    }),
                    const SizedBox(
                      height: 25,
                    ),
                    customeFormField(
                      userInformation.userName,
                      const Icon(
                        CustomeIcons.at,
                        color: Colors.white,
                      ),
                      "Username",
                      validator: (value) {
                        if (value == null) {
                          return 'Please Enter Username.';
                        }
                        if (value.isEmpty || value == "") {
                          return 'Please Enter Username.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        userName = value;
                      },
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    titleText("About"),
                    const SizedBox(
                      height: 25,
                    ),
                    TextFormField(
                      cursorColor: Colors.blueAccent,
                      style: const TextStyle(color: Colors.white),
                      initialValue: biography,
                      maxLines: 6,
                      maxLength: 100,
                      decoration: InputDecoration(
                        counterStyle: const TextStyle(
                          color: Color.fromARGB(255, 194, 187, 187),
                        ),
                        labelText: "Bio",
                        alignLabelWithHint: true,
                        floatingLabelAlignment: FloatingLabelAlignment.start,
                        labelStyle: const TextStyle(
                          color: Color.fromARGB(255, 194, 187, 187),
                        ),
                        filled: true,
                        fillColor: const Color.fromARGB(255, 58, 53, 53),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onSaved: (value) {
                        if (value != null) {
                          biography = value;
                        }
                      },
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    customeFormField(
                      userInformation.companyName,
                      null,
                      "Company",
                      onSaved: (value) {
                        if (value != null) {
                          companyName = value;
                        }
                      },
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    customeFormField(
                      userInformation.jobTitle,
                      null,
                      "Job Title",
                      onSaved: (value) {
                        if (value != null) {
                          jobTitle = value;
                        }
                      },
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    titleText("Profile Social Links"),
                    const SizedBox(
                      height: 3,
                    ),
                    const Text(
                      "Add your social media profiles so others can connect with you and you can grow your network!",
                      style: TextStyle(
                        color: AppColors.substituteColor,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    customeFormField(
                      userInformation.githubUsername,
                      const Icon(
                        CustomeIcons.github_circled_alt2,
                        color: Colors.white,
                      ),
                      "GitHub",
                      onSaved: (value) {
                        if (value != null) {
                          githubUsername = value;
                        }
                      },
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    customeFormField(
                      userInformation.linkedin,
                      const Icon(
                        CustomeIcons.linkedin_1,
                        color: Colors.white,
                      ),
                      "Linkedin",
                      onSaved: (value) {
                        if (value != null) {
                          linkedin = value;
                        }
                      },
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    customeFormField(
                      userInformation.twitter,
                      const Icon(
                        CustomeIcons.twitter,
                        color: Colors.white,
                      ),
                      "Twitter",
                      onSaved: (value) {
                        if (value != null) {
                          twitter = value;
                        }
                      },
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    customeFormField(
                      userInformation.instagram,
                      const Icon(
                        CustomeIcons.instagram,
                        color: Colors.white,
                      ),
                      "Instagram",
                      onSaved: (value) {
                        if (value != null) {
                          instagram = value;
                        }
                      },
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    customeFormField(
                      userInformation.facebook,
                      const Icon(
                        color: Colors.white,
                        CustomeIcons.facebook,
                      ),
                      "Facebook",
                      onSaved: (value) {
                        if (value != null) {
                          facebook = value;
                        }
                      },
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    customeFormField(
                      userInformation.websiteURL,
                      const Icon(
                        CustomeIcons.link,
                        color: Colors.white,
                      ),
                      "Your Website",
                      onSaved: (value) {
                        if (value != null) {
                          websiteURL = value;
                        }
                      },
                    ),
                    if (errorMessage.isNotEmpty)
                      Container(
                        margin: const EdgeInsets.only(
                          bottom: 10,
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 10,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.red,
                            width: 3,
                          ),
                        ),
                        child: Text(
                          errorMessage,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    const SizedBox(
                      height: 40,
                    ),
                    _isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.accent,
                            ),
                          )
                        : SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: saveData,
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(AppColors.accent),
                                padding: MaterialStateProperty.all(
                                  const EdgeInsets.symmetric(
                                      vertical: 15, horizontal: 30),
                                ),
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                )),
                              ),
                              child: const Text(
                                "Save Changes",
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<PermissionStatus> _getPermission() async {
    await Permission.contacts.request();
    final PermissionStatus permission = await Permission.photos.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.denied) {
      final Map<Permission, PermissionStatus> permissionStatus =
          await [Permission.photos].request();
      return permissionStatus[Permission.photos] ?? PermissionStatus.restricted;
    } else {
      return permission;
    }
  }

  Widget titleText(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontFamily: "Roboto",
      ),
    );
  }
}
