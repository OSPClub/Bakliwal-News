import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import "package:flutter/material.dart";

import 'package:bakliwal_news_app/models/user_information.dart';
import 'package:bakliwal_news_app/providers/user_account/user_account.dart';
import 'package:bakliwal_news_app/custome_icons_icons.dart';
import 'package:bakliwal_news_app/style/style_declaration.dart';
import 'package:provider/provider.dart';

class SubmitArticleScreen extends StatefulWidget {
  const SubmitArticleScreen({super.key});

  static const routeName = "/submit-article-screen";
  @override
  State<SubmitArticleScreen> createState() => _SubmitArticleScreenState();
}

class _SubmitArticleScreenState extends State<SubmitArticleScreen> {
  final _submitArticleScreenKey = GlobalKey<FormState>();
  String errorMessage = '';
  double progress = 0;
  bool isUploading = false;
  String profilePictureUploadStatus = "";
  Image? altImageWidget;
  File? systemImageFile;
  String? rawProfilePictureUrl;

  String? articleTitle;
  String? articleDescription;

  Future<void> saveForm(UserInformation userInformation) async {
    if (_submitArticleScreenKey.currentState!.validate() &&
        altImageWidget != null) {
      _submitArticleScreenKey.currentState!.save();
      final articlaPostRef =
          FirebaseDatabase.instance.ref().child("article_sugestions/").push();

      await articlaPostRef.set({
        "discription": articleDescription,
        "title": articleTitle,
        "publishedDate": DateTime.now().toString(),
        "newsImageURL": rawProfilePictureUrl,
        "userId": userInformation.userId,
      });

      if (systemImageFile != null) {
        await uploadFile(systemImageFile as File, articlaPostRef.key!);
      }
    }
  }

  Future<void> uploadFile(File file, String articleId) async {
    profilePictureUploadStatus = "";
    final storageRef =
        FirebaseStorage.instance.ref().child("article_sugestions/$articleId");

    var uploadTask = storageRef.putData(
      await PickedFile(file.path).readAsBytes(),
      SettableMetadata(contentType: "image/jpeg"),
    );
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
              .child("article_sugestions/$articleId")
              .getDownloadURL();

          await FirebaseDatabase.instance
              .ref("article_sugestions/$articleId")
              .update({
            "newsImageURL": urlDownload,
          });
          setState(() {
            rawProfilePictureUrl = urlDownload;
            isUploading = false;
            profilePictureUploadStatus = "Upload is 100% complete.";
            altImageWidget = null;
            _submitArticleScreenKey.currentState!.reset();
          });
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        title: const Text(
          "We are all born ignorant, but one must work hard to remain stupid.",
          style: TextStyle(fontFamily: "Roboto"),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
          ),
          child: Form(
            key: _submitArticleScreenKey,
            child: SizedBox(
              height: height * 0.88,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "Submit Article",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "Note: Provide authentic and currect information if there is any Abusive or Misleading Information, Bad or Hate Speech, etc then article will be rejected and action will be taken accordingly!",
                    style: TextStyle(color: Colors.red, fontFamily: "Roboto"),
                  ),
                  const SizedBox(height: 20),
                  textInputField(1),
                  const SizedBox(height: 20),
                  customUpoadButton(),
                  if (profilePictureUploadStatus.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 10, left: 10),
                      child: Text(
                        profilePictureUploadStatus,
                        style: const TextStyle(
                          color: AppColors.substituteColor,
                        ),
                      ),
                    ),
                  if (isUploading)
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 10,
                      ),
                      child: ClipRRect(
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
                    ),
                  const SizedBox(height: 20),
                  postArticleButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Column textInputField(double inputWidth) {
    return Column(
      children: [
        SizedBox(
          width: inputWidth.sw,
          child: customeFormField(
            "",
            const Icon(
              CustomeIcons.clovers_card,
              color: Colors.white,
            ),
            "Article Title",
            validator: (value) {
              if (value == null) {
                return 'Please Enter Article Title.';
              }
              if (value.isEmpty) {
                return 'Please Enter Article Title.';
              }
              return null;
            },
            onSaved: (value) {
              articleTitle = value;
            },
          ),
        ),
        const SizedBox(
          height: 25,
        ),
        SizedBox(
          width: inputWidth.sw,
          child: TextFormField(
            cursorColor: Colors.blueAccent,
            style: const TextStyle(color: Colors.white),
            maxLines: 10,
            decoration: InputDecoration(
              counterStyle: const TextStyle(
                color: Color.fromARGB(255, 194, 187, 187),
              ),
              labelText: "Article Description",
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
            validator: (value) {
              if (value == null) {
                return 'Please Enter Article Description.';
              }
              if (value.isEmpty) {
                return 'Please Enter Article Description.';
              }
              return null;
            },
            onSaved: (value) {
              articleDescription = value;
            },
          ),
        ),
      ],
    );
  }

  Expanded customUpoadButton() {
    return altImageWidget == null
        ? Expanded(
            child: ElevatedButton(
              onPressed: () async {
                final XFile? image = await ImagePicker().pickImage(
                  source: ImageSource.gallery,
                );
                systemImageFile = File(image!.path);
                altImageWidget = Image.memory(
                  await image.readAsBytes(),
                );
                setState(() {});
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(AppColors.secondary),
                padding: MaterialStateProperty.all(
                  const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                ),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                )),
              ),
              child: const Text(
                "Upload Image",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          )
        : Expanded(
            child: Container(
              child: altImageWidget!,
            ),
          );
  }

  Expanded postArticleButton() {
    return Expanded(
      child: ElevatedButton(
        onPressed: () async {
          await saveForm(Provider.of<UserAccount>(
            context,
            listen: false,
          ).personalInformation);
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(AppColors.accent),
          padding: MaterialStateProperty.all(
            const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
          ),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          )),
        ),
        child: isUploading
            ? const CircularProgressIndicator(
                color: Colors.white,
              )
            : const Text(
                "Submit Articles",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
      ),
    );
  }

  Widget customeFormField(String? initvalue, Widget? icon, String hint,
      {void Function(String?)? onSaved,
      String? Function(String?)? validator,
      void Function(String)? onChanged}) {
    return TextFormField(
      cursorColor: Colors.blueAccent,
      style: const TextStyle(color: Colors.white),
      initialValue: initvalue,
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
        prefixIcon: icon,
        labelText: hint,
        labelStyle: const TextStyle(color: Color.fromARGB(255, 194, 187, 187)),
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
