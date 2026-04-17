// import 'dart:convert';

// GetAllTeachersModel getAllTeachersModelFromJson(String str) =>
//     GetAllTeachersModel.fromJson(json.decode(str));
// String getAllTeachersModelToJson(GetAllTeachersModel data) =>
//     json.encode(data.toJson());

// class GetAllTeachersModel {
//   GetAllTeachersModel({
//     GetAllTeachersDataModel? data,
//     bool? success,
//     String? message,
//     dynamic errors,
//   }) {
//     _data = data;
//     _success = success;
//     _message = message;
//     _errors = errors;
//   }

//   GetAllTeachersModel.fromJson(dynamic json) {
//     _data = json['data'] != null
//         ? GetAllTeachersDataModel.fromJson(json['data'])
//         : null;
//     _success = json['success'];
//     _message = json['message'];
//     _errors = json['errors'];
//   }
//   GetAllTeachersDataModel? _data;
//   bool? _success;
//   String? _message;
//   dynamic _errors;
//   GetAllTeachersModel copyWith({
//     GetAllTeachersDataModel? data,
//     bool? success,
//     String? message,
//     dynamic errors,
//   }) =>
//       GetAllTeachersModel(
//         data: data ?? _data,
//         success: success ?? _success,
//         message: message ?? _message,
//         errors: errors ?? _errors,
//       );
//   GetAllTeachersDataModel? get data => _data;
//   bool? get success => _success;
//   String? get message => _message;
//   dynamic get errors => _errors;

//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     if (_data != null) {
//       map['data'] = _data?.toJson();
//     }
//     map['success'] = _success;
//     map['message'] = _message;
//     map['errors'] = _errors;
//     return map;
//   }
// }

// GetAllTeachersDataModel dataFromJson(String str) =>
//     GetAllTeachersDataModel.fromJson(json.decode(str));
// String dataToJson(GetAllTeachersDataModel data) => json.encode(data.toJson());

// class GetAllTeachersDataModel {
//   GetAllTeachersDataModel({
//     List<TeacherModel>? data,
//     Links? links,
//     Meta? meta,
//   }) {
//     _data = data;
//     _links = links;
//     _meta = meta;
//   }

//   GetAllTeachersDataModel.fromJson(dynamic json) {
//     if (json['data'] != null) {
//       _data = [];
//       json['data'].forEach((v) {
//         _data?.add(TeacherModel.fromJson(v));
//       });
//     }
//     _links = json['links'] != null ? Links.fromJson(json['links']) : null;
//     _meta = json['meta'] != null ? Meta.fromJson(json['meta']) : null;
//   }
//   List<TeacherModel>? _data;
//   Links? _links;
//   Meta? _meta;
//   GetAllTeachersDataModel copyWith({
//     List<TeacherModel>? data,
//     Links? links,
//     Meta? meta,
//   }) =>
//       GetAllTeachersDataModel(
//         data: data ?? _data,
//         links: links ?? _links,
//         meta: meta ?? _meta,
//       );
//   List<TeacherModel>? get data => _data;
//   Links? get links => _links;
//   Meta? get meta => _meta;

//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     if (_data != null) {
//       map['data'] = _data?.map((v) => v.toJson()).toList();
//     }
//     if (_links != null) {
//       map['links'] = _links?.toJson();
//     }
//     if (_meta != null) {
//       map['meta'] = _meta?.toJson();
//     }
//     return map;
//   }
// }

// Meta metaFromJson(String str) => Meta.fromJson(json.decode(str));
// String metaToJson(Meta data) => json.encode(data.toJson());

// class Meta {
//   Meta({
//     num? currentPage,
//     num? from,
//     num? lastPage,
//     List<Links>? links,
//     String? path,
//     num? perPage,
//     num? to,
//     num? total,
//   }) {
//     _currentPage = currentPage;
//     _from = from;
//     _lastPage = lastPage;
//     _links = links;
//     _path = path;
//     _perPage = perPage;
//     _to = to;
//     _total = total;
//   }

//   Meta.fromJson(dynamic json) {
//     _currentPage = json['current_page'];
//     _from = json['from'];
//     _lastPage = json['last_page'];
//     if (json['links'] != null) {
//       _links = [];
//       json['links'].forEach((v) {
//         _links?.add(Links.fromJson(v));
//       });
//     }
//     _path = json['path'];
//     _perPage = json['per_page'];
//     _to = json['to'];
//     _total = json['total'];
//   }
//   num? _currentPage;
//   num? _from;
//   num? _lastPage;
//   List<Links>? _links;
//   String? _path;
//   num? _perPage;
//   num? _to;
//   num? _total;
//   Meta copyWith({
//     num? currentPage,
//     num? from,
//     num? lastPage,
//     List<Links>? links,
//     String? path,
//     num? perPage,
//     num? to,
//     num? total,
//   }) =>
//       Meta(
//         currentPage: currentPage ?? _currentPage,
//         from: from ?? _from,
//         lastPage: lastPage ?? _lastPage,
//         links: links ?? _links,
//         path: path ?? _path,
//         perPage: perPage ?? _perPage,
//         to: to ?? _to,
//         total: total ?? _total,
//       );
//   num? get currentPage => _currentPage;
//   num? get from => _from;
//   num? get lastPage => _lastPage;
//   List<Links>? get links => _links;
//   String? get path => _path;
//   num? get perPage => _perPage;
//   num? get to => _to;
//   num? get total => _total;

//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['current_page'] = _currentPage;
//     map['from'] = _from;
//     map['last_page'] = _lastPage;
//     if (_links != null) {
//       map['links'] = _links?.map((v) => v.toJson()).toList();
//     }
//     map['path'] = _path;
//     map['per_page'] = _perPage;
//     map['to'] = _to;
//     map['total'] = _total;
//     return map;
//   }
// }

