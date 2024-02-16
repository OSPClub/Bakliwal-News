// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:bakliwal_news/custome_icons_icons.dart';
import 'package:bakliwal_news/screens/auth_screen/validator.dart';
import 'package:bakliwal_news/widget/view/custome_snackbar.dart';
import 'package:bakliwal_news/models/user_information.dart';
import 'package:bakliwal_news/screens/auth_screen/login.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  static const routeName = "./register-screen";

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _registerFormKey = GlobalKey<FormState>();
  bool isPasswordInvisible = true;
  bool _isLoading = false;
  String errorMessage = '';

  // ignore: prefer_final_fields
  UserInformation _savedUserInformation = UserInformation(
    userId: null,
    isBlocked: false,
    userName: null,
    emailId: null,
    fullName: null,
    joined: null,
  );
  String? password;

  void _saveForm() async {
    final isValid = _registerFormKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _registerFormKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: _savedUserInformation.emailId.toString(),
        password: password.toString(),
      )
          .then(
        (userCredential) async {
          final user = userCredential.user;
          await user!.updateDisplayName(_savedUserInformation.fullName);
          await FirebaseDatabase.instance.ref("users/${user.uid}").set(
            {
              "userId": user.uid,
              "userName": _savedUserInformation.userName.toString(),
              "emailId": userCredential.user!.email!,
              "fullName": _savedUserInformation.fullName.toString(),
              "joiningDate":
                  userCredential.user!.metadata.creationTime.toString(),
              "password": password.toString(),
              "profilePicture": '',
              "biography": '',
              "companyName": '',
              "jobTitle": '',
              "githubUsername": '',
              "linkedin": '',
              "twitter": '',
              "instagram": '',
              "facebook": '',
              "websiteURL": '',
            },
          );
          await user.sendEmailVerification();

          setState(() {
            _isLoading = false;
          });
          await FirebaseAuth.instance.signOut();
          _registerFormKey.currentState!.reset();
          FocusScope.of(context).unfocus();
          Navigator.of(context).pop();
          CustomSnackBar.showSuccessSnackBar(
            context,
            message:
                "An Email has been sent to ${userCredential.user!.email!}, Click the link to verify the Email",
          );
        },
      );
    } on FirebaseAuthException catch (error) {
      setState(() {
        errorMessage = error.message.toString();
      });
      print("${error.message} : Code ${error.code}");
      setState(() {
        _isLoading = false;
      });
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
              key: _registerFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.arrow_back_ios),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                    "Register Here",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 25.sp),
                  ),
                  Image.network(
                    "https://cdni.iconscout.com/illustration/premium/thumb/sign-up-6333618-5230178.png",
                    height: 100.h,
                    width: double.infinity,
                  ),
                  Text(
                    "Get Registered From Here",
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
                    "Full Name",
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
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter Full Name',
                        contentPadding: EdgeInsets.all(10),
                      ),
                      validator: (value) =>
                          Validator.fullNameValidate(value ?? ""),
                      onSaved: (value) {
                        _savedUserInformation = UserInformation(
                          userId: _savedUserInformation.userId,
                          isBlocked: _savedUserInformation.isBlocked,
                          userName: _savedUserInformation.userName,
                          emailId: _savedUserInformation.emailId,
                          fullName: value,
                          joined: _savedUserInformation.joined,
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Text(
                    "Username",
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
                        hintText: 'Enter username',
                        contentPadding: EdgeInsets.all(10),
                      ),
                      validator: (value) {
                        if (value == null) {
                          return 'Please Enter Username.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _savedUserInformation = UserInformation(
                          userId: _savedUserInformation.userId,
                          isBlocked: _savedUserInformation.isBlocked,
                          userName: value.toString(),
                          emailId: _savedUserInformation.emailId,
                          fullName: _savedUserInformation.fullName,
                          joined: _savedUserInformation.joined,
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
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
                      onSaved: (value) {
                        _savedUserInformation = UserInformation(
                          userId: _savedUserInformation.userId,
                          isBlocked: _savedUserInformation.isBlocked,
                          userName: _savedUserInformation.userName,
                          emailId: value,
                          fullName: _savedUserInformation.fullName,
                          joined: _savedUserInformation.joined,
                        );
                      },
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
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter Password',
                        contentPadding: EdgeInsets.all(10),
                      ),
                      validator: (value) =>
                          Validator.validatePassword(value ?? ""),
                      onChanged: (value) {
                        password = value;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Text(
                    "Confirm Password",
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
                        hintText: 'Enter Confirm Password',
                        contentPadding: const EdgeInsets.all(10),
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
                                ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null) {
                          return 'Please Enter Confirm Password.';
                        }
                        if (value != password) {
                          return 'Password don\'t match!';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
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
                                color: Theme.of(context).primaryColor),
                          ),
                          onPressed: _saveForm,
                          child: Text(
                            "Sign Up",
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
                        "already have an account ? ",
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 14.sp,
                            color: Colors.grey),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const LoginScreen()));
                        },
                        child: Text(
                          "Sign In ",
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
