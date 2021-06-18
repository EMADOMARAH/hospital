import 'dart:core';


import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hospital/modules/Hospital/bed_history/bed_history.dart';
import 'package:hospital/modules/Hospital/hospital_beds/hospital_beds.dart';
import 'package:hospital/modules/User/show_beds/show_beds.dart';
import 'package:hospital/network/local/cache_helper.dart';
import 'package:hospital/network/remote/dio_helper.dart';
import 'package:intl/intl.dart';
import 'package:rating_dialog/rating_dialog.dart';


Widget HospitalList({
  @required BuildContext context,
  @required List<Map> hospitals,
})=>Conditional.single(
    context: context,
    conditionBuilder: (context) => hospitals.length>0,
    widgetBuilder: (context) => ListView.separated(
      physics: BouncingScrollPhysics(),
        itemBuilder: (context ,index)
        {
          return HospitalItem(hospitals: hospitals[index]);
        },
        separatorBuilder: (context , index)=>SizedBox(),
        itemCount: hospitals.length
    ),
    fallbackBuilder: (context)=>Center(
      child:  Text(
        'No Data Found' ,
        style: TextStyle(
            fontSize: 20
        ),
      ),
    ),
);

Widget BedItem({
  @required int  bedId,
  @required dynamic cost,
  @required String status,
  @required BuildContext context,
}
    )=>Padding(
  padding: const EdgeInsets.all(20.0),
  child: Container(
    padding: EdgeInsets.all(10.0),
    decoration: BoxDecoration(
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 3,
          //blurRadius: 7,
          offset: Offset(0, 3), // changes position of shadow
        ),
      ],
      borderRadius: BorderRadius.circular(10.0),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(child: Text(
              status,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            ),
            Text(
              " : حاله السرير " ,
            ),
            Spacer(
            ),
            Expanded(
              child: Text(
                "${bedId}" ,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              " : رقم السرير " ,
            ),

          ],
        ),
        Row(
          children: [
            MaterialButton(
                onPressed: (){
                  DatePicker.showDatePicker(context,
                      showTitleActions: true,
                      minTime: DateTime(2020, 1, 1),
                      maxTime: DateTime(2030, 12, 12),
                      onChanged: (date) {
                        print('change $date');
                      }, onConfirm: (date) {
                        String st = DateFormat('yyyy-MM-dd').format(date);
                        var token = CacheHelper.getData(key: 'token');
                        var body = {"start_at" : st};
                        showDialog(
                            context: context ,
                            builder: (BuildContext context){
                              return AlertDialog(
                                scrollable: true,
                                title: Text('Edit'),
                                content: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'You Sure You Want To Book This Bed '
                                  ),

                                ),
                                actions: [
                                  MaterialButton(
                                    onPressed: (){
                                      DioHelper.bookBed(
                                          url: '/api/v1/user/beds/${bedId}',
                                          userType: { "type" : "user"},
                                          body: body,
                                          token: token).then((value) {
                                        if (value.data['status'] == true) {
                                          Fluttertoast.showToast(
                                              msg: "تم الحجز بنجاح",
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
                                            fontSize: 16.0
                                        );
                                      });
                                      Navigator.pop(context);
                                      navigateReplacement(context, ShowBeds());
                                    },
                                    child: Text('Confirm Book'),
                                  )
                                ],
                              );
                            }
                        );



                        }, currentTime: DateTime.now(), locale: LocaleType.ar);
                },
              child: Text(
                "Book"
              ),
              color: Colors.blue,

            ),
            Spacer(),
            Text(
              "التكلفه اليوميه : ${cost}",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              //textDirection: TextDirection.ltr,
            ),
          ],
        ),
      ],
    ),
  ),
);

Widget UpcomingItem({
  @required Map<dynamic,dynamic> upcoming,
  @required BuildContext context
}
    ){
 // String newDate = DateFormat('yyyy-MM-dd').format();
  String newDate = upcoming['start_at'];
  return Padding(
  padding: const EdgeInsets.symmetric(horizontal: 20 , vertical: 10),
  child: Container(
    padding: EdgeInsets.all(10.0),
    decoration: BoxDecoration(
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 3,
          //blurRadius: 7,
          offset: Offset(0, 3), // changes position of shadow
        ),
      ],
      borderRadius: BorderRadius.circular(10.0),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            MaterialButton(
                child: Text(
                  'Rate Us',
                  style: TextStyle(
                      color: Colors.blue
                  ),
                ),
                onPressed: (){
                  showDialog(context: context, builder:(context) => RatingDialog(
                    // your app's name?
                    title: 'قيمنا',
                    // encourage your user to leave a high rating?
                    message:
                    'اضغط على النجوم لوضع تقيمك و يمكنك ترك رساله',
                    // your app's logo?
                    submitButton: 'تأكيد',
                    onCancelled: () => print('cancelled'),
                    onSubmitted: (response) {
                    },
                    commentHint: "اضف تعليقك",
                  )
                  );
                }),
            Spacer(),
            Text(
              '${upcoming['bed']['id']}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              " : سرير رقم" ,
            ),
            Spacer(
            ),
            Expanded(
              child: Text(
                upcoming['bed']['hospital']['name'] ,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              " : مستشفى " ,
            ),



          ],
        ),
        Row(
          children: [
            Text(
              newDate.substring(0,10),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              " : تاريخ" ,
            ),
            Spacer(),
            Text(
              "${upcoming['bed']['day_cost']}" ,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              " : تكلفه يوميه " ,
            ),

          ],
        ),
        Text(
          upcoming['bed']['hospital']['address'],
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          //textDirection: TextDirection.rtl,
        ),
      ],
    ),
  ),
);
}


