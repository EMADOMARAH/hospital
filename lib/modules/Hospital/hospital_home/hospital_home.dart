import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hospital/modules/Hospital/hospital_beds/hospital_beds.dart';
import 'package:hospital/modules/initial_screen/initial_screen.dart';
import 'package:hospital/network/local/cache_helper.dart';
import 'package:hospital/network/remote/dio_helper.dart';
import 'package:hospital/shared/components/components.dart';

class HospitalHomeScreen extends StatefulWidget {
  const HospitalHomeScreen({Key key}) : super(key: key);

  @override
  _HospitalHomeScreenState createState() => _HospitalHomeScreenState();
}

class _HospitalHomeScreenState extends State<HospitalHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        actions: [
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/hos_sections.jpeg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              MaterialButton(
                onPressed: (){
                  navigateTo(context, HospitalBeds(category: "1" , categoryName: "Burn department",));
                },
                color: Colors.blue,
                height: 100,
                minWidth: double.infinity,
                child: Text(
                  'Burn department' ,
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
                  navigateTo(context, HospitalBeds(category: "2" ,categoryName: "Children nurseries",));
                },
                color: Colors.blue,
                height: 100,
                minWidth: double.infinity,
                child: Text(
                  'Children nurseries ' ,
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
                  navigateTo(context, HospitalBeds(category: "3" , categoryName: "Intensive care "));
                },
                color: Colors.blue,
                height: 100,
                minWidth: double.infinity,
                child: Text(
                  'Intensive care ' ,
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
      ),
      floatingActionButton: MaterialButton(
        onPressed: (){
          DioHelper.Logout(
              "api/v1/auth/hospital/logout",
              {"type" : "hospital"},
              CacheHelper.getData(key: "token")
          ).then((value){
            print(value.data.toString());
            if (value.data['status']) {
              CacheHelper.clearData();
              CacheHelper.removeData("type");
              navigateReplacement(context, InitialScreen());
              Fluttertoast.showToast(
                  msg: "تم تسجيل الخروج بنجاح",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.green,
                  textColor: Colors.white,
                  fontSize: 16.0
              );
            } else{
              Fluttertoast.showToast(
                  msg: value.data['message'],
                  toastLength: Toast.LENGTH_SHORT,
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
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);

          });
        },
        child: Text(
          'Logout' ,

        ),
      ),
    );
  }
}
