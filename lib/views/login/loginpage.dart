// import 'dart:convert';
// import 'dart:io';

// import 'package:animate_do/animate_do.dart';
// import 'package:device_info_plus/device_info_plus.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:winstar/models/loginmodel.dart';
// import 'package:winstar/routenames.dart';
// import 'package:winstar/services/apiservice.dart';
// import 'package:winstar/services/pref.dart';
// import 'package:winstar/utils/app_utils.dart';
// import 'package:winstar/utils/appcolor.dart';
// import 'package:winstar/utils/custom_indicatoronly.dart';
// import 'package:winstar/utils/sharedprefconstants.dart';
// import 'package:winstar/views/forgotpassword/forgotpassword.dart';
// import 'package:winstar/views/widgets/assets_image_widget.dart';
// import 'package:winstar/views/widgets/custom_scaffold.dart';
// import 'package:unique_identifier/unique_identifier.dart';

// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});

//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   TextEditingController usernameController = TextEditingController();
//   TextEditingController passwordController = TextEditingController();
//   bool loading = false;
//   LoginModel loginModel = LoginModel();
//   bool visiblepassword = true;
//   String deviceImei = "";
//   @override
//   void initState() {
//     getdeviceid();
//     super.initState();
//   }

//   void getdeviceid() async {
//     await getUniqueDeviceId();
//   }

//   Future<String> getUniqueDeviceId() async {
//     String uniqueDeviceId = '';

//     var deviceInfo = DeviceInfoPlugin();

//     if (Platform.isIOS) {
//       var iosDeviceInfo = await deviceInfo.iosInfo;
//       uniqueDeviceId = '${iosDeviceInfo.identifierForVendor}'; //
//     } else if (Platform.isAndroid) {
//       try {
//         uniqueDeviceId = (await UniqueIdentifier.serial).toString();
//         print(await UniqueIdentifier.serial);
//       } on PlatformException {
//         uniqueDeviceId = 'Failed to get Unique Identifier';
//       }
//     }
//     setState(() {
//       deviceImei = uniqueDeviceId;
//     });
//     return uniqueDeviceId;
//   }

//   @override
//   void dispose() {
//     usernameController.dispose();
//     passwordController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     return CustomScaffold(
//       child: !loading
//           ? Stack(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.only(left: 35, top: 50),
//                   child: const Text(
//                     'Welcome Back',
//                     style: TextStyle(color: Colors.black, fontSize: 33),
//                   ),
//                 ),
//                 SingleChildScrollView(
//                   child: Container(
//                     padding: EdgeInsets.only(
//                         top: MediaQuery.of(context).size.height * 0.10),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Container(
//                           margin: const EdgeInsets.only(left: 35, right: 35),
//                           child: Column(
//                             children: [buildCard(size, context)],
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             )
//           : const CustomIndicator(),
//     );
//   }

