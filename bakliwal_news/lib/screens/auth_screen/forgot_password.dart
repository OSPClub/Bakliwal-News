// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:bakliwal_news/screens/auth_screen/validator.dart';
import 'package:bakliwal_news/widget/view/custome_snackbar.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  static const routeName = "./forgot-password-screen";

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final auth = FirebaseAuth.instance;
  late AuthStatus _status;
  final _key = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isloading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<AuthStatus> resetPassword({required String email}) async {
    await auth
        .sendPasswordResetEmail(email: email)
        .then((value) => _status = AuthStatus.successful)
        .catchError(
            (e) => _status = AuthExceptionHandler.handleAuthException(e));

    return _status;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: false,
          elevation: 0,
          titleSpacing: 0.0,
          leading: Row(
            children: [
              SizedBox(
                width: 10.w,
              ),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(
                  FeatherIcons.arrowLeft,
                  color: Colors.black,
                  size: 20,
                ),
              ),
            ],
          ),
          title: Transform(
            transform: Matrix4.translationValues(-20.0, 0.0, 0.0),
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Text(
                "Back",
                style: TextStyle(color: Colors.black, fontSize: 12.sp),
              ),
            ),
          ),
          actions: const [
            Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: Icon(
                FeatherIcons.helpCircle,
                color: Colors.black,
                size: 20,
              ),
            ),
          ],
        ),
        body: Stack(
          children: [
            Form(
              key: _key,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 30.h,
                      ),
                      Text(
                        "Reset password",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 22.sp),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Text(
                        "Enter the email associated with your account we will send you and email with instruction to reset your password",
                        style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Text(
                        "Email Address",
                        style: TextStyle(fontSize: 12.sp),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black12,
                            ),
                            color: Colors.grey[100],
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10))),
                        child: TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          textCapitalization: TextCapitalization.none,
                          validator: (value) =>
                              Validator.validateEmail(value ?? ""),
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'abc@example.com',
                              contentPadding: EdgeInsets.all(10)),
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      MaterialButton(
                        color: Theme.of(context).primaryColor,
                        height: 20.h,
                        minWidth: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: BorderSide(
                                color: Theme.of(context).primaryColor)),
                        child: Text(
                          "Send Instruction",
                          style:
                              TextStyle(color: Colors.white, fontSize: 16.sp),
                        ),
                        onPressed: () async {
                          if (_key.currentState!.validate()) {
                            setState(() {
                              _isloading = true;
                            });
                            final status = await resetPassword(
                                email: _emailController.text.trim());
                            if (status == AuthStatus.successful) {
                              setState(() {
                                _isloading = false;
                              });
                              CustomSnackBar.showSuccessSnackBar(
                                context,
                                message:
                                    "Email is been sent to ${_emailController.text.trim()} to reset your password (if can't find check spam)",
                              );
                            } else {
                              setState(() {
                                _isloading = false;
                              });
                              final error =
                                  AuthExceptionHandler.generateErrorMessage(
                                      _status);
                              CustomSnackBar.showErrorSnackBar(context,
                                  message: error);
                            }
                          }
                        },
                      ),
                      SizedBox(
                        height: 8.h,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (_isloading)
              const Center(
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }
}

enum AuthStatus {
  successful,
  wrongPassword,
  emailAlreadyExists,
  invalidEmail,
  weakPassword,
  unknown,
}

class AuthExceptionHandler {
  static handleAuthException(FirebaseAuthException e) {
    AuthStatus status;
    switch (e.code) {
      case "invalid-email":
        status = AuthStatus.invalidEmail;
        break;
      case "wrong-password":
        status = AuthStatus.wrongPassword;
        break;
      case "weak-password":
        status = AuthStatus.weakPassword;
        break;
      case "email-already-in-use":
        status = AuthStatus.emailAlreadyExists;
        break;
      default:
        status = AuthStatus.unknown;
    }
    return status;
  }

  static String generateErrorMessage(error) {
    String errorMessage;
    switch (error) {
      case AuthStatus.invalidEmail:
        errorMessage = "Your email address appears to be malformed.";
        break;
      case AuthStatus.weakPassword:
        errorMessage = "Your password should be at least 6 characters.";
        break;
      case AuthStatus.wrongPassword:
        errorMessage = "Your email or password is wrong.";
        break;
      case AuthStatus.emailAlreadyExists:
        errorMessage =
            "The email address is already in use by another account.";
        break;
      default:
        errorMessage = "An error occured. Please try again later.";
    }
    return errorMessage;
  }
}
