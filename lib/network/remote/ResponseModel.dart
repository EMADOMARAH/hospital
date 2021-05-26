

class ResponseModel {
  String message;
  List<Data> data;
  bool status;

  ResponseModel({this.message, this.data, this.status});

  ResponseModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    return data;
  }
}

class Data {
  int id;
  String name;
  String email;
  String phone;
  String longitude;
  String latitude;
  String address;
  String branch;

  Data(
      {this.id,
        this.name,
        this.email,
        this.phone,
        this.longitude,
        this.latitude,
        this.address,
        this.branch});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    longitude = json['longitude'];
    latitude = json['latitude'];
    address = json['address'];
    branch = json['branch'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['longitude'] = this.longitude;
    data['latitude'] = this.latitude;
    data['address'] = this.address;
    data['branch'] = this.branch;
    return data;
  }
}
