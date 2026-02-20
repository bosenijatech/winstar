// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:winstar/routenames.dart';
// import 'package:winstar/services/pref.dart';
// import 'package:winstar/utils/app_utils.dart';
// import 'package:winstar/utils/appcolor.dart';
// import 'package:winstar/utils/sharedprefconstants.dart';
// import 'package:winstar/views/login/loginpage.dart';
// import 'package:winstar/views/widgets/custom_scaffold.dart';
// import 'package:winstar/views/widgets/customappbar.dart';
// import 'package:winstar/views/widgets/menuwidget.dart';
// import 'package:winstar/views/widgets/notificationtitle.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter_settings_ui/flutter_settings_ui.dart';

// class NotificationPage extends StatefulWidget {
//   const NotificationPage({super.key});

//   @override
//   _NotificationPageState createState() => _NotificationPageState();
// }

// class _NotificationPageState extends State<NotificationPage> {
//   // List<UserNotification> listNotification =
//   //     NotificationService.listNotification;
//   @override
//   Widget build(BuildContext context) {
//     return CustomScaffold(child: settingsList(context));
//   }

//   Widget settingsList(context) {
//     return SettingsList(
//       sections: [
//         // SettingsSection(
//         //   title: const Text('Common'),
//         //   tiles: <SettingsTile>[
//         //     SettingsTile.navigation(
//         //       leading: const Icon(Icons.language),
//         //       title: const Text('Language'),
//         //       value: const Text('English'),
//         //     ),
//         //     SettingsTile.switchTile(
//         //       activeSwitchColor: Appcolor.primarycolor,
//         //       onToggle: (value) {},
//         //       initialValue: true,
//         //       leading: const Icon(
//         //         Icons.notifications,
//         //       ),
//         //       title: const Text('Notification'),
//         //     ),
//         //   ],
//         // ),
//         SettingsSection(
//           title: const Text('Security'),
//           tiles: <SettingsTile>[
//             SettingsTile.navigation(
//               onPressed: (context) =>
//                   {Navigator.pushNamed(context, RouteNames.changepassword)},
//               leading: const Icon(Icons.password),
//               title: const Text('Change Password'),
//               value: const Text('change your password'),
//             ),
//             SettingsTile.navigation(
//               onPressed: (context) => {
//                 AppUtils.showconfirmDialog(
//                     context, "Are you  sure want to logout?", "Yes", "No", () {
//                   Prefs.clear();
//                   Navigator.of(context).pushAndRemoveUntil(
//                       MaterialPageRoute(
//                           builder: (context) => const LoginPage()),
//                       (Route<dynamic> route) => false);
//                 }, () {
//                   AppUtils.pop(context);
//                 })
//               },
//               leading: SvgPicture.asset(
//                 'assets/icons/logout.svg',
//                 color: Colors.red,
//               ),
//               title: const Text('Logout'),
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget settingsPage() {
//     return SizedBox(
//       height: MediaQuery.of(context).size.height / 3,
//       child: ListView(
//         shrinkWrap: true,
//         physics: const BouncingScrollPhysics(),
//         children: [
//           Container(
//             width: MediaQuery.of(context).size.width,
//             margin: const EdgeInsets.only(top: 24),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Container(
//                   margin: const EdgeInsets.only(left: 16),
//                   child: Text(
//                     'SETTINGS',
//                     style: TextStyle(
//                         color: Appcolor.black.withOpacity(0.5),
//                         letterSpacing: 6 / 100,
//                         fontWeight: FontWeight.w600),
//                   ),
//                 ),
//                 MenuTileWidget(
//                   onTap: () {},
//                   margin: const EdgeInsets.only(top: 10),
//                   icon: SvgPicture.asset(
//                     'assets/icons/Filter.svg',
//                     color: Appcolor.black.withOpacity(0.5),
//                   ),
//                   title: 'Languages',
//                   subtitle: 'Change Your Prefer Language',
//                 ),
//                 MenuTileWidget(
//                   onTap: () {
//                     Prefs.clear();
//                     Prefs.remove("remove");
//                     Prefs.setLoggedIn(
//                         SharefprefConstants.sharefloggedin, false);
//                     Navigator.pushNamedAndRemoveUntil(
//                         context,
//                         RouteNames.loginscreen,
//                         (Route<dynamic> route) => false);
//                   },
//                   icon: SvgPicture.asset(
//                     'assets/icons/logout.svg',
//                     color: Colors.red,
//                   ),
//                   iconBackground: Colors.red.shade100,
//                   title: 'Log Out',
//                   titleColor: Colors.red,
//                 ),
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }

