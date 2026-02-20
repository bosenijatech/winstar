// import 'dart:async';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:powergroupess/models/bioattendancemodel.dart';
// import 'package:powergroupess/models/empinfomodel.dart';
// import 'package:powergroupess/models/error_model.dart';
// import 'package:powergroupess/models/holiydaymodel.dart';
// import 'package:powergroupess/models/loginmodel.dart';
// import 'package:powergroupess/routenames.dart';
// import 'package:powergroupess/services/apiservice.dart';
// import 'package:powergroupess/services/pref.dart';
// import 'package:powergroupess/services/userstatusservice.dart';
// import 'package:powergroupess/utils/app_utils.dart';
// import 'package:powergroupess/utils/appcolor.dart';
// import 'package:powergroupess/utils/constants.dart';
// import 'package:powergroupess/utils/custom_indicatoronly.dart';
// import 'package:powergroupess/utils/netsuite/netsuiteservice.dart';
// import 'package:powergroupess/utils/new_version.dart';
// import 'package:powergroupess/utils/sharedprefconstants.dart';
// import 'package:powergroupess/views/login/loginpage.dart';
// import 'package:powergroupess/views/widgets/assets_image_widget.dart';
// import 'package:powergroupess/views/widgets/custom_scaffold.dart';
// import 'package:intl/intl.dart';
// import 'package:url_launcher/url_launcher.dart';

// class Homepage extends StatefulWidget {
//   const Homepage({super.key});

//   @override
//   State<Homepage> createState() => _HomepageState();
// }

// class _HomepageState extends State<Homepage> {
//   HolidayModel holidaymodel = HolidayModel();
//   List<CustomHolidayMaster> customholidaylist = [];
//   BioAttendanceModel checkModel = BioAttendanceModel();
//   StreamController<String> streamController = StreamController();
//   bool loading = false;
//   // final Stream _myStream =
//   //     Stream.periodic(const Duration(minutes: 3), (int count) {
//   //   return count;
//   // });

//   // late StreamSubscription sub;
//   // int computationCount = 0;
//   ErrorModelNetSuite errorModelNetSuite = ErrorModelNetSuite();
//   @override
//   void initState() {
//     getAllEvents();

//     super.initState();
//   }

//   Future<void> checkForUpdates() async {
//     final newVersion = NewVersionPlus(
//       androidId: AppConstants
//           .androidAppPackageName, // Replace with your Android app package name
//       iOSId: AppConstants.iOSAppID,
//       androidHtmlReleaseNotes: true,
//     );

//     final status = await newVersion.getVersionStatus();
//     print(status);
//     if (status?.canUpdate == true) {
//       showUpdateDialog(status!, context);
//     }
//   }

//   void showUpdateDialog(status, BuildContext context1) {
//     showDialog(
//       barrierDismissible: false,
//       context: context1,
//       builder: (BuildContext context1) => AlertDialog(
//         title: const Text('Update Available'),
//         content: Text(
//           'A new version of the app is available!\n\n'
//           'Current Version: ${status.localVersion}\n'
//           'Latest Version: ${status.storeVersion}',
//         ),
//         actions: [
//           TextButton(
//             onPressed: () {
//               status.appStoreLink != "null"
//                   ? launchUrl(Uri.parse(status.appStoreLink))
//                   : print('App Store link not available');
//             },
//             child: const Text('Update Now'),
//           ),
//         ],
//       ),
//     );
//   }

//   void onResumed() {}

//   @override
//   void dispose() {
//     UserStatusService().stopChecking();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return CustomScaffold(
//       //backgroundColor: Colors.white,
//       child: !loading
//           ? SingleChildScrollView(
//               child: Column(
//                 children: [homepagedesign()],
//               ),
//             )
//           : const Center(
//               child: CustomIndicator(),
//             ),
//     );
//   }

//   Widget homepagedesign() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const SizedBox(height: 10),
//         Container(
//           margin: const EdgeInsets.only(left: 15, right: 16, top: 10),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               AppUtils.buildNormalText(
//                   text: "Working Shift Details",
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold),
//               AppUtils.buildNormalText(
//                   text: "", fontSize: 16, color: Appcolor.twitterBlue),
//             ],
//           ),
//         ),
//         const SizedBox(
//           height: 10,
//         ),
//         clockrunningpage(),
//         Divider(
//           color: Colors.grey.shade500,
//           thickness: 0.5,
//         ),
//         const SizedBox(
//           height: 5,
//         ),
//         // hierarchyPage(),
//         // const SizedBox(
//         //   height: 5,
//         // ),
//         Container(
//           margin: const EdgeInsets.only(left: 15, right: 16, top: 10),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               AppUtils.buildNormalText(
//                   text: "Teams", fontSize: 16, fontWeight: FontWeight.bold),
//               AppUtils.buildNormalText(
//                   text: "", fontSize: 16, color: Appcolor.twitterBlue),
//             ],
//           ),
//         ),
//         hierarchyPage(),
//         const SizedBox(
//           height: 5,
//         ),
//         Container(
//           margin: const EdgeInsets.only(left: 15, right: 16, top: 10),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               AppUtils.buildNormalText(
//                   text: "Upcoming holidays",
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold),
//               AppUtils.buildNormalText(
//                   text: "", fontSize: 16, color: Appcolor.twitterBlue),
//             ],
//           ),
//         ),

