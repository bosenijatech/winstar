class AttendanceCheckModel {
  bool? status;
  List<Message>? message;

  AttendanceCheckModel({this.status, this.message});

  AttendanceCheckModel.fromJson(Map<String, dynamic> json) {
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
  String? requestapplicationno;
  String? docdate;
  String? fromtime;
  int? nsId;
  String? empCode;
  String? empName;
  String? fromtype;
  String? description;
  String? fromlatitude;
  String? fromlongitude;
  String? fromlocaddress;
  int? createdby;
  int? isSync;
  List<ApprovalHistory>? approvalHistory;
  String? createdAt;
  String? updatedAt;
  String? tolatitude;
  String? tolocaddress;
  String? tolongitude;
  String? totime;
  String? totype;

  Message(
      {this.sId,
      this.requestapplicationno,
      this.docdate,
      this.fromtime,
      this.nsId,
      this.empCode,
      this.empName,
      this.fromtype,
      this.description,
      this.fromlatitude,
      this.fromlongitude,
      this.fromlocaddress,
      this.createdby,
      this.isSync,
      this.approvalHistory,
      this.createdAt,
      this.updatedAt,
      this.tolatitude,
      this.tolocaddress,
      this.tolongitude,
      this.totime,
      this.totype});

  Message.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    requestapplicationno = json['requestapplicationno'];
    docdate = json['docdate'];
    fromtime = json['fromtime'];
    nsId = json['nsId'];
    empCode = json['empCode'];
    empName = json['empName'];
    fromtype = json['fromtype'];
    description = json['description'];
    fromlatitude = json['fromlatitude'];
    fromlongitude = json['fromlongitude'];
    fromlocaddress = json['fromlocaddress'];
    createdby = json['createdby'];
    isSync = json['isSync'];
    if (json['approval_history'] != null) {
      approvalHistory = <ApprovalHistory>[];
      json['approval_history'].forEach((v) {
        approvalHistory!.add(ApprovalHistory.fromJson(v));
      });
    }
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    tolatitude = json['tolatitude'];
    tolocaddress = json['tolocaddress'];
    tolongitude = json['tolongitude'];
    totime = json['totime'];
    totype = json['totype'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['requestapplicationno'] = requestapplicationno;
    data['docdate'] = docdate;
    data['fromtime'] = fromtime;
    data['nsId'] = nsId;
    data['empCode'] = empCode;
    data['empName'] = empName;
    data['fromtype'] = fromtype;
    data['description'] = description;
    data['fromlatitude'] = fromlatitude;
    data['fromlongitude'] = fromlongitude;
    data['fromlocaddress'] = fromlocaddress;
    data['createdby'] = createdby;
    data['isSync'] = isSync;
    if (approvalHistory != null) {
      data['approval_history'] =
          approvalHistory!.map((v) => v.toJson()).toList();
    }
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['tolatitude'] = tolatitude;
    data['tolocaddress'] = tolocaddress;
    data['tolongitude'] = tolongitude;
    data['totime'] = totime;
    data['totype'] = totype;
    return data;
  }
}

class ApprovalHistory {
  String? approverid;
  String? approvername;
  String? department;
  String? status;
  String? remarks;
  String? approveddate;

  ApprovalHistory(
      {this.approverid,
      this.approvername,
      this.department,
      this.status,
      this.remarks,
      this.approveddate});

  ApprovalHistory.fromJson(Map<String, dynamic> json) {
    approverid = json['approverid'];
    approvername = json['approvername'];
    department = json['department'];
    status = json['status'];
    remarks = json['remarks'];
    approveddate = json['approveddate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['approverid'] = approverid;
    data['approvername'] = approvername;
    data['department'] = department;
    data['status'] = status;
    data['remarks'] = remarks;
    data['approveddate'] = approveddate;
    return data;
  }
}
