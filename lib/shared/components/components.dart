import 'package:flutter/material.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hospital/modules/show_beds/show_beds.dart';
import 'package:hospital/network/local/cache_helper.dart';
import 'package:hospital/network/remote/dio_helper.dart';
import 'package:intl/intl.dart';


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
      child: CircularProgressIndicator(),
    )
);

Widget BedItem({
  @required int bedId,
  @required double cost,
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

      navigateTo(context, ShowBeds());
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


void navigateTo(BuildContext context , Widget screen)
{
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => screen),
  );
}

void navigateReplacement(BuildContext context , Widget screen){
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => screen));
}