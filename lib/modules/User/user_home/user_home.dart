import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hospital/modules/User/history/history_screen.dart';
import 'package:hospital/modules/User/hospital_list/hospital_list_screen.dart';
import 'package:hospital/modules/initial_screen/initial_screen.dart';
import 'package:hospital/modules/User/profile/profile_screen.dart';
import 'package:hospital/modules/User/upcoming/upcoming_screen.dart';
import 'package:hospital/network/local/cache_helper.dart';
import 'package:hospital/network/remote/dio_helper.dart';
import 'package:hospital/shared/components/components.dart';
import 'package:url_launcher/url_launcher.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({Key key}) : super(key: key);

  @override
  _UserHomeScreenState createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: GestureDetector(
              onTap: (){
                navigateTo(context, ProfileScreen());
              },
              child: Icon(
                  Icons.account_circle_rounded,
                size: 30,

              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: GestureDetector(
              onTap: (){
                launch("tel://01067748312");

              },
              child: Icon(
                Icons.contact_support_outlined,
                size: 30,

              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            MaterialButton(
              onPressed: (){
                navigateTo(context, HospitalListScreen(category: "1",));
              },
              color: Colors.blue,
              height: 100,
              minWidth: double.infinity,
              child: Text(
                'قسم الحروق' ,
                style: TextStyle(
                    fontSize: 25,
                    color: Colors.white
                ),
              ),
              shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(15.0),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            MaterialButton(
              onPressed: (){
                navigateTo(context, HospitalListScreen(category: "2",));
              },
              color: Colors.blue,
              height: 100,
              minWidth: double.infinity,
              child: Text(
                'قسم الحضانات' ,
                style: TextStyle(
                    fontSize: 25,
                    color: Colors.white
                ),
              ),
              shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(15.0),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            MaterialButton(
              onPressed: (){
                navigateTo(context, HospitalListScreen(category: "3",));
              //navigateTo(context, HistoryScreen());
              },
              color: Colors.blue,
              height: 100,
              minWidth: double.infinity,
              child: Text(
                'العنايه المركزه ' ,
                style: TextStyle(
                    fontSize: 25,
                    color: Colors.white
                ),
              ),
              shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(15.0),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: MaterialButton(
        onPressed: (){
          DioHelper.Logout(
              "api/v1/auth/user/logout",
              {"type" : "user"},
              CacheHelper.getData(key: "token")
          ).then((value){
            print(value.data.toString());
            if (value.data['status']) {
              CacheHelper.clearData();
              CacheHelper.removeData("type");
              navigateReplacement(context, InitialScreen());
              Fluttertoast.showToast(
                  msg: "تم تسجيل الخروج بنجاح",
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.green,
                  textColor: Colors.white,
                  fontSize: 16.0
              );
            } else{
              Fluttertoast.showToast(
                  msg: value.data['message'],
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0
              );
            }

          }).catchError((onError){
            print(onError.toString());
            Fluttertoast.showToast(
                msg: onError.toString(),
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);

          });
        },
        child: Text(
          'تسجيل الخروج' ,

        ),
      ),
    );
  }
}
