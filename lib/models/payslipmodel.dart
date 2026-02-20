class PaySlipModel {
  bool? status;
  Message? message;

  PaySlipModel({this.status, this.message});

  PaySlipModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message =
        json['message'] != null ? Message.fromJson(json['message']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (message != null) {
      data['message'] = message!.toJson();
    }
    return data;
  }
}

class Message {
  String? sId;
  String? internalid;
  String? requestedate;
  String? monthname;
  String? payslipurl;
  String? payslipname;
  String? createdby;
  String? createdbyname;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Message(
      {this.sId,
      this.internalid,
      this.requestedate,
      this.monthname,
      this.payslipurl,
      this.payslipname,
      this.createdby,
      this.createdbyname,
      this.createdAt,
      this.updatedAt,
      this.iV});

  Message.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    internalid = json['internalid'];
    requestedate = json['requestedate'];
    monthname = json['monthname'];
    payslipurl = json['payslipurl'];
    payslipname = json['payslipname'];
    createdby = json['createdby'];
    createdbyname = json['createdbyname'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['internalid'] = internalid;
    data['requestedate'] = requestedate;
    data['monthname'] = monthname;
    data['payslipurl'] = payslipurl;
    data['payslipname'] = payslipname;
    data['createdby'] = createdby;
    data['createdbyname'] = createdbyname;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}
