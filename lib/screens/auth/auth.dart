import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';
import 'package:suggest_filmov/const.dart';
import 'package:suggest_filmov/provider/provider_data.dart';
import 'package:suggest_filmov/screens/auth/login/login_screen.dart';
import 'package:suggest_filmov/screens/auth/register/register_screen.dart';

PageController pageController = PageController();

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    ProviderData data = Provider.of<ProviderData>(context);
    return LoadingOverlay(
      isLoading: !data.loaded,
      child: Scaffold(
        backgroundColor: loginBg,
        body: SafeArea(
          child: PageView(
            controller: pageController,
            physics: BouncingScrollPhysics(),
            allowImplicitScrolling: true,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: LoginScreen(),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: SignUpScreen(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
