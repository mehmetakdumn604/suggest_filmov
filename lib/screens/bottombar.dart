import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suggest_filmov/const.dart';
import 'package:suggest_filmov/provider/provider_data.dart';
import 'package:suggest_filmov/screens/home/home_screen.dart';
import 'package:suggest_filmov/screens/profile/profile_screen.dart';
import 'package:suggest_filmov/screens/recommedation/recommediation_page.dart';
import 'package:suggest_filmov/screens/search/search_screen.dart';

class BottomBarPage extends StatelessWidget {
  BottomBarPage({Key? key}) : super(key: key);

  List screens = [
    HomeScreen(),
    SearchScreen(),
    RecommediationPage(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    ProviderData data = Provider.of<ProviderData>(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: blackColor,
        body: screens[data.pageIndex],
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: blackColor,
          onTap: (value) {
            data.pageIndex = value;
          },
          currentIndex: data.pageIndex,
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
              ),
              label: "Home",
              backgroundColor: blackColor,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: "Search",
              backgroundColor: blackColor,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.recommend),
              label: "Recommend",
              backgroundColor: blackColor,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "Profile",
              backgroundColor: blackColor,
            ),
          ],
        ),
      ),
    );
  }
}
