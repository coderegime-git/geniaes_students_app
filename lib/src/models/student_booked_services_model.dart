import 'dart:convert';

GetStudentBookedServicesModel getStudentBookedServicesModelFromJson(
        String str) =>
    GetStudentBookedServicesModel.fromJson(json.decode(str));
String getStudentBookedServicesModelToJson(
        GetStudentBookedServicesModel data) =>
    json.encode(data.toJson());

class GetStudentBookedServicesModel {
  GetStudentBookedServicesModel({
    GetStudentBookedServicesDataModel? data,
    bool? success,
    String? message,
    dynamic errors,
  }) {
    _data = data;
    _success = success;
    _message = message;
    _errors = errors;
  }

  GetStudentBookedServicesModel.fromJson(dynamic json) {
    _data = json['data'] != null
        ? GetStudentBookedServicesDataModel.fromJson(json['data'])
        : null;
    _success = json['success'];
    _message = json['message'];
    _errors = json['errors'];
  }
  GetStudentBookedServicesDataModel? _data;
  bool? _success;
  String? _message;
  dynamic _errors;
  GetStudentBookedServicesModel copyWith({
    GetStudentBookedServicesDataModel? data,
    bool? success,
    String? message,
    dynamic errors,
  }) =>
      GetStudentBookedServicesModel(
        data: data ?? _data,
        success: success ?? _success,
        message: message ?? _message,
        errors: errors ?? _errors,
      );
  GetStudentBookedServicesDataModel? get data => _data;
  bool? get success => _success;
  String? get message => _message;
  dynamic get errors => _errors;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_data != null) {
      map['data'] = _data?.toJson();
    }
    map['success'] = _success;
    map['message'] = _message;
    map['errors'] = _errors;
    return map;
  }
}

GetStudentBookedServicesDataModel getStudentBookedServicesDataModelFromJson(
        String str) =>
    GetStudentBookedServicesDataModel.fromJson(json.decode(str));
String getStudentBookedServicesDataModelToJson(
        GetStudentBookedServicesDataModel getStudentBookedServicesDataModel) =>
    json.encode(getStudentBookedServicesDataModel.toJson());

class GetStudentBookedServicesDataModel {
  GetStudentBookedServicesDataModel({
    List<StudentBookedServiceModel>? data,
    Links? links,
    Meta? meta,
  }) {
    _data = data;
    _links = links;
    _meta = meta;
  }

  GetStudentBookedServicesDataModel.fromJson(dynamic json) {
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(StudentBookedServiceModel.fromJson(v));
      });
    }
    _links = json['links'] != null ? Links.fromJson(json['links']) : null;
    _meta = json['meta'] != null ? Meta.fromJson(json['meta']) : null;
  }
  List<StudentBookedServiceModel>? _data;
  Links? _links;
  Meta? _meta;
  GetStudentBookedServicesDataModel copyWith({
    List<StudentBookedServiceModel>? data,
    Links? links,
    Meta? meta,
  }) =>
      GetStudentBookedServicesDataModel(
        data: data ?? _data,
        links: links ?? _links,
        meta: meta ?? _meta,
      );
  List<StudentBookedServiceModel>? get data => _data;
  Links? get links => _links;
  Meta? get meta => _meta;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    if (_links != null) {
      map['links'] = _links?.toJson();
    }
    if (_meta != null) {
      map['meta'] = _meta?.toJson();
    }
    return map;
  }
}

Meta metaFromJson(String str) => Meta.fromJson(json.decode(str));
String metaToJson(Meta data) => json.encode(data.toJson());

class Meta {
  Meta({
    num? currentPage,
    num? from,
    num? lastPage,
    List<Links>? links,
    String? path,
    num? perPage,
    num? to,
    num? total,
  }) {
    _currentPage = currentPage;
    _from = from;
    _lastPage = lastPage;
    _links = links;
    _path = path;
    _perPage = perPage;
    _to = to;
    _total = total;
  }

