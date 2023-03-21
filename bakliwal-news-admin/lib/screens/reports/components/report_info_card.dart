import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:bakliwal_news_admin/constants.dart';
import 'package:bakliwal_news_admin/models/report_model.dart';
import 'package:bakliwal_news_admin/screens/secondary_screens/article_discription_screen.dart';
import 'package:bakliwal_news_admin/style/style_declaration.dart';

// ignore: must_be_immutable
class ReportInfoCardGridView extends StatefulWidget {
  ReportInfoCardGridView({
    Key? key,
    this.crossAxisCount = 4,
    this.childAspectRatio = 1,
    required this.allReports,
  }) : super(key: key);

  final int crossAxisCount;
  final double childAspectRatio;
  List<Report>? allReports;

  @override
  State<ReportInfoCardGridView> createState() => _ReportInfoCardGridViewState();
}

class _ReportInfoCardGridViewState extends State<ReportInfoCardGridView> {
  @override
  Widget build(BuildContext context) {
    void rebuiltState(Report report) {
      setState(() {
        widget.allReports!.remove(report);
      });
    }

    return widget.allReports!.isEmpty || widget.allReports == null
        ? const Center(
            child: Text("There are no reports. hurray! "),
          )
        : GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: widget.allReports!.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: widget.crossAxisCount,
              crossAxisSpacing: defaultPadding,
              mainAxisSpacing: defaultPadding,
              childAspectRatio: widget.childAspectRatio,
            ),
            itemBuilder: (context, index) => ReportInfoCard(
              isSuggested: false,
              info: widget.allReports![index],
              rebuiltState: rebuiltState,
            ),
          );
  }
}

class ReportInfoCard extends StatelessWidget {
  const ReportInfoCard({
    Key? key,
    required this.info,
    this.isSuggested = false,
    required this.rebuiltState,
  }) : super(key: key);

  final Report info;
  final bool isSuggested;
  final void Function(Report) rebuiltState;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(
          ArticleDiscriptionScreen.routeName,
          arguments: info.reportedArticle,
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          info.usersName,
                          style: const TextStyle(color: Colors.red),
                          overflow: TextOverflow.clip,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          DateFormat("yMMMd").format(info.reportedTime),
                          style: const TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ],
                ),
                customePopup(),
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
                    info.reportedArticle!.newsImageURL == null
                        ? "https://www.interpeace.org/wp-content/themes/twentytwenty/img/image-placeholder.png"
                        : info.reportedArticle!.newsImageURL!,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Flexible(
              child: Text(
                info.reportedArticle!.title == null
                    ? "Unknown Error"
                    : info.reportedArticle!.title!,
                overflow: TextOverflow.clip,
              ),
            ),
            Text(
              info.reportedArticle!.publishedDate == null
                  ? "Unknown Error"
                  : DateFormat("yMMMd")
                      .format(info.reportedArticle!.publishedDate!),
              style: const TextStyle(color: Colors.white54),
            ),
          ],
        ),
      ),
    );
  }

  PopupMenuButton customePopup() {
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
          await FirebaseDatabase.instance
              .ref("reports")
              .child(info.reportId)
              .remove();
          rebuiltState(info);
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 1,
          child: Row(
            children: const [
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
}
