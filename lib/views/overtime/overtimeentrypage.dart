import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:bindhaeness/services/apiservice.dart';
import 'package:bindhaeness/services/pref.dart';
import 'package:bindhaeness/utils/app_utils.dart';
import 'package:bindhaeness/utils/appcolor.dart';
import 'package:bindhaeness/utils/sharedprefconstants.dart';
import 'package:bindhaeness/views/attendance/clock_widgets.dart';
import 'package:bindhaeness/views/googlemapslocation/addressservices.dart';
import 'package:bindhaeness/views/widgets/assets_image_widget.dart';
import 'package:bindhaeness/views/widgets/custom_button.dart';
import 'package:location/location.dart' as loca;
import 'package:http/http.dart' as http;

class OvertimeEntryPage extends StatefulWidget {
  final String sid;
  final String name;
  final bool checkin;
  final bool checkout;
  const OvertimeEntryPage(
      {super.key,
      required this.sid,
      required this.name,
      required this.checkin,
      required this.checkout});

  @override
  State<OvertimeEntryPage> createState() => _AttendanceEntryPageState();
}

class _AttendanceEntryPageState extends State<OvertimeEntryPage>
    with WidgetsBindingObserver {
  late LatLng latlong = const LatLng(0.0, 0.0);
  late GoogleMapController _controller;
  final Set<Marker> _markers = {};
  TextEditingController locationController = TextEditingController();
  bool loading = false;
  var address = "";
  var latLngController = "";

  String? alterlatitude = "";
  String? alterlongitude = "";

  //String currenttime = DateFormat("hh:mm:ss a").format(DateTime.now());
  String? currenttime;
  bool? serviceEnabled;
  LocationPermission? permission;
  final LocationService _locationService = LocationService();
  bool islocationenable = false;
  var apiKey = "AIzaSyDBXWcq_Sktyydrst_LhQUeMIt1dQnI7Zs";
  @override
  void initState() {
    // currenttime =
    //     "${DateTime.now().hour} : ${DateTime.now().minute} :${DateTime.now().second}";
    // Timer.periodic(const Duration(seconds: 1), (Timer t) => _getCurrentTime());
    getall();
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    loading = false;
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        onResumed();
        break;
      default:
    }
  }

  void getall() async {
    requestLocationPermission();
  }

  Future<void> requestLocationPermission() async {
    loca.Location location = loca.Location();
    bool ison = await location.serviceEnabled();
    if (!ison) {
      bool isturnedon = await location.requestService();
      if (isturnedon) {
        getLocation();
      } else {}
    } else {
      //Already GPS TURN ON
      getLocation();
    }
  }

  void onResumed() {
    getall();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            icon: const Icon(CupertinoIcons.back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: AppUtils.buildNormalText(
              text: widget.name, color: Colors.black, fontSize: 20),
          centerTitle: true,
        ),
        body: Stack(children: [
          (latlong.latitude > 0.0 && latlong.longitude > 0.0 && !loading)
              ? GoogleMap(
                  initialCameraPosition:
                      CameraPosition(target: latlong, zoom: 17),
                  onMapCreated: (GoogleMapController controller) {
                    _controller = (controller);
                    _controller.animateCamera(CameraUpdate.newCameraPosition(
                        CameraPosition(target: latlong, zoom: 17)));
                  },
                  markers: _markers,
                )
              : Center(
                  child: CupertinoActivityIndicator(
                      radius: 30.0, color: Appcolor.primarycolor),
                ),
          (latlong.latitude > 0.0 && latlong.longitude > 0.0)
              ? Positioned(
                  left: 0.0,
                  right: 0.0,
                  bottom: 0.0,
                  child: Container(
                    height: 200,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5.0),
                          topRight: Radius.circular(5.0)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5.0, vertical: 5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 10.0,
                          ),
                          Row(
                            children: [
                              const Icon(Icons.location_pin),
                              Flexible(
                                child: AppUtils.buildNormalText(
                                    text: address.toString(),
                                    fontSize: 14,
                                    maxLines: 3),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // AppUtils.buildNormalText(
                                    //     text: ClockWidget,
                                    //     fontSize: 20,
                                    //     fontWeight: FontWeight.bold),
                                    const ClockWidget(),
                                    const SizedBox(height: 5),
                                    AppUtils.buildNormalText(
                                        text: DateFormat.yMMMMEEEEd()
                                            .format(DateTime.now()),
                                        fontSize: 14)
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    Visibility(
                                        visible: widget.checkin &&
                                            address.isNotEmpty,
                                        child: CustomButton(
                                          onPressed: () {
                                            addattendance("IN");
                                          },
                                          name: "Clock In",
                                          circularvalue: 30,
                                          fontSize: 16,
                                        )),
                                    const SizedBox(height: 5),
                                    Visibility(
                                        visible: widget.checkout,
                                        child: CustomButton(
                                          onPressed: () {
                                            latlong.latitude > 0.0 &&
                                                    latlong.longitude > 0.0
                                                ? onupdateattendance("OUT")
                                                : null;
                                          },
                                          name: "Clock Out",
                                          circularvalue: 30,
                                          fontSize: 16,
                                        ))
                                  ],
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                )
              : Container()
        ]));
  }

  getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      latlong = LatLng(position.latitude, position.longitude);

      if (latlong.latitude > 0 && latlong.longitude > 0) {
        _markers.add(Marker(
            markerId: const MarkerId("a"),
            draggable: true,
            position: latlong,
            icon:
                BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
            onDragEnd: (currentlatLng) {
              latlong = currentlatLng;
            }));
      }
      loading = false;
    });
    latLngController =
        ("${position.latitude},${position.longitude}").toString();
    alterlatitude = position.latitude.toString();
    alterlongitude = position.longitude.toString();
    _getAddressFromLatLng(position.latitude, position.longitude, position);
    // setState(() {
    //   address = "Fetching address...";
    // });

    // try {
    //   final newaddress = await _locationService.getAddressFromLatLng(
    //       position.latitude, position.longitude);
    //   setState(() {
    //     address = newaddress;
    //   });
    // } catch (e) {
    //   setState(() {
    //     address = "Error: $e";
    //   });
    // }
  }

  // Future<void> _getAddressFromLatLng(lat, lang, Position position) async {
  //   await placemarkFromCoordinates(position.latitude, position.longitude)
  //       .then((List<Placemark> placemarks) {
  //     Placemark place = placemarks[0];
  //     alterlatitude = position.latitude.toString();
  //     alterlongitude = position.longitude.toString();
  //     setState(() {
  //       var currentAddress =
  //           '${place.street}, ${place.subLocality}, ${place.locality},${place.administrativeArea}, ${place.postalCode}';
  //       locationController.text = currentAddress;
  //       address = currentAddress;
  //       setState(() {
  //         loading = false;
  //       });
  //     });
  //   }).catchError((e) {
  //     debugPrint(e);
  //   });
  // }

  // Future<String> _getAddressFromLatLng(
  //     double lat, double long, Position position) async {
  //   try {
  //     List<Placemark> placemarks =
  //         await placemarkFromCoordinates(position.latitude, position.longitude);

  //     var currentAddress = '';

  //     if (placemarks.isNotEmpty) {
  //       // Concatenate non-null components of the address
  //       var streets = placemarks.reversed
  //           .map((placemark) => placemark.street)
  //           .where((street) => street != null);

  //       // Filter out unwanted parts
  //       streets = streets.where((street) =>
  //           street!.toLowerCase() !=
  //           placemarks.reversed.last.locality!
  //               .toLowerCase()); // Remove city names
  //       streets = streets
  //           .where((street) => !street!.contains('+')); // Remove street codes

  //       currentAddress += streets.join(', ');

  //       currentAddress += ', ${placemarks.reversed.last.subLocality ?? ''}';
  //       currentAddress += ', ${placemarks.reversed.last.locality ?? ''}';
  //       currentAddress +=
  //           ', ${placemarks.reversed.last.subAdministrativeArea ?? ''}';
  //       currentAddress +=
  //           ', ${placemarks.reversed.last.administrativeArea ?? ''}';
  //       currentAddress += ', ${placemarks.reversed.last.postalCode ?? ''}';
  //       currentAddress += ', ${placemarks.reversed.last.country ?? ''}';

  //       locationController.text = currentAddress;
  //       address = currentAddress;
  //       setState(() {
  //         loading = false;
  //       });
  //     }

  //     print("Your Address for ($lat, $long) is: $address");

  //     return address;
  //   } catch (e) {
  //     print("Error getting placemarks: $e");
  //     return "No Address";
  //   }
  // }

  Future<String> _getAddressFromLatLng(
      double lat, double lng, Position position) async {
    setState(() {
      loading = true;
    });
    final String url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$apiKey";
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data["status"] == "OK") {
          final results = data["results"];
          setState(() {
            loading = false;
          });
          if (results.isNotEmpty) {
            locationController.text = results[0]["formatted_address"];
            address = results[0]["formatted_address"];
            return results[0]["formatted_address"];
          } else {
            setState(() {
              loading = false;
            });
            return "No results found";
          }
        } else {
          setState(() {
            loading = false;
          });
          return "Error: ${data["status"]}";
        }
      } else {
        setState(() {
          loading = false;
        });
        return "HTTP Error: ${response.statusCode}";
      }
    } catch (e) {
      setState(() {
        loading = false;
      });
      return "Error: $e";
    }
  }

  void addattendance(type) async {
    String cdate = DateFormat("yyyy-MM-dd").format(DateTime.now());
    //hh:mm a  is an am PM
    String cdatetime = DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now());
    String ctime = DateFormat("hh:mm a").format(DateTime.now());

    var json = {
      "emp_code": Prefs.getEmpID('empID'),
      "docdate": cdate,
      "from_latitude": alterlatitude,
      "from_longitude": alterlongitude,
      "from_gps_address": address.toString(),
      "punch_in_time": cdatetime,
      "source": "Mob",
      "nsId": Prefs.getNsID('nsid'),
      "createdbyname": Prefs.getFullName('Name'),
      "createdDate": cdatetime,
      "punchTime": ctime,
      "mobileid": Prefs.getImei(SharefprefConstants.sharedimei)
    };
    print(jsonEncode(json));

    setState(() {
      loading = true;
    });
    ApiService.postovertimeAttendance(json).then((response) {
      setState(() {
        loading = false;
      });
      if (response.statusCode == 200) {
        if (jsonDecode(response.body)['status'].toString() == "true") {
          Prefs.setLogonTime("LogonTime", cdatetime);
          AppUtils.showSingleDialogPopup(
              context,
              jsonDecode(response.body)['message'],
              "Ok",
              onrefreshscreen,
              AssetsImageWidget.successimage);
        } else {
          AppUtils.showSingleDialogPopup(
              context,
              jsonDecode(response.body)['message'],
              "Ok",
              onexitpopup,
              AssetsImageWidget.errorimage);
        }
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

  void onupdateattendance(type) async {
    String cdate = DateFormat("yyyy-MM-dd").format(DateTime.now());
    //hh:mm a  is an am PM
    String cdatetime = DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now());
    String ctime = DateFormat("hh:mm a").format(DateTime.now());

    var json = {
      "_id": widget.sid,
      "to_latitude": alterlatitude,
      "to_longitude": alterlongitude,
      "to_gps_address": address.toString(),
      "punch_out_time": cdatetime,
      "createdby": Prefs.getNsID('nsid'),
      "createdbyname": Prefs.getFullName('Name'),
      "punchTime": ctime,
      "bioDate": cdate,
      "mobileid": Prefs.getImei(SharefprefConstants.sharedimei)
    };

    setState(() {
      loading = true;
    });
    ApiService.updateovertimeAttendance(json).then((response) {
      setState(() {
        loading = false;
      });
      if (response.statusCode == 200) {
        if (jsonDecode(response.body)['status'].toString() == "true") {
          AppUtils.showSingleDialogPopup(
              context,
              jsonDecode(response.body)['message'],
              "Ok",
              onrefreshscreen,
              AssetsImageWidget.successimage);
        } else {
          AppUtils.showSingleDialogPopup(
              context,
              jsonDecode(response.body)['message'],
              "Ok",
              onexitpopup,
              AssetsImageWidget.errorimage);
        }
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

  void onexitpopup() {
    Navigator.of(context).pop();
  }

  void onrefreshscreen() {
    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }
}
