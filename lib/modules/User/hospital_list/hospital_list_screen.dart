import 'package:conditional_builder/conditional_builder.dart';
import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hospital/network/local/cache_helper.dart';
import 'package:hospital/network/remote/dio_helper.dart';
import 'package:hospital/shared/components/components.dart';
import 'package:location/location.dart';

class HospitalListScreen extends StatefulWidget {
  String category;

  HospitalListScreen({Key key, this.category}) : super(key: key);

  @override
  _HospitalListScreenState createState() => _HospitalListScreenState(category);
}

class _HospitalListScreenState extends State<HospitalListScreen> {
  String category;

  _HospitalListScreenState(this.category);

  List<dynamic> myHospitlas = [];
  var token;

  var searchControoler = TextEditingController();

  var latitude = 00.00000;
  var longitude = 00.00000;

  LocationData _currentPosition;
  String _address, _dateTime;
  Location location = Location();
  LatLng _initialcameraposition = LatLng(0.5937, 0.9629);

  @override
  void initState() {
    // TODO: implement initState

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      token = CacheHelper.getData(key: "token");
      await DioHelper.getHospitals(
              url: "/api/v1/user/categories/${category}/hospitals", userType: {"type": "user"}, token: token)
          .then((value) {
        //print(value.data);
        myHospitlas = value.data["data"];
        setState(() {});
      }).catchError((onError) {
        print(onError.toString());
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: DefaultFormField(hint: "بحث...", controller: searchControoler),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios_outlined,
          ),
        ),
        actions: [
          MaterialButton(
            onPressed: () {
              DioHelper.getHospitals(
                      url: "/api/v1/user/categories/${category}/hospitals",
                      userType: {"type": "user", "search": searchControoler.text},
                      token: token)
                  .then((value) {
                print(value.data);
                myHospitlas = value.data["data"];
                setState(() {});
              }).catchError((onError) {
                print(onError.toString());
              });
            },
            child: Text('بحث'),
          ),
          MaterialButton(
            onPressed: () async {
              if (await confirm(
                context,
                title: Text('كيفيه العرض'),
                content: Text('عرض البيانات طبقا للموقع.'),
                textOK: Text('موقك الاساسى'),
                textCancel: Text('موقعك الحالى'),
              )) {
                return await DioHelper.getHospitals(
                        url: "/api/v1/user/categories/${category}/hospitals", userType: {
                          "type": "user" ,
                           "search": searchControoler.text,
                           "distance": true
                }, token: token)
                    .then((value) {
                  //print(value.data);
                  myHospitlas = value.data["data"];
                  setState(() {});
                }).catchError((onError) {
                  print(onError.toString());
                });
              }
              await getLoc();
              print("Long : ${_currentPosition.longitude} , Lat : ${_currentPosition.latitude}");

              return await DioHelper.getHospitals(
                      url: "/api/v1/user/categories/${category}/hospitals",
                      userType: {
                        "type": "user",
                        "search": searchControoler.text,
                        "distance": true,
                        "lat": _currentPosition.latitude,
                        "long": _currentPosition.longitude,
                      },
                      token: token)
                  .then((value) {
                //print(value.data);
                myHospitlas = value.data["data"];
                setState(() {});
              }).catchError((onError) {
                print(onError.toString());
              });
            },
            child: Text('بالمسافه'),
          ),
        ],
      ),
      body: ConditionalBuilder(
        condition: myHospitlas.length > 0,
        builder: (context) => ListView.separated(
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) =>
                HospitalItem(hospitals: myHospitlas[index], category: category, context: context),
            separatorBuilder: (context, index) => SizedBox(
                  height: 5,
                ),
            itemCount: myHospitlas.length),
        fallback: (context) => Center(
          child: Text(
            'لا يوجد بيانات',
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }

  getLoc() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _currentPosition = await location.getLocation();
    _initialcameraposition = LatLng(_currentPosition.latitude, _currentPosition.longitude);
    location.onLocationChanged.listen((LocationData currentLocation) {
      print("${currentLocation.longitude} : ${currentLocation.longitude}");
      setState(() {
        _currentPosition = currentLocation;
        _initialcameraposition = LatLng(_currentPosition.latitude, _currentPosition.longitude);

        DateTime now = DateTime.now();
        //_dateTime = DateFormat('EEE d MMM kk:mm:ss ').format(now);
        // _getAddress(_currentPosition.latitude, _currentPosition.longitude)
        //     .then((value) {
        //   setState(() {
        //     _address = "${value.first.addressLine}";
        //   });
        // });
      });
    });
  }
}
