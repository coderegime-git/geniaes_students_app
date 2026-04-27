import 'dart:convert';

State stateFromJson(String str) =>
    State.fromJson(json.decode(str));
String stateToJson(State data) =>
    json.encode(data.toJson());


class State {
  State({
    required this.data,
    required this.success,
    required this.message,
    this.errors,
  });
  late final List<Data> data;
  late final bool success;
  late final String message;
  late final Null errors;

  State.fromJson(Map<String, dynamic> json){
    data = List.from(json['data']).map((e)=>Data.fromJson(e)).toList();
    success = json['success'];
    message = json['message'];
    errors = null;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['data'] = data.map((e)=>e.toJson()).toList();
    _data['success'] = success;
    _data['message'] = message;
    _data['errors'] = errors;
    return _data;
  }
}

class Data {
  Data({
    required this.id,
    required this.name,
    this.description,
    this.image,
    required this.countryId,
    required this.isActive,
    this.latitude,
    this.longitude,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });
  late final int id;
  late final String name;
  late final Null description;
  late final Null image;
  late final int countryId;
  late final int isActive;
  late final String? latitude;
  late final String? longitude;
  late final String createdAt;
  late final String updatedAt;
  late final Null deletedAt;

  Data.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    description = null;
    image = null;
    countryId = json['country_id'];
    isActive = json['is_active'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = null;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['description'] = description;
    _data['image'] = image;
    _data['country_id'] = countryId;
    _data['is_active'] = isActive;
    _data['latitude'] = latitude;
    _data['longitude'] = longitude;
    _data['created_at'] = createdAt;
    _data['updated_at'] = updatedAt;
    _data['deleted_at'] = deletedAt;
    return _data;
  }
}