// Links linksFromJson(String str) => Links.fromJson(json.decode(str));
// String linksToJson(Links data) => json.encode(data.toJson());

// class Links {
//   Links({
//     dynamic url,
//     String? label,
//     bool? active,
//   }) {
//     _url = url;
//     _label = label;
//     _active = active;
//   }

//   Links.fromJson(dynamic json) {
//     _url = json['url'];
//     _label = json['label'];
//     _active = json['active'];
//   }
//   dynamic _url;
//   String? _label;
//   bool? _active;
//   Links copyWith({
//     dynamic url,
//     String? label,
//     bool? active,
//   }) =>
//       Links(
//         url: url ?? _url,
//         label: label ?? _label,
//         active: active ?? _active,
//       );
//   dynamic get url => _url;
//   String? get label => _label;
//   bool? get active => _active;

//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['url'] = _url;
//     map['label'] = _label;
//     map['active'] = _active;
//     return map;
//   }
// }

// TeacherModel teacherModelFromJson(String str) =>
//     TeacherModel.fromJson(json.decode(str));
// String teacherModelToJson(TeacherModel data) => json.encode(data.toJson());

// class TeacherModel {
//   TeacherModel({
//     num? id,
//     num? userId,
//     num? countryId,
//     num? stateId,
//     dynamic cityId,
//     String? name,
//     String? firstName,
//     String? lastName,
//     List<dynamic>? description,
//     DescriptionTranslations? descriptionTranslations,
//     String? addressLine1,
//     String? addressLine2,
//     String? userName,
//     String? zipCode,
//     num? isApproved,
//     String? approvedAt,
//     num? isActive,
//     num? isOnline,
//     num? isFeatured,
//     dynamic icon,
//     String? image,
//     String? coverImage,
//     num? rating,
//     TeacherSettings? teacherSettings,
//     List<num>? teacherCategoryIds,
//     AppointmentTypes? appointmentTypes,
//     List<TeacherCategories>? teacherCategories,
//     String? createdAt,
//     String? updatedAt,
//   }) {
//     _id = id;
//     _userId = userId;
//     _countryId = countryId;
//     _stateId = stateId;
//     _cityId = cityId;
//     _name = name;
//     _firstName = firstName;
//     _lastName = lastName;
//     _description = description;
//     _descriptionTranslations = descriptionTranslations;
//     _addressLine1 = addressLine1;
//     _addressLine2 = addressLine2;
//     _userName = userName;
//     _zipCode = zipCode;
//     _isApproved = isApproved;
//     _approvedAt = approvedAt;
//     _isActive = isActive;
//     _isOnline = isOnline;
//     _isFeatured = isFeatured;
//     _icon = icon;
//     _image = image;
//     _coverImage = coverImage;
//     _rating = rating;
//     _teacherSettings = teacherSettings;
//     _teacherCategoryIds = teacherCategoryIds;
//     _appointmentTypes = appointmentTypes;
//     _teacherCategories = teacherCategories;
//     _createdAt = createdAt;
//     _updatedAt = updatedAt;
//   }