  Meta.fromJson(dynamic json) {
    _currentPage = json['current_page'];
    _from = json['from'];
    _lastPage = json['last_page'];
    if (json['links'] != null) {
      _links = [];
      json['links'].forEach((v) {
        _links?.add(Links.fromJson(v));
      });
    }
    _path = json['path'];
    _perPage = json['per_page'];
    _to = json['to'];
    _total = json['total'];
  }
  num? _currentPage;
  num? _from;
  num? _lastPage;
  List<Links>? _links;
  String? _path;
  num? _perPage;
  num? _to;
  num? _total;
  Meta copyWith({
    num? currentPage,
    num? from,
    num? lastPage,
    List<Links>? links,
    String? path,
    num? perPage,
    num? to,
    num? total,
  }) =>
      Meta(
        currentPage: currentPage ?? _currentPage,
        from: from ?? _from,
        lastPage: lastPage ?? _lastPage,
        links: links ?? _links,
        path: path ?? _path,
        perPage: perPage ?? _perPage,
        to: to ?? _to,
        total: total ?? _total,
      );
  num? get currentPage => _currentPage;
  num? get from => _from;
  num? get lastPage => _lastPage;
  List<Links>? get links => _links;
  String? get path => _path;
  num? get perPage => _perPage;
  num? get to => _to;
  num? get total => _total;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['current_page'] = _currentPage;
    map['from'] = _from;
    map['last_page'] = _lastPage;
    if (_links != null) {
      map['links'] = _links?.map((v) => v.toJson()).toList();
    }
    map['path'] = _path;
    map['per_page'] = _perPage;
    map['to'] = _to;
    map['total'] = _total;
    return map;
  }
}

Links linksFromJson(String str) => Links.fromJson(json.decode(str));
String linksToJson(Links data) => json.encode(data.toJson());

class Links {
  Links({
    dynamic url,
    String? label,
    bool? active,
  }) {
    _url = url;
    _label = label;
    _active = active;
  }

  Links.fromJson(dynamic json) {
    _url = json['url'];
    _label = json['label'];
    _active = json['active'];
  }
  dynamic _url;
  String? _label;
  bool? _active;
  Links copyWith({
    dynamic url,
    String? label,
    bool? active,
  }) =>
      Links(
        url: url ?? _url,
        label: label ?? _label,
        active: active ?? _active,
      );
  dynamic get url => _url;
  String? get label => _label;
  bool? get active => _active;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['url'] = _url;
    map['label'] = _label;
    map['active'] = _active;
    return map;
  }
}

StudentBookedServiceModel dataFromJson(String str) =>
    StudentBookedServiceModel.fromJson(json.decode(str));
String dataToJson(StudentBookedServiceModel data) => json.encode(data.toJson());

class StudentBookedServiceModel {
  StudentBookedServiceModel({
    num? id,
    num? studentId,
    String? studentName,
    String? studentImage,
    num? teacherId,
    dynamic teacherName,
    dynamic teacherImage,
    dynamic academyId,
    dynamic academyName,
    dynamic academyImage,
    num? serviceId,
    String? serviceName,
    String? serviceImage,
    String? serviceStatusName,
    String? date,
    dynamic startedAt,
    dynamic endedAt,
    num? price,
    num? isPaid,
    String? question,
    dynamic attachmentUrl,
    num? serviceStatusCode,
    List<Messages>? messages,
    List<dynamic>? reviews,
    String? createdAt,
    String? updatedAt,
  }) {
    _id = id;
    _studentId = studentId;
    _studentName = studentName;
    _studentImage = studentImage;
    _teacherId = teacherId;
    _teacherName = teacherName;
    _teacherImage = teacherImage;
    _academyId = academyId;
    _academyName = academyName;
    _academyImage = academyImage;
    _serviceId = serviceId;
    _serviceName = serviceName;
    _serviceImage = serviceImage;
    _serviceStatusName = serviceStatusName;
    _date = date;
    _startedAt = startedAt;
    _endedAt = endedAt;
    _price = price;
    _isPaid = isPaid;
    _question = question;
    _attachmentUrl = attachmentUrl;
    _serviceStatusCode = serviceStatusCode;
    _messages = messages;
    _reviews = reviews;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
  }