Widget HospitalItem({
  @required Map<dynamic,dynamic> hospitals,
  @required String category,
  @required BuildContext context
}
    )=>Padding(
  padding: const EdgeInsets.all(20.0),
  child: GestureDetector(
    onTap: (){
      //print ("cat : ${category}  id : ${hospitals["id"]}");
      CacheHelper.saveData(key: 'cat', value: category);
      CacheHelper.saveData(key: 'hospitalId', value: hospitals["id"]);

      navigateTooo(context, ShowBeds());
    },
    child: Container(
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 3,
            //blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(child: Text(
                hospitals['branch'],
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
               ),
              Text(
                " : فرع " ,
              ),
              Spacer(
              ),
              Expanded(
                child: Text(
                  hospitals['name'] ,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                " : مستشفى " ,
              ),

            ],
          ),
          Text(
            hospitals['address'],
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            //textDirection: TextDirection.rtl,
          ),
          SizedBox(
            height: 5,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              hospitals['phone'],
            ),
          ),
        ],
      ),
    ),
  ),
);


Widget HospotalShowBedsItem({
  @required Map<dynamic,dynamic> hospitalBeds,
  @required BuildContext context,
  @required String token,
  @required String category,
  @required String categoryName,
}){
  String newStatus = "Active";
  var costController = TextEditingController();
  var statusController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  return Padding(
  padding: const EdgeInsets.symmetric(horizontal: 20.0 , vertical: 10),
  child: GestureDetector(
    onTap: () {
      navigateTooo(context, BedHistory(bedId: '${hospitalBeds['id']}',));
    },
    child: Container(
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 3,
            //blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(
                'Bed Id : ${hospitalBeds['id']}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Spacer(),
              Text(
                'Status : ${hospitalBeds['status']}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Spacer(),
              Text(
                'Day Cost : ${hospitalBeds['day_cost']}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(
                child: MaterialButton(
                  onPressed: (){
                    showDialog(
                      context: context ,
                      builder: (BuildContext context){
                        return AlertDialog(
                          scrollable: true,
                          title: Text('Edit'),
                          content: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Form(
                              key: formKey,
                              child: Column(
                                children: [
                                  TextFormField(
                                    decoration: InputDecoration(
                                      labelText: 'Day Cost (LE)',
                                      icon: Icon(Icons.monetization_on),
                                    ),
                                    controller: costController,
                                    keyboardType: TextInputType.number,
                                    validator:(String value){
                                      if (value.isEmpty) {
                                        return "Enter Day Cost";
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(' Status : \n (1) for Active \n (2) for Reserved \n (3) for Out of Service'),
                                  TextFormField(
                                    decoration: InputDecoration(
                                      labelText: 'Status',
                                      icon: Icon(Icons.single_bed),
                                    ),
                                    controller: statusController,
                                    keyboardType: TextInputType.number,
                                    validator:(var value){
                                      if (value.isEmpty) {
                                        return "Enter Status";
                                      }else if(int.parse(value) < 1 || int.parse(value) >3 ){
                                        return "Enter Right Value";
                                      }
                                      return null;
                                    },
                                  ),

                                ],
                              ),
                            ),

                          ),
                          actions: [
                            MaterialButton(
                              onPressed: (){
                                if(formKey.currentState.validate()){
                                  var token = CacheHelper.getData(key: 'token');
                                  String myStatuse;
                                  switch(statusController.text){
                                    case '1':
                                      myStatuse = 'Active';
                                      break;
                                    case '2':
                                      myStatuse = 'Reserved';
                                      break;
                                    case '3':
                                      myStatuse = 'Out of service';
                                      break;

                                  }
                                  var body = {
                                    "day_cost" : double.parse(costController.text) ,
                                    "status" : myStatuse
                                  };
                                  DioHelper.editBed(
                                      url:'api/v1/hospital/beds/${hospitalBeds['id']}/edit',
                                      userType: {"type": "hospital"},
                                      body: body,
                                      token: token
                                  ).then((value){
                                    if (value.data['status']) {
                                      Fluttertoast.showToast(
                                          msg: value.data['message'],
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.green,
                                          textColor: Colors.white,
                                          fontSize: 16.0
                                      );
                                      navigateReplacement(context, HospitalBeds(category: category,categoryName: categoryName,));



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
                              },
                            child: Text('Submit'),
                            )
                          ],
                        );
                      }
                    );
                  } ,
                  child: Text(
                    'Edit' ,
                    style: TextStyle(
                        color: Colors.white
                    ),
                  ),
                  color: Colors.blue,
                ),
              ),
              SizedBox(
                width: 50,
              ),
              Expanded(
                child: MaterialButton(
                  onPressed: (){
                    print('Delete');
                    DioHelper.deleteBed(
                        url: "api/v1/hospital/beds/${hospitalBeds['id']}/delete",
                        userType: {"type": "hospital"},
                        token: token
                    ).then((value){
                      if (value.data['status']) {
                        Fluttertoast.showToast(
                            msg: value.data['message'],
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.green,
                            textColor: Colors.white,
                            fontSize: 16.0
                        );
                        navigateReplacement(context, HospitalBeds(category: category,categoryName: categoryName,));



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
                  } ,
                  child: Text(
                    'Delete',
                    style: TextStyle(
                        color: Colors.white
                    ),
                  ),
                  color: Colors.deepOrange,
                ),
              ),
            ],
          )

        ],
      ),
    ),
  ),
);
}

Widget BedHistoryItem({
  @required Map<dynamic,dynamic> hospitalBeds,
  @required BuildContext context,
  @required String bedId,
  @required String token,
}){
  String startDate = hospitalBeds['start_at'];
  String endDate = hospitalBeds['end_at'];
  return Padding(
  padding: const EdgeInsets.symmetric(horizontal: 20.0 , vertical: 10),
  child: Container(
    padding: EdgeInsets.all(10.0),
    decoration: BoxDecoration(
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 3,
          //blurRadius: 7,
          offset: Offset(0, 3), // changes position of shadow
        ),
      ],
      borderRadius: BorderRadius.circular(10.0),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [

        Row(
          children: [
            Text(
              'Name : ${hospitalBeds['user']['name']}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Spacer(),
            Text(
              'Phone : ${hospitalBeds['user']['phone']}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Text(
              'Started At : ${startDate.substring(0,10)}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Spacer(),
            Container(
              child: endDate == null ? MaterialButton(
                  onPressed: (){
                    var token = CacheHelper.getData(key: 'token');
                    DioHelper.endBedReservation(
                        url: 'api/v1/hospital/beds/${bedId}/reservations/${hospitalBeds['id']}/end',
                        userType: {"type": "hospital"},
                        token: token).then((value){
                      if (value.data['status']) {
                        Fluttertoast.showToast(
                            msg: value.data['message'],
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.green,
                            textColor: Colors.white,
                            fontSize: 16.0
                        );
                        navigateReplacement(context, BedHistory(bedId: bedId,));
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
                  },
                  child: Text(
                    'End Reservation'
                  ),
                color: Colors.lightGreenAccent,
              ) : Text(
                'Ended : ${endDate.substring(0,10)}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),


      ],
    ),
  ),
);
}

Widget DefaultFormField({
  @required TextEditingController controller,
  String label,
  TextInputType textInputType,
  bool isPassword = false,
  IconData suffix,
  IconData prefix,
  int maxLength,
  Function validate,
  Function onSubmit,
  Function onChanged,
  Function suffixPressed,
  String hint,
}) =>
    TextFormField(
      controller: controller,
      keyboardType: textInputType,
      obscureText: isPassword,
      onFieldSubmitted: onSubmit,
      validator: validate,
      onChanged: onChanged,
      maxLength: maxLength ,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        contentPadding: EdgeInsets.symmetric(horizontal: 20),
        labelStyle: TextStyle(
          fontSize: 15,
        ),
        suffixIcon: suffix!= null ? IconButton(
          onPressed: suffixPressed ,
          icon: Icon(
            suffix,
          ),
        ) : null,
        prefixIcon: prefix !=null ? Icon(
          prefix,
        ) : null,
        border: InputBorder.none,
      ),
    );


void navigateTooo(BuildContext context , Widget screen)
{
  SchedulerBinding.instance.addPostFrameCallback((_) {

    Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => screen),
  );
  });
}

void navigateReplacement(BuildContext context , Widget screen){
  SchedulerBinding.instance.addPostFrameCallback((_) {
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => screen));
  });
}