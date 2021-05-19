import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:hospital/modules/hospital_auth/hospital_login.dart';
import 'package:hospital/modules/hospital_auth/hospital_register.dart';
import 'package:hospital/modules/hospital_home/hospital_home.dart';
import 'package:hospital/modules/initial_screen/initial_screen.dart';
import 'package:hospital/modules/user_auth/user_register.dart';
import 'package:hospital/modules/user_home/user_home.dart';
import 'package:hospital/network/local/cache_helper.dart';
import 'package:hospital/network/remote/dio_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = new MyHttpOverrides();
  DioHelper.init();
  await CacheHelper.init();
  Widget screen;
  bool isUser = CacheHelper.getData(key: "type") ;
  if (isUser == true) {
    screen = UserHomeScreen();
  }else if (isUser == false) {
    screen = HospitalHomeScreen();
  } else{
    screen = InitialScreen();
  }
  runApp(MyApp(
    screen: screen,
  ));
}

class MyApp extends StatelessWidget {
  Widget screen ;

  MyApp({this.screen});






  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HospitalLoginScreen(),
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





