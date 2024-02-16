import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:bakliwal_news_admin/constants.dart';
import 'package:bakliwal_news_admin/responsive.dart';
import 'package:bakliwal_news_admin/widgets/header.dart';
import 'package:bakliwal_news_admin/models/report_model.dart';
import 'package:bakliwal_news_admin/providers/user_account/reports_provider.dart';
import 'package:bakliwal_news_admin/screens/reports/components/report_info_card.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  static const routeName = "/report-screen";

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  List<ArticleReport> allArticleReports = [];
  List<CommentReport> allCommentReports = [];
  bool isLoading = false;

  @override
  initState() {
    loadData(context);
    super.initState();
  }

  Future<void> loadData(context) async {
    setState(() {
      isLoading = true;
    });
    final reportsDataRef = Provider.of<ReportsProvider>(context, listen: false);
    await reportsDataRef.fetchAndSetArticleReportData(context);
    await reportsDataRef.fetchAndSetCommentReportData(context);
    setState(() {
      isLoading = false;
    });
  }

  String dropdownValue = 'Articles';

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    allArticleReports = Provider.of<ReportsProvider>(
      context,
    ).allArticleReports;
    allArticleReports.sort((a, b) => b.reportedTime.compareTo(a.reportedTime));

    allCommentReports = Provider.of<ReportsProvider>(
      context,
    ).allCommentsReports;
    allCommentReports.sort((a, b) => b.reportedTime.compareTo(a.reportedTime));

    return SafeArea(
      child: SingleChildScrollView(
        primary: false,
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            Header(
                pageType: dropdownValue == "Articles"
                    ? "Reported Articles"
                    : "Reported Comments",
                needSearchBar: false),
            const SizedBox(height: defaultPadding),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Concerns!",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    // Step 3.
                    value: dropdownValue,
                    // Step 4.
                    items: <String>['Articles', 'Comments']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: const TextStyle(fontSize: 16),
                        ),
                      );
                    }).toList(),
                    // Step 5.
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownValue = newValue!;
                      });
                    },
                    icon: const Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Icon(Icons.arrow_circle_down_sharp)),
                    iconEnabledColor: Colors.white,
                    style: const TextStyle(
                      color: Colors.white,
                    ),

                    dropdownColor: Colors.redAccent,
                  ),
                ),
              ],
            ),
            const SizedBox(height: defaultPadding),
            isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : dropdownValue == "Articles"
                    ? allArticleReports.isEmpty
                        ? const Center(
                            child: Text("No Reported Articles! Rest easy."),
                          )
                        : Responsive(
                            mobile: ReportInfoCardGridView(
                              crossAxisCount: size.width < 650 ? 1 : 2,
                              childAspectRatio:
                                  size.width < 650 && size.width > 350 ? 1 : 1,
                              allReports: allArticleReports,
                            ),
                            tablet: ReportInfoCardGridView(
                                allReports: allArticleReports),
                            desktop: ReportInfoCardGridView(
                              childAspectRatio: size.width < 1400 ? 0.7 : 1.4,
                              allReports: allArticleReports,
                            ),
                          )
                    : allCommentReports.isEmpty
                        ? const Center(
                            child: Text("No Reported Comments! Rest easy."),
                          )
                        : Responsive(
                            mobile: ReportCommentInfoCardGridView(
                              crossAxisCount: size.width < 650 ? 1 : 2,
                              childAspectRatio:
                                  size.width < 650 && size.width > 350 ? 1 : 1,
                              allComments: allCommentReports,
                            ),
                            tablet: ReportCommentInfoCardGridView(
                                allComments: allCommentReports),
                            desktop: ReportCommentInfoCardGridView(
                              childAspectRatio: size.width < 1400 ? 0.7 : 1.4,
                              allComments: allCommentReports,
                            ),
                          ),
          ],
        ),
      ),
    );
  }
}