//   TeacherModel.fromJson(dynamic json) {
//     _id = json['id'];
//     _userId = json['user_id'];
//     _countryId = json['country_id'];
//     _stateId = json['state_id'];
//     _cityId = json['city_id'];
//     _name = json['name'];
//     _firstName = json['first_name'];
//     _lastName = json['last_name'];
//     if (json['description'] != null) {
//       _description = [];
//       json['description'].forEach((v) {
//         _description?.add(Dynamic.fromJson(v));
//       });
//     }
//     _descriptionTranslations = json['description_translations'] != null
//         ? DescriptionTranslations.fromJson(json['description_translations'])
//         : null;
//     _addressLine1 = json['address_line_1'];
//     _addressLine2 = json['address_line_2'];
//     _userName = json['user_name'];
//     _zipCode = json['zip_code'];
//     _isApproved = json['is_approved'];
//     _approvedAt = json['approved_at'];
//     _isActive = json['is_active'];
//     _isOnline = json['is_online'];
//     _isFeatured = json['is_featured'];
//     _icon = json['icon'];
//     _image = json['image'];
//     _coverImage = json['cover_image'];
//     _rating = json['rating'];
//     _teacherSettings = json['teacher_settings'] != null
//         ? TeacherSettings.fromJson(json['teacher_settings'])
//         : null;
//     _teacherCategoryIds = json['teacher_category_ids'] != null
//         ? json['teacher_category_ids'].cast<num>()
//         : [];
//     _appointmentTypes = json['appointment_types'] != null
//         ? AppointmentTypes.fromJson(json['appointment_types'])
//         : null;
//     if (json['teacher_categories'] != null) {
//       _teacherCategories = [];
//       json['teacher_categories'].forEach((v) {
//         _teacherCategories?.add(TeacherCategories.fromJson(v));
//       });
//     }
//     _createdAt = json['created_at'];
//     _updatedAt = json['updated_at'];
//   }
//   num? _id;
//   num? _userId;
//   num? _countryId;
//   num? _stateId;
//   dynamic _cityId;
//   String? _name;
//   String? _firstName;
//   String? _lastName;
//   List<dynamic>? _description;
//   DescriptionTranslations? _descriptionTranslations;
//   String? _addressLine1;
//   String? _addressLine2;
//   String? _userName;
//   String? _zipCode;
//   num? _isApproved;
//   String? _approvedAt;
//   num? _isActive;
//   num? _isOnline;
//   num? _isFeatured;
//   dynamic _icon;
//   String? _image;
//   String? _coverImage;
//   num? _rating;
//   TeacherSettings? _teacherSettings;
//   List<num>? _teacherCategoryIds;
//   AppointmentTypes? _appointmentTypes;
//   List<TeacherCategories>? _teacherCategories;
//   String? _createdAt;
//   String? _updatedAt;
//   TeacherModel copyWith({
//     num? id,
//     num? userId,
//     num? countryId,
//     num? stateId,
//     dynamic cityId,
//     String? name,
//     String? firstName,
//     String? lastName,
//     List<dynamic>? description,
//     DescriptionTranslations? descriptionTranslations,
//     String? addressLine1,
//     String? addressLine2,
//     String? userName,
//     String? zipCode,
//     num? isApproved,
//     String? approvedAt,
//     num? isActive,
//     num? isOnline,
//     num? isFeatured,
//     dynamic icon,
//     String? image,
//     String? coverImage,
//     num? rating,
//     TeacherSettings? teacherSettings,
//     List<num>? teacherCategoryIds,
//     AppointmentTypes? appointmentTypes,
//     List<TeacherCategories>? teacherCategories,
//     String? createdAt,
//     String? updatedAt,
//   }) =>
//       TeacherModel(
//         id: id ?? _id,
//         userId: userId ?? _userId,
//         countryId: countryId ?? _countryId,
//         stateId: stateId ?? _stateId,
//         cityId: cityId ?? _cityId,
//         name: name ?? _name,
//         firstName: firstName ?? _firstName,
//         lastName: lastName ?? _lastName,
//         description: description ?? _description,
//         descriptionTranslations:
//             descriptionTranslations ?? _descriptionTranslations,
//         addressLine1: addressLine1 ?? _addressLine1,
//         addressLine2: addressLine2 ?? _addressLine2,
//         userName: userName ?? _userName,
//         zipCode: zipCode ?? _zipCode,
//         isApproved: isApproved ?? _isApproved,
//         approvedAt: approvedAt ?? _approvedAt,
//         isActive: isActive ?? _isActive,
//         isOnline: isOnline ?? _isOnline,
//         isFeatured: isFeatured ?? _isFeatured,
//         icon: icon ?? _icon,
//         image: image ?? _image,
//         coverImage: coverImage ?? _coverImage,
//         rating: rating ?? _rating,
//         teacherSettings: teacherSettings ?? _teacherSettings,
//         teacherCategoryIds: teacherCategoryIds ?? _teacherCategoryIds,
//         appointmentTypes: appointmentTypes ?? _appointmentTypes,
//         teacherCategories: teacherCategories ?? _teacherCategories,
//         createdAt: createdAt ?? _createdAt,
//         updatedAt: updatedAt ?? _updatedAt,
//       );
//   num? get id => _id;
//   num? get userId => _userId;
//   num? get countryId => _countryId;
//   num? get stateId => _stateId;
//   dynamic get cityId => _cityId;
//   String? get name => _name;
//   String? get firstName => _firstName;
//   String? get lastName => _lastName;
//   List<dynamic>? get description => _description;
//   DescriptionTranslations? get descriptionTranslations =>
//       _descriptionTranslations;
//   String? get addressLine1 => _addressLine1;
//   String? get addressLine2 => _addressLine2;
//   String? get userName => _userName;
//   String? get zipCode => _zipCode;
//   num? get isApproved => _isApproved;
//   String? get approvedAt => _approvedAt;
//   num? get isActive => _isActive;
//   num? get isOnline => _isOnline;
//   num? get isFeatured => _isFeatured;
//   dynamic get icon => _icon;
//   String? get image => _image;
//   String? get coverImage => _coverImage;
//   num? get rating => _rating;
//   TeacherSettings? get teacherSettings => _teacherSettings;
//   List<num>? get teacherCategoryIds => _teacherCategoryIds;
//   AppointmentTypes? get appointmentTypes => _appointmentTypes;
//   List<TeacherCategories>? get teacherCategories => _teacherCategories;
//   String? get createdAt => _createdAt;
//   String? get updatedAt => _updatedAt;

//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['id'] = _id;
//     map['user_id'] = _userId;
//     map['country_id'] = _countryId;
//     map['state_id'] = _stateId;
//     map['city_id'] = _cityId;
//     map['name'] = _name;
//     map['first_name'] = _firstName;
//     map['last_name'] = _lastName;
//     if (_description != null) {
//       map['description'] = _description?.map((v) => v.toJson()).toList();
//     }
//     if (_descriptionTranslations != null) {
//       map['description_translations'] = _descriptionTranslations?.toJson();
//     }
//     map['address_line_1'] = _addressLine1;
//     map['address_line_2'] = _addressLine2;
//     map['user_name'] = _userName;
//     map['zip_code'] = _zipCode;
//     map['is_approved'] = _isApproved;
//     map['approved_at'] = _approvedAt;
//     map['is_active'] = _isActive;
//     map['is_online'] = _isOnline;
//     map['is_featured'] = _isFeatured;
//     map['icon'] = _icon;
//     map['image'] = _image;
//     map['cover_image'] = _coverImage;
//     map['rating'] = _rating;
//     if (_teacherSettings != null) {
//       map['teacher_settings'] = _teacherSettings?.toJson();
//     }
//     map['teacher_category_ids'] = _teacherCategoryIds;
//     if (_appointmentTypes != null) {
//       map['appointment_types'] = _appointmentTypes?.toJson();
//     }
//     if (_teacherCategories != null) {
//       map['teacher_categories'] =
//           _teacherCategories?.map((v) => v.toJson()).toList();
//     }
//     map['created_at'] = _createdAt;
//     map['updated_at'] = _updatedAt;
//     return map;
//   }
// }

