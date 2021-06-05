import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hospital/network/local/cache_helper.dart';
import 'package:hospital/network/remote/dio_helper.dart';
import 'package:hospital/shared/components/components.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class HospitalBeds extends StatefulWidget {
  String category, categoryName;

  HospitalBeds({Key key, this.category, this.categoryName}) : super(key: key);

  @override
  _HospitalBedsState createState() => _HospitalBedsState(category, categoryName);
}

class _HospitalBedsState extends State<HospitalBeds> {
  String category;
  String categoryName;
  String selectedState;

  _HospitalBedsState(this.category, this.categoryName);

  Map<String, dynamic> hospitalinfo = {};
  List<dynamic> hospitalBeds = [];
  var token;

  var formKey = GlobalKey<FormState>();
  var costController = TextEditingController();


  @override
  void initState() {
    // TODO: implement initState

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      token = CacheHelper.getData(key: "token");
      await DioHelper.getHospitalBeds(
              url: "api/v1/hospital/categories/${category}/beds",
          userType: {"type": "hospital"},
          token: token
      )
          .then((value) {
        print(value.data['data']['beds']);
        hospitalinfo = value.data['data'];
        print(hospitalinfo);
        hospitalBeds = value.data['data']['beds'];
        print(hospitalBeds);
        setState(() {}
        );
      }).catchError((onError) {
        print("ERROR  :  ${onError}");
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${categoryName}'),
      ),
      body: ConditionalBuilder(
        condition: hospitalBeds.length>0,
        builder: (context) => ListView.separated(
            physics: BouncingScrollPhysics(),
            itemBuilder: (context , index) =>Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    children: [
                      Text(
                        'نشط : ${hospitalinfo['active']}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      Spacer(),
                      Text(
                        'محجوز : ${hospitalinfo['reserved']}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      Spacer(),
                      Text(
                        'خارج الخدمه : ${hospitalinfo['out']}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
                ListView.separated(
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context , index) =>HospotalShowBedsItem(hospitalBeds: hospitalBeds[index] , context: context , token: token , category:category , categoryName: categoryName ),
                    separatorBuilder:(context , index) => SizedBox(
                      height: 0,
                    ),
                    itemCount: hospitalBeds.length
                ),
              ],
            ),
            separatorBuilder:(context , index) => SizedBox(
              height: 5,
            ),
            itemCount: 1
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
      floatingActionButton: FloatingActionButton(
        child: Text(
          'اضافه'
        ),
        onPressed: (){
          showDialog(
              context: context ,
              builder: (BuildContext context){
                return AlertDialog(
                  scrollable: true,
                  title: Text('اضافه سرير'),
                  content: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'تكلفه يوميه',
                              icon: Icon(Icons.monetization_on),
                            ),
                            controller: costController,
                            keyboardType: TextInputType.number,
                            validator:(String value){
                              if (value.isEmpty) {
                                return "ادخل التكلفه اليوميه";
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
                          var body = {
                            "day_cost" : double.parse(costController.text) ,
                          };
                          DioHelper.addBed(
                              url:'api/v1/hospital/categories/${category}/beds/new',
                              userType: {"type": "hospital"},
                              body: body,
                              token: token
                          ).then((value){
                            if (value.data['status']) {
                              Fluttertoast.showToast(
                                  msg: value.data['message'],
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.green,
                                  textColor: Colors.white,
                                  fontSize: 16.0
                              );
                              //navigateReplacement(context, HospitalBeds(category: category,categoryName: categoryName,));
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
                            Fluttertoast.showToast(
                                msg: onError.toString(),
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0
                            );
                          });

                        }
                        Navigator.pop(context);

                        navigateReplacement(context, HospitalBeds(categoryName: categoryName,category: category,));
                      },
                      child: Text('تأكيد'),
                    )
                  ],
                );
              }
          );

        },

      ),
    );
  }

  void openPopup(context) {
    Alert(
        context: context,
        title: "تعديل",
        content: Column(
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                icon: Icon(Icons.monetization_on),
                labelText: 'تكلفه يوميه',
              ),
            ),
            new DropdownButton<String>(
              items: <String>['Active', 'Out of service'].map((String value) {
                return new DropdownMenuItem<String>(
                  value: value,
                  child: new Text(value),
                );
              }).toList(),
              onChanged: (val) {
                setState(() {
                  selectedState  = val;
                });
              },
            ),
          ],
        ),
        buttons: [
          DialogButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "تعديل",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ]).show();
  }
}