//   Widget notificationdetails() {
//     return ListView(
//       shrinkWrap: true,
//       physics: const BouncingScrollPhysics(),
//       children: [
//         Container(
//           width: MediaQuery.of(context).size.width,
//           padding: const EdgeInsets.symmetric(vertical: 16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Container(
//                 margin: const EdgeInsets.only(left: 16, bottom: 8),
//                 child: Text(
//                   'NOTIFICATION DETAILS',
//                   style: TextStyle(
//                       color: Appcolor.black.withOpacity(0.5),
//                       letterSpacing: 6 / 100,
//                       fontWeight: FontWeight.w600),
//                 ),
//               ),
//               ListView.builder(
//                 itemBuilder: (context, index) {
//                   return NotificationTile(
//                     data: "Notification",
//                     onTap: () {},
//                   );
//                 },
//                 itemCount: 2,
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//               ),
//             ],
//           ),
//         )
//       ],
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:winstar/routenames.dart';
import 'package:winstar/services/pref.dart';
import 'package:winstar/utils/app_utils.dart';
import 'package:winstar/utils/appcolor.dart';
import 'package:winstar/views/login/loginpage.dart';
import 'package:winstar/views/widgets/custom_scaffold.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: SafeArea(
        child: Column(
          children: [
         
            Expanded(child: _settingsList(context)),
          ],
        ),
      ),
    );
  }

  // ---------------------------
  // TOP HEADER UI
  // ---------------------------

  // ---------------------------
  // SETTINGS LIST (Enhanced UI)
  // ---------------------------
  Widget _settingsList(BuildContext context) {
    return SettingsList(
      physics: const BouncingScrollPhysics(),
      lightTheme: SettingsThemeData(
        settingsListBackground: Colors.transparent,
        settingsSectionBackground: Colors.white,
        dividerColor: Colors.grey.shade200,
        tileDescriptionTextColor: Colors.grey.shade600,
        tileHighlightColor: Appcolor.primarycolor.withOpacity(0.08),
        titleTextColor: Appcolor.black,
        leadingIconsColor: Appcolor.primarycolor,
        settingsTileTextColor: Appcolor.black,
      ),
      sections: [
        SettingsSection(
        
          tiles: <SettingsTile>[
            // Change Password
            SettingsTile.navigation(
              onPressed: (context) =>
                  Navigator.pushNamed(context, RouteNames.changepassword),
              leading: _leadingIconBox(
                icon: Icons.password_rounded,
                bgColor: Appcolor.primarycolor.withOpacity(0.10),
                iconColor: Appcolor.primarycolor,
              ),
              title: const Text(
                'Change Password',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
              ),
              description: const Text(
                'Update your password for better security',
                style: TextStyle(fontSize: 13),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: Colors.grey.shade500,
              ),
            ),

            // Logout
            SettingsTile.navigation(
              onPressed: (context) {
                AppUtils.showconfirmDialog(
                  context,
                  "Are you sure want to logout?",
                  "Yes",
                  "No",
                  () {
                    Prefs.clear();
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => const LoginPage()),
                      (Route<dynamic> route) => false,
                    );
                  },
                  () {
                    AppUtils.pop(context);
                  },
                );
              },
              leading: _svgLeadingIconBox(
                assetPath: 'assets/icons/logout.svg',
                bgColor: Colors.red.withOpacity(0.10),
                iconColor: Colors.red,
              ),
              title: const Text(
                'Logout',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: Colors.red,
                ),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: Colors.red.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ---------------------------
  // ICON UI HELPERS
  // ---------------------------
  Widget _leadingIconBox({
    required IconData icon,
    required Color bgColor,
    required Color iconColor,
  }) {
    return Container(
      height: 42,
      width: 42,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, size: 22, color: iconColor),
    );
  }

  Widget _svgLeadingIconBox({
    required String assetPath,
    required Color bgColor,
    required Color iconColor,
  }) {
    return Container(
      height: 42,
      width: 42,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: SvgPicture.asset(
          assetPath,
          height: 20,
          width: 20,
          color: iconColor,
        ),
      ),
    );
  }
}
