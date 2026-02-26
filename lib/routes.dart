import 'package:flutter/material.dart';
import 'package:bindhaeness/routenames.dart';
import 'package:bindhaeness/views/assetrequest/assetapply.dart';
import 'package:bindhaeness/views/assetrequest/viewassets.dart';
import 'package:bindhaeness/views/attendance/attendance_history.dart';
import 'package:bindhaeness/views/attendance/view_attendance.dart';
import 'package:bindhaeness/views/changepassword/changepassword.dart';
import 'package:bindhaeness/views/dutytravel/dutytravelapply.dart';
import 'package:bindhaeness/views/dutytravel/dutytraveldetail.dart';
import 'package:bindhaeness/views/grievances/applygrievance.dart';
import 'package:bindhaeness/views/landingpage/teammets.dart';
import 'package:bindhaeness/views/leave/applycompoffpage.dart';
import 'package:bindhaeness/views/leave/dummy.dart';
import 'package:bindhaeness/views/leave/leaveapplypage.dart';
import 'package:bindhaeness/views/leave/viewcompoffdetails.dart';
import 'package:bindhaeness/views/leave/viewleavedetails.dart';
import 'package:bindhaeness/views/letterpage/letterapply.dart';
import 'package:bindhaeness/views/letterpage/viewletterdetails.dart';
import 'package:bindhaeness/views/login/loginpage.dart';
import 'package:bindhaeness/views/overtime/overtimehistory.dart';
import 'package:bindhaeness/views/payslip/viewpayslip.dart';
import 'package:bindhaeness/views/profilepage/profilepage.dart';
import 'package:bindhaeness/views/reimbursement/reimburesementapply.dart';
import 'package:bindhaeness/views/reimbursement/reimbursementdetails.dart';
import 'package:bindhaeness/views/rejoin/rejointab.dart';
import 'package:bindhaeness/views/splash.dart/splash.dart';


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
      // case (RouteNames.landingpage):
      //   return MaterialPageRoute(
      //       builder: (BuildContext context) => const LandingPage());

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

      //LEAVE
      case (RouteNames.applycompoffleave):
        return MaterialPageRoute(
            builder: (BuildContext context) => const CompOffApplyPage());
      case (RouteNames.viewcompoffleave):
        return MaterialPageRoute(
            builder: (BuildContext context) => const ViewCompOffPage());

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
            builder: (BuildContext context) => const ViewLetterDetailsPage());
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
            builder: (BuildContext context) => const ReimbursementApplyPage());

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

      case (RouteNames.overtimehistory):
        return MaterialPageRoute(
            builder: (BuildContext context) => const Overtimehistory());

      case (RouteNames.viewprofile):
        return MaterialPageRoute(
            builder: (BuildContext context) => const ProfilePage());

      case (RouteNames.viewdummy):
        return MaterialPageRoute(
            builder: (BuildContext context) => const DummyScreen());

      case (RouteNames.myteam):
        return MaterialPageRoute(
            builder: (BuildContext context) => const MyTeamScreen());
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
