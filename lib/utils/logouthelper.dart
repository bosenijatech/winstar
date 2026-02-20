// import 'package:flutter/material.dart';
// import 'package:winstar/views/login/loginpage.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class LogoutHelper {
//   static Future<void> forceLogout(BuildContext context) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.clear(); // clear all saved data

//     Navigator.of(context).pushAndRemoveUntil(
//       MaterialPageRoute(builder: (_) => const LoginPage()),
//       (route) => false,
//     );
//   }
// }
