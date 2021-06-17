import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hospital/modules/Hospital/hospital_auth/hospital_login.dart';
import 'package:hospital/modules/Hospital/hospital_home/hospital_home.dart';
import 'package:hospital/modules/User/user_auth/user_login.dart';
import 'package:hospital/modules/User/user_home/user_home.dart';
import 'package:hospital/network/local/cache_helper.dart';
import 'package:hospital/shared/components/components.dart';

class InitialScreen extends StatefulWidget {
  const InitialScreen({Key key}) : super(key: key);

  @override
  _InitialScreenState createState() => _InitialScreenState();
}



class _InitialScreenState extends State<InitialScreen> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();

    Widget screen;
    bool isUser = CacheHelper.getData(key: "type") ;
    if (isUser == true) {
      screen = UserHomeScreen();
      navigateReplacement(context, screen);
    }else if (isUser == false) {
      screen = HospitalHomeScreen();
      navigateReplacement(context, screen);
    } else{
    }



  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("الصفحة الرئيسية"),
            backgroundColor: Colors.grey[800],
            centerTitle: true,
            elevation: 6,
            //actions: <Widget>[IconButton(icon: Icon(Icons.search), onPressed: () {})]
        ),
        // drawer: Drawer(
        //     child: ListView(children: <Widget>[
        //   UserAccountsDrawerHeader(
        //       accountEmail: Text("ahmedhamad@gmail.com"),
        //       accountName: Text("ahmed"),
        //       currentAccountPicture: CircleAvatar(child: Icon(Icons.person)),
        //       decoration: BoxDecoration(
        //           color: Colors.blue,
        //           image: DecorationImage(
        //             image: NetworkImage("https://thearabhospital.com/wp-content/uploads/2020/01/smart-beds.jpg"),
        //             fit: BoxFit.cover,
        //           ))),
        //   ListTile(
        //     title: Text("الصفحة الرئيسية", style: TextStyle(color: Colors.black, fontSize: 18)),
        //     leading: Icon(Icons.home, color: Colors.blue),
        //     onTap: () {
        //       // Navigator.push(
        //       //     context, new MaterialPageRoute(builder: (context) =>
        //       // new Home()));
        //     },
        //   ),
        //   ListTile(
        //     title: Text("حول التطبيق", style: TextStyle(color: Colors.black, fontSize: 18)),
        //     leading: Icon(Icons.info, color: Colors.blue),
        //     onTap: () {},
        //   ),
        //   ListTile(
        //     title: Text("الاعدادات", style: TextStyle(color: Colors.black, fontSize: 18)),
        //     leading: Icon(Icons.settings, color: Colors.blue),
        //     onTap: () {},
        //   ),
        //   ListTile(
        //     title: Text("تسجيل الخروج", style: TextStyle(color: Colors.black, fontSize: 18)),
        //     leading: Icon(Icons.logout, color: Colors.blue),
        //     onTap: () {},
        //   ),
        // ])),
        body: ListView(scrollDirection: Axis.vertical, children: <Widget>[
          Container(
            height: 300,
            width: double.infinity,
            child: Carousel(
              images: [
                NetworkImage(
                    "https://www.sidra.org/sites/default/files/inline-images/Sidra-Medicine-IMRIS-and-Radiology-team-1.jpg"),
                NetworkImage("https://www.skynewsarabia.com/amp/images/v1/2021/02/24/1417556/768/430/1-1417556.jpg"),
                NetworkImage(
                    "https://www.studygorussia.net/uploads/original_images/6e5aacO_O%D8%AF%D8%B1%D8%A7%D8%B3%D8%A9%20%D8%A7%D9%84%D8%B7%D8%A8%20%D9%81%D9%89%20%D8%A7%D9%84%D8%AC%D8%A7%D9%85%D8%B9%D8%A7%D8%AA%20%D8%A7%D9%84%D8%B1%D9%88%D8%B3%D9%8A%D8%A9.jpg"),
                NetworkImage(
                    "https://2.bp.blogspot.com/-sWT8RYx95AE/W1zIKUfrEAI/AAAAAAAAAOA/nbqbrGdzJdAjr9l94_ozM1odWTGrcNQ7ACLcBGAs/s1600/photo_2018-07-28_22-45-12.jpg"),
                NetworkImage("https://www.sidra.org/sites/default/files/inline-images/IMG_1207_Fotor-2_0.jpg"),
                NetworkImage("https://www.jamila.qa/Pictures/Articles/21112_2.jpg"),
              ],
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Container(
            width: 50,
            height: 50,
            color: Colors.blue,
            padding: EdgeInsets.only(top: 10, left: 80, right: 10, bottom: 10),
            margin: EdgeInsets.all(20),
            child: Row(
              children: [
                InkWell
                    //للدخول علي صفحه انشاء الحساب
                    (
                  onTap: () {
                    navigateTooo(context, UserLoginScreen());
                  },
                  child: Text("تسجيل الدخول كمستخدم", style: TextStyle(color: Colors.white, fontSize: 20)),
                ),
              ],
            ),
          ),
          Container(
            width: 100,
            height: 50,
            color: Colors.blue,

            margin: EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell
                    //للدخول علي صفحه انشاء الحساب
                    (
                  onTap: () {
                    navigateTooo(context, HospitalLoginScreen());
                  },
                  child: Text("تسجيل الدخول كمستشفي",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        decoration: TextDecoration.none,
                      )),
                ),
              ],
            ),
          ),
        ])
        // backgroundColor: HexColor("#F2F3F8"),
        // body: Center(
        //   child: Column(
        //     children: [
        //       SizedBox(height: 200,),
        //       TextButton(
        //         style: ButtonStyle(
        //             padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(50)),
        //             backgroundColor: MaterialStateProperty.all<Color>(HexColor("#3655D1")),
        //             shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        //               RoundedRectangleBorder(
        //                 borderRadius: BorderRadius.circular(10.0),
        //               ),
        //             )
        //         ),
        //         onPressed: (){
        //
        //         },
        //         child: Text(
        //           "Patient " ,
        //           style: TextStyle(
        //               color: Colors.white,
        //               fontWeight: FontWeight.w700,
        //               fontSize: 20
        //           ),
        //         ),
        //       ),
        //       SizedBox(height: 50,),
        //       TextButton(
        //         style: ButtonStyle(
        //             padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(50)),
        //             backgroundColor: MaterialStateProperty.all<Color>(HexColor("#3655D1")),
        //             shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        //               RoundedRectangleBorder(
        //                 borderRadius: BorderRadius.circular(10.0),
        //               ),
        //             )
        //         ),
        //         onPressed: (){
        //
        //         },
        //         child: Text(
        //           "Hospital" ,
        //           style: TextStyle(
        //               color: Colors.white,
        //               fontWeight: FontWeight.w700,
        //               fontSize: 20
        //           ),
        //         ),
        //       ),
        //     ],
        //
        //   ),
        // ),
        );
  }
}