// TeacherCategories teacherCategoriesFromJson(String str) =>
//     TeacherCategories.fromJson(json.decode(str));
// String teacherCategoriesToJson(TeacherCategories data) =>
//     json.encode(data.toJson());

// class TeacherCategories {
//   TeacherCategories({
//     num? id,
//     String? name,
//     String? description,
//     String? slug,
//     num? isActive,
//     num? isFeatured,
//     dynamic icon,
//     dynamic image,
//     dynamic teachers,
//     String? createdAt,
//     String? updatedAt,
//   }) {
//     _id = id;
//     _name = name;
//     _description = description;
//     _slug = slug;
//     _isActive = isActive;
//     _isFeatured = isFeatured;
//     _icon = icon;
//     _image = image;
//     _teachers = teachers;
//     _createdAt = createdAt;
//     _updatedAt = updatedAt;
//   }

//   TeacherCategories.fromJson(dynamic json) {
//     _id = json['id'];
//     _name = json['name'];
//     _description = json['description'];
//     _slug = json['slug'];
//     _isActive = json['is_active'];
//     _isFeatured = json['is_featured'];
//     _icon = json['icon'];
//     _image = json['image'];
//     _teachers = json['teachers'];
//     _createdAt = json['created_at'];
//     _updatedAt = json['updated_at'];
//   }
//   num? _id;
//   String? _name;
//   String? _description;
//   String? _slug;
//   num? _isActive;
//   num? _isFeatured;
//   dynamic _icon;
//   dynamic _image;
//   dynamic _teachers;
//   String? _createdAt;
//   String? _updatedAt;
//   TeacherCategories copyWith({
//     num? id,
//     String? name,
//     String? description,
//     String? slug,
//     num? isActive,
//     num? isFeatured,
//     dynamic icon,
//     dynamic image,
//     dynamic teachers,
//     String? createdAt,
//     String? updatedAt,
//   }) =>
//       TeacherCategories(
//         id: id ?? _id,
//         name: name ?? _name,
//         description: description ?? _description,
//         slug: slug ?? _slug,
//         isActive: isActive ?? _isActive,
//         isFeatured: isFeatured ?? _isFeatured,
//         icon: icon ?? _icon,
//         image: image ?? _image,
//         teachers: teachers ?? _teachers,
//         createdAt: createdAt ?? _createdAt,
//         updatedAt: updatedAt ?? _updatedAt,
//       );
//   num? get id => _id;
//   String? get name => _name;
//   String? get description => _description;
//   String? get slug => _slug;
//   num? get isActive => _isActive;
//   num? get isFeatured => _isFeatured;
//   dynamic get icon => _icon;
//   dynamic get image => _image;
//   dynamic get teachers => _teachers;
//   String? get createdAt => _createdAt;
//   String? get updatedAt => _updatedAt;

//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['id'] = _id;
//     map['name'] = _name;
//     map['description'] = _description;
//     map['slug'] = _slug;
//     map['is_active'] = _isActive;
//     map['is_featured'] = _isFeatured;
//     map['icon'] = _icon;
//     map['image'] = _image;
//     map['teachers'] = _teachers;
//     map['created_at'] = _createdAt;
//     map['updated_at'] = _updatedAt;
//     return map;
//   }
// }

// AppointmentTypes appointmentTypesFromJson(String str) =>
//     AppointmentTypes.fromJson(json.decode(str));
// String appointmentTypesToJson(AppointmentTypes data) =>
//     json.encode(data.toJson());

// class AppointmentTypes {
//   AppointmentTypes({
//     Video? video,
//     Chat? chat,
//     Audio? audio,
//   }) {
//     _video = video;
//     _chat = chat;
//     _audio = audio;
//   }

//   AppointmentTypes.fromJson(dynamic json) {
//     _video = json['video'] != null ? Video.fromJson(json['video']) : null;
//     _chat = json['chat'] != null ? Chat.fromJson(json['chat']) : null;
//     _audio = json['audio'] != null ? Audio.fromJson(json['audio']) : null;
//   }
//   Video? _video;
//   Chat? _chat;
//   Audio? _audio;
//   AppointmentTypes copyWith({
//     Video? video,
//     Chat? chat,
//     Audio? audio,
//   }) =>
//       AppointmentTypes(
//         video: video ?? _video,
//         chat: chat ?? _chat,
//         audio: audio ?? _audio,
//       );
//   Video? get video => _video;
//   Chat? get chat => _chat;
//   Audio? get audio => _audio;

//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     if (_video != null) {
//       map['video'] = _video?.toJson();
//     }
//     if (_chat != null) {
//       map['chat'] = _chat?.toJson();
//     }
//     if (_audio != null) {
//       map['audio'] = _audio?.toJson();
//     }
//     return map;
//   }
// }

// Audio audioFromJson(String str) => Audio.fromJson(json.decode(str));
// String audioToJson(Audio data) => json.encode(data.toJson());

// class Audio {
//   Audio({
//     num? id,
//     num? teacherId,
//     dynamic academyId,
//     num? appointmentTypeId,
//     num? fee,
//     String? day,
//     num? isHoliday,
//     String? startTime,
//     String? endTime,
//     num? slotDuration,
//     String? type,
//     AppointmentType? appointmentType,
//     List<dynamic>? scheduleSlots,
//     String? createdAt,
//     String? updatedAt,
//   }) {
//     _id = id;
//     _teacherId = teacherId;
//     _academyId = academyId;
//     _appointmentTypeId = appointmentTypeId;
//     _fee = fee;
//     _day = day;
//     _isHoliday = isHoliday;
//     _startTime = startTime;
//     _endTime = endTime;
//     _slotDuration = slotDuration;
//     _type = type;
//     _appointmentType = appointmentType;
//     _scheduleSlots = scheduleSlots;
//     _createdAt = createdAt;
//     _updatedAt = updatedAt;
//   }

