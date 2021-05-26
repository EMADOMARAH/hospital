import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:hospital/network/local/cache_helper.dart';
import 'package:hospital/network/remote/dio_helper.dart';
import 'package:hospital/shared/components/components.dart';

class HospitalListScreen extends StatefulWidget {
  String category ;
  HospitalListScreen({Key key , this.category}) : super(key: key );

  @override
  _HospitalListScreenState createState() => _HospitalListScreenState(category );
}

class _HospitalListScreenState extends State<HospitalListScreen> {
  String category;
  _HospitalListScreenState(this.category);

  List<dynamic> myHospitlas = [];
  var token;

  var searchControoler = TextEditingController();



  @override
  void initState()  {
    // TODO: implement initState

    WidgetsBinding.instance.addPostFrameCallback((_) async {
       token = CacheHelper.getData(key: "token");
       await DioHelper.getHospitals(
          url: "/api/v1/user/categories/${category}/hospitals",
          userType: { "type" : "user"},
        token: token
      ).then((value){
        //print(value.data);
        myHospitlas = value.data["data"];
        //print("CAt : ${category}");
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
        title: DefaultFormField(
          hint: "Search...",
          controller: searchControoler
        ) ,
        leading: GestureDetector(
          onTap: (){
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios_outlined,

          ),
        ),
        actions: [
          MaterialButton(
              onPressed: (){
                DioHelper.getHospitals(
                    url: "/api/v1/user/categories/${category}/hospitals",
                    userType: {
                      "type" : "user" ,
                      "search" : searchControoler.text
                    },
                    token: token
                ).then((value){
                  print(value.data);
                  myHospitlas = value.data["data"];
                  setState(() {

                  });
                })
                    .catchError((onError){
                  print(onError.toString());
                });
              },
            child: Text(
              'Search'
            ),
              ),
          MaterialButton(
            onPressed: (){
              DioHelper.getHospitals(
                  url: "/api/v1/user/categories/${category}/hospitals",
                  userType: {
                    "type" : "user" ,
                    "search" : searchControoler.text ,
                    "distance" : true
                  },
                  token: token
              ).then((value){
                print(value.data);
                myHospitlas = value.data["data"];
                setState(() {

                });
              })
                  .catchError((onError){
                print(onError.toString());
              });
            },
            child: Text(
                'By distance'
            ),
          ),
        ],

      ),
       body: ConditionalBuilder(
         condition: myHospitlas.length>0,
         builder: (context) => ListView.separated(
           physics: BouncingScrollPhysics(),
             itemBuilder: (context , index) =>HospitalItem(hospitals: myHospitlas[index], category : category , context: context),
             separatorBuilder:(context , index) => SizedBox(
               height: 5,
             ),
             itemCount: myHospitlas.length
         ),
         fallback:(context) => Center(
           child:  CircularProgressIndicator(),
         ),
       ),


    );
  }
}
