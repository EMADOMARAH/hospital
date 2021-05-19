import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class DioHelper{
  static Dio dio;

  static init()
  {
    dio = Dio(
      BaseOptions(
        baseUrl: "https://hospital.mohameek-eg.com/",
        receiveDataWhenStatusError: true,
      )
    );
  }


  static Future<Response> userRegister({
  @required String url,
  @required Map<String , dynamic> userType,
    Map<String, dynamic> body
  }) async {
    return await dio.post(
        url ,
        queryParameters:userType,
        data: body,
    );

  }


  static Future<Response> hospitalRegister({
    @required String url,
    Map<String, dynamic> body
  }) async {
    return await dio.post(
      url ,
      data: body,
    );

  }

  static Future<Response> Logout(
      @required String url,
      @required Map<String , dynamic> userType ,
      @required String token
      ) async {
    return await dio.post(
     url,
    queryParameters: userType,
    options: Options(headers: {"Authorization" : "Bearer " + token}),
    );

  }

  static Future<Response> login(
      @required String url,
      @required Map<String , dynamic> userType,
      Map<String, dynamic> body
      ) async {
    return await dio.post(
      url ,
      queryParameters:userType,
      data: body,
    );
  }


}