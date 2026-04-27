import 'dart:convert';

Country countryFromJson(String str) =>
    Country.fromJson(json.decode(str));
String countryToJson(Country data) =>
    json.encode(data.toJson());

class Country {
  Country({
    required this.data,
    required this.success,
    required this.message,
    this.errors,
  });
  late final List<Data> data;
  late final bool success;
  late final String message;
  late final Null errors;

  Country.fromJson(Map<String, dynamic> json){
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
    this.isoCode_3,
    this.isoCode_2,
    this.phoneCode,
    this.capital,
    this.currency,
    this.currencySymbol,
    this.native,
    this.region,
    this.isActive,
    this.subRegion,
    this.latitude,
    this.longitude,
    this.emoji,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });
  late final int id;
  late final String name;
  late final String? description;
  late final String? image;
  late final String? isoCode_3;
  late final String? isoCode_2;
  late final String? phoneCode;
  late final String? capital;
  late final String? currency;
  late final String? currencySymbol;
  late final String? native;
  late final String? region;
  late final int? isActive;
  late final String? subRegion;
  late final String? latitude;
  late final String? longitude;
  late final String? emoji;
  late final String? createdAt;
  late final String? updatedAt;
  late final String? deletedAt;

  Data.fromJson(Map<String, dynamic> json){
    id = json['id'] ?? 0;
    name = json['name'] ?? '';
    description = json['description']?.toString();
    image = json['image']?.toString();
    isoCode_3 = json['iso_code_3']?.toString();
    isoCode_2 = json['iso_code_2']?.toString();
    phoneCode = json['phone_code']?.toString();
    capital = json['capital']?.toString();
    currency = json['currency']?.toString();
    currencySymbol = json['currency_symbol']?.toString();
    native = json['native']?.toString();
    region = json['region']?.toString();
    isActive = json['is_active'] is int ? json['is_active'] : int.tryParse(json['is_active']?.toString() ?? '');
    subRegion = json['sub_region']?.toString();
    latitude = json['latitude']?.toString();
    longitude = json['longitude']?.toString();
    emoji = json['emoji']?.toString();
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
    deletedAt = json['deleted_at']?.toString();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['description'] = description;
    _data['image'] = image;
    _data['iso_code_3'] = isoCode_3;
    _data['iso_code_2'] = isoCode_2;
    _data['phone_code'] = phoneCode;
    _data['capital'] = capital;
    _data['currency'] = currency;
    _data['currency_symbol'] = currencySymbol;
    _data['native'] = native;
    _data['region'] = region;
    _data['is_active'] = isActive;
    _data['sub_region'] = subRegion;
    _data['latitude'] = latitude;
    _data['longitude'] = longitude;
    _data['emoji'] = emoji;
    _data['created_at'] = createdAt;
    _data['updated_at'] = updatedAt;
    _data['deleted_at'] = deletedAt;
    return _data;
  }
}