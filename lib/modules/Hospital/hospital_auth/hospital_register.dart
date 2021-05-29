import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hospital/modules/Hospital/hospital_home/hospital_home.dart';
import 'package:hospital/network/local/cache_helper.dart';
import 'package:hospital/network/remote/dio_helper.dart';
import 'package:hospital/shared/components/components.dart';
import 'package:location/location.dart';

class HospitalRegisterScreen extends StatefulWidget
{
  const HospitalRegisterScreen({Key key}) : super(key: key);


  @override
  _HospitalRegisterScreenState createState()
  => _HospitalRegisterScreenState();

}

class _HospitalRegisterScreenState extends State<HospitalRegisterScreen>
{
  var emailController = TextEditingController();
  var hospitalNameController = TextEditingController();
  var passwordController = TextEditingController();
  var rePasswordController = TextEditingController();
  var phoneController = TextEditingController();
  var addressController = TextEditingController();
  var branchController = TextEditingController();

  var formKey = GlobalKey<FormState>();

  var lat = 00.000000;
  var lang = 00.00000;

  LocationData _currentPosition;
  String _address,_dateTime;
  Location location = Location();
  LatLng _initialcameraposition = LatLng(0.5937, 0.9629);

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
        appBar: AppBar(title: Text("انشاء حساب جديد") , backgroundColor: Colors.blue , centerTitle: true ,) ,
        body: SingleChildScrollView(
          child:

          Container(

            padding: EdgeInsets.all(20) ,
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  Container(
                    height: 300 ,
                    width: double.infinity ,
                    child: Carousel(
                      images: [
                        NetworkImage("https://i.pinimg.com/originals/df/93/3b/df933b3b42d323c05fd30dc72c2323f8.jpg")
                      ] ,
                      dotBgColor: Colors.white ,
                    ) ,
                  ) ,
                  TextFormField(
                    controller: hospitalNameController,
                    keyboardType: TextInputType.text,
                    validator: (String value){
                      if (value.isEmpty) {
                        return "ادخل اسم المستشفى";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person ,) ,
                        hintText: ("أدخل أسم المستشفى") ,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(width: 1) ,
                        )) ,

                  ) ,


                  TextFormField(
                    controller: passwordController,
                    keyboardType: TextInputType.visiblePassword,
                    validator: (String value){
                      if (value.isEmpty) {
                        return "ادخل ارقم السرى";
                      }
                      return null;
                    },
                    obscureText: true ,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.security) ,
                      hintText: "الرقم السرى " ,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(width: 1) ,
                      ) ,
                    ) ,
                  ) ,
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (String value)
                    {
                      if (value.isEmpty) {
                        return "ادخل البريد الالكترونى";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person) ,
                      hintText: " البريد الاكتروني " ,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(width: 1) ,
                      ) ,
                    ) ,
                  ) ,
                  TextFormField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    validator: (String value){
                      if (value.isEmpty) {
                        return "ادخل رقم الهاتف";
                      }
                      return null;
                    },

                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.call) ,
                      hintText: "رقم الهاتف " ,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(width: 1) ,
                      ) ,
                    ) ,
                  ) ,
                  TextFormField(
                    controller: branchController,
                    keyboardType: TextInputType.text,
                    validator: (String value){
                      if (value.isEmpty) {
                        return "ادخل اسم فرع المستشفى";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.info) ,
                      hintText: "فرع المستشفى" ,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(width: 1) ,
                      ) ,
                    ) ,
                  ) ,
                  //للدخول الي حساب
                  Container(
                    margin: EdgeInsets.all(20) ,
                    child: Row(
                      children: [
                      ] ,
                    ) ,
                  ) ,

                  Container(
                    child: RaisedButton(
                      color: Colors.blue ,
                      onPressed: ()
                      {

                           if (formKey.currentState.validate()) {
                             getLoc();
                           }


                      } ,
                      child: Text(
                        " انشاء الحساب  " ,
                        style: TextStyle(fontSize: 20 ,) ,
                      ) ,
                    ) ,
                  ) ,
                ] ,
              ) ,
            ) ,
          ) ,

        ));
  }


  void register(){
    var email = emailController.text;
    var password = passwordController.text;
    var name = hospitalNameController.text;
    var phone = phoneController.text;
    var long = _currentPosition.longitude;
    var lat = _currentPosition.latitude;
    var branch = branchController.text;
    var address = _address;
    var type = "hospital";

    var body = {
      "email" : email,
      "password": password,
      "name": name,
      "phone": phone,
      "longitude" : long,
      "latitude": lat,
      "branch": branch,
      "address":address,
      "type":type
    };

    DioHelper.hospitalRegister(
        url: "api/v1/auth/hospital/register",
        body: body
    ).then((value){
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
    })
        .catchError((onError){
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