//   Audio.fromJson(dynamic json) {
//     _id = json['id'];
//     _teacherId = json['teacher_id'];
//     _academyId = json['academy_id'];
//     _appointmentTypeId = json['appointment_type_id'];
//     _fee = json['fee'];
//     _day = json['day'];
//     _isHoliday = json['is_holiday'];
//     _startTime = json['start_time'];
//     _endTime = json['end_time'];
//     _slotDuration = json['slot_duration'];
//     _type = json['type'];
//     _appointmentType = json['appointment_type'] != null
//         ? AppointmentType.fromJson(json['appointment_type'])
//         : null;
//     if (json['schedule_slots'] != null) {
//       _scheduleSlots = [];
//       json['schedule_slots'].forEach((v) {
//         _scheduleSlots?.add(Dynamic.fromJson(v));
//       });
//     }
//     _createdAt = json['created_at'];
//     _updatedAt = json['updated_at'];
//   }
//   num? _id;
//   num? _teacherId;
//   dynamic _academyId;
//   num? _appointmentTypeId;
//   num? _fee;
//   String? _day;
//   num? _isHoliday;
//   String? _startTime;
//   String? _endTime;
//   num? _slotDuration;
//   String? _type;
//   AppointmentType? _appointmentType;
//   List<dynamic>? _scheduleSlots;
//   String? _createdAt;
//   String? _updatedAt;
//   Audio copyWith({
//     num? id,
//     num? teacherId,
//     dynamic academyId,
//     num? appointmentTypeId,
//     num? fee,
//     String? day,
//     num? isHoliday,
//     String? startTime,
//     String? endTime,
//     num? slotDuration,
//     String? type,
//     AppointmentType? appointmentType,
//     List<dynamic>? scheduleSlots,
//     String? createdAt,
//     String? updatedAt,
//   }) =>
//       Audio(
//         id: id ?? _id,
//         teacherId: teacherId ?? _teacherId,
//         academyId: academyId ?? _academyId,
//         appointmentTypeId: appointmentTypeId ?? _appointmentTypeId,
//         fee: fee ?? _fee,
//         day: day ?? _day,
//         isHoliday: isHoliday ?? _isHoliday,
//         startTime: startTime ?? _startTime,
//         endTime: endTime ?? _endTime,
//         slotDuration: slotDuration ?? _slotDuration,
//         type: type ?? _type,
//         appointmentType: appointmentType ?? _appointmentType,
//         scheduleSlots: scheduleSlots ?? _scheduleSlots,
//         createdAt: createdAt ?? _createdAt,
//         updatedAt: updatedAt ?? _updatedAt,
//       );
//   num? get id => _id;
//   num? get teacherId => _teacherId;
//   dynamic get academyId => _academyId;
//   num? get appointmentTypeId => _appointmentTypeId;
//   num? get fee => _fee;
//   String? get day => _day;
//   num? get isHoliday => _isHoliday;
//   String? get startTime => _startTime;
//   String? get endTime => _endTime;
//   num? get slotDuration => _slotDuration;
//   String? get type => _type;
//   AppointmentType? get appointmentType => _appointmentType;
//   List<dynamic>? get scheduleSlots => _scheduleSlots;
//   String? get createdAt => _createdAt;
//   String? get updatedAt => _updatedAt;

//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['id'] = _id;
//     map['teacher_id'] = _teacherId;
//     map['academy_id'] = _academyId;
//     map['appointment_type_id'] = _appointmentTypeId;
//     map['fee'] = _fee;
//     map['day'] = _day;
//     map['is_holiday'] = _isHoliday;
//     map['start_time'] = _startTime;
//     map['end_time'] = _endTime;
//     map['slot_duration'] = _slotDuration;
//     map['type'] = _type;
//     if (_appointmentType != null) {
//       map['appointment_type'] = _appointmentType?.toJson();
//     }
//     if (_scheduleSlots != null) {
//       map['schedule_slots'] = _scheduleSlots?.map((v) => v.toJson()).toList();
//     }
//     map['created_at'] = _createdAt;
//     map['updated_at'] = _updatedAt;
//     return map;
//   }
// }

// AppointmentType appointmentTypeFromJson(String str) =>
//     AppointmentType.fromJson(json.decode(str));
// String appointmentTypeToJson(AppointmentType data) =>
//     json.encode(data.toJson());

// class AppointmentType {
//   AppointmentType({
//     num? id,
//     String? displayName,
//     String? description,
//     String? type,
//     num? isScheduleRequired,
//     num? isPaid,
//     num? isActive,
//     String? createdAt,
//     String? updatedAt,
//   }) {
//     _id = id;
//     _displayName = displayName;
//     _description = description;
//     _type = type;
//     _isScheduleRequired = isScheduleRequired;
//     _isPaid = isPaid;
//     _isActive = isActive;
//     _createdAt = createdAt;
//     _updatedAt = updatedAt;
//   }

