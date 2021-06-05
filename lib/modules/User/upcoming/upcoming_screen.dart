import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:hospital/network/local/cache_helper.dart';
import 'package:hospital/network/remote/dio_helper.dart';
import 'package:hospital/shared/components/components.dart';

class UpcomingScreen extends StatefulWidget {
  const UpcomingScreen({Key key}) : super(key: key);

  @override
  _UpcomingScreenState createState() => _UpcomingScreenState();
}

class _UpcomingScreenState extends State<UpcomingScreen> {
  List<dynamic> uocpmingList = [];
  var token;

  @override
  void initState()  {
    // TODO: implement initState

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      token = CacheHelper.getData(key: "token");
      await DioHelper.getUpcoming(
          url: "/api/v1/user/reservations/upcoming",
          userType: { "type" : "user"},
          token: token
      ).then((value){
        uocpmingList = value.data["data"];
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
          'الحجوزات القادمه'
        ),
      ),
      body: ConditionalBuilder(
        condition: uocpmingList.length>0,
        builder: (context) => ListView.separated(
            physics: BouncingScrollPhysics(),
            itemBuilder: (context , index) =>UpcomingItem(
              context: context,
              upcoming: uocpmingList[index]
            ),
            separatorBuilder:(context , index) => SizedBox(
              height: 0,
            ),
            itemCount: uocpmingList.length
        ),
        fallback:(context) => Center(
          child:  Text(
            'لا يوجد بيانات' ,
            style: TextStyle(
                fontSize: 20
            ),
          ),
        ),
      ),
    );
  }
}