//   Widget buildCard(Size size, BuildContext context) {
//     return Container(
//       alignment: Alignment.topCenter,
//       decoration: const BoxDecoration(
//         borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(40), topRight: Radius.circular(40)),
//         //color: Colors.white,
//       ),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 20.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             const SizedBox(
//               height: 20,
//             ),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     Flexible(
//                       child: AppUtils.buildNormalText(
//                           text: deviceImei, fontSize: 14, maxLines: 3),
//                     ),
//                     const SizedBox(
//                       width: 10,
//                     ),
//                     IconButton(
//                         onPressed: () async {
//                           final String textToCopy = deviceImei;
//                           if (textToCopy.isNotEmpty) {
//                             try {
//                               await Clipboard.setData(
//                                   ClipboardData(text: textToCopy));
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 const SnackBar(
//                                     content: Text('Device ID Copied!')),
//                               );
//                             } catch (e) {
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 const SnackBar(
//                                     content:
//                                         Text('Failed to copy to clipboard.')),
//                               );
//                             }
//                           }
//                         },
//                         icon: const Icon(Icons.copy))
//                   ],
//                 ),
//                 AppUtils.buildNormalText(
//                     text: "Enter your email Id", fontSize: 14),
//                 SizedBox(
//                   height: size.height * 0.02,
//                 ),
//                 emailTextField(size),
//                 SizedBox(
//                   height: size.height * 0.02,
//                 ),
//                 AppUtils.buildNormalText(
//                     text: "Enter your password", fontSize: 14),
//                 SizedBox(
//                   height: size.height * 0.02,
//                 ),
//                 passwordTextField(size),
//                 SizedBox(
//                   height: size.height * 0.04,
//                 ),
//                 // signInButton(size, context),
//                 FadeInUp(
//                     duration: const Duration(milliseconds: 1400),
//                     child: InkWell(
//                       onTap: () {
//                         if (usernameController.text.isEmpty) {
//                           AppUtils.showSingleDialogPopup(
//                               context,
//                               "Please Enter Username",
//                               "Ok",
//                               onexitpopup,
//                               AssetsImageWidget.warningimage);
//                         } else if (usernameController.text.isEmpty) {
//                           AppUtils.showSingleDialogPopup(
//                               context,
//                               "Please Enter Password",
//                               "Ok",
//                               onexitpopup,
//                               AssetsImageWidget.warningimage);
//                         } else {
//                           getlogin();
//                         }
//                       },
//                       child: Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 40),
//                           child: Container(
//                               height: 50,
//                               width: MediaQuery.of(context).size.width,
//                               decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(30),
//                                   gradient: const LinearGradient(colors: [
//                                     Color(0xFF3674B5),
//                                     Color(0xFF3674B5),
//                                   ])),
//                               child: const Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   SizedBox(
//                                     width: 20,
//                                   ),
//                                   Text(
//                                     'Login',
//                                     style: TextStyle(
//                                         fontWeight: FontWeight.w500,
//                                         fontSize: 17,
//                                         color: Colors.white),
//                                   ),
//                                   SizedBox(
//                                     width: 20,
//                                   ),
//                                   Icon(
//                                     Icons.arrow_forward,
//                                     color: Colors.white,
//                                   )
//                                 ],
//                               ))),
//                     )),
//                 SizedBox(
//                   height: size.height * 0.04,
//                 ),
//               ],
//             ),
//             footerText(),
//             // Align(
//             //   alignment: Alignment.bottomCenter,
//             //   child: Image.asset(
//             //     "assets/images/nijalogo.png",
//             //     height: 80,
//             //     width: 130,
//             //   ),
//             // ),
//             FadeInUp(
//                 duration: const Duration(milliseconds: 1200),
//                 child: Container(
//                   height: MediaQuery.of(context).size.height / 3,
//                   decoration: const BoxDecoration(
//                       image: DecorationImage(
//                           image: AssetImage('assets/images/ePortal.png'),
//                           fit: BoxFit.fitWidth)),
//                 ))
//           ],
//         ),
//       ),
//     );
//   }

//   Widget logo(double height_, double width_) {
//     return Image.asset(
//       'assets/images/kpclogo.png',
//       height: height_,
//       width: width_,
//     );
//   }

//   Widget richText(double fontSize) {
//     return Text.rich(
//       TextSpan(
//         style: GoogleFonts.inter(
//           fontSize: fontSize,
//           color: const Color(0xFF21899C),
//           letterSpacing: 2.000000061035156,
//         ),
//         children: const [
//           TextSpan(
//             text: 'LOGIN',
//             style: TextStyle(
//               fontWeight: FontWeight.w800,
//             ),
//           ),
//           TextSpan(
//             text: 'PAGE',
//             style: TextStyle(
//               color: Color(0xFFFE9879),
//               fontWeight: FontWeight.w800,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget emailTextField(Size size) {
//     return Container(
//       alignment: Alignment.center,
//       height: size.height / 14,
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       decoration: BoxDecoration(
//         color: Colors.white70,
//         borderRadius: BorderRadius.circular(8.0),
//         border: Border.all(width: 0.5, color: Colors.grey),
//       ),
//       child: TextField(
//         controller: usernameController,
//         style: GoogleFonts.inter(
//           fontSize: 16.0,
//           color: const Color(0xFF15224F),
//         ),
//         maxLines: 1,
//         maxLength: 40,
//         cursorColor: const Color(0xFF15224F),
//         decoration: const InputDecoration(
//           counterText: "",
//           hintText: '',
//           border: InputBorder.none,
//         ),
//       ),
//     );
//   }

//   Widget passwordTextField(Size size) {
//     return Container(
//       alignment: Alignment.center,
//       height: size.height / 14,
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//       decoration: BoxDecoration(
//         color: Colors.white70,
//         borderRadius: BorderRadius.circular(8.0),
//         border: Border.all(width: 0.5, color: Colors.grey),
//       ),
//       child: TextField(
//         controller: passwordController,
//         maxLines: 1,
//         maxLength: 40,
//         obscureText: visiblepassword,
//         keyboardType: TextInputType.text,
//         cursorColor: const Color(0xFF15224F),
//         decoration: InputDecoration(
//           hintText: '',
//           border: InputBorder.none,
//           counterText: "",
//           suffixIcon: IconButton(
//             icon: Icon(
//               visiblepassword ? Icons.visibility : Icons.visibility_off,
//               color: Colors.black,
//             ),
//             onPressed: () {
//               // Update the state i.e. toogle the state of passwordVisible variable
//               setState(() {
//                 visiblepassword = !visiblepassword;
//               });
//             },
//           ),
//         ),
//       ),
//     );
//   }

//   Widget signInButton(Size size, context) {
//     return InkWell(
//         onTap: () async {
//           if (usernameController.text.isEmpty) {
//             AppUtils.showSingleDialogPopup(context, "Please Enter Username",
//                 "Ok", onexitpopup, AssetsImageWidget.warningimage);
//           } else if (usernameController.text.isEmpty) {
//             AppUtils.showSingleDialogPopup(context, "Please Enter Password",
//                 "Ok", onexitpopup, AssetsImageWidget.warningimage);
//           } else {
//             getlogin();
//           }
//         },
//         child: Container(
//           alignment: Alignment.center,
//           height: size.height / 14,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(50.0),
//             color: Colors.black,
//             boxShadow: [
//               BoxShadow(
//                 color: Appcolor.primarycolor,
//                 offset: const Offset(0, 15.0),
//                 blurRadius: 60.0,
//               ),
//             ],
//           ),
//           child: Text(
//             'Sign in',
//             style: GoogleFonts.inter(
//               fontSize: 16.0,
//               color: Colors.white,
//               fontWeight: FontWeight.w600,
//               height: 1.5,
//             ),
//             textAlign: TextAlign.center,
//           ),
//         ));
//   }

//   Widget footerText() {
//     return Text.rich(
//       TextSpan(
//         style: GoogleFonts.inter(
//           fontSize: 12.0,
//           color: const Color(0xFF3B4C68),
//         ),
//         children: [
//           const TextSpan(
//             text: 'Forgot your password ?',
//           ),
//           const TextSpan(
//             text: ' ',
//             style: TextStyle(
//               color: Color(0xFFFF5844),
//             ),
//           ),
//           TextSpan(
//               text: 'Click here',
//               style: const TextStyle(
//                 color: Color(0xFFFF5844),
//                 fontWeight: FontWeight.w700,
//               ),
//               recognizer: TapGestureRecognizer()
//                 ..onTap = () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => const ForgoPasswordPage()),
//                   );
//                 }),
//         ],
//       ),
//     );
//   }

//   void getlogin() async {
//     setState(() {
//       loading = true;
//     });
//     ApiService.getlogin(
//             usernameController.text, passwordController.text, deviceImei)
//         .then((response) {
//       setState(() {
//         loading = false;
//       });
//       if (response.statusCode == 200) {
//         if (jsonDecode(response.body)['status'].toString() == "true") {
//           loginModel = LoginModel.fromJson(jsonDecode(response.body));
//           if (loginModel.data!.mobileaccess.toString() == "false") {
//             AppUtils.showSingleDialogPopup(
//                 context,
//                 "You Are Not Authorised Mobile User. Please Contact Your Administrator!.",
//                 "Ok",
//                 onexitpopup,
//                 null);
//           } else {
//             addsharedpref(loginModel);
//           }
//         } else {
//           AppUtils.showSingleDialogPopup(
//               context,
//               jsonDecode(response.body)['message'],
//               "Ok",
//               onexitpopup,
//               AssetsImageWidget.errorimage);
//         }
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

//   Future addsharedpref(LoginModel model) async {
//     await Prefs.setLoggedIn(SharefprefConstants.sharefloggedin, true);
//     await Prefs.setFullName(
//         SharefprefConstants.shareFullName,
//         '${model.data!.firstName.toString()} '
//         ' ${model.data!.middleName.toString()} '
//         ' ${model.data!.lastName.toString()}');
//     await Prefs.setFirstName(
//         SharefprefConstants.shareFirstName, model.data!.firstName.toString());
//     await Prefs.setMiddleName(
//         SharefprefConstants.shareMiddleName, model.data!.middleName.toString());

//     await Prefs.setLastName(
//         SharefprefConstants.sharedLastName, model.data!.lastName.toString());
//     await Prefs.setTitle(
//         SharefprefConstants.sharedLastName, model.data!.title.toString());

//     await Prefs.setEmpID(
//         SharefprefConstants.sharedempId, model.data!.employeeCode!.toString());
//     await Prefs.setUniqId(
//         SharefprefConstants.shareduniqId, model.data!.sId.toString());
//     await Prefs.setUserName(SharefprefConstants.shareduserName,
//         model.data!.mobileusername.toString());
//     await Prefs.setToken(SharefprefConstants.sharedToken, "");
//     await Prefs.setDesignation(SharefprefConstants.shareddesignation, "");
//     await Prefs.setDept(
//         SharefprefConstants.shareddept, model.data!.department.toString());

//     await Prefs.setNsID(
//         SharefprefConstants.sharednsid, model.data!.nsId!.toString());

//     await Prefs.setShiftName(SharefprefConstants.sharedshiftName,
//         "GENERAL SHIFT (08:00 AM - 05:30 PM)");
//     await Prefs.setShiftFromTime(
//         SharefprefConstants.sharedShiftFromTime, "08:00 AM");
//     await Prefs.setShiftToTime(
//         SharefprefConstants.sharedShiftToTime, "05:30 PM");

//     await Prefs.setImageURL(
//         (model.data!.imageurl.toString() == "null" ||
//                 model.data!.imageurl.toString().isEmpty)
//             ? ""
//             : SharefprefConstants.sharedImgUrl,
//         model.data!.imageurl.toString());

//     await Prefs.setMobileNo(
//         SharefprefConstants.sharedMobNo, model.data!.mobileNo.toString());

//     await Prefs.setWorkRegion(SharefprefConstants.sharedWorkregion,
//         model.data!.workRegion.toString());

//     await Prefs.setLinemanager(
//         SharefprefConstants.sharedLineManager,
//         model.data!.linemanager.toString() == "null"
//             ? "-"
//             : model.data!.linemanager.toString());

//     await Prefs.setSupervisor(
//         SharefprefConstants.sharedsupervisor,
//         model.data!.supervisor.toString() == "null"
//             ? "-"
//             : model.data!.supervisor.toString());

//     await Prefs.sethod(
//         SharefprefConstants.sharedhod,
//         model.data!.hod.toString() == "null"
//             ? "-"
//             : model.data!.hod.toString());

//     await Prefs.setDeviceIdnetifier(SharefprefConstants.sharedDeviceID, "");
//     await Prefs.setPayGroupID(SharefprefConstants.sharedpaygroupid,
//         model.data!.paygroupId.toString());
//     await Prefs.setPayGroupName(SharefprefConstants.sharedpaygroupname,
//         model.data!.paygroupName.toString());

//     await Prefs.setEmail(
//         SharefprefConstants.sharedemailid, model.data!.mobileemail.toString());

//     await Prefs.setImei(SharefprefConstants.sharedimei, deviceImei);

//     await Prefs.setnetsuiteConsumerKey(
//         "netsuiteConsumerKey", model.secretkey![0].cONSUMERKEY.toString());
//     await Prefs.setnetsuiteConsumerSecret("netsuiteConsumerSecret",
//         model.secretkey![0].cONSUMERSECRET.toString());
//     await Prefs.setnetsuiteToken(
//         "netsuiteToken", model.secretkey![0].aCCESSTOKEN.toString());
//     await Prefs.setnetsuiteTokenSecret(
//         "netsuiteTokenSecret", model.secretkey![0].tOKENSECRET.toString());
//     await Prefs.setRealm("netSuiteRealm", model.secretkey![0].rEALM.toString());
//     //print(Prefs.getImageURL(SharefprefConstants.sharedImgUrl.toString()));

//     // await Prefs.setWorkingHours(
//     //     SharefprefConstants.sharedWorkhourslist,
//     //     model.message!.workingHours!.isEmpty
//     //         ? []
//     //         : model.message!.workingHours!.toList());

//     if (context.mounted) {
//       Navigator.pushNamedAndRemoveUntil(
//           context, RouteNames.landingpage, (Route<dynamic> route) => false);
//     }
//   }

//   void onexitpopup() {
//     Navigator.of(context).pop();
//   }
// }



import 'dart:convert';
import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:winstar/models/loginmodel.dart';
import 'package:winstar/routenames.dart';
import 'package:winstar/services/apiservice.dart';
import 'package:winstar/services/pref.dart';
import 'package:winstar/utils/app_utils.dart';
import 'package:winstar/utils/custom_indicatoronly.dart';
import 'package:winstar/utils/sharedprefconstants.dart';
import 'package:winstar/views/forgotpassword/forgotpassword.dart';
import 'package:winstar/views/widgets/assets_image_widget.dart';
import 'package:winstar/views/widgets/custom_scaffold.dart';
import 'package:unique_identifier/unique_identifier.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool loading = false;
  LoginModel loginModel = LoginModel();

  bool visiblepassword = true;
  String deviceImei = "";

  @override
  void initState() {
    super.initState();
    getdeviceid();
  }

  void getdeviceid() async {
    await getUniqueDeviceId();
  }

  Future<String> getUniqueDeviceId() async {
    String uniqueDeviceId = '';

    final deviceInfo = DeviceInfoPlugin();

    if (Platform.isIOS) {
      final iosDeviceInfo = await deviceInfo.iosInfo;
      uniqueDeviceId = '${iosDeviceInfo.identifierForVendor}';
    } else if (Platform.isAndroid) {
      try {
        uniqueDeviceId = (await UniqueIdentifier.serial).toString();
      } on PlatformException {
        uniqueDeviceId = 'Failed to get Unique Identifier';
      }
    }

    if (!mounted) return uniqueDeviceId;

    setState(() {
      deviceImei = uniqueDeviceId;
    });

    return uniqueDeviceId;
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return CustomScaffold(
      child: loading
          ? const CustomIndicator()
          : SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),

                      // Header
                      Text(
                        "Welcome Back 👋",
                        style: GoogleFonts.inter(
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Login to continue",
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black54,
                        ),
                      ),

                      const SizedBox(height: 22),

                      // Card
                      buildCard(size, context),

                      const SizedBox(height: 20),

                      // Bottom Illustration
                      FadeInUp(
                        duration: const Duration(milliseconds: 1200),
                        child: Container(
                          height: size.height * 0.30,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images/ePortal.png'),
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget buildCard(Size size, BuildContext context) {
    return FadeInUp(
      duration: const Duration(milliseconds: 900),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Device ID Section
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF4F6FB),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.black12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.phonelink_lock, size: 18),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      deviceImei.isEmpty
                          ? "Fetching Device ID..."
                          : deviceImei,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () async {
                      final textToCopy = deviceImei;
                      if (textToCopy.isNotEmpty) {
                        try {
                          await Clipboard.setData(
                              ClipboardData(text: textToCopy));
                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Device ID Copied!')),
                          );
                        } catch (e) {
                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Failed to copy to clipboard.')),
                          );
                        }
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.black12),
                      ),
                      child: const Icon(Icons.copy, size: 18),
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 18),

            Text(
              "Email / Username",
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            emailTextField(size),

            const SizedBox(height: 16),

            Text(
              "Password",
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            passwordTextField(size),

            const SizedBox(height: 22),

            // Login Button
            InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: () {
                if (usernameController.text.trim().isEmpty) {
                  AppUtils.showSingleDialogPopup(
                    context,
                    "Please Enter Username",
                    "Ok",
                    onexitpopup,
                    AssetsImageWidget.warningimage,
                  );
                } else if (passwordController.text.trim().isEmpty) {
                  // ✅ FIXED BUG (was checking username again)
                  AppUtils.showSingleDialogPopup(
                    context,
                    "Please Enter Password",
                    "Ok",
                    onexitpopup,
                    AssetsImageWidget.warningimage,
                  );
                } else {
                  getlogin();
                }
              },
              child: Container(
                height: 54,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF3674B5),
                      Color(0xFF1E4E89),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF3674B5).withOpacity(0.35),
                      blurRadius: 18,
                      offset: const Offset(0, 10),
                    )
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Login",
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Icon(Icons.arrow_forward_rounded,
                        color: Colors.white),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 18),

            Center(child: footerText()),
          ],
        ),
      ),
    );
  }

  Widget emailTextField(Size size) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black12),
      ),
      child: Row(
        children: [
          const Icon(Icons.mail_outline, size: 20, color: Colors.black54),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: usernameController,
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF15224F),
              ),
              maxLines: 1,
              maxLength: 40,
              cursorColor: const Color(0xFF15224F),
              decoration: InputDecoration(
                counterText: "",
                hintText: "Enter your email",
                hintStyle: GoogleFonts.inter(
                  fontSize: 14,
                  color: Colors.black38,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget passwordTextField(Size size) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black12),
      ),
      child: Row(
        children: [
          const Icon(Icons.lock_outline, size: 20, color: Colors.black54),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: passwordController,
              maxLines: 1,
              maxLength: 40,
              obscureText: visiblepassword,
              keyboardType: TextInputType.text,
              cursorColor: const Color(0xFF15224F),
              decoration: InputDecoration(
                hintText: "Enter your password",
                hintStyle: GoogleFonts.inter(
                  fontSize: 14,
                  color: Colors.black38,
                ),
                border: InputBorder.none,
                counterText: "",
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              visiblepassword ? Icons.visibility : Icons.visibility_off,
              color: Colors.black54,
            ),
            onPressed: () {
              setState(() {
                visiblepassword = !visiblepassword;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget footerText() {
    return Text.rich(
      TextSpan(
        style: GoogleFonts.inter(
          fontSize: 12.5,
          color: Colors.black54,
          fontWeight: FontWeight.w500,
        ),
        children: [
          const TextSpan(text: 'Forgot your password? '),
          TextSpan(
            text: 'Click here',
            style: GoogleFonts.inter(
              color: const Color(0xFFFF5844),
              fontWeight: FontWeight.w800,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ForgoPasswordPage(),
                  ),
                );
              },
          ),
        ],
      ),
    );
  }

  // ---------------------------
  // 🔥 YOUR SAME LOGIN LOGIC
  // ---------------------------

  void getlogin() async {
    setState(() {
      loading = true;
    });

    ApiService.getlogin(
      usernameController.text,
      passwordController.text,
      deviceImei,
    ).then((response) {
      setState(() {
        loading = false;
      });

      if (response.statusCode == 200) {
        if (jsonDecode(response.body)['status'].toString() == "true") {
          loginModel = LoginModel.fromJson(jsonDecode(response.body));

          if (loginModel.data!.mobileaccess.toString() == "false") {
            AppUtils.showSingleDialogPopup(
              context,
              "You Are Not Authorised Mobile User. Please Contact Your Administrator!.",
              "Ok",
              onexitpopup,
              null,
            );
          } else {
            addsharedpref(loginModel);
          }
        } else {
          AppUtils.showSingleDialogPopup(
            context,
            jsonDecode(response.body)['message'],
            "Ok",
            onexitpopup,
            AssetsImageWidget.errorimage,
          );
        }
      } else {
        throw Exception(jsonDecode(response.body)['message'].toString());
      }
    }).catchError((e) {
      setState(() {
        loading = false;
      });

      AppUtils.showSingleDialogPopup(
        context,
        e.toString(),
        "Ok",
        onexitpopup,
        AssetsImageWidget.errorimage,
      );
    });
  }

  Future addsharedpref(LoginModel model) async {
    await Prefs.setLoggedIn(SharefprefConstants.sharefloggedin, true);

    await Prefs.setFullName(
      SharefprefConstants.shareFullName,
      '${model.data!.firstName.toString()} '
      ' ${model.data!.middleName.toString()} '
      ' ${model.data!.lastName.toString()}',
    );

    await Prefs.setFirstName(
        SharefprefConstants.shareFirstName, model.data!.firstName.toString());

    await Prefs.setMiddleName(SharefprefConstants.shareMiddleName,
        model.data!.middleName.toString());

    await Prefs.setLastName(
        SharefprefConstants.sharedLastName, model.data!.lastName.toString());

    await Prefs.setTitle(
        SharefprefConstants.sharedLastName, model.data!.title.toString());

    await Prefs.setEmpID(SharefprefConstants.sharedempId,
        model.data!.employeeCode!.toString());

    await Prefs.setUniqId(
        SharefprefConstants.shareduniqId, model.data!.sId.toString());

    await Prefs.setUserName(SharefprefConstants.shareduserName,
        model.data!.mobileusername.toString());

    await Prefs.setToken(SharefprefConstants.sharedToken, "");
    await Prefs.setDesignation(SharefprefConstants.shareddesignation, "");

    await Prefs.setDept(
        SharefprefConstants.shareddept, model.data!.department.toString());

    await Prefs.setNsID(
        SharefprefConstants.sharednsid, model.data!.nsId!.toString());

    await Prefs.setShiftName(
        SharefprefConstants.sharedshiftName,
        "GENERAL SHIFT (08:00 AM - 05:30 PM)");

    await Prefs.setShiftFromTime(
        SharefprefConstants.sharedShiftFromTime, "08:00 AM");

    await Prefs.setShiftToTime(
        SharefprefConstants.sharedShiftToTime, "05:30 PM");

    await Prefs.setImageURL(
      (model.data!.imageurl.toString() == "null" ||
              model.data!.imageurl.toString().isEmpty)
          ? ""
          : SharefprefConstants.sharedImgUrl,
      model.data!.imageurl.toString(),
    );

    await Prefs.setMobileNo(
        SharefprefConstants.sharedMobNo, model.data!.mobileNo.toString());

    await Prefs.setWorkRegion(SharefprefConstants.sharedWorkregion,
        model.data!.workRegion.toString());

    await Prefs.setLinemanager(
      SharefprefConstants.sharedLineManager,
      model.data!.linemanager.toString() == "null"
          ? "-"
          : model.data!.linemanager.toString(),
    );

    await Prefs.setSupervisor(
      SharefprefConstants.sharedsupervisor,
      model.data!.supervisor.toString() == "null"
          ? "-"
          : model.data!.supervisor.toString(),
    );

    await Prefs.sethod(
      SharefprefConstants.sharedhod,
      model.data!.hod.toString() == "null" ? "-" : model.data!.hod.toString(),
    );

    await Prefs.setDeviceIdnetifier(SharefprefConstants.sharedDeviceID, "");

    await Prefs.setPayGroupID(SharefprefConstants.sharedpaygroupid,
        model.data!.paygroupId.toString());

    await Prefs.setPayGroupName(SharefprefConstants.sharedpaygroupname,
        model.data!.paygroupName.toString());

    await Prefs.setEmail(
        SharefprefConstants.sharedemailid, model.data!.mobileemail.toString());

    await Prefs.setImei(SharefprefConstants.sharedimei, deviceImei);

    await Prefs.setnetsuiteConsumerKey(
        "netsuiteConsumerKey", model.secretkey![0].cONSUMERKEY.toString());

    await Prefs.setnetsuiteConsumerSecret("netsuiteConsumerSecret",
        model.secretkey![0].cONSUMERSECRET.toString());

    await Prefs.setnetsuiteToken(
        "netsuiteToken", model.secretkey![0].aCCESSTOKEN.toString());

    await Prefs.setnetsuiteTokenSecret(
        "netsuiteTokenSecret", model.secretkey![0].tOKENSECRET.toString());

    await Prefs.setRealm(
        "netSuiteRealm", model.secretkey![0].rEALM.toString());

    if (context.mounted) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        RouteNames.landingpage,
        (Route<dynamic> route) => false,
      );
    }
  }

  void onexitpopup() {
    Navigator.of(context).pop();
  }
}
