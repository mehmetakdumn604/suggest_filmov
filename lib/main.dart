// ignore_for_file: must_be_immutable
import 'dart:math';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:suggest_filmov/components/utility_funcs.dart';
import 'package:suggest_filmov/const.dart';
import 'package:suggest_filmov/provider/provider_data.dart';
import 'package:suggest_filmov/screens/auth/auth.dart';
import 'package:suggest_filmov/screens/bottombar.dart';
import 'package:suggest_filmov/services/firebase_service.dart';
import 'package:suggest_filmov/services/shared_service.dart';
import 'package:suggest_filmov/services/sql_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    name: "SuggestFilmov",
    options: FirebaseOptions(
      apiKey: "AIzaSyBBubbm817YU741_p5cvpdKksxktna9rLE",
      appId: "1:34374969050:web:2e5edb1dd33fc03b1667e3",
      messagingSenderId: "34374969050",
      projectId: "suggestfilmov",
    ),
  );

  setDatasToSP();

  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider<ProviderData>(create: (_) => ProviderData())
    ], child: const MyApp()),
  );
}

void setDatasToSP() {
  SharedService.setData(tvRecPageKey, Random().nextInt(116), "dateForTv");
  SharedService.setData(latestPageKey, Random().nextInt(116), "dateForLatest");
  SharedService.setData(
      topRatedPageKey, Random().nextInt(116), "dateForTopRated");
  SharedService.setData(
      discoverPageKey, Random().nextInt(116), "dateForDiscover");
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(330, 712),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context,child) => GetMaterialApp(
        title: 'Suggest Filmov',
        debugShowCheckedModeBanner: false,
        enableLog: false,
        defaultTransition: Transition.downToUp,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          appBarTheme: AppBarTheme(
            backgroundColor: blackColor,
            elevation: 0,
          ),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: blackColor,
            unselectedLabelStyle: textStyle.copyWith(fontSize: 15),
            showUnselectedLabels: true,
            unselectedItemColor: whiteColor,
            selectedItemColor: redColor,
            selectedIconTheme: IconThemeData(color: redColor),
          ),
        ),
        onInit: () {
          ProviderData data = Provider.of<ProviderData>(context);
          final binding = WidgetsFlutterBinding.ensureInitialized();

          // Prevents app from closing splash screen, app layout will be build but not displayed.
          binding.deferFirstFrame();
          binding.addPostFrameCallback((_) async {
            BuildContext? context = binding.renderViewElement;
            if (context != null) {
              // Run any sync or awaited async function you want to wait for before showing app layout
              await loadDatas.call(data);
            }

            // Closes splash screen, and show the app layout.
            Future.delayed(Duration(seconds: 3), () {
              binding.allowFirstFrame();
            });
          });
        },
        color: Colors.black,
        home: AuthService.isLogin() ? BottomBarPage() : AuthScreen(),
      ),
    );
  }
}

Future<void> setUserIfLogged(ProviderData data) async {
  //firebase
  if (AuthService.isLogin()) FirestoreService.getUser(data);
}

Future<void> getWatchListFromSql(ProviderData data) async {
  await SqlService.instance.readAll(tableName).then((value) {
    data.watchList = value;
  });
}

Future<void> getFavListFromSql(ProviderData data) async {
  await SqlService.instance.readAll(favTable).then((value) {
    data.favList = value;
  });
}

int page = 1;
Future<void> loadDatas(ProviderData data, {bool firstOpen = true}) async {
  apiService.getUpComingMovies(data);
  apiService.getGenreList(data);
  data.nowPlayingMovies = await apiService.getNowPlayingMovie();
  data.latestMovies = await apiService.getPopular();
  data.topRatedMovies = await apiService.getTopRated();
  data.popularCasts = await apiService.getPopularActors();
  apiService.getDiscover(data);

  if (firstOpen) {
    setUserIfLogged(data);
    getWatchListFromSql(data);
    getFavListFromSql(data);
  }
}
