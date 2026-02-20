import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:powergroupess/routenames.dart';
import 'package:powergroupess/routes.dart';
import 'package:powergroupess/services/pref.dart';
import 'package:powergroupess/utils/appcolor.dart';
import 'package:powergroupess/views/widgets/custom_widgets.dart';
import 'package:powergroupess/views/widgets/network_status_service.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  // SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
  //   statusBarColor: Appcolor.primary,
  //   statusBarIconBrightness: Brightness.light,
  //   systemNavigationBarColor: Colors.white,
  //   systemNavigationBarIconBrightness: Brightness.dark,
  // ));
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
          initialData: NetworkStatus.Online,
        ),
      ],
      child: MaterialApp(
        initialRoute: RouteNames.splashscreen,
        onGenerateRoute: Routes.generateRoutes,
        theme: ThemeData(
          // scaffoldBackgroundColor: const Color(0xFFEFEFEF),
          textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
          primarySwatch: Colors.blue,
          fontFamily: GoogleFonts.montserrat().fontFamily,
          appBarTheme: AppBarTheme(
            surfaceTintColor: Colors.transparent,

              iconTheme: const IconThemeData(color: Colors.red),
              centerTitle: false,
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
