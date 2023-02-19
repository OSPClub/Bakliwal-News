import 'package:flutter/material.dart';

import 'package:bakliwal_news_admin/responsive.dart';
import 'package:bakliwal_news_admin/screens/dashboard/components/my_fields.dart';
import 'package:bakliwal_news_admin/constants.dart';
import 'package:bakliwal_news_admin/widgets/header.dart';
import 'package:bakliwal_news_admin/screens/dashboard/components/storage_details.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        primary: false,
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            const Header(
              pageType: "Dashboard",
              needSearchBar: false,
            ),
            const SizedBox(height: defaultPadding),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const MyFiles(),
                      if (Responsive.isMobile(context))
                        const SizedBox(height: defaultPadding),
                      if (Responsive.isMobile(context)) const StarageDetails(),
                      if (!Responsive.isMobile(context))
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: defaultPadding),
                            Text(
                              "Recent Articles",
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                            const SizedBox(height: defaultPadding),
                            ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: 5,
                              itemBuilder: (ctx, index) {
                                return Container(
                                  padding: const EdgeInsets.all(5),
                                  margin: const EdgeInsets.only(
                                      bottom: defaultPadding),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                        width: 2, color: secondaryColor),
                                  ),
                                  child: ListTile(
                                    leading: SizedBox(
                                      height: 70,
                                      width: 100,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: const Image(
                                          image: NetworkImage(
                                              "https://firebasestorage.googleapis.com/v0/b/bakliwal-news.appspot.com/o/articles%2F-NGtFZpO9nBsyxKfCxZj?alt=media&token=38077ffd-2884-49ee-b37d-592ad594716d"),
                                        ),
                                      ),
                                    ),
                                    title: const Text(
                                        "Introduction fine-gained Personal access tokens for GitHub"),
                                    subtitle: const Text(
                                      "Nov 15, 2022",
                                      style: TextStyle(color: Colors.white54),
                                    ),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.only(
                                              top: 5,
                                              bottom: 5,
                                              left: 5,
                                              right: 7),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            color: secondaryColor,
                                          ),
                                          child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: const [
                                                Icon(Icons.arrow_upward),
                                                SizedBox(width: 4),
                                                Text("52"),
                                              ]),
                                        ),
                                        const SizedBox(width: 15),
                                        Container(
                                          padding: const EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            color: secondaryColor,
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: const [
                                              Icon(Icons.comment),
                                              SizedBox(width: 4),
                                              Text("6525"),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
                if (!Responsive.isMobile(context))
                  const SizedBox(width: defaultPadding),
                if (!Responsive.isMobile(context))
                  const Expanded(
                    flex: 2,
                    child: StarageDetails(),
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
