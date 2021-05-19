import 'package:flutter/material.dart';

class HospitalHomeScreen extends StatefulWidget {
  const HospitalHomeScreen({Key key}) : super(key: key);

  @override
  _HospitalHomeScreenState createState() => _HospitalHomeScreenState();
}

class _HospitalHomeScreenState extends State<HospitalHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text(
            'USER'
        ),
      ),
    );
  }
}
