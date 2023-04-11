import 'dart:async';

import 'package:fire3/screens/login_screen.dart';
import 'package:fire3/screens/tabs_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get_storage/get_storage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  GetStorage getStorage = GetStorage();

  @override
  void initState() {
    openNextPage(context);
    super.initState();
  }

  openNextPage(BuildContext ctx) {
    Timer(const Duration(milliseconds: 2000), () {
      if (getStorage.read('token') == null || getStorage.read('token') == '') {
        Navigator.of(context).pushReplacementNamed(LoginScreen.id);
      } else {
        Navigator.of(context).pushReplacementNamed(TabsScreen.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
