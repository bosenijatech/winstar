import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:powergroupess/models/empinfomodel.dart';
import 'package:powergroupess/routenames.dart';
import 'package:powergroupess/services/apiservice.dart';
import 'package:powergroupess/services/pref.dart';
import 'package:powergroupess/utils/app_utils.dart';
import 'package:powergroupess/utils/sharedprefconstants.dart';
import 'package:powergroupess/views/landingpage/homepage.dart';
import 'package:powergroupess/views/landingpage/menuspage.dart';
import 'package:powergroupess/views/landingpage/notifictionpage.dart';
import 'package:powergroupess/views/login/loginpage.dart';
import 'package:powergroupess/views/profilepage/profilepage.dart';
import 'package:powergroupess/views/widgets/customappbar.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  int selectedIndex = 0;

  List pages = [
    const Homepage(),
    const Menuspage(),
    const ProfilePage(),
    const NotificationPage(),
  ];
  StreamController<String> streamController = StreamController();
  final Stream _myStream =
      Stream.periodic(const Duration(minutes: 3), (int count) {
    return count;
  });

  late StreamSubscription sub;
  int computationCount = 0;
  @override
  void initState() {
    sub = _myStream.listen((event) {
      setState(() {
        computationCount = event;
        // checkuserisdisabled();
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    streamController.close();
    sub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Customappbar(
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: GestureDetector(
                  onTap: () {
                    AppUtils.showconfirmDialog(
                        context, "Do you want to logout?", "Yes", "No", () {
                      logout();
                    }, () {
                      AppUtils.pop(context);
                    });
                  },
                  child: SizedBox()
                  ),
            )
          ],
          title: AppUtils.buildNormalText(
            text: "Power Group Ess",
            fontSize: 18,
            color: Colors.black,
          ),
        ),
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Colors.white, width: 2))),
          child: BottomNavigationBar(
            onTap: onItemTapped,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            items: [
              (selectedIndex == 0)
                  ? BottomNavigationBarItem(
                      icon: SvgPicture.asset('assets/icons/Home-active.svg'),
                      label: '')
                  : BottomNavigationBarItem(
                      icon: SvgPicture.asset('assets/icons/Home.svg'),
                      label: ''),
              (selectedIndex == 1)
                  ? BottomNavigationBarItem(
                      icon:
                          SvgPicture.asset('assets/icons/Category-active.svg'),
                      label: '')
                  : BottomNavigationBarItem(
                      icon: SvgPicture.asset('assets/icons/Category.svg'),
                      label: ''),
              (selectedIndex == 2)
                  ? BottomNavigationBarItem(
                      icon: SvgPicture.asset('assets/icons/Profile-active.svg'),
                      label: '')
                  : BottomNavigationBarItem(
                      icon: SvgPicture.asset('assets/icons/Profile.svg'),
                      label: ''),
              (selectedIndex == 3)
                  ? BottomNavigationBarItem(
                      icon: SvgPicture.asset(
                          'assets/icons/Notification-active.svg'),
                      label: '')
                  : BottomNavigationBarItem(
                      icon: SvgPicture.asset('assets/icons/Notification.svg'),
                      label: ''),
            ],
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/waveshapes.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: pages[selectedIndex],
        ));

    //pages[selectedIndex]);
  }

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  void logout() {
    Prefs.clear();
    Prefs.remove("remove");
    Prefs.setLoggedIn(SharefprefConstants.sharefloggedin, false);
    Navigator.pushNamedAndRemoveUntil(
        context, RouteNames.loginscreen, (Route<dynamic> route) => false);
  }

  // void checkuserisdisabled() async {
  //   ApiService.getemployeedetailsdata().then((response) {
  //     if (response.statusCode == 200) {
  //       if (jsonDecode(response.body)['status'].toString() == "true") {
  //         EmpInfoModel empinfomodel =
  //             EmpInfoModel.fromJson(jsonDecode(response.body));
  //         var mobileaccess = empinfomodel.message!.mobileaccess.toString();

  //         if (mobileaccess.toString() == "true") {
  //         } else {
  //           forcelogout();
  //         }
  //       } else {
  //         forcelogout();
  //       }
  //     } else {
  //       throw Exception(jsonDecode(response.body)['message'].toString());
  //     }
  //   }).catchError((e) {
  //     print(e.toString());
  //   });
  // }

  void onexitpopup() {
    Navigator.of(context).pop();
  }

  forcelogout() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            title: const Text(
                "Your account has been locked from Netsuite. please contact your Administrator!."),
            titleTextStyle: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.black, fontSize: 14),
            actionsOverflowButtonSpacing: 10,
            actions: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Prefs.clear();
                    Prefs.remove("remove");
                    Prefs.setLoggedIn("IsLoggedIn", false);
                    Navigator.pushAndRemoveUntil<void>(
                      context,
                      MaterialPageRoute<void>(
                          builder: (BuildContext context) => const LoginPage()),
                      ModalRoute.withName('/'),
                    );
                  },
                  child: const Text("Ok")),
            ],
          ),
        );
      },
    );
  }

  void onrefreshscreen() {
    Navigator.of(context).pop();
    // Navigator.of(context).pop();
  }
}
