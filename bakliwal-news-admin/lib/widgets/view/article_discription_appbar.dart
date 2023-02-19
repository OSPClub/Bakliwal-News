import 'package:bakliwal_news_admin/widgets/header.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:bakliwal_news_admin/style/style_declaration.dart';
import 'package:bakliwal_news_admin/models/news_articles.dart';

class ArticleDiscriptionAppBar extends StatelessWidget {
  final NewsArticle newsArticle;
  final Future<void> Function(dynamic) reload;
  const ArticleDiscriptionAppBar({
    super.key,
    required this.newsArticle,
    required this.reload,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        articleInformationWidget(),
        Row(
          children: [
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
          ClipRRect(
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
