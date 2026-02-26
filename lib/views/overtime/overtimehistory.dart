import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bindhaeness/models/bioattendancemodel.dart';
import 'package:bindhaeness/models/dailyhistorymodel.dart';
import 'package:bindhaeness/services/apiservice.dart';
import 'package:bindhaeness/utils/app_utils.dart';
import 'package:bindhaeness/utils/constants.dart';
import 'package:bindhaeness/utils/custom_indicatoronly.dart';
import 'package:bindhaeness/views/googlemapslocation/googlemaps.dart';
import 'package:bindhaeness/views/overtime/overtimeentrypage.dart';
import 'package:bindhaeness/views/widgets/assets_image_widget.dart';
import 'package:bindhaeness/views/widgets/custom_button.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart';

class Overtimehistory extends StatefulWidget {
  const Overtimehistory({super.key});

  @override
  State<Overtimehistory> createState() => _AttendancehistoryState();
}

class _AttendancehistoryState extends State<Overtimehistory> {
  //AttendanceCheckModel checkModel = AttendanceCheckModel();
  BioAttendanceModel checkModel = BioAttendanceModel();
  DailyHistoryModel model = DailyHistoryModel();

  bool loading = false;
  @override
  void initState() {
    getattendancecheckdata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,

          leading: IconButton(
            icon: const Icon(CupertinoIcons.back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),

          title: AppUtils.buildNormalText(
              text: "Overtime History", color: Colors.black, fontSize: 16),
          //centerTitle: true,
        ),
        body: !loading
            ? SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    clockrunningpage(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AppUtils.buildNormalText(text: "Show Time Logs"),
                    ),
                    const SizedBox(
                      height: 5,
                    ),

                    showfrmtimeandlocation(),
                    //showtotimeandlocation()
                  ],
                ),
              )
            : const Center(child: CustomIndicator()));
  }

  Widget clockrunningpage() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color(0xFF3B72FF).withOpacity(0.1)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 5,
          ),
          AppUtils.buildNormalText(
              text: DateFormat.MMMEd().format(DateTime.now()), fontSize: 14),
          const SizedBox(
            height: 10,
          ),
          AppUtils.buildNormalText(
              //text: Prefs.getShiftName(SharefprefConstants.sharedshiftName),
              text: "Over Time - 5.30 PM to 8.00 AM ",
              fontSize: 12),
          const SizedBox(
            height: 10,
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  AppUtils.buildNormalText(text: "OVERTIME IN"),
                  const SizedBox(height: 5),
                  AppUtils.buildNormalText(
                      text: (checkModel.status == true &&
                              checkModel.message!.first.punchInTime
                                  .toString()
                                  .isNotEmpty)
                          ? AppConstants.changeddmmyyhhmmssformat(
                              checkModel.message!.first.punchInTime.toString())
                          : "MISSING",
                      color: Colors.green,
                      fontWeight: FontWeight.bold),
                ],
              ),
              Column(
                children: [
                  AppUtils.buildNormalText(text: "OVERTIME OUT"),
                  const SizedBox(height: 5),
                  AppUtils.buildNormalText(
                      text: checkModel.status == true &&
                              checkModel.message!.first.punchOutTime
                                  .toString()
                                  .isNotEmpty
                          ? AppConstants.changeddmmyyhhmmssformat(
                              checkModel.message!.first.punchOutTime.toString())
                          : "MISSING",
                      color: (checkModel.message != null)
                          ? Colors.green
                          : Colors.red,
                      fontWeight: FontWeight.bold),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Visibility(
            visible: (checkModel.message == null)
                ? true
                : checkModel.message!.isNotEmpty &&
                        checkModel.message!.first.isAttendanceout.toString() ==
                            'OUT'
                    ? true
                    : false,
            child: CustomButton(
              onPressed: () async {
                Map<Permission, PermissionStatus> statuses = await [
                  Permission.location,
                ].request();
                statuses.values.forEach((element) async {
                  if (element.isDenied || element.isPermanentlyDenied) {
                    await openAppSettings();
                  }
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const OvertimeEntryPage(
                          sid: "",
                          name: "Overtime In",
                          checkin: true,
                          checkout: false)),
                ).then((_) => getattendancecheckdata());
              },
              name: "Overtime In",
              circularvalue: 30,
              fontSize: 14,
            ),
          ),
          Visibility(
            visible: (checkModel.message == null ||
                    checkModel.message!.first.isAttendanceout.toString() ==
                        'OUT')
                ? false
                : true,
            child: CustomButton(
              onPressed: () async {
                Map<Permission, PermissionStatus> statuses = await [
                  Permission.location,
                ].request();
                statuses.values.forEach((element) async {
                  if (element.isDenied || element.isPermanentlyDenied) {
                    await openAppSettings();
                  }
                });
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => OvertimeEntryPage(
                            sid: checkModel.message!.first.sId.toString(),
                            name: "Overtime Out",
                            checkin: false,
                            checkout: true))).then((value) {
                  setState(() {
                    getattendancecheckdata();
                  });
                });
              },
              name: "Overtime Out",
              circularvalue: 30,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget showfrmtimeandlocation() {
    return model.message != null
        ? ListView.builder(
            itemCount: model.message!.length ?? 0,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return Container(
                margin: const EdgeInsets.all(5),
                padding: const EdgeInsets.only(left: 5, right: 5, bottom: 3),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        if (model.message![index].fromLatitude
                                .toString()
                                .isNotEmpty &&
                            model.message![index].fromLongitude
                                .toString()
                                .isNotEmpty) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => GoogleMapsPage(
                                    lati: double.parse(model
                                        .message![index].fromLatitude
                                        .toString()),
                                    longi: double.parse(model
                                        .message![index].fromLongitude
                                        .toString()),
                                    address: model
                                        .message![index].fromGpsAddress
                                        .toString(),
                                    time: model.message![index].punchInTime
                                        .toString(),
                                    type: model.message![index].isAttendancein
                                        .toString())),
                          );
                        }
                      },
                      child: Card(
                        elevation: 0,
                        child: ListTile(
                          leading: const SizedBox(
                            height: double.infinity,
                            child: Icon(
                              Icons.call_received_outlined,
                              color: Colors.green,
                              size: 20,
                            ),
                          ),
                          trailing: const Icon(
                            Icons.location_pin,
                            color: Colors.green,
                          ),
                          title: Text(
                              AppConstants.changeddmmyyhhmmssformat(
                                      model.message![index].punchInTime) ??
                                  "",
                              overflow: TextOverflow.ellipsis),
                          subtitle: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppUtils.buildNormalText(
                                    text: model.message![index].fromGpsAddress
                                                .toString() ==
                                            "null"
                                        ? "-"
                                        : model.message![index].fromGpsAddress
                                            .toString(),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis),
                                AppUtils.buildNormalText(
                                    text: model.message![index].source),
                              ]),
                        ),
                      ),
                    ),
                    model.message![index].punchOutTime.toString().isNotEmpty
                        ? InkWell(
                            onTap: () {
                              if (model.message![index].toLatitude
                                      .toString()
                                      .isNotEmpty &&
                                  model.message![index].toLatitude
                                      .toString()
                                      .isNotEmpty) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => GoogleMapsPage(
                                          lati: double.parse(model
                                              .message![index].toLatitude
                                              .toString()),
                                          longi: double.parse(model
                                              .message![index].toLongitude
                                              .toString()),
                                          address: model
                                              .message![index].toGpsAddress
                                              .toString(),
                                          time: model
                                              .message![index].punchOutTime
                                              .toString(),
                                          type: model
                                              .message![index].isAttendanceout
                                              .toString())),
                                );
                              } else {}
                            },
                            child: Card(
                              elevation: 0,
                              color: Colors.white,
                              child: ListTile(
                                leading: const SizedBox(
                                  height: double.infinity,
                                  child: Icon(
                                    Icons.arrow_outward,
                                    color: Colors.red,
                                    size: 20,
                                  ),
                                ),
                                trailing: const Icon(Icons.location_pin,
                                    color: Colors.red),
                                title: Text(
                                    AppConstants.changeddmmyyhhmmssformat(model
                                            .message![index].punchOutTime) ??
                                        "",
                                    overflow: TextOverflow.ellipsis),
                                subtitle: AppUtils.buildNormalText(
                                    text: model.message![index].toGpsAddress
                                                .toString() ==
                                            "null"
                                        ? "-"
                                        : model.message![index].fromGpsAddress
                                            .toString(),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis),
                              ),
                            ),
                          )
                        : Container()
                  ],
                ),
              );
            })
        : Container();
  }

  void getattendancecheckdata() async {
    setState(() {
      loading = true;
    });
    ApiService.viewovertimebioattendance().then((response) {
      setState(() {
        loading = false;
      });
      if (response.statusCode == 200) {
        if (jsonDecode(response.body)['status'].toString() == "true") {
          checkModel = BioAttendanceModel.fromJson(jsonDecode(response.body));
          gethistorymodel();
        } else {
          checkModel.message = null;
          checkModel.status = false;
          gethistorymodel();
        }
      } else {
        throw Exception(jsonDecode(response.body)['message'].toString());
      }
    }).catchError((e) {
      setState(() {
        loading = false;
      });
      AppUtils.showSingleDialogPopup(context, e.toString(), "Ok", onexitpopup,
          AssetsImageWidget.errorimage);
    });
  }

  void gethistorymodel() async {
    setState(() {
      loading = true;
    });
    ApiService.viewovertimeattendancebiohistory().then((response) {
      setState(() {
        loading = false;
      });
      if (response.statusCode == 200) {
        if (jsonDecode(response.body)['status'].toString() == "true") {
          model = DailyHistoryModel.fromJson(jsonDecode(response.body));
        } else {}
      } else {
        throw Exception(jsonDecode(response.body)['message'].toString());
      }
    }).catchError((e) {
      setState(() {
        loading = false;
      });
      AppUtils.showSingleDialogPopup(context, e..toString(), "Ok", onexitpopup,
          AssetsImageWidget.errorimage);
    });
  }

  void onexitpopup() {
    Navigator.of(context).pop();
  }

  void onrefreshscreen() {
    Navigator.of(context).pop();
    // Navigator.of(context).pop();
  }
}
