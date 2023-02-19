import 'package:flutter/material.dart';

import 'package:bakliwal_news_app/style/style_declaration.dart';

// ignore: must_be_immutable
class CommentBox extends StatelessWidget {
  Widget? child;
  dynamic formKey;
  dynamic sendButtonMethod;
  dynamic commentController;
  String? userImage;
  String? labelText;
  String? errorText;
  Widget? sendWidget;
  Color? backgroundColor;
  Color? textColor;
  bool withBorder;
  bool enabled;
  Widget? header;
  FocusNode? focusNode;
  CommentBox({
    super.key,
    this.child,
    this.header,
    this.sendButtonMethod,
    this.formKey,
    this.commentController,
    this.sendWidget,
    this.userImage,
    this.labelText,
    this.focusNode,
    this.errorText,
    this.enabled = true,
    this.withBorder = true,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final image = userImage == null || userImage!.isEmpty
        ? const AssetImage("assets/images/profilePlaceholder.jpeg")
        : NetworkImage(
            userImage!,
          );
    return Column(
      children: [
        Expanded(
          child: child!,
        ),
        const Divider(
          height: 1,
        ),
        header ?? const SizedBox.shrink(),
        Container(
          margin: const EdgeInsets.only(
            left: 10,
            right: 10,
            top: 10,
            bottom: 10,
          ),
          child: ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            horizontalTitleGap: 2,
            tileColor: backgroundColor,
            leading: Container(
              height: 30.0,
              width: 30.0,
              decoration: const BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.all(
                  Radius.circular(7),
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(7),
                child: Image(
                  fit: BoxFit.cover,
                  image: image as ImageProvider<Object>,
                ),
              ),
            ),
            title: Form(
              key: formKey,
              child: TextFormField(
                maxLines: 4,
                minLines: 1,
                enabled: enabled,
                textCapitalization: TextCapitalization.sentences,
                focusNode: focusNode,
                cursorColor: textColor,
                style: TextStyle(color: textColor),
                controller: commentController,
                decoration: InputDecoration(
                  enabledBorder: !withBorder
                      ? InputBorder.none
                      : UnderlineInputBorder(
                          borderSide: BorderSide(color: textColor!),
                        ),
                  focusedBorder: !withBorder
                      ? InputBorder.none
                      : UnderlineInputBorder(
                          borderSide: BorderSide(color: textColor!),
                        ),
                  border: !withBorder
                      ? InputBorder.none
                      : UnderlineInputBorder(
                          borderSide: BorderSide(color: textColor!),
                        ),
                  hintText: labelText,
                  hintStyle: const TextStyle(
                    color: AppColors.secondary,
                  ),
                  focusColor: textColor,
                  fillColor: textColor,
                  labelStyle: TextStyle(color: textColor),
                ),
                validator: (value) => value!.isEmpty ? errorText : null,
              ),
            ),
            trailing: GestureDetector(
              onTap: sendButtonMethod,
              child: sendWidget,
            ),
          ),
        ),
      ],
    );
  }
}
