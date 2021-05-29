import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hospital/modules/Hospital/hospital_auth/hospital_register.dart';
import 'package:hospital/modules/Hospital/hospital_home/hospital_home.dart';
import 'package:hospital/network/local/cache_helper.dart';
import 'package:hospital/network/remote/dio_helper.dart';
import 'package:hospital/shared/components/components.dart';

class HospitalLoginScreen extends StatefulWidget {
  const HospitalLoginScreen({Key key}) : super(key: key);

  @override
  _HospitalLoginScreenState createState() => _HospitalLoginScreenState();
}

class _HospitalLoginScreenState extends State<HospitalLoginScreen> {

  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  var formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("تسجيل الدخول كمستشفي "),
          backgroundColor: Colors.grey[800],
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  Container(
                    height: 300,
                    width: double.infinity,
                    child: Carousel(
                      images: [
                        NetworkImage(
                            "https://www.123creative.com/5816-thickbox/doctor-vector-characters-man-and-woman.jpg")
                      ],
                      dotBgColor: Colors.white,
                    ),
                  ),

                  TextFormField(
                    controller: emailController,
                    validator: (String value){
                      if (value.isEmpty) {
                        return "ادخل البريد الالكترونى";
                      }
                      return null;
                    },
                    decoration: InputDecoration(prefixIcon: Icon(Icons.person), hintText: "أدخل البريد الالكتروني"),
                  ),
                  SizedBox(
                    height: 30,
                  ),

                  TextFormField(
                    controller: passwordController,
                      validator: (String value){
                        if (value.isEmpty) {
                          return "ادخل الرقم السرى";
                        }
                        return null;
                      },
                      obscureText: true,
                      decoration: InputDecoration(prefixIcon: Icon(Icons.person), hintText: "الرقم السري ")),
                  //لأنشاء حساب جديد
                  Container(
                    margin: EdgeInsets.all(20),
                    child: Row(
                      children: [
                        InkWell
                            //للدخول علي صفحه انشاء الحساب
                            (
                          onTap: () {
                           navigateTo(context, HospitalRegisterScreen());
                          },
                          child: Text(
                            "انشاء حساب جديد",
                            style: TextStyle(color: Colors.deepOrange, fontSize: 15),
                          ),
                        )
                      ],
                    ),
                  ),

                  Container(
                    child: RaisedButton(
                      color: Colors.blue,
                      onPressed: () {
                        if (formKey.currentState.validate()) {
                          hospitalLogin();
                        }
                      },
                      child: Text(
                        "تسجيل الدخول ",
                        style: TextStyle(fontSize: 15, color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  InkWell(
                    child: Text("هل نسيت كلمه السر", style: TextStyle(color: Colors.deepOrange, fontSize: 15)),
                  )
                ],
              ),
            ),
          ),
        ));
  }


  void hospitalLogin(){
    var email = emailController.text;
    var password = passwordController.text;

    var body = {
      "email" : email,
      "password": password,
    };

    DioHelper.login(
        "api/v1/auth/login",
        {"type" : "hospital"},
        body)
        .then((value) {
      print(value.data.toString());
      if (value.data['status']) {
        CacheHelper.saveData(key: 'token', value: value.data["data"]['credentials']['access_token']);
        CacheHelper.saveData(key: "type", value: false);
        navigateReplacement(context, HospitalHomeScreen());
        Fluttertoast.showToast(
            msg: "تم التسجيل بنجاح",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0
        );
      }else{
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

    }
    ).catchError((onError){
      print(onError.toString());
      Fluttertoast.showToast(
          msg: onError.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );

    });


  }
}
