import 'package:flutter/material.dart';
import 'package:hospital/modules/User/history/history_screen.dart';
import 'package:hospital/modules/User/upcoming/upcoming_screen.dart';
import 'package:hospital/network/local/cache_helper.dart';
import 'package:hospital/network/remote/dio_helper.dart';
import 'package:hospital/shared/components/components.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<dynamic ,dynamic> profileMap = {};
  var token;

  @override
  void initState()  {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      token = CacheHelper.getData(key: "token");
      await DioHelper.getProfile(
          url: "/api/v1/auth/user/profile",
          userType: { "type" : "user"},
          token: token
      ).then((value){
        profileMap = value.data['data'];
        print(profileMap);
        setState(() {

        });
      })
          .catchError((onError){
        print(onError.toString());
      });

    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "الصفحه الشخصيه"
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            Text(
              "الاسم   : ${profileMap['name']}",
              style: TextStyle(
                fontSize: 20
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
                "الايميل : ${profileMap['email']}",
              style: TextStyle(
                  fontSize: 20
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
                "الرقم : ${profileMap['phone']}",
              style: TextStyle(
                  fontSize: 20
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
                "النوع : ${profileMap['gender']}",
              style: TextStyle(
                  fontSize: 20
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Align(
              alignment: Alignment.center,
              child: MaterialButton(
                  onPressed:(){
                    navigateTo(context, UpcomingScreen());
                  },
                child: Text(
                  'الحجوزات القادمه'
                ),
                color: Colors.blue,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.center,
              child: MaterialButton(
                onPressed:(){
                  navigateTo(context, HistoryScreen());
                },
                child: Text(
                    'الحجوزات السابقه'
                ),
                color: Colors.blue,
              ),
            ),
          ],

        ),
      ),
    );
  }
}
