// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:intl/intl.dart';
import 'package:html/parser.dart';

import 'package:bakliwal_news/style/shimmers_effect.dart';

import 'package:bakliwal_news/models/public_article_model.dart';
import 'package:bakliwal_news/widget/view/article_discription_appbar.dart';
import 'package:bakliwal_news/style/style_declaration.dart';
import 'package:url_launcher/url_launcher.dart';

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
  });

  final PublicComments comment;
  PublicArticleCanonicalModel newsArticle;

  @override
  State<ArticleComments> createState() => _ArticleCommentsState();
}

class _ArticleCommentsState extends State<ArticleComments> {
  String _parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString =
        parse(document.body!.text).documentElement!.text;

    return parsedString;
  }

  @override
  Widget build(BuildContext context) {
    // ignore: avoid_unnecessary_containers
    return Container(
      child: Column(
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
                    child: widget.comment.user.profileImage == null ||
                            widget.comment.user.profileImage!.isEmpty
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
                                widget.comment.user.profileImage!,
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
                        widget.comment.user.username!,
                        style: const TextStyle(color: Colors.white),
                      ),
                      Text(
                        DateFormat("MMMd").format(
                          widget.comment.createdAt,
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
              _parseHtmlString(widget.comment.commentBody).trim(),
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          // Row(
          //   children: [
          //     IconButton(onPressed: () {}, icon: const Icon(Icons.add))
          //   ],
          // )
        ],
      ),
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
