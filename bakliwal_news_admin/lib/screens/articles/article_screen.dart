import 'package:bakliwal_news_admin/screens/secondary_screens/submit_article_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:bakliwal_news_admin/providers/articles.dart';
import 'package:bakliwal_news_admin/responsive.dart';
import 'package:bakliwal_news_admin/constants.dart';
import 'package:bakliwal_news_admin/widgets/header.dart';
import 'package:bakliwal_news_admin/models/news_articles.dart';
import 'package:bakliwal_news_admin/widgets/article_info_card.dart';

class ArticlesScreen extends StatefulWidget {
  const ArticlesScreen({super.key});

  @override
  State<ArticlesScreen> createState() => _ArticlesScreenState();
}

class _ArticlesScreenState extends State<ArticlesScreen> {
  List<NewsArticle> newsArticles = [];
  bool isLoading = false;
  ScrollController paginationScrollController = ScrollController();
  bool gettingMoreArticles = false;
  bool moreArticlesAvailable = true;

  @override
  initState() {
    loadData(context);
    paginationScrollController.addListener(() {
      double maxScroll = paginationScrollController.position.maxScrollExtent;
      double currentScroll = paginationScrollController.position.pixels;
      double threshold = MediaQuery.of(context).size.height * 0.25;

      if (maxScroll - currentScroll <= threshold) {
        final articlesDataRef = Provider.of<Articles>(context, listen: false);
        articlesDataRef.fetchAndSetMoreArticles();
      }
    });
    super.initState();
  }

  Future<void> loadData(context) async {
    setState(() {
      isLoading = true;
    });
    final articlesDataRef = Provider.of<Articles>(context, listen: false);
    await articlesDataRef.fetchAndSetInitArticles();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    newsArticles = Provider.of<Articles>(
      context,
    ).newsArticles;
    newsArticles.sort(
        (a, b) => b.publishedDate!.compareTo(a.publishedDate as DateTime));
    moreArticlesAvailable =
        Provider.of<Articles>(context).moreArticlesAvailable;
    gettingMoreArticles = Provider.of<Articles>(context).gettingMoreArticles;
    return SafeArea(
      child: SingleChildScrollView(
        controller: paginationScrollController,
        primary: false,
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            const Header(pageType: "Articles", needSearchBar: true),
            const SizedBox(height: defaultPadding),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "All Plates",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                ElevatedButton.icon(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      horizontal: defaultPadding * 1.5,
                      vertical: defaultPadding /
                          (Responsive.isMobile(context) ? 2 : 1),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamed(SubmitArticleScreen.routeName);
                  },
                  icon: const Icon(Icons.add),
                  label: const Text("Add New"),
                ),
              ],
            ),
            const SizedBox(height: defaultPadding),
            isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : newsArticles.isEmpty
                    ? const Center(
                        child: Text("Feed is Empty!"),
                      )
                    : Column(
                        children: [
                          Responsive(
                            mobile: FileInfoCardGridView(
                              crossAxisCount: size.width < 650 ? 1 : 2,
                              childAspectRatio:
                                  size.width < 650 && size.width > 350 ? 1 : 1,
                              newsArticles: newsArticles,
                              loadData: loadData,
                            ),
                            tablet: FileInfoCardGridView(
                                loadData: loadData, newsArticles: newsArticles),
                            desktop: FileInfoCardGridView(
                              childAspectRatio: size.width < 1400 ? 0.7 : 1.4,
                              loadData: loadData,
                              newsArticles: newsArticles,
                            ),
                          ),
                          if (gettingMoreArticles)
                            const Padding(
                              padding: EdgeInsets.all(20.0),
                              child: CircularProgressIndicator(),
                            ),
                          if (!moreArticlesAvailable)
                            const Padding(
                              padding: EdgeInsets.all(30),
                              child: Center(
                                  child: Text(
                                "No More Articles!!",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              )),
                            ),
                        ],
                      ),
          ],
        ),
      ),
    );
  }
}

class FileInfoCardGridView extends StatelessWidget {
  const FileInfoCardGridView({
    super.key,
    this.crossAxisCount = 4,
    this.childAspectRatio = 1,
    required this.newsArticles,
    required this.loadData,
  });

  final int crossAxisCount;
  final double childAspectRatio;
  final List<NewsArticle> newsArticles;
  final Future<void> Function(BuildContext) loadData;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: newsArticles.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: defaultPadding,
        mainAxisSpacing: defaultPadding,
        childAspectRatio: childAspectRatio,
      ),
      itemBuilder: (context, index) => ArticleInfoCard(
        isSuggested: false,
        info: newsArticles[index],
        loadData: loadData,
      ),
    );
  }
}
