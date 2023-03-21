import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'package:bakliwal_news_admin/responsive.dart';
import 'package:bakliwal_news_admin/constants.dart';
import 'package:bakliwal_news_admin/providers/articles.dart';
import 'package:bakliwal_news_admin/widgets/header.dart';
import 'package:bakliwal_news_admin/models/news_articles.dart';
import 'package:bakliwal_news_admin/widgets/article_info_card.dart';

class SuggestedArticlesScreen extends StatefulWidget {
  const SuggestedArticlesScreen({super.key});

  @override
  State<SuggestedArticlesScreen> createState() =>
      _SuggestedArticlesScreenState();
}

class _SuggestedArticlesScreenState extends State<SuggestedArticlesScreen> {
  List<NewsArticle> suggestedNewsArticles = [];
  bool isLoading = true;

  @override
  initState() {
    loadData(context);
    super.initState();
  }

  Future<void> loadData(context) async {
    final articlesDataRef = Provider.of<Articles>(context, listen: false);
    await articlesDataRef.fetchAndSetSuggestedArticles();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    suggestedNewsArticles = Provider.of<Articles>(
      context,
    ).suggestedNewsArticles;
    suggestedNewsArticles.sort(
        (a, b) => b.publishedDate!.compareTo(a.publishedDate as DateTime));
    return SafeArea(
      child: SingleChildScrollView(
        primary: false,
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            const Header(pageType: "Suggestions", needSearchBar: false),
            const SizedBox(height: defaultPadding),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "New Ideas!",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                // ElevatedButton.icon(
                //   style: TextButton.styleFrom(
                //     padding: EdgeInsets.symmetric(
                //       horizontal: defaultPadding * 1.5,
                //       vertical: defaultPadding /
                //           (Responsive.isMobile(context) ? 2 : 1),
                //     ),
                //   ),
                //   onPressed: () {},
                //   icon: const Icon(Icons.add),
                //   label: const Text("Add New"),
                // ),
              ],
            ),
            const SizedBox(height: defaultPadding),
            isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : suggestedNewsArticles.isEmpty
                    ? const Center(
                        child: Text("Suggestions is Empty!"),
                      )
                    : Responsive(
                        mobile: FileInfoCardGridView(
                          crossAxisCount: size.width < 650 ? 1 : 2,
                          childAspectRatio:
                              size.width < 650 && size.width > 350 ? 1 : 1,
                          suggestedNewsArticles: suggestedNewsArticles,
                        ),
                        tablet: FileInfoCardGridView(
                            suggestedNewsArticles: suggestedNewsArticles),
                        desktop: FileInfoCardGridView(
                          childAspectRatio: size.width < 1400 ? 0.7 : 1.4,
                          suggestedNewsArticles: suggestedNewsArticles,
                        ),
                      ),
          ],
        ),
      ),
    );
  }
}

class FileInfoCardGridView extends StatelessWidget {
  const FileInfoCardGridView({
    Key? key,
    this.crossAxisCount = 4,
    this.childAspectRatio = 1,
    required this.suggestedNewsArticles,
  }) : super(key: key);

  final int crossAxisCount;
  final double childAspectRatio;
  final List<NewsArticle> suggestedNewsArticles;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: suggestedNewsArticles.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: defaultPadding,
        mainAxisSpacing: defaultPadding,
        childAspectRatio: childAspectRatio,
      ),
      itemBuilder: (context, index) => ArticleInfoCard(
        isSuggested: true,
        info: suggestedNewsArticles[index],
      ),
    );
  }
}
