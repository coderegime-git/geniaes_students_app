import 'dart:convert';

StudentBookAppointment studentBookAppointmentFromJson(String str) =>
    StudentBookAppointment.fromJson(json.decode(str));
String studentBookAppointmentToJson(StudentBookAppointment data) =>
    json.encode(data.toJson());

class StudentBookAppointment {
  StudentBookAppointment({
    Data? data,
    bool? success,
    String? message,
    dynamic errors,
  }) {
    _data = data;
    _success = success;
    _message = message;
    _errors = errors;
  }

  StudentBookAppointment.fromJson(dynamic json) {
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
    _success = json['success'];
    _message = json['message'];
    _errors = json['errors'];
  }
  Data? _data;
  bool? _success;
  String? _message;
  dynamic _errors;
  StudentBookAppointment copyWith({
    Data? data,
    bool? success,
    String? message,
    dynamic errors,
  }) =>
      StudentBookAppointment(
        data: data ?? _data,
        success: success ?? _success,
        message: message ?? _message,
        errors: errors ?? _errors,
      );
  Data? get data => _data;
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

Data dataFromJson(String str) => Data.fromJson(json.decode(str));
String dataToJson(Data data) => json.encode(data.toJson());

class Data {
  Data({
    num? id,
    num? studentId,
    dynamic studentName,
    dynamic appointmentStatusName,
    dynamic appointmentTypeName,
    num? isScheduleRequired,
    String? teacherId,
    dynamic teacherName,
    dynamic academyId,
    dynamic academyName,
    String? date,
    String? startTime,
    String? endTime,
    num? fee,
    num? isPaid,
    String? appointmentTypeId,
    String? question,
    dynamic attachmentUrl,
    num? appointmentStatusCode,
    List? messages,
    String? createdAt,
    String? updatedAt,
  }) {
    _id = id;
    _studentId = studentId;
    _studentName = studentName;
    _appointmentStatusName = appointmentStatusName;
    _appointmentTypeName = appointmentTypeName;
    _isScheduleRequired = isScheduleRequired;
    _teacherId = teacherId;
    _teacherName = teacherName;
    _academyId = academyId;
    _academyName = academyName;
    _date = date;
    _startTime = startTime;
    _endTime = endTime;
    _fee = fee;
    _isPaid = isPaid;
    _appointmentTypeId = appointmentTypeId;
    _question = question;
    _attachmentUrl = attachmentUrl;
    _appointmentStatusCode = appointmentStatusCode;
    _messages = messages;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
  }

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _studentId = json['student_id'];
    _studentName = json['student_name'];
    _appointmentStatusName = json['appointment_status_name'];
    _appointmentTypeName = json['appointment_type_name'];
    _isScheduleRequired = json['is_schedule_required'];
    _teacherId = json['teacher_id'];
    _teacherName = json['teacher_name'];
    _academyId = json['academy_id'];
    _academyName = json['academy_name'];
    _date = json['date'];
    _startTime = json['start_time'];
    _endTime = json['end_time'];
    _fee = json['fee'];
    _isPaid = json['is_paid'];
    _appointmentTypeId = json['appointment_type_id'];
    _question = json['question'];
    _attachmentUrl = json['attachment_url'];
    _appointmentStatusCode = json['appointment_status_code'];
    if (json['messages'] != null) {
      _messages = [];
      // json['messages'].forEach((v) {
      //   _messages?.add(Dynamic.fromJson(v));
      // });
    }
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }
  num? _id;
  num? _studentId;
  dynamic _studentName;
  dynamic _appointmentStatusName;
  dynamic _appointmentTypeName;
  num? _isScheduleRequired;
  String? _teacherId;
  dynamic _teacherName;
  dynamic _academyId;
  dynamic _academyName;
  String? _date;
  String? _startTime;
  String? _endTime;
  num? _fee;
  num? _isPaid;
  String? _appointmentTypeId;
  String? _question;
  dynamic _attachmentUrl;
  num? _appointmentStatusCode;
  List<dynamic>? _messages;
  String? _createdAt;
  String? _updatedAt;
  Data copyWith({
    num? id,
    num? studentId,
    dynamic studentName,
    dynamic appointmentStatusName,
    dynamic appointmentTypeName,
    num? isScheduleRequired,
    String? teacherId,
    dynamic teacherName,
    dynamic academyId,
    dynamic academyName,
    String? date,
    String? startTime,
    String? endTime,
    num? fee,
    num? isPaid,
    String? appointmentTypeId,
    String? question,
    dynamic attachmentUrl,
    num? appointmentStatusCode,
    List<dynamic>? messages,
    String? createdAt,
    String? updatedAt,
  }) =>
      Data(
        id: id ?? _id,
        studentId: studentId ?? _studentId,
        studentName: studentName ?? _studentName,
        appointmentStatusName: appointmentStatusName ?? _appointmentStatusName,
        appointmentTypeName: appointmentTypeName ?? _appointmentTypeName,
        isScheduleRequired: isScheduleRequired ?? _isScheduleRequired,
        teacherId: teacherId ?? _teacherId,
        teacherName: teacherName ?? _teacherName,
        academyId: academyId ?? _academyId,
        academyName: academyName ?? _academyName,
        date: date ?? _date,
        startTime: startTime ?? _startTime,
        endTime: endTime ?? _endTime,
        fee: fee ?? _fee,
        isPaid: isPaid ?? _isPaid,
        appointmentTypeId: appointmentTypeId ?? _appointmentTypeId,
        question: question ?? _question,
        attachmentUrl: attachmentUrl ?? _attachmentUrl,
        appointmentStatusCode: appointmentStatusCode ?? _appointmentStatusCode,
        messages: messages ?? _messages,
        createdAt: createdAt ?? _createdAt,
        updatedAt: updatedAt ?? _updatedAt,
      );
  num? get id => _id;
  num? get studentId => _studentId;
  dynamic get studentName => _studentName;
  dynamic get appointmentStatusName => _appointmentStatusName;
  dynamic get appointmentTypeName => _appointmentTypeName;
  num? get isScheduleRequired => _isScheduleRequired;
  String? get teacherId => _teacherId;
  dynamic get teacherName => _teacherName;
  dynamic get academyId => _academyId;
  dynamic get academyName => _academyName;
  String? get date => _date;
  String? get startTime => _startTime;
  String? get endTime => _endTime;
  num? get fee => _fee;
  num? get isPaid => _isPaid;
  String? get appointmentTypeId => _appointmentTypeId;
  String? get question => _question;
  dynamic get attachmentUrl => _attachmentUrl;
  num? get appointmentStatusCode => _appointmentStatusCode;
  List<dynamic>? get messages => _messages;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['student_id'] = _studentId;
    map['student_name'] = _studentName;
    map['appointment_status_name'] = _appointmentStatusName;
    map['appointment_type_name'] = _appointmentTypeName;
    map['is_schedule_required'] = _isScheduleRequired;
    map['teacher_id'] = _teacherId;
    map['teacher_name'] = _teacherName;
    map['academy_id'] = _academyId;
    map['academy_name'] = _academyName;
    map['date'] = _date;
    map['start_time'] = _startTime;
    map['end_time'] = _endTime;
    map['fee'] = _fee;
    map['is_paid'] = _isPaid;
    map['appointment_type_id'] = _appointmentTypeId;
    map['question'] = _question;
    map['attachment_url'] = _attachmentUrl;
    map['appointment_status_code'] = _appointmentStatusCode;
    if (_messages != null) {
      map['messages'] = _messages?.map((v) => v.toJson()).toList();
    }
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    return map;
  }
}
