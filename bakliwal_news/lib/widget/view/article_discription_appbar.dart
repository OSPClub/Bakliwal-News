import 'package:bakliwal_news/models/public_article_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:bakliwal_news/models/screen_enums.dart';
import 'package:bakliwal_news/widget/view/common_article_popmenue.dart';
import 'package:bakliwal_news/style/style_declaration.dart';
import 'package:bakliwal_news/models/user_article.dart';

class ArticleDiscriptionAppBar extends StatelessWidget {
  final UserArticle? userArticle;
  final PublicArticleCanonicalModel? publicArticle;
  const ArticleDiscriptionAppBar({
    super.key,
    required this.userArticle,
    required this.publicArticle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        articleInformationWidget(),
        Row(
          children: [
            publicArticle == null
                ? CommonArticlePopMenue(
                    newsArticle: userArticle!,
                    iconSize: 35,
                    screenName: ScreenType.articleDiscription,
                  )
                : Container(),
            publicArticle == null
                ? const SizedBox(
                    width: 10,
                  )
                : Container(),
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
          publicArticle == null
              ? userArticle!.userProfilePicture == null ||
                      userArticle!.userProfilePicture!.isEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: const Image(
                        height: 40,
                        width: 40,
                        fit: BoxFit.cover,
                        image:
                            AssetImage("assets/images/profilePlaceholder.jpeg"),
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
                          userArticle!.userProfilePicture!,
                        ),
                      ),
                    )
              : publicArticle!.user.profileImage == null ||
                      publicArticle!.user.profileImage!.isEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: const Image(
                        height: 40,
                        width: 40,
                        fit: BoxFit.cover,
                        image:
                            AssetImage("assets/images/profilePlaceholder.jpeg"),
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
                          publicArticle!.user.profileImage!,
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
                  publicArticle == null
                      ? userArticle!.username!
                      : publicArticle!.user.name!,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(
                  height: 2,
                ),
                Text(
                  "Published on ${DateFormat("yMMMd").format(
                    publicArticle == null
                        ? userArticle!.publishedDate!
                        : publicArticle!.publishedTimestamp!,
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
