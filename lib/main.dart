import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bindhaeness/routenames.dart';
import 'package:bindhaeness/routes.dart';
import 'package:bindhaeness/services/idletimeoutservice.dart';
import 'package:bindhaeness/services/pref.dart';
import 'package:bindhaeness/utils/appcolor.dart';
import 'package:bindhaeness/views/widgets/custom_widgets.dart';
import 'package:bindhaeness/views/widgets/network_status_service.dart';
import 'package:provider/provider.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
IdleTimeoutService idleService = IdleTimeoutService();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  ErrorWidget.builder = (FlutterErrorDetails details) {
    return CustomErrorWidget(errorMessage: details.exceptionAsString());
  };
  await Prefs.init();
  // PackageInfo packageInfo = await PackageInfo.fromPlatform();
  // print(packageInfo.packageName);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<NetworkStatus>(
          create: (context) =>
              NetworkStatusService().networkStatusController.stream,
          initialData: NetworkStatus.online,
        ),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        initialRoute: RouteNames.splashscreen,
        onGenerateRoute: Routes.generateRoutes,
        theme: ThemeData(
          textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
          primaryColor: Appcolor.primarycolor,
          fontFamily: GoogleFonts.zhiMangXing().fontFamily,
          appBarTheme: const AppBarTheme(
              iconTheme: IconThemeData(color: Colors.black),
              centerTitle: false,
              actionsIconTheme: IconThemeData(color: Colors.black),
              elevation: 2,
              backgroundColor: Colors.white),
          cardTheme: const CardThemeData(
              elevation: 1,
              surfaceTintColor: Colors.white,
              color: Colors.white),
        ),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
