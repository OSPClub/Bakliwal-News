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
  List<Report> allReports = [];
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
    await reportsDataRef.fetchAndSetReportData(context);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    allReports = Provider.of<ReportsProvider>(
      context,
    ).allReports;
    allReports.sort((a, b) => b.reportedTime.compareTo(a.reportedTime));
    return SafeArea(
      child: SingleChildScrollView(
        primary: false,
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            const Header(pageType: "User Reports", needSearchBar: false),
            const SizedBox(height: defaultPadding),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Concerns!",
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ],
            ),
            const SizedBox(height: defaultPadding),
            isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : allReports.isEmpty
                    ? const Center(
                        child: Text("No Reports! Rest easy."),
                      )
                    : Responsive(
                        mobile: ReportInfoCardGridView(
                          crossAxisCount: size.width < 650 ? 1 : 2,
                          childAspectRatio:
                              size.width < 650 && size.width > 350 ? 1 : 1,
                          allReports: allReports,
                        ),
                        tablet: ReportInfoCardGridView(allReports: allReports),
                        desktop: ReportInfoCardGridView(
                          childAspectRatio: size.width < 1400 ? 0.7 : 1.4,
                          allReports: allReports,
                        ),
                      ),
          ],
        ),
      ),
    );
  }
}
