import 'dart:math' as math;

// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:html/parser.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import 'package:bakliwal_news/style/shimmers_effect.dart';

import 'package:bakliwal_news/models/public_article_model.dart';
import 'package:bakliwal_news/style/style_declaration.dart';
import 'package:bakliwal_news/widget/view/article_discription_appbar.dart';

// ignore: must_be_immutable
class PublicArticleCanonical extends StatefulWidget {
  const PublicArticleCanonical({super.key});

  static const routeName = "./public-article-canonical";

  @override
  State<PublicArticleCanonical> createState() => _PublicArticleCanonicalState();
}

class _PublicArticleCanonicalState extends State<PublicArticleCanonical> {
  PublicArticleCanonicalModel? newsArticle;

  @override
  Widget build(BuildContext context) {
    newsArticle = ModalRoute.of(context)!.settings.arguments
        as PublicArticleCanonicalModel;
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: MainDescriptionContent(
        constNewsArticle: newsArticle!,
      ),
    );
  }
}

class MainDescriptionContent extends StatelessWidget {
  const MainDescriptionContent({
    super.key,
    required this.constNewsArticle,
  });
  final PublicArticleCanonicalModel constNewsArticle;
  @override
  Widget build(
    BuildContext context,
  ) {
    PublicArticleCanonicalModel newsArticle = constNewsArticle;
    List<PublicComments>? allComments = constNewsArticle.comments;
    allComments.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding:
              const EdgeInsets.only(top: 15, left: 25, right: 25, bottom: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ArticleDiscriptionAppBar(
                userArticle: null,
                publicArticle: newsArticle,
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                newsArticle.title!,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  wordSpacing: 5,
                  fontFamily: AppFonts.cabin,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                padding: const EdgeInsets.only(left: 5),
                decoration: const BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      width: 3,
                      color: AppColors.accent,
                    ),
                  ),
                ),
                child: Markdown(
                  // selectable: true,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  data: newsArticle.description!,
                  imageBuilder: (uri, _, __) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        uri.toString(),
                        frameBuilder:
                            (context, child, frame, wasSynchronouslyLoaded) {
                          return child;
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          } else {
                            return CustomShimmerEffect.rectangular(
                              height: 150,
                            );
                          }
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Image.network(
                            "https://upload.wikimedia.org/wikipedia/commons/thumb/d/d1/Image_not_available.png/800px-Image_not_available.png",
                          );
                        },
                      ),
                    );
                  },
                  onTapLink: (s1, s2, s3) async {
                    var url = s2;

                    if (await canLaunchUrl(Uri.parse(url!))) {
                      await launchUrl(
                        Uri.parse(url),
                        mode: LaunchMode.externalApplication,
                      );
                    } else {
                      throw 'There was a problem to open the url: $url';
                    }
                  },
                  styleSheet: MarkdownStyleSheet(
                    h1: const TextStyle(fontSize: 24, color: Colors.white),
                    h2: const TextStyle(fontSize: 20, color: Colors.white),
                    h3: const TextStyle(fontSize: 18, color: Colors.white),
                    h4: const TextStyle(fontSize: 16, color: Colors.white),
                    h5: const TextStyle(fontSize: 14, color: Colors.white),
                    h6: const TextStyle(fontSize: 12, color: Colors.white),
                    a: const TextStyle(color: AppColors.accent),
                    p: const TextStyle(color: Colors.white),
                    tableBody: const TextStyle(color: Colors.white),
                    listBullet: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  newsArticle.coverImage!,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.network(
                      "https://upload.wikimedia.org/wikipedia/commons/thumb/d/d1/Image_not_available.png/800px-Image_not_available.png",
                    );
                  },
                  frameBuilder:
                      (context, child, frame, wasSynchronouslyLoaded) {
                    return child;
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    } else {
                      return CustomShimmerEffect.rectangular(
                        height: 150,
                      );
                    }
                  },
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Wrap(
                // spacing: 5,
                runSpacing: 5,
                children: [
                  if (newsArticle.tags![0].hashCode != 1)
                    ...newsArticle.tags!.map((e) {
                      return Card(
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                        color: const Color.fromARGB(255, 37, 37, 37),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 10),
                          child: Text(
                            "#${e.toString().trim()}",
                            style: const TextStyle(
                              color: Color.fromARGB(255, 180, 188, 207),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    })
                ],
              ),
              const SizedBox(
                height: 25,
              ),
              Row(
                children: [
                  Text(
                    "${newsArticle.publicReactionsCount} Upvotes",
                    style: const TextStyle(
                      color: AppColors.secondary,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    "${newsArticle.comments.length} Comments",
                    style: const TextStyle(
                      color: AppColors.secondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              const Divider(
                color: AppColors.secondary,
              ),
              const SizedBox(
                height: 15,
              ),
              ...allComments.map((comment) {
                return ArticleComments(
                  comment: comment,
                  newsArticle: newsArticle,
                  commentReplyPadding: 25,
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class ArticleComments extends StatefulWidget {
  ArticleComments({
    super.key,
    required this.comment,
    required this.newsArticle,
    required this.commentReplyPadding,
  });

  final PublicComments comment;
  PublicArticleCanonicalModel newsArticle;
  double commentReplyPadding;

  @override
  State<ArticleComments> createState() => _ArticleCommentsState();
}

class _ArticleCommentsState extends State<ArticleComments> {
  @override
  Widget build(BuildContext context) {
    // ignore: avoid_unnecessary_containers
    return Container(
      child: Column(
        children: [
          CommentCard(comment: widget.comment),
          if (widget.comment.children.isNotEmpty)
            Container(
              padding: EdgeInsets.only(left: widget.commentReplyPadding),
              child: Column(
                children: [
                  ...widget.comment.children.map((element) {
                    return ArticleComments(
                      comment: element,
                      newsArticle: widget.newsArticle,
                      commentReplyPadding: 10,
                    );
                  }).toList(),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class CommentCard extends StatelessWidget {
  const CommentCard({super.key, required this.comment});

  String _parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString =
        parse(document.body!.text).documentElement!.text;

    return parsedString;
  }

  final PublicComments comment;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 40.0,
                  width: 40.0,
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.all(
                      Radius.circular(7),
                    ),
                  ),
                  child: comment.user.profileImage == null ||
                          comment.user.profileImage!.isEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(7),
                          child: const Image(
                            fit: BoxFit.cover,
                            image: AssetImage(
                              "assets/images/profilePlaceholder.jpeg",
                            ),
                          ),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(7),
                          child: Image(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                              comment.user.profileImage!,
                            ),
                          ),
                        ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      comment.user.username!,
                      style: const TextStyle(color: Colors.white),
                    ),
                    Text(
                      DateFormat("MMMd").format(
                        comment.createdAt,
                      ),
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.blueGrey[200],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey[900],
          ),
          margin: const EdgeInsets.symmetric(vertical: 10),
          padding: const EdgeInsets.all(15),
          child: Text(
            _parseHtmlString(comment.commentBody).trim(),
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}

class DescriptionTextWidget extends StatefulWidget {
  final String text;

  const DescriptionTextWidget({
    super.key,
    required this.text,
  });

  @override
  // ignore: library_private_types_in_public_api
  _DescriptionTextWidgetState createState() => _DescriptionTextWidgetState();
}

class _DescriptionTextWidgetState extends State<DescriptionTextWidget> {
  String? firstHalf;
  String? secondHalf;

  bool flag = true;

  @override
  void initState() {
    super.initState();

    if (widget.text.length > 500) {
      firstHalf = widget.text.substring(0, 500);
      secondHalf = widget.text.substring(500, widget.text.length);
    } else {
      firstHalf = widget.text;
      secondHalf = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
      child: secondHalf!.isEmpty
          ? Text(
              firstHalf!,
              style: TextStyle(
                color: Colors.grey[350]!,
                fontFamily: AppFonts.cabin,
                fontSize: 16,
              ),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  flag ? ("${firstHalf!}...") : (firstHalf! + secondHalf!),
                  style: TextStyle(
                    color: Colors.grey[350]!,
                    fontFamily: AppFonts.cabin,
                    fontSize: 16,
                  ),
                ),
                InkWell(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        flag ? "show more" : "show less",
                        style: const TextStyle(color: Colors.blue),
                      ),
                    ],
                  ),
                  onTap: () {
                    setState(() {
                      flag = !flag;
                    });
                  },
                ),
              ],
            ),
    );
  }
}
