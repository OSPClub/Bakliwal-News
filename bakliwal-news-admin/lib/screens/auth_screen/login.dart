// ignore_for_file: avoid_print

import 'package:bakliwal_news_admin/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:bakliwal_news_admin/screens/main/main_screen.dart';
import 'package:bakliwal_news_admin/package_service/locator_service.dart';
import 'package:bakliwal_news_admin/repository/auth_repo.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  static const routeName = "./login-screen";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _loginFormKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String errorMessage = '';
  String email = '';
  String password = '';
  List<String> adminIds = [
    "open.source.programming.committee@gmail.com",
    "anilkaraniya21@gmail.com"
  ];

  void _login() async {
    final isValid = _loginFormKey.currentState!.validate();
    final authRef = FirebaseAuth.instance;
    if (!isValid) {
      return;
    }
    if (!adminIds.any((element) => element == email.trim())) {
      setState(() {
        errorMessage = "Email not found!";
      });
      return;
    }

    _loginFormKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      await authRef.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (error) {
      setState(() {
        errorMessage = error.message.toString();
      });
      print("${error.message} : Code ${error.code}");
      setState(() {
        _isLoading = false;
      });
    } finally {
      User? user = authRef.currentUser;
      if (user!.emailVerified) {
        // Navigator.of(context).pushReplacementNamed(MainScreen.routeName);

      } else {
        setState(() {
          _isLoading = false;
        });
        user.sendEmailVerification();
        locator.get<AuthRepo>().logout(context);
        setState(
          () {
            errorMessage =
                "Verify your Email \n An Email has been sent to ${user.email}. If it is not showing up on the inbox then check the spam!";
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
          child: SingleChildScrollView(
            child: Form(
              key: _loginFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 40.h,
                  ),
                  Text(
                    "Login Here",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25.sp,
                      color: secondaryColor,
                    ),
                  ),
                  Image.asset(
                    "assets/images/login.jpg",
                    height: 250.h,
                    width: double.infinity,
                  ),
                  Text(
                    "Get Logged In From Here",
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: secondaryColor,
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  if (errorMessage.isNotEmpty)
                    Container(
                      margin: const EdgeInsets.only(
                        bottom: 10,
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 10,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.red,
                          width: 3,
                        ),
                      ),
                      child: Text(
                        errorMessage,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  Text(
                    "Email",
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: secondaryColor,
                    ),
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
                      style: const TextStyle(
                        color: secondaryColor,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter Your Email',
                        hintStyle: TextStyle(
                          color: secondaryColor,
                        ),
                        contentPadding: EdgeInsets.all(10),
                      ),
                      validator: (value) {
                        if (value == null) {
                          return 'Please Enter Email Address.';
                        }
                        if (!value.contains("@")) {
                          return 'Please Enter valid Email Address.';
                        }
                        return null;
                      },
                      onChanged: (value) => email = value,
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Text(
                    "Password",
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: secondaryColor,
                    ),
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
                      style: const TextStyle(
                        color: secondaryColor,
                      ),
                      obscureText: true,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter Password',
                        hintStyle: TextStyle(
                          color: secondaryColor,
                        ),
                        contentPadding: EdgeInsets.all(10),
                      ),
                      validator: (value) {
                        if (value == null) {
                          return 'Please Enter Password.';
                        }
                        if (value.length < 8) {
                          return 'Password should be more than 8 characters.';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        password = value;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : MaterialButton(
                          color: Theme.of(context).primaryColor,
                          height: 20.h,
                          minWidth: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: BorderSide(
                                  color: Theme.of(context).primaryColor)),
                          onPressed: _login,
                          child: Text(
                            "Login",
                            style:
                                TextStyle(color: Colors.white, fontSize: 20.sp),
                          ),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
