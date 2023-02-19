import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:bakliwal_news_app/models/screen_enums.dart';
import 'package:bakliwal_news_app/widget/view/common_article_popmenue.dart';
import 'package:bakliwal_news_app/style/style_declaration.dart';
import 'package:bakliwal_news_app/models/news_article.dart';

class ArticleDiscriptionAppBar extends StatelessWidget {
  final NewsArticle newsArticle;
  const ArticleDiscriptionAppBar({
    super.key,
    required this.newsArticle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        articleInformationWidget(),
        Row(
          children: [
            CommonArticlePopMenue(
              newsArticle: newsArticle,
              iconSize: 35,
              screenName: ScreenType.articleDiscription,
            ),
            const SizedBox(
              width: 10,
            ),
            InkWell(
              onTap: () => Navigator.of(context).pop(),
              child: const Icon(
                Icons.close_rounded,
                color: AppColors.secondary,
                size: 40,
              ),
            ),
          ],
        )
      ],
    );
  }

  SizedBox articleInformationWidget() {
    return SizedBox(
      width: 150,
      child: Row(
        children: [
          newsArticle.userProfilePicture == null ||
                  newsArticle.userProfilePicture!.isEmpty
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: const Image(
                    height: 40,
                    width: 40,
                    fit: BoxFit.cover,
                    image: AssetImage("assets/images/profilePlaceholder.jpeg"),
                  ),
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image(
                    height: 40,
                    width: 40,
                    fit: BoxFit.cover,
                    image: NetworkImage(
                      scale: 15,
                      newsArticle.userProfilePicture!,
                    ),
                  ),
                ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  newsArticle.username!,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(
                  height: 2,
                ),
                Text(
                  "Published on ${DateFormat("yMMMd").format(
                    newsArticle.publishedDate!,
                  )}",
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.blueGrey[200],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