//   AppointmentType.fromJson(dynamic json) {
//     _id = json['id'];
//     _displayName = json['display_name'];
//     _description = json['description'];
//     _type = json['type'];
//     _isScheduleRequired = json['is_schedule_required'];
//     _isPaid = json['is_paid'];
//     _isActive = json['is_active'];
//     _createdAt = json['created_at'];
//     _updatedAt = json['updated_at'];
//   }
//   num? _id;
//   String? _displayName;
//   String? _description;
//   String? _type;
//   num? _isScheduleRequired;
//   num? _isPaid;
//   num? _isActive;
//   String? _createdAt;
//   String? _updatedAt;
//   AppointmentType copyWith({
//     num? id,
//     String? displayName,
//     String? description,
//     String? type,
//     num? isScheduleRequired,
//     num? isPaid,
//     num? isActive,
//     String? createdAt,
//     String? updatedAt,
//   }) =>
//       AppointmentType(
//         id: id ?? _id,
//         displayName: displayName ?? _displayName,
//         description: description ?? _description,
//         type: type ?? _type,
//         isScheduleRequired: isScheduleRequired ?? _isScheduleRequired,
//         isPaid: isPaid ?? _isPaid,
//         isActive: isActive ?? _isActive,
//         createdAt: createdAt ?? _createdAt,
//         updatedAt: updatedAt ?? _updatedAt,
//       );
//   num? get id => _id;
//   String? get displayName => _displayName;
//   String? get description => _description;
//   String? get type => _type;
//   num? get isScheduleRequired => _isScheduleRequired;
//   num? get isPaid => _isPaid;
//   num? get isActive => _isActive;
//   String? get createdAt => _createdAt;
//   String? get updatedAt => _updatedAt;

//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['id'] = _id;
//     map['display_name'] = _displayName;
//     map['description'] = _description;
//     map['type'] = _type;
//     map['is_schedule_required'] = _isScheduleRequired;
//     map['is_paid'] = _isPaid;
//     map['is_active'] = _isActive;
//     map['created_at'] = _createdAt;
//     map['updated_at'] = _updatedAt;
//     return map;
//   }
// }

// Chat chatFromJson(String str) => Chat.fromJson(json.decode(str));
// String chatToJson(Chat data) => json.encode(data.toJson());

// class Chat {
//   Chat({
//     num? id,
//     num? teacherId,
//     dynamic academyId,
//     num? appointmentTypeId,
//     num? fee,
//     dynamic day,
//     dynamic isHoliday,
//     dynamic startTime,
//     dynamic endTime,
//     dynamic slotDuration,
//     String? type,
//     AppointmentType? appointmentType,
//     List<dynamic>? scheduleSlots,
//     String? createdAt,
//     String? updatedAt,
//   }) {
//     _id = id;
//     _teacherId = teacherId;
//     _academyId = academyId;
//     _appointmentTypeId = appointmentTypeId;
//     _fee = fee;
//     _day = day;
//     _isHoliday = isHoliday;
//     _startTime = startTime;
//     _endTime = endTime;
//     _slotDuration = slotDuration;
//     _type = type;
//     _appointmentType = appointmentType;
//     _scheduleSlots = scheduleSlots;
//     _createdAt = createdAt;
//     _updatedAt = updatedAt;
//   }

//   Chat.fromJson(dynamic json) {
//     _id = json['id'];
//     _teacherId = json['teacher_id'];
//     _academyId = json['academy_id'];
//     _appointmentTypeId = json['appointment_type_id'];
//     _fee = json['fee'];
//     _day = json['day'];
//     _isHoliday = json['is_holiday'];
//     _startTime = json['start_time'];
//     _endTime = json['end_time'];
//     _slotDuration = json['slot_duration'];
//     _type = json['type'];
//     _appointmentType = json['appointment_type'] != null
//         ? AppointmentType.fromJson(json['appointment_type'])
//         : null;
//     if (json['schedule_slots'] != null) {
//       _scheduleSlots = [];
//       json['schedule_slots'].forEach((v) {
//         _scheduleSlots?.add(Dynamic.fromJson(v));
//       });
//     }
//     _createdAt = json['created_at'];
//     _updatedAt = json['updated_at'];
//   }
//   num? _id;
//   num? _teacherId;
//   dynamic _academyId;
//   num? _appointmentTypeId;
//   num? _fee;
//   dynamic _day;
//   dynamic _isHoliday;
//   dynamic _startTime;
//   dynamic _endTime;
//   dynamic _slotDuration;
//   String? _type;
//   AppointmentType? _appointmentType;
//   List<dynamic>? _scheduleSlots;
//   String? _createdAt;
//   String? _updatedAt;
//   Chat copyWith({
//     num? id,
//     num? teacherId,
//     dynamic academyId,
//     num? appointmentTypeId,
//     num? fee,
//     dynamic day,
//     dynamic isHoliday,
//     dynamic startTime,
//     dynamic endTime,
//     dynamic slotDuration,
//     String? type,
//     AppointmentType? appointmentType,
//     List<dynamic>? scheduleSlots,
//     String? createdAt,
//     String? updatedAt,
//   }) =>
//       Chat(
//         id: id ?? _id,
//         teacherId: teacherId ?? _teacherId,
//         academyId: academyId ?? _academyId,
//         appointmentTypeId: appointmentTypeId ?? _appointmentTypeId,
//         fee: fee ?? _fee,
//         day: day ?? _day,
//         isHoliday: isHoliday ?? _isHoliday,
//         startTime: startTime ?? _startTime,
//         endTime: endTime ?? _endTime,
//         slotDuration: slotDuration ?? _slotDuration,
//         type: type ?? _type,
//         appointmentType: appointmentType ?? _appointmentType,
//         scheduleSlots: scheduleSlots ?? _scheduleSlots,
//         createdAt: createdAt ?? _createdAt,
//         updatedAt: updatedAt ?? _updatedAt,
//       );
//   num? get id => _id;
//   num? get teacherId => _teacherId;
//   dynamic get academyId => _academyId;
//   num? get appointmentTypeId => _appointmentTypeId;
//   num? get fee => _fee;
//   dynamic get day => _day;
//   dynamic get isHoliday => _isHoliday;
//   dynamic get startTime => _startTime;
//   dynamic get endTime => _endTime;
//   dynamic get slotDuration => _slotDuration;
//   String? get type => _type;
//   AppointmentType? get appointmentType => _appointmentType;
//   List<dynamic>? get scheduleSlots => _scheduleSlots;
//   String? get createdAt => _createdAt;
//   String? get updatedAt => _updatedAt;

