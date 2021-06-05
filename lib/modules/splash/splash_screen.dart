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

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  var _visible = true;

  AnimationController animationController;
  Animation<double> animation;

  startTime() async {
    var _duration = new Duration(seconds: 3);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    navigateReplacement(context, InitialScreen());
  }

  @override
  dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    animationController = new AnimationController(
      vsync: this,
      duration: new Duration(seconds: 3),
    );
    animation =
    new CurvedAnimation(parent: animationController, curve: Curves.easeOut);

    SchedulerBinding.instance.addPostFrameCallback((_)
    {
      animation.addListener(()
      =>
          this.setState(()
          {}));
      animationController.forward();

      setState(()
      {
        _visible = !_visible;
      });
      startTime();
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