  StudentBookedServiceModel.fromJson(dynamic json) {
    _id = json['id'];
    _studentId = json['student_id'];
    _studentName = json['student_name'];
    _studentImage = json['student_image'];
    _teacherId = json['teacher_id'];
    _teacherName = json['teacher_name'];
    _teacherImage = json['teacher_image'];
    _academyId = json['law_firm_id'];
    _academyName = json['law_firm_name'];
    _academyImage = json['law_firm_image'];
    _serviceId = json['service_id'];
    _serviceName = json['service_name'];
    _serviceImage = json['service_image'];
    _serviceStatusName = json['service_status_name'];
    _date = json['date'];
    _startedAt = json['started_at'];
    _endedAt = json['ended_at'];
    _price = json['price'];
    _isPaid = json['is_paid'];
    _question = json['question'];
    _attachmentUrl = json['attachment_url'];
    _serviceStatusCode = json['service_status_code'];
    if (json['messages'] != null) {
      _messages = [];
      json['messages'].forEach((v) {
        _messages?.add(Messages.fromJson(v));
      });
    }
    if (json['reviews'] != null) {
      _reviews = [];
      json['reviews'].forEach((v) {
        // _reviews?.add(Dynamic.fromJson(v));
      });
    }
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }
  num? _id;
  num? _studentId;
  String? _studentName;
  String? _studentImage;
  num? _teacherId;
  dynamic _teacherName;
  dynamic _teacherImage;
  dynamic _academyId;
  dynamic _academyName;
  dynamic _academyImage;
  num? _serviceId;
  String? _serviceName;
  String? _serviceImage;
  String? _serviceStatusName;
  String? _date;
  dynamic _startedAt;
  dynamic _endedAt;
  num? _price;
  num? _isPaid;
  String? _question;
  dynamic _attachmentUrl;
  num? _serviceStatusCode;
  List<Messages>? _messages;
  List<dynamic>? _reviews;
  String? _createdAt;
  String? _updatedAt;
  StudentBookedServiceModel copyWith({
    num? id,
    num? studentId,
    String? studentName,
    String? studentImage,
    num? teacherId,
    dynamic teacherName,
    dynamic teacherImage,
    dynamic academyId,
    dynamic academyName,
    dynamic academyImage,
    num? serviceId,
    String? serviceName,
    String? serviceImage,
    String? serviceStatusName,
    String? date,
    dynamic startedAt,
    dynamic endedAt,
    num? price,
    num? isPaid,
    String? question,
    dynamic attachmentUrl,
    num? serviceStatusCode,
    List<Messages>? messages,
    List<dynamic>? reviews,
    String? createdAt,
    String? updatedAt,
  }) =>
      StudentBookedServiceModel(
        id: id ?? _id,
        studentId: studentId ?? _studentId,
        studentName: studentName ?? _studentName,
        studentImage: studentImage ?? _studentImage,
        teacherId: teacherId ?? _teacherId,
        teacherName: teacherName ?? _teacherName,
        teacherImage: teacherImage ?? _teacherImage,
        academyId: academyId ?? _academyId,
        academyName: academyName ?? _academyName,
        academyImage: academyImage ?? _academyImage,
        serviceId: serviceId ?? _serviceId,
        serviceName: serviceName ?? _serviceName,
        serviceImage: serviceImage ?? _serviceImage,
        serviceStatusName: serviceStatusName ?? _serviceStatusName,
        date: date ?? _date,
        startedAt: startedAt ?? _startedAt,
        endedAt: endedAt ?? _endedAt,
        price: price ?? _price,
        isPaid: isPaid ?? _isPaid,
        question: question ?? _question,
        attachmentUrl: attachmentUrl ?? _attachmentUrl,
        serviceStatusCode: serviceStatusCode ?? _serviceStatusCode,
        messages: messages ?? _messages,
        reviews: reviews ?? _reviews,
        createdAt: createdAt ?? _createdAt,
        updatedAt: updatedAt ?? _updatedAt,
      );
  num? get id => _id;
  num? get studentId => _studentId;
  String? get studentName => _studentName;
  String? get studentImage => _studentImage;
  num? get teacherId => _teacherId;
  dynamic get teacherName => _teacherName;
  dynamic get teacherImage => _teacherImage;
  dynamic get academyId => _academyId;
  dynamic get academyName => _academyName;
  dynamic get academyImage => _academyImage;
  num? get serviceId => _serviceId;
  String? get serviceName => _serviceName;
  String? get serviceImage => _serviceImage;
  String? get serviceStatusName => _serviceStatusName;
  String? get date => _date;
  dynamic get startedAt => _startedAt;
  dynamic get endedAt => _endedAt;
  num? get price => _price;
  num? get isPaid => _isPaid;
  String? get question => _question;
  dynamic get attachmentUrl => _attachmentUrl;
  num? get serviceStatusCode => _serviceStatusCode;
  List<Messages>? get messages => _messages;
  List<dynamic>? get reviews => _reviews;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['student_id'] = _studentId;
    map['student_name'] = _studentName;
    map['student_image'] = _studentImage;
    map['teacher_id'] = _teacherId;
    map['teacher_name'] = _teacherName;
    map['teacher_image'] = _teacherImage;
    map['law_firm_id'] = _academyId;
    map['law_firm_name'] = _academyName;
    map['law_firm_image'] = _academyImage;
    map['service_id'] = _serviceId;
    map['service_name'] = _serviceName;
    map['service_image'] = _serviceImage;
    map['service_status_name'] = _serviceStatusName;
    map['date'] = _date;
    map['started_at'] = _startedAt;
    map['ended_at'] = _endedAt;
    map['price'] = _price;
    map['is_paid'] = _isPaid;
    map['question'] = _question;
    map['attachment_url'] = _attachmentUrl;
    map['service_status_code'] = _serviceStatusCode;
    if (_messages != null) {
      map['messages'] = _messages?.map((v) => v.toJson()).toList();
    }
    if (_reviews != null) {
      map['reviews'] = _reviews?.map((v) => v.toJson()).toList();
    }
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    return map;
  }
}