//         const SizedBox(
//           height: 5,
//         ),

//         upcomingholidays(),
//         Container(
//             margin: const EdgeInsets.only(
//                 left: 15, right: 16, top: 10, bottom: 20)),
//       ],
//     );
//   }

//   Widget clockrunningpage() {
//     return InkWell(
//       onTap: () {
//         Navigator.pushNamed(context, RouteNames.attendancehistory);
//       },
//       child: Card(
//         elevation: 1,
//         borderOnForeground: true,
//         child: Container(
//           padding: const EdgeInsets.all(8),
//           margin: const EdgeInsets.only(left: 10, right: 10),
//           decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(10),
//               color: Colors.blue.withOpacity(0.1)),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const SizedBox(
//                 height: 5,
//               ),
//               AppUtils.buildNormalText(
//                   text: Prefs.getShiftName(
//                     SharefprefConstants.sharedshiftName,
//                   ),
//                   fontSize: 14),
//               const SizedBox(
//                 height: 10,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Expanded(
//                       flex: 9,
//                       child: Row(
//                         children: [
//                           Container(
//                             margin: const EdgeInsets.all(0),
//                             padding: const EdgeInsets.all(12),
//                             decoration: const BoxDecoration(
//                                 color: Appcolor.black, shape: BoxShape.circle),
//                             child: const Icon(
//                               Icons.card_membership_outlined,
//                               color: Colors.white,
//                               size: 14,
//                             ),
//                           ),
//                           const SizedBox(width: 15),
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               AppUtils.buildNormalText(
//                                   text:
//                                       DateFormat.MMMEd().format(DateTime.now()),
//                                   fontSize: 12,
//                                   fontWeight: FontWeight.bold),
//                               const SizedBox(
//                                 height: 5,
//                               ),
//                               AppUtils.buildNormalText(
//                                   text: '0h / 8h',
//                                   fontSize: 12,
//                                   fontWeight: FontWeight.bold),
//                             ],
//                           )
//                         ],
//                       )),
//                   Expanded(
//                       flex: 1,
//                       child: Icon(
//                         Icons.navigate_next_outlined,
//                         color: Colors.grey.shade400,
//                       )),
//                 ],
//               ),
//               const SizedBox(
//                 height: 10,
//               ),
//               Container(
//                 padding: const EdgeInsets.all(5),
//                 //margin: EdgeInsets.only(left: 5, right: 5),
//                 decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(5),
//                     color: Colors.blue[100]),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Expanded(
//                         flex: 7,
//                         child: checkModel.status == true &&
//                                 checkModel.message!.first.punchInTime
//                                     .toString()
//                                     .isNotEmpty
//                             ? AppUtils.buildNormalText(
//                                 text: "Click Here to Clock Out")
//                             : AppUtils.buildNormalText(
//                                 text: "Click Here to Clock In")),
//                     Expanded(
//                         flex: 3,
//                         child: Column(
//                           children: [
//                             Row(
//                               children: [
//                                 checkModel.status == true &&
//                                         checkModel.message!.first.punchInTime
//                                             .toString()
//                                             .isNotEmpty
//                                     ? const Icon(
//                                         Icons.call_made_outlined,
//                                         color: Colors.red,
//                                         size: 20,
//                                       )
//                                     : const Icon(
//                                         Icons.call_received_outlined,
//                                         color: Colors.green,
//                                         size: 20,
//                                       ),
//                               ],
//                             )
//                           ],
//                         )),
//                   ],
//                 ),
//               ),
//               const SizedBox(
//                 height: 10,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget hierarchyPage() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       mainAxisAlignment: MainAxisAlignment.start,
//       children: [
//         ListTile(
//           title: AppUtils.buildNormalText(
//               text: "Head Of The Department(HOD)",
//               fontSize: 14,
//               fontWeight: FontWeight.w300),
//           subtitle: AppUtils.buildNormalText(
//               text: Prefs.getLinemanager(SharefprefConstants.sharedhod),
//               fontWeight: FontWeight.w500),
//           leading: const CircleAvatar(
//               radius: 30,
//               backgroundImage: AssetImage('assets/images/manandwomen.png')),
//         ),
//         Container(
//             height: 30,
//             margin: const EdgeInsets.only(left: 30),
//             child: Image.asset(
//               'assets/images/ic_arrow.png',
//               color: Colors.black,
//             )),
//         ListTile(
//           title: AppUtils.buildNormalText(
//               text: "Line Manager", fontSize: 14, fontWeight: FontWeight.w300),
//           subtitle: AppUtils.buildNormalText(
//               text: Prefs.getSupervisor(SharefprefConstants.sharedLineManager),
//               fontWeight: FontWeight.w500),
//           // leading: Image.asset(
//           //   'assets/images/teamavatar.png',
//           //   color: Colors.grey.shade400,
//           // ),
//           leading: const CircleAvatar(
//               backgroundColor: Colors.white,
//               radius: 30,
//               backgroundImage: AssetImage('assets/images/manandwomen.png')),
//         ),
//         Container(
//             height: 30,
//             margin: const EdgeInsets.only(left: 30),
//             child: Image.asset(
//               'assets/images/ic_arrow.png',
//               color: Colors.black,
//             )),
//         ListTile(
//           title: AppUtils.buildNormalText(
//               text: "Supervisor", fontSize: 14, fontWeight: FontWeight.w300),
//           subtitle: AppUtils.buildNormalText(
//               text: Prefs.gethod(SharefprefConstants.sharedsupervisor),
//               fontWeight: FontWeight.w500),
//           leading: const CircleAvatar(
//               backgroundColor: Colors.white,
//               radius: 30,
//               backgroundImage: AssetImage('assets/images/manandwomen.png')),
//         ),
//         Container(
//             height: 30,
//             margin: const EdgeInsets.only(left: 30),
//             child: Image.asset(
//               'assets/images/ic_arrow.png',
//               color: Colors.black,
//             )),
//         ListTile(
//           title: AppUtils.buildNormalText(
//               text: Prefs.getFullName(
//                 SharefprefConstants.shareFullName,
//               ),
//               fontWeight: FontWeight.w500,
//               fontSize: 14),
//           subtitle: AppUtils.buildNormalText(
//               text: Prefs.getdesignation(SharefprefConstants.shareddesignation),
//               fontSize: 14),
//           leading: Prefs.getImageURL(SharefprefConstants.sharedImgUrl) != null
//               ? SizedBox(
//                   width: 60,
//                   height: 60,
//                   child: CircleAvatar(
//                     backgroundColor: Colors.white,
//                     radius: 30,
//                     child: CachedNetworkImage(
//                       imageUrl: Prefs.getImageURL(
//                         SharefprefConstants.sharedImgUrl,
//                       ).toString(),
//                       imageBuilder: (context, imageProvider) => Container(
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           image: DecorationImage(
//                             image: imageProvider,
//                             fit: BoxFit.fitHeight,
//                           ),
//                         ),
//                       ),
//                       placeholder: (context, url) =>
//                           const CircularProgressIndicator(),
//                       errorWidget: (context, url, error) => const CircleAvatar(
//                           radius: 40,
//                           backgroundImage:
//                               AssetImage('assets/images/manandwomen.png')),
//                     ),
//                   ),
//                 )
//               : const CircleAvatar(
//                   radius: 40,
//                   backgroundColor: Colors.white,
//                   backgroundImage: AssetImage('assets/images/manandwomen.png')),
//         ),
//       ],
//     );
//   }

//   Widget upcomingholidays() {
//     return customholidaylist.isNotEmpty
//         ? Container(
//             margin: const EdgeInsets.only(top: 15, left: 15, right: 15),
//             height: 130,
//             child: ListView.builder(
//                 scrollDirection: Axis.horizontal,
//                 itemCount: customholidaylist.length,
//                 shrinkWrap: true,
//                 physics: const ScrollPhysics(),
//                 itemBuilder: (context, index) {
//                   return SizedBox(
//                     width: MediaQuery.of(context).size.width * 0.7,
//                     child: Card(
//                       color: AppConstants.colorArray[
//                           index.remainder(AppConstants.colorArray.length)],
//                       child: Container(
//                         margin:
//                             const EdgeInsets.only(left: 10, right: 10, top: 10),
//                         decoration: const BoxDecoration(),
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const SizedBox(
//                               height: 5,
//                             ),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 AppUtils.buildNormalText(
//                                     text: "Holiday",
//                                     color: Appcolor.kwhite,
//                                     fontSize: 12),
//                                 Container(
//                                   width: 30,
//                                   height: 30,
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(20),
//                                     color: Colors.white24,
//                                   ),
//                                   child: const Icon(
//                                     Icons.message,
//                                     color: Colors.white,
//                                     size: 18,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             const SizedBox(
//                               height: 10,
//                             ),
//                             AppUtils.buildNormalText(
//                                 text: customholidaylist[index].name.toString(),
//                                 color: Appcolor.kwhite,
//                                 maxLines: 2,
//                                 overflow: TextOverflow.ellipsis,
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.bold),
//                             const SizedBox(
//                               height: 10,
//                             ),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 AppUtils.buildNormalText(
//                                     text: customholidaylist[index]
//                                         .holidayDate
//                                         .toString(),
//                                     color: Appcolor.kwhite,
//                                     fontSize: 14,
//                                     fontWeight: FontWeight.bold),
//                                 AppUtils.buildNormalText(
//                                     text: customholidaylist[index]
//                                         .holidayDay
//                                         .toString(),
//                                     color: Appcolor.kwhite,
//                                     fontSize: 14,
//                                     fontWeight: FontWeight.bold),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   );
//                 }),
//           )
//         : Container(
//             child: const Text('No Holiday Found!'),
//           );
//   }

//   void getAllEvents() async {
//     getattendancecheckdata();
//     getholidaymaster();
//     syncCredentialsFromBackend();
//     UserStatusService().startChecking(context);
//   }

//   Future<void> syncCredentialsFromBackend() async {
//     final response = await http.get(
//         Uri.parse('${AppConstants.apiBaseUrl}api/mobileapp/getcredentials'));

//     if (response.statusCode == 200) {
//       final body = jsonDecode(response.body);

//       if (body['status'].toString() == "true") {
//         final loginModel = LoginModel.fromJson(body);

//         if (loginModel.secretkey != null && loginModel.secretkey!.isNotEmpty) {
//           await updateSharedPrefIfDifferent(loginModel);
//         }
//       }
//     }
//   }

//   Future<void> updateSharedPrefIfDifferent(LoginModel loginModel) async {
//     final newKey = loginModel.secretkey![0];

//     // Read existing values
//     final currentConsumerKey =
//         Prefs.getnetsuiteConsumerKey("netsuiteConsumerKey");
//     final currentConsumerSecret =
//         Prefs.getnetsuiteConsumerSecret("netsuiteConsumerSecret");
//     final currentToken = Prefs.getnetsuiteToken("netsuiteToken");
//     final currentTokenSecret =
//         Prefs.getnetsuiteTokenSecret("netsuiteTokenSecret");
//     final currentRealm = Prefs.getRealm("netSuiteRealm");

//     // Update only if different
//     if (currentConsumerKey != newKey.cONSUMERKEY) {
//       await Prefs.setnetsuiteConsumerKey(
//           "netsuiteConsumerKey", newKey.cONSUMERKEY.toString());
//     }

//     if (currentConsumerSecret != newKey.cONSUMERSECRET) {
//       await Prefs.setnetsuiteConsumerSecret(
//           "netsuiteConsumerSecret", newKey.cONSUMERSECRET.toString());
//     }

//     if (currentToken != newKey.aCCESSTOKEN) {
//       await Prefs.setnetsuiteToken(
//           "netsuiteToken", newKey.aCCESSTOKEN.toString());
//     }

//     if (currentTokenSecret != newKey.tOKENSECRET) {
//       await Prefs.setnetsuiteTokenSecret(
//           "netsuiteTokenSecret", newKey.tOKENSECRET.toString());
//     }

//     if (currentRealm != newKey.rEALM) {
//       await Prefs.setRealm("netSuiteRealm", newKey.rEALM.toString());
//     }

//     print("SharedPreferences updated if any key changed");
//   }

//   getholidaymaster() async {
//     setState(() {
//       loading = true;
//     });
//     try {
//       Uri baseUri = Uri.parse(
//           '${AppConstants.netSuiteapiBaseUrl}script=${AppConstants.holidayscriptid}&deploy=${AppConstants.holidaydeployid}');
//       await NetSuiteApiService.client.get(baseUri).then((response) {
//         setState(() {
//           loading = false;
//         });

//         if (response.statusCode == 200) {
//           holidaymodel =
//               HolidayModel.fromJson(json.decode(json.decode(response.body)));

//           customholidaylist.clear();

//           holidaymodel.records?.forEach((element) {
//             if (element.inactive == false) {
//               customholidaylist.add(CustomHolidayMaster(
//                   element.internalId.toString(),
//                   element.name.toString(),
//                   element.region.toString(),
//                   element.holidayDate.toString(),
//                   element.holidayDay.toString(),
//                   element.remark.toString(),
//                   element.inactive));
//             }
//           });

//           customholidaylist
//               .sort((a, b) => a.id.toString().compareTo(b.id.toString()));
//         } else {
//           errorModelNetSuite =
//               ErrorModelNetSuite.fromJson(jsonDecode(response.body));
//           throw Exception(errorModelNetSuite.error!.message);
//         }
//       });
//     } on Exception catch (_) {
//       setState(() {
//         loading = false;
//       });
//       rethrow;
//     }
//   }

//   getattendancecheckdata() async {
//     setState(() {
//       loading = true;
//     });
//     ApiService.viewbioattendance().then((response) {
//       setState(() {
//         loading = false;
//       });
//       if (response.statusCode == 200) {
//         if (jsonDecode(response.body)['status'].toString() == "true") {
//           checkModel = BioAttendanceModel.fromJson(jsonDecode(response.body));
//         } else {}
//       } else {
//         throw Exception(jsonDecode(response.body)['message'].toString());
//       }
//     }).catchError((e) {
//       setState(() {
//         loading = false;
//       });
//       AppUtils.showSingleDialogPopup(context, e.toString(), "Ok", onexitpopup,
//           AssetsImageWidget.errorimage);
//     });
//   }

//   // void checkuserisdisabled() async {
//   //   ApiService.getemployeedetailsdata().then((response) {
//   //     if (response.statusCode == 200) {
//   //       if (jsonDecode(response.body)['status'].toString() == "true") {
//   //         EmpInfoModel empinfomodel =
//   //             EmpInfoModel.fromJson(jsonDecode(response.body));
//   //         var mobileaccess = empinfomodel.message!.mobileaccess.toString();

//   //         if (mobileaccess.toString() == "true") {
//   //         } else {
//   //           forcelogout();
//   //         }
//   //       } else {
//   //         forcelogout();
//   //       }
//   //     } else {
//   //       throw Exception(jsonDecode(response.body)['message'].toString());
//   //     }
//   //   }).catchError((e) {
//   //     print(e.toString());
//   //   });
//   // }

//   void onexitpopup() {
//     Navigator.of(context).pop();
//   }

//   forcelogout() {
//     showDialog(
//       barrierDismissible: false,
//       context: context,
//       builder: (BuildContext context) {
//         return WillPopScope(
//           onWillPop: () async => false,
//           child: AlertDialog(
//             title: const Text(
//                 "Your account has been locked from Netsuite. please contact your Administrator!."),
//             titleTextStyle: const TextStyle(
//                 fontWeight: FontWeight.bold, color: Colors.black, fontSize: 14),
//             actionsOverflowButtonSpacing: 10,
//             actions: [
//               ElevatedButton(
//                   onPressed: () {
//                     Navigator.pop(context);
//                     Prefs.clear();
//                     Prefs.remove("remove");
//                     Prefs.setLoggedIn("IsLoggedIn", false);
//                     Navigator.pushAndRemoveUntil<void>(
//                       context,
//                       MaterialPageRoute<void>(
//                           builder: (BuildContext context) => const LoginPage()),
//                       ModalRoute.withName('/'),
//                     );
//                   },
//                   child: const Text("Ok")),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   void onrefreshscreen() {
//     Navigator.of(context).pop();
//     // Navigator.of(context).pop();
//   }
// }

// class CustomHolidayMaster {
//   String? id;
//   String? name;
//   String? region;
//   String? holidayDate;
//   String? holidayDay;
//   String? remark;
//   bool? inactive;

//   CustomHolidayMaster(this.id, this.name, this.region, this.holidayDate,
//       this.holidayDay, this.remark, this.inactive);
// }





import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:powergroupess/models/bioattendancemodel.dart';
import 'package:powergroupess/models/empinfomodel.dart';
import 'package:powergroupess/models/error_model.dart';
import 'package:powergroupess/models/holiydaymodel.dart';
import 'package:powergroupess/models/loginmodel.dart';
import 'package:powergroupess/routenames.dart';
import 'package:powergroupess/services/apiservice.dart';
import 'package:powergroupess/services/pref.dart';
import 'package:powergroupess/services/userstatusservice.dart';
import 'package:powergroupess/utils/app_utils.dart';
import 'package:powergroupess/utils/appcolor.dart';
import 'package:powergroupess/utils/constants.dart';
import 'package:powergroupess/utils/custom_indicatoronly.dart';
import 'package:powergroupess/utils/netsuite/netsuiteservice.dart';
import 'package:powergroupess/utils/new_version.dart';
import 'package:powergroupess/utils/sharedprefconstants.dart';
import 'package:powergroupess/views/login/loginpage.dart';
import 'package:powergroupess/views/widgets/assets_image_widget.dart';
import 'package:powergroupess/views/widgets/custom_scaffold.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  HolidayModel holidaymodel = HolidayModel();
  List<CustomHolidayMaster> customholidaylist = [];
  BioAttendanceModel checkModel = BioAttendanceModel();
  StreamController<String> streamController = StreamController();
  bool loading = false;
  // final Stream _myStream =
  //     Stream.periodic(const Duration(minutes: 3), (int count) {
  //   return count;
  // });

  // late StreamSubscription sub;
  // int computationCount = 0;
  ErrorModelNetSuite errorModelNetSuite = ErrorModelNetSuite();
  @override
  void initState() {
    getAllEvents();

    super.initState();
  }

  Future<void> checkForUpdates() async {
    final newVersion = NewVersionPlus(
      androidId: AppConstants
          .androidAppPackageName, // Replace with your Android app package name
      iOSId: AppConstants.iOSAppID,
      androidHtmlReleaseNotes: true,
    );

    final status = await newVersion.getVersionStatus();
    print(status);
    if (status?.canUpdate == true) {
      showUpdateDialog(status!, context);
    }
  }

  void showUpdateDialog(status, BuildContext context1) {
    showDialog(
      barrierDismissible: false,
      context: context1,
      builder: (BuildContext context1) => AlertDialog(
        title: const Text('Update Available'),
        content: Text(
          'A new version of the app is available!\n\n'
          'Current Version: ${status.localVersion}\n'
          'Latest Version: ${status.storeVersion}',
        ),
        actions: [
          TextButton(
            onPressed: () {
              status.appStoreLink != "null"
                  ? launchUrl(Uri.parse(status.appStoreLink))
                  : print('App Store link not available');
            },
            child: const Text('Update Now'),
          ),
        ],
      ),
    );
  }

  void onResumed() {}

  @override
  void dispose() {
    UserStatusService().stopChecking();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      
      //backgroundColor: Colors.white,
      child: !loading
          ? SingleChildScrollView(
              child: Column(
                children: [homepagedesign()],
              ),
            )
          : const Center(
              child: CustomIndicator(),
            ),
    );
  }

  Widget homepagedesign() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 6),

        _sectionHeader(
          title: "Working Shift Details",
          icon: Icons.access_time_rounded,
        ),
        const SizedBox(height: 10),
        clockrunningpage(),

        const SizedBox(height: 18),

        _sectionHeader(
          title: "Teams",
          icon: Icons.groups_2_rounded,
        ),
        const SizedBox(height: 10),
        hierarchyPage(),

        const SizedBox(height: 18),

        _sectionHeader(
          title: "Upcoming Holidays",
          icon: Icons.celebration_rounded,
        ),
        const SizedBox(height: 10),
        upcomingholidays(),

        const SizedBox(height: 25),
      ],
    ),
  );
}
Widget _sectionHeader({required String title, required IconData icon}) {
  return Row(
    children: [
      Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: Appcolor.twitterBlue.withOpacity(0.12),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(icon, color: Appcolor.twitterBlue, size: 22),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: AppUtils.buildNormalText(
          text: title,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
  );
}

BoxDecoration _cardDecoration() {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(18),
    border: Border.all(color: Colors.grey.shade200),
    boxShadow: [
      BoxShadow(
        blurRadius: 18,
        offset: const Offset(0, 10),
        color: Colors.black.withOpacity(0.06),
      ),
    ],
  );
}

 Widget clockrunningpage() {
  final shiftName = Prefs.getShiftName(SharefprefConstants.sharedshiftName);

  final bool isPunchedIn = checkModel.status == true &&
      checkModel.message != null &&
      checkModel.message!.isNotEmpty &&
      checkModel.message!.first.punchInTime.toString().isNotEmpty;

  return InkWell(
    borderRadius: BorderRadius.circular(18),
    onTap: () {
      Navigator.pushNamed(context, RouteNames.attendancehistory);
    },
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          colors: [
            Colors.blue.withOpacity(0.12),
            Colors.blue.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: Colors.blue.withOpacity(0.18)),
        boxShadow: [
          BoxShadow(
            blurRadius: 18,
            offset: const Offset(0, 10),
            color: Colors.black.withOpacity(0.06),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: AppUtils.buildNormalText(
                  text: shiftName,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_month_outlined,
                      size: 16,
                      color: Colors.grey.shade700,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      DateFormat.MMMEd().format(DateTime.now()),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),

          const SizedBox(height: 14),

          // Work info row
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.badge_outlined,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppUtils.buildNormalText(
                      text: "Today Work",
                      fontSize: 12,
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                    const SizedBox(height: 4),
                    AppUtils.buildNormalText(
                      text: "0h / 8h",
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.navigate_next_rounded,
                color: Colors.grey.shade400,
                size: 30,
              ),
            ],
          ),

          const SizedBox(height: 14),

          // CTA
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              children: [
                Expanded(
                  child: AppUtils.buildNormalText(
                    text: isPunchedIn
                        ? "Click here to Clock Out"
                        : "Click here to Clock In",
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isPunchedIn
                        ? Colors.red.withOpacity(0.12)
                        : Colors.green.withOpacity(0.12),
                  ),
                  child: Icon(
                    isPunchedIn
                        ? Icons.call_made_outlined
                        : Icons.call_received_outlined,
                    color: isPunchedIn ? Colors.red : Colors.green,
                    size: 22,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget hierarchyPage() {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(14),
    decoration: _cardDecoration(),
    child: Column(
      children: [
        _teamRow(
          title: "Head Of The Department (HOD)",
          subtitle: Prefs.getLinemanager(SharefprefConstants.sharedhod),
        ),
        _connector(),

        _teamRow(
          title: "Line Manager",
          subtitle:
              Prefs.getSupervisor(SharefprefConstants.sharedLineManager),
        ),
        _connector(),

        _teamRow(
          title: "Supervisor",
          subtitle: Prefs.gethod(SharefprefConstants.sharedsupervisor),
        ),
        _connector(),

        _myProfileRow(),
      ],
    ),
  );
}

Widget _connector() {
  return Padding(
    padding: const EdgeInsets.only(left: 22),
    child: Align(
      alignment: Alignment.centerLeft,
      child: Container(
        width: 2,
        height: 22,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ),
  );
}
Widget _teamRow({required String title, required String? subtitle}) {
  final safeSubtitle =
      (subtitle == null || subtitle.trim().isEmpty) ? "Not Assigned" : subtitle;

  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const CircleAvatar(
        radius: 24,
        backgroundColor: Colors.white,
        backgroundImage: AssetImage('assets/images/manandwomen.png'),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppUtils.buildNormalText(
              text: title,
              fontSize: 12,
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w500,
            ),
            const SizedBox(height: 4),
            AppUtils.buildNormalText(
              text: safeSubtitle,
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ],
        ),
      ),
    ],
  );
}

Widget _myProfileRow() {
  final myName = Prefs.getFullName(SharefprefConstants.shareFullName);
  final myRole = Prefs.getdesignation(SharefprefConstants.shareddesignation);
  final imgUrl = Prefs.getImageURL(SharefprefConstants.sharedImgUrl);

  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(
        width: 48,
        height: 48,
        child: CircleAvatar(
          backgroundColor: Colors.white,
          radius: 24,
          child: imgUrl != null
              ? CachedNetworkImage(
                  imageUrl: imgUrl.toString(),
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(strokeWidth: 2),
                  errorWidget: (context, url, error) => const CircleAvatar(
                    backgroundImage:
                        AssetImage('assets/images/manandwomen.png'),
                  ),
                )
              : const CircleAvatar(
                  backgroundImage:
                      AssetImage('assets/images/manandwomen.png'),
                ),
        ),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppUtils.buildNormalText(
              text: myName,
              fontSize: 14,
              fontWeight: FontWeight.w900,
            ),
            const SizedBox(height: 4),
            AppUtils.buildNormalText(
              text: myRole,
              fontSize: 12,
              color: Colors.grey.shade700,
            ),
          ],
        ),
      ),
    ],
  );
}
Widget upcomingholidays() {
  if (customholidaylist.isEmpty) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: _cardDecoration(),
      child: Center(
        child: AppUtils.buildNormalText(
          text: "No Holiday Found!",
          fontSize: 13,
          color: Colors.grey.shade700,
        ),
      ),
    );
  }

  return SizedBox(
    height: 150,
    child: ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: customholidaylist.length,
      padding: const EdgeInsets.only(right: 4),
      separatorBuilder: (context, index) => const SizedBox(width: 12),
      itemBuilder: (context, index) {
        final holiday = customholidaylist[index];

        return Container(
          width: MediaQuery.of(context).size.width * 0.74,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: AppConstants.colorArray[
                index.remainder(AppConstants.colorArray.length)],
            boxShadow: [
              BoxShadow(
                blurRadius: 18,
                offset: const Offset(0, 10),
                color: Colors.black.withOpacity(0.10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: AppUtils.buildNormalText(
                      text: "Holiday",
                      color: Appcolor.kwhite,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.celebration_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              AppUtils.buildNormalText(
                text: holiday.name.toString(),
                color: Appcolor.kwhite,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),

              const Spacer(),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: AppUtils.buildNormalText(
                      text: holiday.holidayDate.toString(),
                      color: Appcolor.kwhite,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: AppUtils.buildNormalText(
                      text: holiday.holidayDay.toString(),
                      color: Appcolor.kwhite,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    ),
  );
}


  void getAllEvents() async {
    getattendancecheckdata();
    getholidaymaster();
    syncCredentialsFromBackend();
    UserStatusService().startChecking(context);
  }

  Future<void> syncCredentialsFromBackend() async {
    final response = await http.get(
        Uri.parse('${AppConstants.apiBaseUrl}api/mobileapp/getcredentials'));

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);

      if (body['status'].toString() == "true") {
        final loginModel = LoginModel.fromJson(body);

        if (loginModel.secretkey != null && loginModel.secretkey!.isNotEmpty) {
          await updateSharedPrefIfDifferent(loginModel);
        }
      }
    }
  }

  Future<void> updateSharedPrefIfDifferent(LoginModel loginModel) async {
    final newKey = loginModel.secretkey![0];

    // Read existing values
    final currentConsumerKey =
        Prefs.getnetsuiteConsumerKey("netsuiteConsumerKey");
    final currentConsumerSecret =
        Prefs.getnetsuiteConsumerSecret("netsuiteConsumerSecret");
    final currentToken = Prefs.getnetsuiteToken("netsuiteToken");
    final currentTokenSecret =
        Prefs.getnetsuiteTokenSecret("netsuiteTokenSecret");
    final currentRealm = Prefs.getRealm("netSuiteRealm");

    // Update only if different
    if (currentConsumerKey != newKey.cONSUMERKEY) {
      await Prefs.setnetsuiteConsumerKey(
          "netsuiteConsumerKey", newKey.cONSUMERKEY.toString());
    }

    if (currentConsumerSecret != newKey.cONSUMERSECRET) {
      await Prefs.setnetsuiteConsumerSecret(
          "netsuiteConsumerSecret", newKey.cONSUMERSECRET.toString());
    }

    if (currentToken != newKey.aCCESSTOKEN) {
      await Prefs.setnetsuiteToken(
          "netsuiteToken", newKey.aCCESSTOKEN.toString());
    }

    if (currentTokenSecret != newKey.tOKENSECRET) {
      await Prefs.setnetsuiteTokenSecret(
          "netsuiteTokenSecret", newKey.tOKENSECRET.toString());
    }

    if (currentRealm != newKey.rEALM) {
      await Prefs.setRealm("netSuiteRealm", newKey.rEALM.toString());
    }

    print("SharedPreferences updated if any key changed");
  }

  getholidaymaster() async {
    setState(() {
      loading = true;
    });
    try {
      Uri baseUri = Uri.parse(
          '${AppConstants.netSuiteapiBaseUrl}script=${AppConstants.holidayscriptid}&deploy=${AppConstants.holidaydeployid}');
      await NetSuiteApiService.client.get(baseUri).then((response) {
        setState(() {
          loading = false;
        });

        if (response.statusCode == 200) {
          holidaymodel =
              HolidayModel.fromJson(json.decode(json.decode(response.body)));

          customholidaylist.clear();

          holidaymodel.records?.forEach((element) {
            if (element.inactive == false) {
              customholidaylist.add(CustomHolidayMaster(
                  element.internalId.toString(),
                  element.name.toString(),
                  element.region.toString(),
                  element.holidayDate.toString(),
                  element.holidayDay.toString(),
                  element.remark.toString(),
                  element.inactive));
            }
          });

          customholidaylist
              .sort((a, b) => a.id.toString().compareTo(b.id.toString()));
        } else {
          errorModelNetSuite =
              ErrorModelNetSuite.fromJson(jsonDecode(response.body));
          throw Exception(errorModelNetSuite.error!.message);
        }
      });
    } on Exception catch (_) {
      setState(() {
        loading = false;
      });
      rethrow;
    }
  }

  getattendancecheckdata() async {
    setState(() {
      loading = true;
    });
    ApiService.viewbioattendance().then((response) {
      setState(() {
        loading = false;
      });
      if (response.statusCode == 200) {
        if (jsonDecode(response.body)['status'].toString() == "true") {
          checkModel = BioAttendanceModel.fromJson(jsonDecode(response.body));
        } else {}
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

class CustomHolidayMaster {
  String? id;
  String? name;
  String? region;
  String? holidayDate;
  String? holidayDay;
  String? remark;
  bool? inactive;

  CustomHolidayMaster(this.id, this.name, this.region, this.holidayDate,
      this.holidayDay, this.remark, this.inactive);
}
