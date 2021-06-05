import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hospital/modules/User/user_home/user_home.dart';
import 'package:hospital/network/local/cache_helper.dart';
import 'package:hospital/network/remote/dio_helper.dart';
import 'package:hospital/shared/components/components.dart';
import 'package:location/location.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class UserRegisterScreen extends StatefulWidget {
  const UserRegisterScreen({Key key}) : super(key: key);

  @override
  _UserRegisterScreenState createState() => _UserRegisterScreenState();
}

class _UserRegisterScreenState extends State<UserRegisterScreen> {
  var userNameController = TextEditingController();
  var passwordController = TextEditingController();
  var rePasswordController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  var socialController = TextEditingController();

   var formKey = GlobalKey<FormState>();

  var latitude = 00.00000;
  var longitude = 00.00000;


  LocationData _currentPosition;
  String _address,_dateTime;
  Location location = Location();
  LatLng _initialcameraposition = LatLng(0.5937, 0.9629);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("انشاء حساب جديد"),
          backgroundColor: Colors.blue,
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
                            "https://storage.googleapis.com/jarida-cdn/images/1517670240938425800/1517670290000/1280x960.jpg")
                      ],
                      dotBgColor: Colors.white,
                    ),
                  ),
                  TextFormField(
                    controller: userNameController,
                    keyboardType: TextInputType.text ,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        hintText: ("أدخل أسم المستخدم"),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(width: 1),
                        )),
                    validator: (String value){
                      if (value.isEmpty) {
                        return "ادخل اسم المستخدم";
                      }
                      return null;
                    },
                  ),

                  TextFormField(
                    controller: passwordController,
                    keyboardType: TextInputType.visiblePassword,
                    validator: (String value){
                      if (value.isEmpty) {
                        return "ادخل الرقم السرى";
                      }
                      return null;
                    },
                    obscureText: true,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.security),
                      hintText: "الرقم السري ",
                      border: OutlineInputBorder(
                        borderSide: BorderSide(width: 1),
                      ),
                    ),
                  ),
                  TextFormField(
                    controller: rePasswordController,
                    validator: (String value){
                      if (value.isEmpty) {
                        return "ادخل الرقم السرى";
                      }else if(value != passwordController.text){
                        return "الرقم السرى خطأ";

                      }
                      return null;
                    },
                    obscureText: true,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.security),
                      hintText: "تأكيد الرقم السري ",
                      border: OutlineInputBorder(
                        borderSide: BorderSide(width: 1),
                      ),
                    ),
                  ),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    validator: (String value){
                      if (value.isEmpty) {
                        return "ادخل البريج الالكترونى";
                      }
                      return null;
                    },
                    controller: emailController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      hintText: " البريد الاكتروني ",
                      border: OutlineInputBorder(
                        borderSide: BorderSide(width: 1),
                      ),
                    ),
                  ),
                  TextFormField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    validator: (String value){
                      if (value.isEmpty) {
                        return "ادخل رقم الهاتف";
                      }else if (value.length !=11) {
                        return "ادخل رقم هاتف صحيح مكون من 11 رقم";
                      }  else if (!value.startsWith("0" , 0)) {
                        return"ادخل رقم هاتف يبدأ ب 01";
                      }  else if (!value.startsWith("1" , 1)) {
                        return"ادخل رقم هاتف يبدأ ب 01";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.call),
                      hintText: "رقم الهاتف ",
                      border: OutlineInputBorder(
                        borderSide: BorderSide(width: 1),
                      ),
                    ),
                  ),
                  TextFormField(
                    controller: socialController,
                    validator: (String value){
                      if (value.isEmpty) {
                        return "ادخل الرقم القومى";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.info),
                      hintText: "الرقم القومي ",
                      border: OutlineInputBorder(
                        borderSide: BorderSide(width: 1),
                      ),
                    ),
                  ),
                  //للدخول الي حساب
                  Container(
                    margin: EdgeInsets.all(20),
                    child: Row(
                      children: [],
                    ),
                  ),

                  Container(
                    child: RaisedButton(
                      color: Colors.blue,
                      onPressed: () {

                        if (formKey.currentState.validate()) {
                          getLoc();
                        }
                        },
                      child: Text(
                        " انشاء الحساب  ",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }


  void register(){
    var email = emailController.text;
    var password = passwordController.text;
    var name = userNameController.text;
    var phone = phoneController.text;
    var long = _currentPosition.longitude;
    var lat = _currentPosition.latitude;
    var gender = "male";

    var body = {
      "email" : email,
      "password": password,
      "name": name,
      "phone": phone,
      "longitude" : long,
      "latitude": lat,
      "gender": gender
    };

    DioHelper.userRegister(
        url: "api/v1/auth/user/register",
        userType: {
          "type" : "user"
        },
      body: body
    ).then((value){
      print("${userNameController.text}  Registered");
      if (value.data['status']) {
        CacheHelper.saveData(key: 'token', value: value.data["data"]['credentials']['access_token']);
        CacheHelper.saveData(key: "type", value: true);
        navigateReplacement(context, UserHomeScreen());
        Fluttertoast.showToast(
            msg: "تم التسجيل بنجاح",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0
        );
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
    })
        .catchError((onError){
          print(onError.toString());
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

  getLoc() async{
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
    _initialcameraposition = LatLng(_currentPosition.latitude,_currentPosition.longitude);
    location.onLocationChanged.listen((LocationData currentLocation) {
      print("${currentLocation.longitude} : ${currentLocation.longitude}");
      setState(() {
        _currentPosition = currentLocation;
        _initialcameraposition = LatLng(_currentPosition.latitude,_currentPosition.longitude);

        DateTime now = DateTime.now();
        //_dateTime = DateFormat('EEE d MMM kk:mm:ss ').format(now);
        _getAddress(_currentPosition.latitude, _currentPosition.longitude)
            .then((value) {
          setState(() {
            _address = "${value.first.addressLine}";
          });
        });
      });
    });

    register();
  }

  Future<List<Address>> _getAddress(double lat, double lang) async {
    final coordinates = new Coordinates(lat, lang);
    List<Address> add =
    await Geocoder.local.findAddressesFromCoordinates(coordinates);
    return add;
  }


}