//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['id'] = _id;
//     map['teacher_id'] = _teacherId;
//     map['academy_id'] = _academyId;
//     map['appointment_type_id'] = _appointmentTypeId;
//     map['fee'] = _fee;
//     map['day'] = _day;
//     map['is_holiday'] = _isHoliday;
//     map['start_time'] = _startTime;
//     map['end_time'] = _endTime;
//     map['slot_duration'] = _slotDuration;
//     map['type'] = _type;
//     if (_appointmentType != null) {
//       map['appointment_type'] = _appointmentType?.toJson();
//     }
//     if (_scheduleSlots != null) {
//       map['schedule_slots'] = _scheduleSlots?.map((v) => v.toJson()).toList();
//     }
//     map['created_at'] = _createdAt;
//     map['updated_at'] = _updatedAt;
//     return map;
//   }
// }

// Video videoFromJson(String str) => Video.fromJson(json.decode(str));
// String videoToJson(Video data) => json.encode(data.toJson());

// class Video {
//   Video({
//     num? id,
//     num? teacherId,
//     dynamic academyId,
//     num? appointmentTypeId,
//     num? fee,
//     String? day,
//     num? isHoliday,
//     String? startTime,
//     String? endTime,
//     num? slotDuration,
//     String? type,
//     AppointmentType? appointmentType,
//     List<dynamic>? scheduleSlots,
//     String? createdAt,
//     String? updatedAt,
//   }) {
//     _id = id;
//     _teacherId = teacherId;
//     _academyId = academyId;
//     _appointmentTypeId = appointmentTypeId;
//     _fee = fee;
//     _day = day;
//     _isHoliday = isHoliday;
//     _startTime = startTime;
//     _endTime = endTime;
//     _slotDuration = slotDuration;
//     _type = type;
//     _appointmentType = appointmentType;
//     _scheduleSlots = scheduleSlots;
//     _createdAt = createdAt;
//     _updatedAt = updatedAt;
//   }

//   Video.fromJson(dynamic json) {
//     _id = json['id'];
//     _teacherId = json['teacher_id'];
//     _academyId = json['academy_id'];
//     _appointmentTypeId = json['appointment_type_id'];
//     _fee = json['fee'];
//     _day = json['day'];
//     _isHoliday = json['is_holiday'];
//     _startTime = json['start_time'];
//     _endTime = json['end_time'];
//     _slotDuration = json['slot_duration'];
//     _type = json['type'];
//     _appointmentType = json['appointment_type'] != null
//         ? AppointmentType.fromJson(json['appointment_type'])
//         : null;
//     if (json['schedule_slots'] != null) {
//       _scheduleSlots = [];
//       json['schedule_slots'].forEach((v) {
//         _scheduleSlots?.add(Dynamic.fromJson(v));
//       });
//     }
//     _createdAt = json['created_at'];
//     _updatedAt = json['updated_at'];
//   }
//   num? _id;
//   num? _teacherId;
//   dynamic _academyId;
//   num? _appointmentTypeId;
//   num? _fee;
//   String? _day;
//   num? _isHoliday;
//   String? _startTime;
//   String? _endTime;
//   num? _slotDuration;
//   String? _type;
//   AppointmentType? _appointmentType;
//   List<dynamic>? _scheduleSlots;
//   String? _createdAt;
//   String? _updatedAt;
//   Video copyWith({
//     num? id,
//     num? teacherId,
//     dynamic academyId,
//     num? appointmentTypeId,
//     num? fee,
//     String? day,
//     num? isHoliday,
//     String? startTime,
//     String? endTime,
//     num? slotDuration,
//     String? type,
//     AppointmentType? appointmentType,
//     List<dynamic>? scheduleSlots,
//     String? createdAt,
//     String? updatedAt,
//   }) =>
//       Video(
//         id: id ?? _id,
//         teacherId: teacherId ?? _teacherId,
//         academyId: academyId ?? _academyId,
//         appointmentTypeId: appointmentTypeId ?? _appointmentTypeId,
//         fee: fee ?? _fee,
//         day: day ?? _day,
//         isHoliday: isHoliday ?? _isHoliday,
//         startTime: startTime ?? _startTime,
//         endTime: endTime ?? _endTime,
//         slotDuration: slotDuration ?? _slotDuration,
//         type: type ?? _type,
//         appointmentType: appointmentType ?? _appointmentType,
//         scheduleSlots: scheduleSlots ?? _scheduleSlots,
//         createdAt: createdAt ?? _createdAt,
//         updatedAt: updatedAt ?? _updatedAt,
//       );
//   num? get id => _id;
//   num? get teacherId => _teacherId;
//   dynamic get academyId => _academyId;
//   num? get appointmentTypeId => _appointmentTypeId;
//   num? get fee => _fee;
//   String? get day => _day;
//   num? get isHoliday => _isHoliday;
//   String? get startTime => _startTime;
//   String? get endTime => _endTime;
//   num? get slotDuration => _slotDuration;
//   String? get type => _type;
//   AppointmentType? get appointmentType => _appointmentType;
//   List<dynamic>? get scheduleSlots => _scheduleSlots;
//   String? get createdAt => _createdAt;
//   String? get updatedAt => _updatedAt;

