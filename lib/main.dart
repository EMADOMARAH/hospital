import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:hospital/modules/Hospital/hospital_auth/hospital_login.dart';
import 'package:hospital/modules/Hospital/hospital_auth/hospital_register.dart';
import 'package:hospital/modules/Hospital/hospital_home/hospital_home.dart';
import 'package:hospital/modules/User/hospital_list/hospital_list_screen.dart';
import 'package:hospital/modules/initial_screen/initial_screen.dart';
import 'package:hospital/modules/User/user_auth/user_register.dart';
import 'package:hospital/modules/User/user_home/user_home.dart';
import 'package:hospital/modules/splash/splash_screen.dart';
import 'package:hospital/network/local/cache_helper.dart';
import 'package:hospital/network/remote/dio_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelper.init();

  HttpOverrides.global = new MyHttpOverrides();

  DioHelper.init();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}





