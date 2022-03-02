import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:suggest_filmov/components/check_error.dart';
import 'package:suggest_filmov/components/cstm_svg.dart';
import 'package:suggest_filmov/components/custom_tf.dart';
import 'package:suggest_filmov/const.dart';
import 'package:suggest_filmov/models/current_user.dart';
import 'package:suggest_filmov/provider/provider_data.dart';
import 'package:suggest_filmov/screens/auth/auth.dart';
import 'package:suggest_filmov/screens/auth/components/hav_acc_or_no.dart';
import 'package:suggest_filmov/screens/auth/components/sign_in_up_btn.dart';
import 'package:suggest_filmov/services/firebase_service.dart';

import '../components/button_bg.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({Key? key}) : super(key: key);
  TextEditingController tfName = TextEditingController();
  TextEditingController tfBio = TextEditingController();
  TextEditingController tfEmail = TextEditingController();
  TextEditingController tfPass = TextEditingController();
  @override
  Widget build(BuildContext context) {
    ProviderData data = Provider.of<ProviderData>(context);
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        children: [
          SizedBox(
            height: 45.h,
          ),
          Row(
            children: [
              GestureDetector(
                onTap: goToSignIn,
                child: Icon(Icons.arrow_back_ios_new),
              ),
              SizedBox(width: 10.w),
              Text(
                "Sign up",
                style: TextStyle(
                  color: blackColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 25.sp,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 45.h,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: SizedBox(
              width: double.maxFinite,
              child: Text(
                "Sign Up with one of the following options",
                style: TextStyle(
                  color: blackColor.withOpacity(.6),
                  fontSize: 14.sp,
                ),
              ),
            ),
          ),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ButtonBg(
                child: CstmSvgPicture(
                  svgName: "googleLogo",
                ),
              ),
              ButtonBg(
                child: CstmSvgPicture(
                  svgName: "fbLogo",
                ),
              )
            ],
          ),
          SizedBox(height: 30.h),
          CustomTF(
            controller: tfName,
            hint: "Please enter your name and surname...",
            label: "Name and Surname",
          ),
          CustomTF(
            hint: "Let me know you...",
            label: "Bio",
            controller: tfBio,
            height: 60.h,
          ),
          CustomTF(
            controller: tfEmail,
            hint: "Please enter your email...",
            label: "Email",
          ),
          CustomTF(
            controller: tfPass,
            hint: "Please enter your password...",
            label: "Password",
          ),
          SignInUpButton(
              btnTxt: "Sign Up",
              onPressed: () {
                signUp(context, data);
              }),
          HaveAccOrNo(
            goToSignIn: goToSignIn,
            txt: "Already have an account?",
            btnTxt: "Log in",
          ),
        ],
      ),
    );
  }

  void signUp(BuildContext context, ProviderData data) {
    if (CheckError.checkBasicErrors(
        context, [tfEmail.text, tfPass.text, tfName.text])) {
      return;
    }

    data.loaded = false;
    CurrUser currUser =
        CurrUser(name: tfName.text, email: tfEmail.text, bio: tfBio.text);
    AuthService.register(context, tfEmail.text, tfPass.text, data, currUser);
  }

  void goToSignIn() {
    pageController.animateToPage(
      0,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInBack,
    );
  }
}
