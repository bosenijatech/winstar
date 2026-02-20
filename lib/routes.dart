import 'package:flutter/material.dart';
import 'package:winstar/routenames.dart';
import 'package:winstar/views/assetrequest/assetapply.dart';
import 'package:winstar/views/assetrequest/viewassets.dart';
import 'package:winstar/views/attendance/attendance_history.dart';
import 'package:winstar/views/attendance/view_attendance.dart';
import 'package:winstar/views/changepassword/changepassword.dart';
import 'package:winstar/views/dutytravel/dutytravelapply.dart';
import 'package:winstar/views/dutytravel/dutytraveldetail.dart';
import 'package:winstar/views/grievances/applygrievance.dart';
import 'package:winstar/views/landingpage/landingpage.dart';
import 'package:winstar/views/leave/leaveapplypage.dart';
import 'package:winstar/views/leave/viewleavedetails.dart';
import 'package:winstar/views/letterpage/letterapply.dart';
import 'package:winstar/views/letterpage/letterdetails.dart';
import 'package:winstar/views/login/loginpage.dart';
import 'package:winstar/views/payslip/viewpayslip.dart';
import 'package:winstar/views/reimbursement/reimburesementapply.dart';
import 'package:winstar/views/reimbursement/reimbursementdetails.dart';
import 'package:winstar/views/rejoin/rejointab.dart';
import 'package:winstar/views/splash.dart/splash.dart';

// class AppRoutes {
//   static final routes = {
//     '/': (context) => const SplashScreen(),
//     '/login': (context) => const LoginPage(),
//     '/landingpage': (context) => const LandingPage(),
//     '/homepage': (context) => const Homepage(),
//     '/menuspage': (context) => const Menuspage(),
//     '/profilepage': (context) => const ProfilePage(),
//     '/notificationpage': (context) => const NotificationPage(),
//     '/otpverify': (context) => const OTPVerificationPage(),
//     '/viewattendance': (context) => const ViewAttendance(),
//     '/viewleave': (context) => const ViewLeavePage(),
//     '/addleave': (context) => const LeaveApplyPage(),
//     '/attendancehistory': (context) => const ViewLeavePage(),
//   };
// }

class Routes {
  static Route<dynamic> generateRoutes(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case (RouteNames.splashscreen):
        return MaterialPageRoute(
            builder: (BuildContext context) => const SplashScreen());
      case (RouteNames.loginscreen):
        return MaterialPageRoute(
            builder: (BuildContext context) => const LoginPage());
      case (RouteNames.landingpage):
        return MaterialPageRoute(
            builder: (BuildContext context) => const LandingPage());

      case (RouteNames.attendancehistory):
        return MaterialPageRoute(
            builder: (BuildContext context) => const Attendancehistory());

      //LEAVE
      case (RouteNames.applyleave):
        return MaterialPageRoute(
            builder: (BuildContext context) => const LeaveApplyPage());
      case (RouteNames.viewleave):
        return MaterialPageRoute(
            builder: (BuildContext context) => const ViewLeavePage());

      // //RE JOIN
      // case (RouteNames.dutyresumption):
      //   return MaterialPageRoute(
      //       builder: (BuildContext context) => const DutyResumption());

      //ASSET
      case (RouteNames.viewasset):
        return MaterialPageRoute(
            builder: (BuildContext context) => const AssetDetailPage());

      case (RouteNames.applyasset):
        return MaterialPageRoute(
            builder: (BuildContext context) => const AssetApplyPage());
      //LETTER REQUEST

      // case (RouteNames.rejoin):
      //   return MaterialPageRoute(
      //       builder: (BuildContext context) => const DutyResumption());
      case (RouteNames.viewrejoin):
        return MaterialPageRoute(
            builder: (BuildContext context) => const ReJoinTab());
      //ASSET
      case (RouteNames.viewletter):
        return MaterialPageRoute(
            builder: (BuildContext context) => const LetterDetailPage());
      case (RouteNames.addletter):
        return MaterialPageRoute(
            builder: (BuildContext context) => const LetterApplyPage());
      //Duty Travel
      case (RouteNames.dutytravelview):
        return MaterialPageRoute(
            builder: (BuildContext context) => const DutyTravelDetailsPage());
      case (RouteNames.dutytravelapply):
        return MaterialPageRoute(
            builder: (BuildContext context) => const DutyTravelApplyPage());
      //REIM APPLY
      case (RouteNames.reimview):
        return MaterialPageRoute(
            builder: (BuildContext context) => const ReimbursementDetails());
      case (RouteNames.reimapply):
        return MaterialPageRoute(
            builder: (BuildContext context) => const ReimburesementApplyPage());

      //GRIEVANCE
      case (RouteNames.viewgrievance):
      case (RouteNames.addgrievance):
        return MaterialPageRoute(
            builder: (BuildContext context) => const ApplyGrievancePage());

      case (RouteNames.changepassword):
        return MaterialPageRoute(
            builder: (BuildContext context) => const ChangePassword());
      case (RouteNames.payslip):
        return MaterialPageRoute(
            builder: (BuildContext context) => const ViewPaySlipPage());
      case (RouteNames.viewattendance):
        return MaterialPageRoute(
            builder: (BuildContext context) => const ViewAttendance());
      default:
        _errorRoute();
    }
    return _errorRoute();
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) => const Scaffold(
        body: Center(
          child: Text("No route is configured"),
        ),
      ),
    );
  }
}
