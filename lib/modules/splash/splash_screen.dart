import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hospital/modules/initial_screen/initial_screen.dart';
import 'package:hospital/shared/components/components.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>  {


  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    SchedulerBinding.instance.addPostFrameCallback((_) async {
        Timer(Duration(seconds: 3),
              () =>  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => InitialScreen()))
      );
    });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: new Image(
          image: new AssetImage("assets/images/icon.jpeg"),

        )
      ),
      );

  }
}
