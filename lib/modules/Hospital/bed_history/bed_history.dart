import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:hospital/network/local/cache_helper.dart';
import 'package:hospital/network/remote/dio_helper.dart';
import 'package:hospital/shared/components/components.dart';

class BedHistory extends StatefulWidget {
  String bedId;
   BedHistory({Key key , this.bedId}) : super(key: key);

  @override
  _BedHistoryState createState() => _BedHistoryState(bedId);
}

class _BedHistoryState extends State<BedHistory> {
  String bedId;
  _BedHistoryState(this.bedId);

  List<dynamic> bedsHistory = [];
  var token;

  @override
  void initState() {
    // TODO: implement initState

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      token = CacheHelper.getData(key: "token");
      await DioHelper.getBedHistory(
          url: "api/v1/hospital/beds/${bedId}/reservations",
          userType: {"type": "hospital"},
          token: token
      )
          .then((value) {
        //print(value.data['data']['beds']);
        bedsHistory = value.data['data'];
        print(bedsHistory);
        setState(() {});
      }).catchError((onError) {
        print(onError);
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Bed Reservation'
        ),

      ),
      body: ConditionalBuilder(
        condition: bedsHistory.length>0,
        builder: (context) => ListView.separated(
            physics: BouncingScrollPhysics(),
            itemBuilder: (context , index) =>BedHistoryItem(hospitalBeds: bedsHistory[index], context: context, bedId: bedId, token: token),
            separatorBuilder:(context , index) => SizedBox(
              height: 5,
            ),
            itemCount: bedsHistory.length
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
    );
  }
}
