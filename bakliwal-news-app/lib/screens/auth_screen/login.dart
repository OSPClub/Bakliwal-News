// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:bakliwal_news_app/custome_icons_icons.dart';
import 'package:bakliwal_news_app/models/settings_model.dart';
import 'package:bakliwal_news_app/providers/settings_const.dart';
import 'package:bakliwal_news_app/screens/auth_screen/validator.dart';
import 'package:bakliwal_news_app/widget/view/custome_snackbar.dart';
import 'package:bakliwal_news_app/package_service/locator_service.dart';
import 'package:bakliwal_news_app/repository/auth_repo.dart';
import 'package:bakliwal_news_app/view/home_view_screen.dart';
import 'package:bakliwal_news_app/screens/auth_screen/forgot_password.dart';
import 'package:bakliwal_news_app/screens/auth_screen/register.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  static const routeName = "./login-screen";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _loginFormKey = GlobalKey<FormState>();
  bool isPasswordInvisible = true;
  bool _isLoading = false;
  String errorMessage = '';
  String email = '';
  String password = '';

  void _login() async {
    final isValid = _loginFormKey.currentState!.validate();
    final authRef = FirebaseAuth.instance;
    if (!isValid) {
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
        Navigator.of(context).pushReplacementNamed(HomeViewScreen.routeName);
      } else {
        setState(() {
          _isLoading = false;
        });
        user.sendEmailVerification();
        locator.get<AuthRepo>().logout(context);
        setState(() {
          errorMessage =
              "Verify your Email \n An Email has been sent to ${user.email}. If it is not showing up on the inbox then check the spam!";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Settings settings = Provider.of<ConstSettings>(context).constSettings;
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
                  IconButton(
                    onPressed: () {
                      Navigator.of(context)
                          .pushReplacementNamed(HomeViewScreen.routeName);
                    },
                    icon: const Icon(Icons.arrow_back_ios),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                    "Login Here",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 25.sp),
                  ),
                  Image.asset(
                    "assets/images/login.jpg",
                    height: 250.h,
                    width: double.infinity,
                  ),
                  Text(
                    "Get Logged In From Here",
                    style: TextStyle(fontSize: 12.sp),
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
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter Your Email',
                        contentPadding: EdgeInsets.all(10),
                      ),
                      validator: (value) =>
                          Validator.validateEmail(value ?? ""),
                      onChanged: (value) => email = value,
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Text(
                    "Password",
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
                      obscureText: isPasswordInvisible,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter Password',
                        suffix: InkWell(
                            onTap: () {
                              setState(() {
                                isPasswordInvisible = !isPasswordInvisible;
                              });
                            },
                            child: isPasswordInvisible
                                ? const Icon(
                                    CustomeIcons.eye_off,
                                    color: Colors.black,
                                  )
                                : const Icon(
                                    CustomeIcons.eye,
                                    color: Colors.black,
                                  )),
                        contentPadding: const EdgeInsets.all(10),
                      ),
                      validator: (value) =>
                          Validator.validatePassword(value ?? ""),
                      onChanged: (value) {
                        password = value;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const ForgotPasswordScreen()));
                      },
                      child: Text(
                        "Forgot Password ? ",
                        style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                      )),
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
                  SizedBox(
                    height: 8.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "don't have an account ? ",
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 14.sp,
                            color: Colors.grey),
                      ),
                      InkWell(
                        onTap: () {
                          if (settings.enableSignUp!) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const RegisterScreen()));
                          } else {
                            CustomSnackBar.showErrorSnackBar(context,
                                message: "Signup is disable!");
                          }
                        },
                        child: Text(
                          "Sign Up ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.sp,
                              color: Theme.of(context).primaryColor),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
