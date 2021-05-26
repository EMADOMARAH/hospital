import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:hospital/network/remote/ResponseModel.dart';

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

  static Future<Response> bookBed({
    @required String url,
    @required Map<String , dynamic> userType ,
    Map<String, dynamic> body,
    @required String token
  }) async {
    return await dio.post(
      url ,
      data: body,
      queryParameters: userType,
      options: Options(headers: {"Authorization" : "Bearer " + token}),

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

  static Future<Response>getUpcoming({
    @required String url,
    @required Map<String , dynamic>userType,
    @required String token
  }) async {
    return await dio.get(
      url ,
      queryParameters: userType ,
      options: Options(headers: {"Authorization" : "Bearer " + token}),
    );
  }

  static Future<Response>getHistory({
    @required String url,
    @required Map<String , dynamic>userType,
    @required String token
  }) async {
    return await dio.get(
      url ,
      queryParameters: userType ,
      options: Options(headers: {"Authorization" : "Bearer " + token}),
    );
  }

  static Future<Response>getProfile({
    @required String url,
    @required Map<String , dynamic>userType,
    @required String token
  }) async {
    return await dio.get(
      url ,
      queryParameters: userType ,
      options: Options(headers: {"Authorization" : "Bearer " + token}),
    );
  }

  static Future<Response>getHospitals({
    @required String url,
    @required Map<String , dynamic>userType,
    @required String token
}) async {
    return await dio.get(
      url ,
      queryParameters: userType ,
      options: Options(headers: {"Authorization" : "Bearer " + token}),
    );
  }
  static Future<Response>getBeds({
    @required String url,
    @required Map<String , dynamic>userType,
    @required String token
  }) async {
    return await dio.get(
      url ,
      queryParameters: userType ,
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