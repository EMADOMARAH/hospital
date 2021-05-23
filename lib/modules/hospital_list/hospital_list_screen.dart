import 'package:flutter/material.dart';
import 'package:hospital/shared/components/components.dart';

class HospitalListScreen extends StatefulWidget {
  const HospitalListScreen({Key key}) : super(key: key);

  @override
  _HospitalListScreenState createState() => _HospitalListScreenState();
}

class _HospitalListScreenState extends State<HospitalListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: DefaultFormField(
          hint: "Search..."
        ) ,
        leading: Icon(
          Icons.arrow_back_ios_outlined,
        ),
        actions: [
          MaterialButton(
              onPressed: (){},
            child: Text(
              'Search'
            ),
              ),
        ],

      ),

    );
  }
}
