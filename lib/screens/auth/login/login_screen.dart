import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';
import 'package:suggest_filmov/components/check_error.dart';
import 'package:suggest_filmov/components/cstm_svg.dart';
import 'package:suggest_filmov/components/custom_tf.dart';
import 'package:suggest_filmov/const.dart';
import 'package:suggest_filmov/provider/provider_data.dart';
import 'package:suggest_filmov/screens/auth/auth.dart';
import 'package:suggest_filmov/screens/auth/components/button_bg.dart';
import 'package:suggest_filmov/screens/auth/components/hav_acc_or_no.dart';
import 'package:suggest_filmov/screens/auth/components/sign_in_up_btn.dart';
import 'package:suggest_filmov/services/firebase_service.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

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
                onTap: goToSignUp,
                child: Icon(
                  Icons.arrow_back_ios_new,
                  color: blackColor,
                ),
              ),
              SizedBox(width: 10.w),
              Text(
                "Sign in",
                style: TextStyle(
                  color: blackColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 25.sp,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 55.h,
          ),
          SizedBox(
            width: double.maxFinite,
            child: Text(
              "Log in with one of the following options",
              style: TextStyle(
                color: Colors.black.withOpacity(.6),
                fontSize: 14.sp,
              ),
            ),
          ),
          SizedBox(height: 23.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
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
          SizedBox(height: 50.h),
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
          SizedBox(height: 24.h),
          SignInUpButton(
            btnTxt: "Login",
            onPressed: () {
              data.loaded = false;
              login(context, data);
            },
          ),
          SizedBox(height: 20.h),
          HaveAccOrNo(
              goToSignIn: goToSignUp,
              txt: "Don't you have an account?",
              btnTxt: "Sign Up")
        ],
      ),
    );
  }

  void login(BuildContext context, ProviderData data) {
    if (CheckError.checkBasicErrors(context, [tfEmail.text, tfPass.text])) {
      return;
    }

    AuthService.login(context, tfEmail.text, tfPass.text, data);
  }

  void goToSignUp() {
    pageController.animateToPage(
      1,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInBack,
    );
  }
}
