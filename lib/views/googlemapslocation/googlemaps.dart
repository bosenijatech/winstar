import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:winstar/utils/app_utils.dart';
import 'package:winstar/utils/appcolor.dart';
import 'package:winstar/utils/constants.dart';
import 'package:permission_handler/permission_handler.dart' as handler;
import 'package:intl/intl.dart';
import 'package:location/location.dart' as loca;

class GoogleMapsPage extends StatefulWidget {
  late double lati;
  late double longi;
  late String address;
  late String time;
  late String type;
  GoogleMapsPage({
    super.key,
    required this.lati,
    required this.longi,
    required this.address,
    required this.time,
    required this.type,
  });

  @override
  GoogleMapsPageState createState() => GoogleMapsPageState();
}

class GoogleMapsPageState extends State<GoogleMapsPage> {
  // LatLng initialLocation = const LatLng(37.422131, -122.084801);
  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;
  late LatLng latlong = const LatLng(0.0, 0.0);
  bool loading = false;
  late GoogleMapController _controller;
  @override
  void initState() {
    getall();

    super.initState();
  }

  void getall() async {
    requestCameraPermission();
  }

  Future<void> requestCameraPermission() async {
    final serviceStatus = await handler.Permission.camera.isGranted;

    //bool isCameraOn = serviceStatus == ServiceStatus.enabled;

    final status = await handler.Permission.location.request();

    if (status == handler.PermissionStatus.granted) {
      requestLocationPermission();
      //print()
    } else if (status == handler.PermissionStatus.denied) {
      print('Permission denied');
    } else if (status == handler.PermissionStatus.permanentlyDenied) {
      print('Permission Permanently Denied');
      await handler.openAppSettings();
    }
  }

  Future<void> requestLocationPermission() async {
    final serviceStatusLocation =
        await handler.Permission.locationWhenInUse.isGranted;

    bool isLocation = serviceStatusLocation == handler.ServiceStatus.enabled;

    final status = await handler.Permission.locationWhenInUse.request();

    if (status == handler.PermissionStatus.granted) {
      loca.Location location = loca.Location();
      bool ison = await location.serviceEnabled();
      //print(ison);
      if (!ison) {
        bool isturnedon = await location.requestService();
        if (isturnedon) {
          addCustomIcon();
        } else {
          //onrefreshscreen();
        }
      } else {
        addCustomIcon();
      }
    } else if (status == handler.PermissionStatus.denied) {
      print('Permission denied');
    } else if (status == handler.PermissionStatus.permanentlyDenied) {
      print('Permission Permanently Denied');
      await handler.openAppSettings();
    }
  }

  void addCustomIcon() async {
    markerIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(50, 50)),
        'assets/icons/location_marker.png');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            icon: const Icon(CupertinoIcons.back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: AppUtils.buildNormalText(
              text: "Location Details", color: Colors.black, fontSize: 20),
          centerTitle: true,
        ),
        body: !loading
            ? Stack(
                children: [
                  GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(widget.lati, widget.longi),
                      zoom: 17.0,
                    ),
                    markers: {
                      Marker(
                        markerId: const MarkerId("marker1"),
                        position: LatLng(widget.lati, widget.longi),
                        icon: BitmapDescriptor.defaultMarker,
                      ),
                    },
                  ),
                  // (widget.lati > 0 && widget.longi > 0)
                  //     ? GoogleMap(
                  //         mapType: MapType.normal,
                  //         initialCameraPosition:
                  //             CameraPosition(target: latlong, zoom: 17),
                  //         onMapCreated: (GoogleMapController controller) {
                  //           _controller = (controller);
                  //           _controller.animateCamera(
                  //               CameraUpdate.newCameraPosition(
                  //                   CameraPosition(target: latlong, zoom: 17)));
                  //         },
                  //         markers: {
                  //           Marker(
                  //             markerId: const MarkerId("marker1"),
                  //             position: LatLng(widget.lati, widget.longi),
                  //             icon: BitmapDescriptor.defaultMarker,
                  //           ),
                  //         },
                  //       )
                  //     : Center(
                  //         child: CupertinoActivityIndicator(
                  //             radius: 30.0, color: Appcolor.primarycolor),
                  //       ),
                  Positioned(
                    left: 0.0,
                    right: 0.0,
                    bottom: 0.0,
                    child: Container(
                      height: 170.0,
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    AppUtils.buildNormalText(
                                        text: widget.type,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                    AppUtils.buildNormalText(
                                        text: AppConstants
                                            .changeddmmyyhhmmssformat(
                                                widget.time),
                                        //DateFormat.yMMMMEEEEd().format(
                                        // DateTime.now(),

                                        fontSize: 16,
                                        overflow: TextOverflow.ellipsis),
                                  ],
                                ),
                                // AppUtils.buildNormalText(
                                //     text: widget.time,
                                //     fontSize: 16,
                                //     fontWeight: FontWeight.bold),
                              ],
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            AppUtils.buildNormalText(
                                text: "LOCATION",
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                            const SizedBox(
                              height: 10.0,
                            ),
                            AppUtils.buildNormalText(
                                text: widget.address.toString() == "null"
                                    ? "-"
                                    : widget.address.toString(),
                                fontSize: 14),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : Container());
  }
}
