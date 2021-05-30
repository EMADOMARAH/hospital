import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:hospital/network/local/cache_helper.dart';
import 'package:hospital/network/remote/dio_helper.dart';
import 'package:hospital/shared/components/components.dart';

class ShowBeds extends StatefulWidget {
   ShowBeds({Key key }) : super(key: key);

  @override
  _ShowBedsState createState() => _ShowBedsState();
}

class _ShowBedsState extends State<ShowBeds> {


  List<dynamic> myBeds = [];
  var token;
  var category , hospitalId;
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    category = CacheHelper.getData(key: "cat");
    hospitalId = CacheHelper.getData(key: "hospitalId");

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      token = CacheHelper.getData(key: "token");
      await DioHelper.getBeds(
          url: "/api/v1/user/categories/${category}/hospitals/${hospitalId}/beds",
          userType: { "type" : "user"},
          token: token
      ).then((value){
        //print(value.data);
        if (value.data['status'] ==true) {
          myBeds = value.data["data"];
          setState(() {

          });
        }  else{
          print("Error : ${value.data['message']}" );
        }

      })
          .catchError((onError){
        print(onError.toString());
        //print("CAT : ${category}  HID : ${hospitalId}");
      });

    });


    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ConditionalBuilder(
          condition: myBeds.length>0,
          builder: (context) => Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/bed_list.jpeg"),
                fit: BoxFit.cover,
              ),
            ),
            child: ListView.separated(
                physics: BouncingScrollPhysics(),
                itemBuilder: (context , index) => BedItem(context: context, bedId: myBeds[index]["id"] , cost:myBeds[index]["day_cost"], status:myBeds[index]["status"]  ),
                separatorBuilder:(context , index) => SizedBox(
                  height: 5,
                ),
                itemCount: myBeds.length
            ),
          ),
          fallback:(context) => Center(
            child:  Text(
              'No Data Found' ,
              style: TextStyle(
                  fontSize: 20
              ),
            ),
          ),
        ),

      ),
    );
  }


}
