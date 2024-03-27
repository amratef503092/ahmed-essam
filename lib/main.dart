import 'dart:io';
import 'package:flutter/services.dart';
import 'package:three_m_physics/providers/bundles.dart';
import 'package:three_m_physics/providers/course_forum.dart';
import 'package:three_m_physics/screens/account_remove_screen.dart';
import 'package:three_m_physics/screens/auth_screen_private.dart';
import 'package:three_m_physics/screens/downloaded_course_list.dart';
import 'package:three_m_physics/screens/edit_password_screen.dart';
import 'package:three_m_physics/screens/edit_profile_screen.dart';
import 'package:three_m_physics/screens/sub_category_screen.dart';
import 'package:three_m_physics/screens/verification_screen.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:get/get.dart';
import 'package:logging/logging.dart';
import 'providers/auth.dart';
import 'providers/courses.dart';
import 'providers/http_overrides.dart';
import 'providers/misc_provider.dart';
import 'providers/my_bundles.dart';
import 'providers/my_courses.dart';
import 'screens/bundle_details_screen.dart';
import 'screens/bundle_list_screen.dart';
import 'screens/courses_screen.dart';
import 'screens/device_verifcation.dart';
import 'screens/forgot_password_screen.dart';
import 'screens/my_bundle_courses_list_screen.dart';
import 'screens/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'constants.dart';
import 'providers/categories.dart';
import 'screens/auth_screen.dart';
import 'screens/course_detail_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/tabs_screen.dart';

import 'package:root_checker_plus/root_checker_plus.dart';
import 'package:bot_toast/bot_toast.dart';

void main() async 
{
  WidgetsFlutterBinding.ensureInitialized();
  Logger.root.onRecord.listen((LogRecord rec) {
    debugPrint(
        '${rec.loggerName}>${rec.level.name}: ${rec.time}: ${rec.message}');
  });
  HttpOverrides.global = PostHttpOverrides();
  await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.

  @override
  bool rootedCheck = false;
  initState() {
    super.initState();
    if (Platform.isAndroid) {
      androidRootChecker();
    }
    // FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

  Future<void> androidRootChecker() async {
    try {
      rootedCheck = (await RootCheckerPlus.isRootChecker())!;
    } on PlatformException {
      rootedCheck = false;
    }
    if (!mounted) return;
    setState(() {
      rootedCheck = rootedCheck;
    });
    if (rootedCheck) {
      Dialog alert = Dialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0)), //this right here
        child: const SizedBox(
          height: 200.0,
          width: 200.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(15.0),
                child: Text(
                  'في روت في جهازك يا حبيبي',
                  style: TextStyle(color: Colors.red, fontSize: 20),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(15.0),
                child: Text(
                  'التطبيق لا يدعم ال روت شيلو وتعالي اتعلم',
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      );
      Get.dialog(alert);
      Future.delayed(const Duration(seconds: 5), () {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          SystemNavigator.pop();
        });
      });
      FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => Auth()),
        ChangeNotifierProvider(create: (ctx) => Categories()),
        ChangeNotifierProxyProvider<Auth, Courses>(
          create: (ctx) => Courses([], []),
          update: (ctx, auth, prevoiusCourses) => Courses(
            prevoiusCourses == null ? [] : prevoiusCourses.items,
            prevoiusCourses == null ? [] : prevoiusCourses.topItems,
          ),
        ),
        ChangeNotifierProxyProvider<Auth, MyCourses>(
          create: (ctx) => MyCourses([], []),
          update: (ctx, auth, previousMyCourses) => MyCourses(
            previousMyCourses == null ? [] : previousMyCourses.items,
            previousMyCourses == null ? [] : previousMyCourses.sectionItems,
          ),
        ),
        ChangeNotifierProvider(create: (ctx) => Languages()),
        ChangeNotifierProvider(create: (ctx) => Bundles()),
        ChangeNotifierProvider(create: (ctx) => MyBundles()),
        ChangeNotifierProvider(create: (ctx) => CourseForum()),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => GetMaterialApp(
          builder: BotToastInit(), //1. call BotToastInit
          navigatorObservers: [
            BotToastNavigatorObserver()
          ], //2. registered route observer

          title: 'Mr Ahmed Essam',

          locale: const Locale('ar'),
          
          theme: ThemeData(
            fontFamily: 'NotoSans',
            // fontFamily: 'Tajawal',
            useMaterial3: true,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            dialogBackgroundColor: kBackgroundColor,
          
            colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue)
                .copyWith(secondary: kDarkButtonBg),
          ),
          debugShowCheckedModeBanner: true,
          home: const SplashScreen(),
          getPages: [
            GetPage(
              name: SubCategoryScreen.routeName,
              page: () => const SubCategoryScreen(),
              binding: SubBinding(),
            )
          ],
          routes: {
            '/home': (ctx) => const TabsScreen(),
            AuthScreen.routeName: (ctx) => const AuthScreen(),
            AuthScreenPrivate.routeName: (ctx) => const AuthScreenPrivate(),
            SignUpScreen.routeName: (ctx) => const SignUpScreen(),
            ForgotPassword.routeName: (ctx) => const ForgotPassword(),
            CoursesScreen.routeName: (ctx) => const CoursesScreen(),
            CourseDetailScreen.routeName: (ctx) => const CourseDetailScreen(),
            EditPasswordScreen.routeName: (ctx) => const EditPasswordScreen(),
            EditProfileScreen.routeName: (ctx) => const EditProfileScreen(),
            VerificationScreen.routeName: (ctx) => const VerificationScreen(),
            AccountRemoveScreen.routeName: (ctx) => const AccountRemoveScreen(),
            DownloadedCourseList.routeName: (ctx) =>
                const DownloadedCourseList(),
            // SubCategoryScreen.routeName: (ctx) => const SubCategoryScreen(),
            BundleListScreen.routeName: (ctx) => const BundleListScreen(),
            BundleDetailsScreen.routeName: (ctx) => const BundleDetailsScreen(),
            MyBundleCoursesListScreen.routeName: (ctx) =>
                const MyBundleCoursesListScreen(),
            DeviceVerificationScreen.routeName: (context) =>
                const DeviceVerificationScreen(),
          },
        ),
      ),
    );
  }
}
