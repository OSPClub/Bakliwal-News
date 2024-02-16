// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:bakliwal_news_admin/constants.dart';
import 'package:bakliwal_news_admin/custome_icons_icons.dart';
import 'package:bakliwal_news_admin/models/news_articles.dart';
import 'package:bakliwal_news_admin/providers/articles.dart';
import 'package:bakliwal_news_admin/screens/secondary_screens/article_discription_screen.dart';
import 'package:bakliwal_news_admin/screens/secondary_screens/submit_article_screen.dart';
import 'package:bakliwal_news_admin/style/style_declaration.dart';

class ArticleInfoCard extends StatelessWidget {
  const ArticleInfoCard({
    super.key,
    required this.info,
    this.isSuggested = false,
    required this.loadData,
  });

  final NewsArticle info;
  final bool isSuggested;
  final Future<void> Function(BuildContext) loadData;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(
          ArticleDiscriptionScreen.routeName,
          arguments: info,
        );
      },
      child: Container(
        padding: const EdgeInsets.all(defaultPadding),
        decoration: const BoxDecoration(
          color: secondaryColor,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SizedBox(
                      height: 30,
                      width: 30,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(7),
                        child: Image(
                          fit: BoxFit.cover,
                          image: info.userProfilePicture == null ||
                                  info.userProfilePicture!.isEmpty
                              ? const AssetImage(
                                  "assets/images/profilePlaceholder.jpeg",
                                ) as ImageProvider<Object>
                              : NetworkImage(
                                  info.userProfilePicture!,
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      info.username == null ? "Unknown Error" : info.username!,
                      overflow: TextOverflow.ellipsis,
                    )
                  ],
                ),
                // IconButton(
                //   icon: const Icon(Icons.more_vert),
                //   onPressed: () {},
                // ),
                CustomePopup(
                  info: info,
                  isSuggested: isSuggested,
                  loadData: loadData,
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 150,
              width: double.infinity,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image(
                  fit: BoxFit.fill,
                  image: NetworkImage(
                    info.newsImageURL == null
                        ? "https://www.interpeace.org/wp-content/themes/twentytwenty/img/image-placeholder.png"
                        : info.newsImageURL!,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Flexible(
              child: Text(
                info.title == null ? "Unknown Error" : info.title!,
                overflow: TextOverflow.clip,
              ),
            ),
            Text(
              info.publishedDate == null
                  ? "Unknown Error"
                  : DateFormat("yMMMd").format(info.publishedDate!),
              style: const TextStyle(color: Colors.white54),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomePopup extends StatefulWidget {
  const CustomePopup({
    super.key,
    required this.info,
    this.isSuggested = false,
    required this.loadData,
  });
  final NewsArticle info;
  final Future<void> Function(BuildContext) loadData;
  final bool isSuggested;

  @override
  State<CustomePopup> createState() => _CustomePopupState();
}

class _CustomePopupState extends State<CustomePopup> {
  String errorMessage = '';
  double progress = 0;
  bool isUploading = false;
  String profilePictureUploadStatus = "";
  File? systemImageFile;
  bool isSaving = false;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      splashRadius: 20,
      elevation: 20,
      offset: const Offset(-12, 40),
      icon: const Icon(
        Icons.more_vert_sharp,
        color: AppColors.secondary,
      ),
      color: AppColors.secondary,
      onSelected: (value) async {
        if (value == 1) {
          Navigator.of(context).pushNamed(
            SubmitArticleScreen.routeName,
            arguments: {"info": widget.info, "isSuggested": widget.isSuggested},
          );
        } else if (value == 2) {
          if (widget.isSuggested) {
            await FirebaseFirestore.instance
                .collection("article_sugestions")
                .doc(widget.info.articlesId)
                .delete();
            await FirebaseStorage.instance
                .ref("article_sugestions/${widget.info.articlesId}")
                .delete();
            await FirebaseDatabase.instance
                .ref()
                .child(
                    "users/${widget.info.userId}/submited-articles/${widget.info.articlesId}")
                .remove();
            await Provider.of<Articles>(context, listen: false)
                .fetchAndSetSuggestedArticles();
            widget.loadData;
          } else {
            await FirebaseFirestore.instance
                .collection("articles")
                .doc(widget.info.articlesId)
                .delete();
            await FirebaseStorage.instance
                .ref("articles/${widget.info.articlesId}")
                .delete();
            await FirebaseDatabase.instance
                .ref()
                .child(
                    "users/${widget.info.userId}/articles/${widget.info.articlesId}")
                .remove();
            await FirebaseDatabase.instance
                .ref()
                .child("upVotes/${widget.info.articlesId}")
                .remove();
            final commentRef = await FirebaseDatabase.instance
                .ref()
                .child("comments/${widget.info.articlesId}")
                .get();
            if (commentRef.exists) {
              final allComments = commentRef.value as Map;
              allComments.forEach((key, comment) async {
                await FirebaseDatabase.instance
                    .ref(
                        "users/${comment["commentorUserId"]}/comments/${comment["commentId"]}")
                    .remove();
              });
            }
            await FirebaseDatabase.instance
                .ref()
                .child("comments/${widget.info.articlesId}")
                .remove();

            await Provider.of<Articles>(context, listen: false)
                .fetchAndSetInitArticles();
          }
        } else if (value == 3) {
          final firebaseRef = FirebaseFirestore.instance;
          final articleImageRef = FirebaseStorage.instance
              .ref()
              .child("article_sugestions/${widget.info.articlesId}");

          try {
            const oneMegabyte = 1024 * 1024 * 5;
            final Uint8List? data = await articleImageRef.getData(oneMegabyte);

            await firebaseRef
                .collection("articles")
                .doc(widget.info.articlesId)
                .set({
              "discription": widget.info.discription,
              "newsImageURL": widget.info.newsImageURL,
              "publishedDate": DateTime.now().toString(),
              "title": widget.info.title,
              "userId": widget.info.userId,
              "timestamp": FieldValue.serverTimestamp(),
            });
            final ownerInfo = FirebaseDatabase.instance
                .ref()
                .child("users/${widget.info.userId}");
            await ownerInfo.child("articles/${widget.info.articlesId}").set({
              "dateOfPost": widget.info.publishedDate.toString(),
            });
            await ownerInfo
                .child("submited-articles/${widget.info.articlesId}")
                .remove();
            await uploadFile(data!, widget.info.articlesId);
            await firebaseRef
                .collection("article_sugestions")
                .doc(widget.info.articlesId)
                .delete();
            await Provider.of<Articles>(
              context,
              listen: false,
            ).fetchAndSetSuggestedArticles();
          } on FirebaseException catch (e) {
            errorMessage =
                "Unknown Error! Failed to Publish | system: '${e.message}'";
          }
          widget.loadData;
        }
      },
      itemBuilder: (context) => [
        if (widget.isSuggested)
          const PopupMenuItem(
            value: 3,
            child: Row(
              children: [
                Icon(
                  CustomeIcons.noun_send_1408229,
                  color: secondaryColor,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "Publish Article",
                  style: TextStyle(
                    color: secondaryColor,
                  ),
                ),
              ],
            ),
          ),
        const PopupMenuItem(
          value: 1,
          child: Row(
            children: [
              Icon(
                Icons.change_circle,
                color: secondaryColor,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                "Edit Article",
                style: TextStyle(
                  color: secondaryColor,
                ),
              ),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 2,
          child: Row(
            children: [
              Icon(
                Icons.delete,
                color: secondaryColor,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                "Delete",
                style: TextStyle(color: secondaryColor),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> uploadFile(Uint8List file, String articleId) async {
    profilePictureUploadStatus = "";
    final storageRef = FirebaseStorage.instance.ref();

    var uploadTask = storageRef.child("articles/$articleId").putData(
          file,
          SettableMetadata(contentType: "image/jpeg"),
        );
    uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) async {
      switch (taskSnapshot.state) {
        case TaskState.running:
          isUploading = true;
          progress = (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);

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
              .child("articles/$articleId")
              .getDownloadURL();

          await FirebaseFirestore.instance
              .collection("articles")
              .doc("/$articleId")
              .update({
            "newsImageURL": urlDownload,
          });
          await storageRef.child("article_sugestions/$articleId").delete();
          isUploading = false;
          profilePictureUploadStatus = "Upload is 100% complete.";
          setState(() {
            isSaving = false;
          });

          break;
      }
    });
  }
}