//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['id'] = _id;
//     map['teacher_id'] = _teacherId;
//     map['academy_id'] = _academyId;
//     map['appointment_type_id'] = _appointmentTypeId;
//     map['fee'] = _fee;
//     map['day'] = _day;
//     map['is_holiday'] = _isHoliday;
//     map['start_time'] = _startTime;
//     map['end_time'] = _endTime;
//     map['slot_duration'] = _slotDuration;
//     map['type'] = _type;
//     if (_appointmentType != null) {
//       map['appointment_type'] = _appointmentType?.toJson();
//     }
//     if (_scheduleSlots != null) {
//       map['schedule_slots'] = _scheduleSlots?.map((v) => v.toJson()).toList();
//     }
//     map['created_at'] = _createdAt;
//     map['updated_at'] = _updatedAt;
//     return map;
//   }
// }

// TeacherSettings teacherSettingsFromJson(String str) =>
//     TeacherSettings.fromJson(json.decode(str));
// String teacherSettingsToJson(TeacherSettings data) =>
//     json.encode(data.toJson());

// class TeacherSettings {
//   TeacherSettings({
//     dynamic facebookUrl,
//     dynamic twitterXUrl,
//     String? youtubeUrl,
//     dynamic tiktokUrl,
//     dynamic linkedinUrl,
//     dynamic whatsappUrl,
//     dynamic snapchatUrl,
//     dynamic instagramUrl,
//     dynamic pinterestUrl,
//   }) {
//     _facebookUrl = facebookUrl;
//     _twitterXUrl = twitterXUrl;
//     _youtubeUrl = youtubeUrl;
//     _tiktokUrl = tiktokUrl;
//     _linkedinUrl = linkedinUrl;
//     _whatsappUrl = whatsappUrl;
//     _snapchatUrl = snapchatUrl;
//     _instagramUrl = instagramUrl;
//     _pinterestUrl = pinterestUrl;
//   }

//   TeacherSettings.fromJson(dynamic json) {
//     _facebookUrl = json['facebook_url'];
//     _twitterXUrl = json['twitter/X_url'];
//     _youtubeUrl = json['youtube_url'];
//     _tiktokUrl = json['tiktok_url'];
//     _linkedinUrl = json['linkedin_url'];
//     _whatsappUrl = json['whatsapp_url'];
//     _snapchatUrl = json['snapchat_url'];
//     _instagramUrl = json['instagram_url'];
//     _pinterestUrl = json['pinterest_url'];
//   }
//   dynamic _facebookUrl;
//   dynamic _twitterXUrl;
//   String? _youtubeUrl;
//   dynamic _tiktokUrl;
//   dynamic _linkedinUrl;
//   dynamic _whatsappUrl;
//   dynamic _snapchatUrl;
//   dynamic _instagramUrl;
//   dynamic _pinterestUrl;
//   TeacherSettings copyWith({
//     dynamic facebookUrl,
//     dynamic twitterXUrl,
//     String? youtubeUrl,
//     dynamic tiktokUrl,
//     dynamic linkedinUrl,
//     dynamic whatsappUrl,
//     dynamic snapchatUrl,
//     dynamic instagramUrl,
//     dynamic pinterestUrl,
//   }) =>
//       TeacherSettings(
//         facebookUrl: facebookUrl ?? _facebookUrl,
//         twitterXUrl: twitterXUrl ?? _twitterXUrl,
//         youtubeUrl: youtubeUrl ?? _youtubeUrl,
//         tiktokUrl: tiktokUrl ?? _tiktokUrl,
//         linkedinUrl: linkedinUrl ?? _linkedinUrl,
//         whatsappUrl: whatsappUrl ?? _whatsappUrl,
//         snapchatUrl: snapchatUrl ?? _snapchatUrl,
//         instagramUrl: instagramUrl ?? _instagramUrl,
//         pinterestUrl: pinterestUrl ?? _pinterestUrl,
//       );
//   dynamic get facebookUrl => _facebookUrl;
//   dynamic get twitterXUrl => _twitterXUrl;
//   String? get youtubeUrl => _youtubeUrl;
//   dynamic get tiktokUrl => _tiktokUrl;
//   dynamic get linkedinUrl => _linkedinUrl;
//   dynamic get whatsappUrl => _whatsappUrl;
//   dynamic get snapchatUrl => _snapchatUrl;
//   dynamic get instagramUrl => _instagramUrl;
//   dynamic get pinterestUrl => _pinterestUrl;

//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['facebook_url'] = _facebookUrl;
//     map['twitter/X_url'] = _twitterXUrl;
//     map['youtube_url'] = _youtubeUrl;
//     map['tiktok_url'] = _tiktokUrl;
//     map['linkedin_url'] = _linkedinUrl;
//     map['whatsapp_url'] = _whatsappUrl;
//     map['snapchat_url'] = _snapchatUrl;
//     map['instagram_url'] = _instagramUrl;
//     map['pinterest_url'] = _pinterestUrl;
//     return map;
//   }
// }

// DescriptionTranslations descriptionTranslationsFromJson(String str) =>
//     DescriptionTranslations.fromJson(json.decode(str));
// String descriptionTranslationsToJson(DescriptionTranslations data) =>
//     json.encode(data.toJson());

// class DescriptionTranslations {
//   DescriptionTranslations({
//     List<dynamic>? en,
//   }) {
//     _en = en;
//   }

//   DescriptionTranslations.fromJson(dynamic json) {
//     if (json['en'] != null) {
//       _en = [];
//       json['en'].forEach((v) {
//         _en?.add(Dynamic.fromJson(v));
//       });
//     }
//   }
//   List<dynamic>? _en;
//   DescriptionTranslations copyWith({
//     List<dynamic>? en,
//   }) =>
//       DescriptionTranslations(
//         en: en ?? _en,
//       );
//   List<dynamic>? get en => _en;

//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     if (_en != null) {
//       map['en'] = _en?.map((v) => v.toJson()).toList();
//     }
//     return map;
//   }
// }
