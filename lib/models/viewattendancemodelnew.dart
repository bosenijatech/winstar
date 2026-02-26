class ViewAttendanceModelNew {
  bool? status;
  List<Message>? message;

  ViewAttendanceModelNew({this.status, this.message});

  ViewAttendanceModelNew.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['message'] != null) {
      message = <Message>[];
      json['message'].forEach((v) {
        message!.add(Message.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (message != null) {
      data['message'] = message!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Message {
  String? sId;
  String? purpose;
  List<Log>? log;

  Message({this.sId, this.purpose, this.log});

  Message.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    purpose = json['purpose'];
    if (json['log'] != null) {
      log = <Log>[];
      json['log'].forEach((v) {
        log!.add(Log.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['purpose'] = purpose;
    if (log != null) {
      data['log'] = log!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Log {
  String? detailuniqid;
  String? checkintime;
  String? checkouttime;
  String? checkin;
  String? checkout;

  Log(
      {this.detailuniqid,
      this.checkintime,
      this.checkouttime,
      this.checkin,
      this.checkout});

  Log.fromJson(Map<String, dynamic> json) {
    detailuniqid = json['detailuniqid'];
    checkintime = json['checkintime'];
    checkouttime = json['checkouttime'];
    checkin = json['checkin'];
    checkout = json['checkout'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['detailuniqid'] = detailuniqid;
    data['checkintime'] = checkintime;
    data['checkouttime'] = checkouttime;
    data['checkin'] = checkin;
    data['checkout'] = checkout;
    return data;
  }
}
