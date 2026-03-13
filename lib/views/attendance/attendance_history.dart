import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:winstar/models/attendanceModel.dart';
import 'package:winstar/routenames.dart';
import 'package:winstar/services/apiservice.dart';
import 'package:winstar/utils/app_utils.dart';
import 'package:winstar/utils/custom_indicatoronly.dart';
import 'package:winstar/views/attendance/attendanceentrypage.dart';
import 'package:winstar/views/attendance/googlemaps.dart';
import 'package:winstar/views/widgets/assets_image_widget.dart';

class Attendancehistory extends StatefulWidget {
  const Attendancehistory({super.key});

  @override
  State<Attendancehistory> createState() => _AttendancehistoryState();
}

class _AttendancehistoryState extends State<Attendancehistory> {
  List<AttendanceModel> attendanceModel = [];

  bool loading = false;

  bool get hasAttendanceToday => attendanceModel.isNotEmpty;

  bool get hasClockIn =>
      hasAttendanceToday &&
      attendanceModel.first.checkIn != null &&
      attendanceModel.first.checkIn!.isNotEmpty;

  bool get hasClockOut =>
      hasAttendanceToday &&
      attendanceModel.first.checkOut != null &&
      attendanceModel.first.checkOut!.isNotEmpty;

  @override
  void initState() {
    super.initState();
    getattendancecheckdata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: AppUtils.buildNormalText(
          text: "Attendance - Today",
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onSelected: (value) {
              if (value == "1") {
                Navigator.pushNamed(context, RouteNames.viewattendance);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: "1",
                child: Text("Add Regularization"),
              ),
            ],
          )
        ],
      ),
      body: loading
          ? const Center(child: CustomIndicator())
          : RefreshIndicator(
              onRefresh: () async {
                getattendancecheckdata();
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    clockrunningpage(),
                    const SizedBox(height: 10),
                    showfrmtimeandlocation(),
                  ],
                ),
              ),
            ),
    );
  }

  // ================= HEADER CARD =================

  Widget clockrunningpage() {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Colors.white,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _clockInfoCard(
                  title: "CLOCK IN",
                  value:
                      hasClockIn ? attendanceModel.first.checkIn! : "MISSING",
                  icon: Icons.call_received_outlined,
                  color: Colors.green,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _clockInfoCard(
                  title: "CLOCK OUT",
                  value:
                      hasClockOut ? attendanceModel.first.checkOut! : "MISSING",
                  icon: Icons.arrow_outward,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          // attendanceModel.isNotEmpty &&
          //         attendanceModel.first.isRegularized == false
          //     ? const SizedBox.shrink()
          //     : buildAttendanceButton()

          buildAttendanceButton()
        ],
      ),
    );
  }

  // ================= CLOCK CARDS =================

  Widget _clockInfoCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 18),
              const SizedBox(width: 6),
              Text(title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: value == "MISSING" ? Colors.red : Colors.black),
          ),
        ],
      ),
    );
  }

  // ================= CLOCK BUTTON =================

  Widget buildAttendanceButton() {
    String title = "Clock In";
    bool checkin = true;
    bool checkout = false;
    Color color = Colors.blue;

    if (attendanceModel.isNotEmpty &&
        attendanceModel.first.punches != null &&
        attendanceModel.first.punches!.isNotEmpty) {
      var lastPunch = attendanceModel.first.punches!.last;

      if (lastPunch.type == "IN") {
        title = "Clock Out";
        checkin = false;
        checkout = true;
        color = Colors.redAccent;
      } else {
        title = "Clock In";
        checkin = true;
        checkout = false;
        color = Colors.blue;
      }
    }

    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AttendanceEntryPage(
                sid: attendanceModel.isNotEmpty
                    ? attendanceModel.first.internalId.toString()
                    : "",
                name: title,
                checkin: checkin,
                checkout: checkout,
              ),
            ),
          ).then((_) => getattendancecheckdata());
        },
        child: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  // ================= PUNCH LOGS =================

  Widget showfrmtimeandlocation() {
    if (attendanceModel.isEmpty ||
        attendanceModel.first.punches == null ||
        attendanceModel.first.punches!.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(20),
        child: Center(child: Text("No logs found for today")),
      );
    }

    final punches = attendanceModel.first.punches!;

    return ListView.builder(
      itemCount: punches.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(12),
      itemBuilder: (context, index) {
        final punch = punches[index];

        return ListTile(
          leading: Icon(
            punch.type == "IN"
                ? Icons.call_received_outlined
                : Icons.arrow_outward,
            color: punch.type == "IN" ? Colors.green : Colors.red,
          ),
          title: Text(punch.type == "IN" ? "Clock In" : "Clock Out"),
          subtitle: Text(punch.address ?? "-"),
          trailing: Text(punch.time ?? ""),
          onTap: () {
            if ((punch.latitude ?? "").isNotEmpty) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => GoogleMapsPage(
                    latlang: "${punch.latitude},${punch.longitude}",
                    address: punch.address ?? "",
                    time: punch.time ?? "",
                    type: punch.type ?? "",
                  ),
                ),
              );
            }
          },
        );
      },
    );
  }

  // ================= API CALL =================

  void getattendancecheckdata() async {
    setState(() {
      loading = true;
    });

    ApiService.viewbioattendance().then((response) {
      setState(() {
        loading = false;
      });

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        if (decoded['status'] == true) {
          attendanceModel.clear();

          attendanceModel.add(AttendanceModel.fromJson(decoded['message']));
        }
      }
    }).catchError((e) {
      setState(() {
        loading = false;
      });

      AppUtils.showSingleDialogPopup(
        context,
        e.toString(),
        "Ok",
        () {
          Navigator.of(context).pop();
        },
        AssetsImageWidget.errorimage,
      );
    });
  }
}
