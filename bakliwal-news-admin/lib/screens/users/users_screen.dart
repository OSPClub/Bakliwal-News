import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'package:bakliwal_news_admin/providers/users.dart';
import 'package:bakliwal_news_admin/models/user_information.dart';
import 'package:bakliwal_news_admin/responsive.dart';
import 'package:bakliwal_news_admin/constants.dart';
import 'package:bakliwal_news_admin/widgets/header.dart';
import 'package:bakliwal_news_admin/screens/users/components/custome_pupup.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  List<UserInformation> users = [];
  bool isLoading = true;

  @override
  initState() {
    loadData(context);
    super.initState();
  }

  Future<void> loadData(context) async {
    final articlesDataRef = Provider.of<Users>(context, listen: false);
    await articlesDataRef.fetchAndSetUserData();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    users = Provider.of<Users>(
      context,
    ).allUsers;
    users.sort((a, b) => a.joined!.compareTo(b.joined as DateTime));
    return SafeArea(
      child: SingleChildScrollView(
        primary: false,
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            const Header(pageType: "Users", needSearchBar: true),
            const SizedBox(height: defaultPadding),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Intellectual People",
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ],
            ),
            const SizedBox(height: defaultPadding),
            isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : users.isEmpty
                    ? const Center(
                        child: Text("Ops! seems no users found"),
                      )
                    : ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: users.length,
                        itemBuilder: (ctx, index) {
                          return Container(
                            padding: const EdgeInsets.all(5),
                            margin:
                                const EdgeInsets.only(bottom: defaultPadding),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: secondaryColor,
                            ),
                            child: ListTile(
                              key: UniqueKey(),
                              leading: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: bgColor,
                                      ),
                                      child: Text("${index + 1}")),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  SizedBox(
                                    height: 50,
                                    width: 50,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(9),
                                      child: Image(
                                        fit: BoxFit.cover,
                                        image: users[index].profilePicture ==
                                                    null ||
                                                users[index]
                                                    .profilePicture!
                                                    .isEmpty
                                            ? const AssetImage(
                                                "assets/images/profilePlaceholder.jpeg",
                                              ) as ImageProvider<Object>
                                            : NetworkImage(
                                                users[index].profilePicture!,
                                              ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              title: Text(
                                "${users[index].fullName == null ? "Unknown" : users[index].fullName!} (@${users[index].userName == null ? "Unknown" : users[index].userName!})",
                              ),
                              subtitle: Text(
                                users[index].joined != null
                                    ? DateFormat("yMMMd")
                                        .format(users[index].joined!)
                                    : "NO! Data Available",
                                style: const TextStyle(color: Colors.white54),
                              ),
                              trailing: UserCustomePopup(
                                userInformation: users[index],
                              ),
                            ),
                          );
                        },
                      )
          ],
        ),
      ),
    );
  }
}
