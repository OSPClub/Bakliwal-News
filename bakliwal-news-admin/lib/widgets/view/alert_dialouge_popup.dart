import 'package:flutter/material.dart';

class AlertDialougePopup extends StatelessWidget {
  final String? title;
  final String? content;
  final List<Widget> actions;

  const AlertDialougePopup({
    super.key,
    this.title,
    this.content,
    this.actions = const [],
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title!,
        style: Theme.of(context).textTheme.headline6,
      ),
      actions: actions,
      content: Text(
        content!,
        style: Theme.of(context).textTheme.bodyText2,
      ),
    );
  }
}
