class NetSuiteLeaveTypeModel {
  String? status;
  String? responseCode;
  int? totalRecords;
  List<Records>? records;

  NetSuiteLeaveTypeModel(
      {this.status, this.responseCode, this.totalRecords, this.records});

  NetSuiteLeaveTypeModel.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    responseCode = json['ResponseCode'];
    totalRecords = json['totalRecords'];
    if (json['records'] != null) {
      records = <Records>[];
      json['records'].forEach((v) {
        records!.add(Records.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Status'] = status;
    data['ResponseCode'] = responseCode;
    data['totalRecords'] = totalRecords;
    if (records != null) {
      data['records'] = records!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Records {
  String? internalId;
  String? empId;
  String? employeeName;
  String? leaveTypeId;
  String? leaveType;
  String? yearlyLeaveBalance;
  String? leaveBalanceCredited;
  String? leaveBalanceTaken;
  String? totalAppliedDays;
  String? availableLeaveBalance;
  String? encashableDays;
  String? employeeLocation;
  String? employeeGender;
  String? leaveBalanceCarryForward;
  String? leaveBalanceLaps;
  String? employeeCode;
  String? weeklyOffCriteria;
  String? employeeWorkRegion;
  String? encashableDaysTaken;
  String? additionalEncashableDays;
  String? nationality;
  String? availableLeaveBalanceOld;
  String? oldInternalId;
  String? obDate;
  String? openingBalance;
  String? hrDepartment;

  Records(
      {this.internalId,
      this.empId,
      this.employeeName,
      this.leaveTypeId,
      this.leaveType,
      this.yearlyLeaveBalance,
      this.leaveBalanceCredited,
      this.leaveBalanceTaken,
      this.totalAppliedDays,
      this.availableLeaveBalance,
      this.encashableDays,
      this.employeeLocation,
      this.employeeGender,
      this.leaveBalanceCarryForward,
      this.leaveBalanceLaps,
      this.employeeCode,
      this.weeklyOffCriteria,
      this.employeeWorkRegion,
      this.encashableDaysTaken,
      this.additionalEncashableDays,
      this.nationality,
      this.availableLeaveBalanceOld,
      this.oldInternalId,
      this.obDate,
      this.openingBalance,
      this.hrDepartment});

  Records.fromJson(Map<String, dynamic> json) {
    internalId = json['internalId'];
    empId = json['empId'];
    employeeName = json['employeeName'];
    leaveTypeId = json['leaveTypeId'];
    leaveType = json['leaveType'];
    yearlyLeaveBalance = json['yearlyLeaveBalance'];
    leaveBalanceCredited = json['leaveBalanceCredited'];
    leaveBalanceTaken = json['leaveBalanceTaken'];
    totalAppliedDays = json['totalAppliedDays'];
    availableLeaveBalance = json['availableLeaveBalance'];
    encashableDays = json['encashableDays'];
    employeeLocation = json['employeeLocation'];
    employeeGender = json['employeeGender'];
    leaveBalanceCarryForward = json['leaveBalanceCarryForward'];
    leaveBalanceLaps = json['leaveBalanceLaps'];
    employeeCode = json['employeeCode'];
    weeklyOffCriteria = json['weeklyOffCriteria'];
    employeeWorkRegion = json['employeeWorkRegion'];
    encashableDaysTaken = json['encashableDaysTaken'];
    additionalEncashableDays = json['additionalEncashableDays'];
    nationality = json['nationality'];
    availableLeaveBalanceOld = json['availableLeaveBalanceOld'];
    oldInternalId = json['oldInternalId'];
    obDate = json['obDate'];
    openingBalance = json['openingBalance'];
    hrDepartment = json['hrDepartment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['internalId'] = internalId;
    data['empId'] = empId;
    data['employeeName'] = employeeName;
    data['leaveType'] = leaveType;
    data['leaveTypeId'] = leaveTypeId;
    data['yearlyLeaveBalance'] = yearlyLeaveBalance;
    data['leaveBalanceCredited'] = leaveBalanceCredited;
    data['leaveBalanceTaken'] = leaveBalanceTaken;
    data['totalAppliedDays'] = totalAppliedDays;
    data['availableLeaveBalance'] = availableLeaveBalance;
    data['encashableDays'] = encashableDays;
    data['employeeLocation'] = employeeLocation;
    data['employeeGender'] = employeeGender;
    data['leaveBalanceCarryForward'] = leaveBalanceCarryForward;
    data['leaveBalanceLaps'] = leaveBalanceLaps;
    data['employeeCode'] = employeeCode;
    data['weeklyOffCriteria'] = weeklyOffCriteria;
    data['employeeWorkRegion'] = employeeWorkRegion;
    data['encashableDaysTaken'] = encashableDaysTaken;
    data['additionalEncashableDays'] = additionalEncashableDays;
    data['nationality'] = nationality;
    data['availableLeaveBalanceOld'] = availableLeaveBalanceOld;
    data['oldInternalId'] = oldInternalId;
    data['obDate'] = obDate;
    data['openingBalance'] = openingBalance;
    data['hrDepartment'] = hrDepartment;
    return data;
  }
}
