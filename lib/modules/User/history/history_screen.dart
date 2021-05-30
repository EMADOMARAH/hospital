import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:hospital/network/local/cache_helper.dart';
import 'package:hospital/network/remote/dio_helper.dart';
import 'package:hospital/shared/components/components.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key key}) : super(key: key);

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<dynamic> historyList = [];
  var token;
  @override
  void initState()  {
    // TODO: implement initState

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      token = CacheHelper.getData(key: "token");
      print(token);
      await DioHelper.getHistory(
          url: "/api/v1/user/reservations/history",
          userType: { "type" : "user"},
          token: token
      ).then((value){
        historyList = value.data["data"];
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
            'History'
        ),
      ),
      body: ConditionalBuilder(
        condition: historyList.length>0,
        builder: (context) => ListView.separated(
            physics: BouncingScrollPhysics(),
            itemBuilder: (context , index) =>UpcomingItem(
                context: context,
                upcoming: historyList[index]
            ),
            separatorBuilder:(context , index) => SizedBox(
              height: 0,
            ),
            itemCount: historyList.length
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
