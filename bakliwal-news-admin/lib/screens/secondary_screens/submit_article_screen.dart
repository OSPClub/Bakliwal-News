// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:bakliwal_news_admin/models/news_articles.dart';
import 'package:bakliwal_news_admin/providers/articles.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import "package:flutter/material.dart";

import 'package:bakliwal_news_admin/models/user_information.dart';
import 'package:bakliwal_news_admin/providers/user_account/user_account.dart';
import 'package:bakliwal_news_admin/custome_icons_icons.dart';
import 'package:bakliwal_news_admin/style/style_declaration.dart';
import 'package:provider/provider.dart';

class SubmitArticleScreen extends StatefulWidget {
  const SubmitArticleScreen({super.key});

  static const routeName = "submit-article-screen";
  @override
  State<SubmitArticleScreen> createState() => _SubmitArticleScreenState();
}

class _SubmitArticleScreenState extends State<SubmitArticleScreen> {
  NewsArticle? article;
  final _submitArticleScreenKey = GlobalKey<FormState>();
  String errorMessage = '';
  double progress = 0;
  bool isUploading = false;
  String profilePictureUploadStatus = "";
  Image? altImageWidget;
  File? systemImageFile;
  String? rawProfilePictureUrl;
  var _isInit = true;
  var _isUpdate = false;
  bool isSaving = false;
  bool isSuggestedArticle = false;

  String? articleTitle;
  String? articleDescription;

  Future<void> saveForm(UserInformation userInformation) async {
    if (_submitArticleScreenKey.currentState!.validate() &&
        altImageWidget != null) {
      setState(() {
        isSaving = true;
      });
      _submitArticleScreenKey.currentState!.save();
      final articlaPostRef = FirebaseDatabase.instance
          .ref()
          .child("${isSuggestedArticle ? "article_sugestions" : "articles"}/")
          .push();

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
    final storageRef = FirebaseStorage.instance.ref().child(
        "${isSuggestedArticle ? "article_sugestions" : "articles"}/$articleId");

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
            setState(() {
              isSaving = false;
            });
          });
          break;
      }
    });
  }

  // ignore: prefer_final_fields
  var _initvalue = {
    'articleTitle': '',
    'articleDiscription': '',
    'articleId': '',
  };

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final routeData = ModalRoute.of(context)!.settings.arguments as Map;
      // ignore: unnecessary_null_comparison
      if (routeData != null) {
        article = routeData["info"];
        isSuggestedArticle = routeData["isSuggested"];
        _isUpdate = true;
        _initvalue = {
          'articleTitle': article!.title!,
          'articleDiscription': article!.discription!,
          'articleId': article!.articlesId,
        };
        altImageWidget = Image(
          image: NetworkImage(article!.newsImageURL!),
        );
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> updateForm() async {
    if (_submitArticleScreenKey.currentState!.validate() &&
        altImageWidget != null) {
      setState(() {
        isSaving = true;
      });
      _submitArticleScreenKey.currentState!.save();

      await FirebaseDatabase.instance
          .ref()
          .child(
              "${isSuggestedArticle ? "article_sugestions" : "articles"}/${_initvalue['articleId']}")
          .update({
        "discription": articleDescription,
        "title": articleTitle,
      });
      final NewsArticle updatedArticle = NewsArticle(
        articlesId: article!.articlesId,
        title: articleTitle,
        comments: article!.comments,
        newsImageURL: article!.newsImageURL,
        discription: articleDescription,
        username: article!.username,
        userProfilePicture: article!.userProfilePicture,
        userId: article!.userId,
        publishedDate: article!.publishedDate,
        upVotes: article!.upVotes,
        articleViews: article!.articleViews,
        isBookmarked: article!.isBookmarked,
      );
      isSuggestedArticle
          ? await Provider.of<Articles>(context, listen: false)
              .fetchAndSetSuggestedArticles()
          : await Provider.of<Articles>(context, listen: false)
              .updateArticles(updatedArticle);

      setState(() {
        altImageWidget = null;
        _initvalue = {
          'articleTitle': '',
          'articleDiscription': '',
          'articleId': '',
        };
        _submitArticleScreenKey.currentState!.reset();
      });
      setState(() {
        isSaving = false;
      });
      Navigator.of(context).pop();
    }
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
            _initvalue["articleTitle"],
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
            initialValue: _initvalue["articleDiscription"],
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
      child: isSaving
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ElevatedButton(
              onPressed: () async {
                _isUpdate
                    ? await updateForm()
                    : await saveForm(Provider.of<UserAccount>(
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
                  : Text(
                      _isUpdate ? "Update Article" : "Submit Articles",
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
            ),
    );
  }

  Widget customeFormField(
    String? initvalue,
    Widget? icon,
    String hint, {
    void Function(String?)? onSaved,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
  }) {
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
