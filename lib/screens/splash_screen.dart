// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:three_m_physics/constants.dart';
import 'package:three_m_physics/screens/auth_screen_private.dart';
import 'package:flutter/material.dart';
import '../providers/shared_pref_helper.dart';
import 'tabs_screen.dart';
import 'package:http/http.dart' as http;

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  dynamic courseAccessibility;

  systemSettings() async {
    var url = "$BASE_URL/api/system_settings";
    var response = await http.get(
      Uri.parse(url),
    );
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      setState(() {
        courseAccessibility = data['course_accessibility'];
      });
    } else {
      setState(() {
        courseAccessibility = '';
      });
    }
  }

  @override
  void initState() {
    donLogin();
    systemSettings();
    super.initState();
  }

  void donLogin() {
    String? token;
    Future.delayed(
      const Duration(seconds: 3),
      () async {
        token = await SharedPreferenceHelper().getAuthToken();
        if (token != null && token!.isNotEmpty) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const TabsScreen()),
          );
        } else {
          if (courseAccessibility == 'publicly') {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const TabsScreen()),
            );
          } else {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                  builder: (context) => const AuthScreenPrivate()),
            );
          }
        }
      },
    );
  }

  String get splashIcon => switch (BASE_URL) {
        "https://yoossr.com" => "assets/images/yoossr_logo.png",
        "http://3m-physics.com" => "assets/images/3m_logo.png",
        "https://thewahy.com" => "assets/images/wahy_logo.png",
        "https://nata3lm.com" => "assets/images/nata3lm.png",
        "https://zaakr.net" => "assets/images/splash.png",
        _ => "",
      };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Center(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          child: Image.asset(
            'assets/images/splash.png',
            fit: BoxFit.fitWidth,
          ),
        ),
      ),
    );
  }
}