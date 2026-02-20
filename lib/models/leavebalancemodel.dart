class LeaveBalanceModel {
  int? currentPage;
  int? pageSize;
  int? totalRecords;
  int? totalRecordsInCurrentPage;
  List<Employees>? employees;

  LeaveBalanceModel(
      {this.currentPage,
      this.pageSize,
      this.totalRecords,
      this.totalRecordsInCurrentPage,
      this.employees});

  LeaveBalanceModel.fromJson(Map<String, dynamic> json) {
    currentPage = json['currentPage'];
    pageSize = json['pageSize'];
    totalRecords = json['totalRecords'];
    totalRecordsInCurrentPage = json['totalRecordsInCurrentPage'];
    if (json['employees'] != null) {
      employees = <Employees>[];
      json['employees'].forEach((v) {
        employees!.add(Employees.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['currentPage'] = currentPage;
    data['pageSize'] = pageSize;
    data['totalRecords'] = totalRecords;
    data['totalRecordsInCurrentPage'] = totalRecordsInCurrentPage;
    if (employees != null) {
      data['employees'] = employees!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Employees {
  String? id;
  String? empId;
  String? employeeCode;
  String? firstName;
  String? lastName;
  String? leaveId;
  String? leaveName;
  bool? isAirTicketApplicable;
  String? leaveBalanceTaken;
  String? availableLeaveBalance;
  String? encashableDays;
  String? encashableDaysTaken;
  bool? inactive;

  Employees(
      {this.id,
      this.empId,
      this.employeeCode,
      this.firstName,
      this.lastName,
      this.leaveId,
      this.leaveName,
      this.isAirTicketApplicable,
      this.leaveBalanceTaken,
      this.availableLeaveBalance,
      this.encashableDays,
      this.encashableDaysTaken,
      this.inactive});

  Employees.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    empId = json['empId'];
    employeeCode = json['employeeCode'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    leaveId = json['leaveId'];
    leaveName = json['leaveName'];
    isAirTicketApplicable = json['isAirTicketApplicable'];
    leaveBalanceTaken = json['leaveBalanceTaken'];
    availableLeaveBalance = json['availableLeaveBalance'];
    encashableDays = json['encashableDays'];
    encashableDaysTaken = json['encashableDaysTaken'];
    inactive = json['inactive'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['empId'] = empId;
    data['employeeCode'] = employeeCode;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['leaveId'] = leaveId;
    data['leaveName'] = leaveName;
    data['isAirTicketApplicable'] = isAirTicketApplicable;
    data['leaveBalanceTaken'] = leaveBalanceTaken;
    data['availableLeaveBalance'] = availableLeaveBalance;
    data['encashableDays'] = encashableDays;
    data['encashableDaysTaken'] = encashableDaysTaken;
    data['inactive'] = inactive;
    return data;
  }
}