Messages messagesFromJson(String str) => Messages.fromJson(json.decode(str));
String messagesToJson(Messages data) => json.encode(data.toJson());

class Messages {
  Messages({
    num? id,
    String? message,
    num? appointmentId,
    dynamic bookedServiceId,
    num? senderId,
    String? senderType,
    String? recieverId,
    String? recieverType,
    dynamic attachmentUrl,
    bool? isAttachment,
    bool? isSeen,
    dynamic seenAt,
    bool? isDelivered,
    dynamic deliveredAt,
    String? createdAt,
    String? updatedAt,
  }) {
    _id = id;
    _message = message;
    _appointmentId = appointmentId;
    _bookedServiceId = bookedServiceId;
    _senderId = senderId;
    _senderType = senderType;
    _recieverId = recieverId;
    _recieverType = recieverType;
    _attachmentUrl = attachmentUrl;
    _isAttachment = isAttachment;
    _isSeen = isSeen;
    _seenAt = seenAt;
    _isDelivered = isDelivered;
    _deliveredAt = deliveredAt;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
  }

  Messages.fromJson(dynamic json) {
    _id = json['id'];
    _message = json['message'];
    _appointmentId = json['appointment_id'];
    _bookedServiceId = json['booked_service_id'];
    _senderId = json['sender_id'];
    _senderType = json['sender_type'];
    _recieverId = json['reciever_id'];
    _recieverType = json['reciever_type'];
    _attachmentUrl = json['attachment_url'];
    _isAttachment = json['is_attachment'];
    _isSeen = json['is_seen'];
    _seenAt = json['seen_at'];
    _isDelivered = json['is_delivered'];
    _deliveredAt = json['delivered_at'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }
  num? _id;
  String? _message;
  num? _appointmentId;
  dynamic _bookedServiceId;
  num? _senderId;
  String? _senderType;
  String? _recieverId;
  String? _recieverType;
  dynamic _attachmentUrl;
  bool? _isAttachment;
  bool? _isSeen;
  dynamic _seenAt;
  bool? _isDelivered;
  dynamic _deliveredAt;
  String? _createdAt;
  String? _updatedAt;
  Messages copyWith({
    num? id,
    String? message,
    num? appointmentId,
    dynamic bookedServiceId,
    num? senderId,
    String? senderType,
    String? recieverId,
    String? recieverType,
    dynamic attachmentUrl,
    bool? isAttachment,
    bool? isSeen,
    dynamic seenAt,
    bool? isDelivered,
    dynamic deliveredAt,
    String? createdAt,
    String? updatedAt,
  }) =>
      Messages(
        id: id ?? _id,
        message: message ?? _message,
        appointmentId: appointmentId ?? _appointmentId,
        bookedServiceId: bookedServiceId ?? _bookedServiceId,
        senderId: senderId ?? _senderId,
        senderType: senderType ?? _senderType,
        recieverId: recieverId ?? _recieverId,
        recieverType: recieverType ?? _recieverType,
        attachmentUrl: attachmentUrl ?? _attachmentUrl,
        isAttachment: isAttachment ?? _isAttachment,
        isSeen: isSeen ?? _isSeen,
        seenAt: seenAt ?? _seenAt,
        isDelivered: isDelivered ?? _isDelivered,
        deliveredAt: deliveredAt ?? _deliveredAt,
        createdAt: createdAt ?? _createdAt,
        updatedAt: updatedAt ?? _updatedAt,
      );
  num? get id => _id;
  String? get message => _message;
  num? get appointmentId => _appointmentId;
  dynamic get bookedServiceId => _bookedServiceId;
  num? get senderId => _senderId;
  String? get senderType => _senderType;
  String? get recieverId => _recieverId;
  String? get recieverType => _recieverType;
  dynamic get attachmentUrl => _attachmentUrl;
  bool? get isAttachment => _isAttachment;
  bool? get isSeen => _isSeen;
  dynamic get seenAt => _seenAt;
  bool? get isDelivered => _isDelivered;
  dynamic get deliveredAt => _deliveredAt;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['message'] = _message;
    map['appointment_id'] = _appointmentId;
    map['booked_service_id'] = _bookedServiceId;
    map['sender_id'] = _senderId;
    map['sender_type'] = _senderType;
    map['reciever_id'] = _recieverId;
    map['reciever_type'] = _recieverType;
    map['attachment_url'] = _attachmentUrl;
    map['is_attachment'] = _isAttachment;
    map['is_seen'] = _isSeen;
    map['seen_at'] = _seenAt;
    map['is_delivered'] = _isDelivered;
    map['delivered_at'] = _deliveredAt;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    return map;
  }
}
