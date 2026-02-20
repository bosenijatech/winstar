import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:winstar/models/empinfomodel.dart';
import 'package:winstar/models/filemodel.dart';
import 'package:winstar/services/apiservice.dart';
import 'package:winstar/services/pref.dart';
import 'package:winstar/utils/app_utils.dart';
import 'package:winstar/utils/appcolor.dart';
import 'package:winstar/utils/constants.dart';
import 'package:winstar/utils/custom_indicatoronly.dart';
import 'package:winstar/utils/sharedprefconstants.dart';
import 'package:winstar/views/profilepage/StickyTabBarDelegate.dart';
import 'package:winstar/views/profilepage/edit_dependentiddetails.dart';
import 'package:winstar/views/profilepage/edit_depends.dart';
import 'package:winstar/views/profilepage/edit_documents.dart';
import 'package:winstar/views/profilepage/edit_education.dart';
import 'package:winstar/views/profilepage/edit_skills.dart';
import 'package:winstar/views/widgets/assets_image_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:developer' as log;

import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _selectedColor = const Color(0xff1a73e8);
  final _unselectedColor = const Color(0xff5f6368);
  final _tabs = [
    const Tab(text: 'Personal'),
    const Tab(text: 'Qualification'),
    const Tab(text: 'Documents'),
    const Tab(text: 'Other Details'),
  ];
  String attachmentID = "";
  String attachmentURL = "";
  bool loading = false;
  EmpInfoModel empinfomodel = EmpInfoModel();
  List<String> files = [];
  TextEditingController attachcontroller = TextEditingController();

  final picker = ImagePicker();
  File? imagefile;
  List<File> filelist = [];
  List<PlatformFile>? _paths;
  List<AttachModel> attachlist = [];
  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this);
    getdata();
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    attachcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white30,
      body: !loading
          ? DefaultTabController(
              length: 4,
              child: NestedScrollView(
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return [
                    _headerSection(),
                    _tabSection(),
                  ];
                },
                body: TabBarView(
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          primarydetails(),
                          contactdetails(),
                          addressdetails(),
                          addressdetails2(),
                          dependents(),
                        ],
                      ),
                    ),
                    SingleChildScrollView(
                      child: Column(
                        children: [qualificationdetails()],
                      ),
                    ),
                    SingleChildScrollView(
                      child: Column(
                        children: [documentdetails()],
                      ),
                    ),
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          dependentIDdetails(),
                          const SizedBox(
                            height: 10,
                          ),

                          skillsdetails(),
                          // InkWell(
                          //   onTap: () {
                          //     Navigator.push(
                          //       context,
                          //       MaterialPageRoute(
                          //           builder: (context) => EditWorkExperience(
                          //               model: empinfomodel,
                          //               iseditable: false,
                          //               position: 0)),
                          //     ).then((_) => getdata());
                          //   },
                          //   child: Padding(
                          //     padding: const EdgeInsets.all(10),
                          //     child: Row(
                          //       mainAxisAlignment:
                          //           MainAxisAlignment.spaceBetween,
                          //       crossAxisAlignment: CrossAxisAlignment.start,
                          //       children: [
                          //         AppUtils.buildNormalText(
                          //             text: "Work Experience",
                          //             fontSize: 18,
                          //             fontWeight: FontWeight.bold),
                          //         AppUtils.buildNormalText(
                          //             text: "ADD",
                          //             fontSize: 14,
                          //             color: Appcolor.twitterBlue),
                          //       ],
                          //     ),
                          //   ),
                          // ),
                          // workdetails(),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          : const CustomIndicator(),
    );
  }

  Widget _headerSection() {
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          SizedBox(
            height: 210,
            child: Center(
              child: ListView(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 24),
                    decoration: const BoxDecoration(),
                    child: Column(
                      children: [
                       (empinfomodel.message?.imageurl ?? "").isNotEmpty

                            ? InkWell(
                                onTap: () async {
                                  Map<Permission, PermissionStatus> statuses =
                                      await [
                                    Permission.camera,
                                  ].request();
                                  statuses.values.forEach((element) async {
                                    if (element.isDenied ||
                                        element.isPermanentlyDenied) {
                                      await openAppSettings();
                                    }
                                  });

                                  AppUtils.showBottomCupertinoDialog(context,
                                      title: "Choose any one option",
                                      btn1function: () async {
                                    AppUtils.pop(context);
                                    getImageFromCamera();
                                  }, btn2function: () {
                                    AppUtils.pop(context);
                                    pickFile();
                                  });
                                },
                                child: SizedBox(
                                  width: 100,
                                  height: 100,
                                  child: CachedNetworkImage(
                                    imageUrl: empinfomodel.message!.imageurl
                                        .toString(),
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                      child: Align(
                                          alignment: Alignment.bottomRight,
                                          child: Image.asset(
                                            'assets/icons/plus.png',
                                            width: 30,
                                            height: 30,
                                          )),
                                    ),
                                    placeholder: (context, url) =>
                                        const CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                                ),
                              )
                            : InkWell(
                                onTap: () async {
                                  Map<Permission, PermissionStatus> statuses =
                                      await [
                                    Permission.camera,
                                  ].request();
                                  statuses.values.forEach((element) async {
                                    if (element.isDenied ||
                                        element.isPermanentlyDenied) {
                                      await openAppSettings();
                                    }
                                  });
                                  AppUtils.showBottomCupertinoDialog(context,
                                      title: "Choose any one option",
                                      btn1function: () async {
                                    AppUtils.pop(context);
                                    getImageFromCamera();
                                  }, btn2function: () {
                                    AppUtils.pop(context);
                                    pickFile();
                                  });
                                },
                                child: Container(
                                  width: 70,
                                  height: 70,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: Colors.white,
                                    image: const DecorationImage(
                                      image: AssetImage(
                                          'assets/images/avataricon.png'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  child: Align(
                                      alignment: Alignment.bottomRight,
                                      child: Image.asset(
                                        'assets/icons/plus.png',
                                        width: 30,
                                        height: 30,
                                      )),
                                ),
                              ),
                        // Fullname
                        Container(
                          margin: const EdgeInsets.only(bottom: 4, top: 14),
                          child: AppUtils.buildNormalText(
                              text: empinfomodel.message != null
                                  ? '${empinfomodel.message!.firstName.toString()}'
                                      ' ${empinfomodel.message!.middleName.toString()}'
                                      ' ${empinfomodel.message!.lastName.toString()}'
                                  : '',
                              fontSize: 16,
                              color: Appcolor.black,
                              fontWeight: FontWeight.bold),
                        ),

                        AppUtils.buildNormalText(
                            text: empinfomodel.message != null
                                ? empinfomodel.message!.workRegion.toString()
                                : "NA",
                            fontSize: 13),
                        const SizedBox(
                          height: 5,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future getImageFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      imagefile = File(pickedFile.path);

      final bytes = imagefile!.readAsBytesSync().lengthInBytes;
      final kb = bytes / 1024;
      final mb = kb / 1024;

      Random random = Random();
      int randomnumber = random.nextInt(100);

      File imageFile = File(pickedFile.path);

      Uint8List bytes0 = await imageFile.readAsBytes();
      String base64String = base64Encode(bytes0);
      attachcontroller.text = pickedFile.path.toString().split("/").last;
      attachlist.clear();

      attachlist.add(AttachModel(
          randomnumber.toString(),
          base64String,
          AppConstants.getFileTypeExtension(pickedFile.path.toString()) ==
                  ".jpg"
              ? "jpg"
              : AppConstants.getFileTypeExtension(pickedFile.path.toString()) ==
                      ".jpeg"
                  ? "jpeg"
                  : AppConstants.getFileTypeExtension(
                      pickedFile.path.toString()),
          pickedFile.path.toString().split("/").last,
          mb.toStringAsFixed(3).toString()));
      onupload();
      setState(() {});
    } else {
      attachlist.clear();
      print('No image selected.');
    }
  }

  void pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      withData: true,
      allowMultiple: false,
      allowCompression: true,
      allowedExtensions: ['png', 'jpg', 'jpeg'],
    );
    Random random = Random();
    int randomnumber = random.nextInt(100);
    if (result != null && result.files.single.path != null) {
      PlatformFile file = result.files.first;

      File file0 = File(result.files.single.path!);
      String file64 = "";
      setState(() async {
        if (file.extension.toString() == "pdf") {
          attachcontroller.text = file0.path;
          final bytes = File(file0.path).readAsBytesSync();
          file64 = base64Encode(bytes);
        } else {
          //Image
          attachcontroller.text = file0.path.toString();
          Uint8List bytes0 = await file0.readAsBytes();
          file64 = base64Encode(bytes0);
        }

        attachlist.clear();

        attachlist.add(AttachModel(randomnumber.toString(), file64,
            file.extension, file.name, file.size.toString()));
        onupload();
      });
    } else {
      /// User canceled the picker
    }
  }

  void onupload() async {
    var body = {
      "attachment": [
        {
          "FileData": attachlist[0].fileData.toString(),
          "FileType": attachlist[0].fileType.toString(),
          "FileName": attachlist[0].fileName.toString()
        }
      ]
    };
    setState(() {
      loading = true;
    });
    log.log(jsonEncode(body));
    ApiService.postattachment(body).then((response) {
      setState(() {
        loading = false;
      });
      if (response.statusCode == 200) {
        if (jsonDecode(response.body)['status'].toString() == "true") {
          attachmentID = jsonDecode(response.body)['fileId'].toString();
          attachmentURL = jsonDecode(response.body)['url'].toString();
          attachlist[0].fileData = attachmentID;
          updateuserimage(attachmentID, attachmentURL);
        } else {
          AppUtils.showSingleDialogPopup(
              context,
              jsonDecode(response.body)['message'],
              "Ok",
              onexitpopup,
              AssetsImageWidget.warningimage);
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

  void updateuserimage(attachid, imageurl) {
    var json = {
      "type": "UserImg",
      "_id": Prefs.getNsID('nsid'),
      "nsId": Prefs.getNsID('nsid'),
      "firstName": Prefs.getFirstName(
        SharefprefConstants.shareFirstName,
      ),
      "middleName": Prefs.getMiddleName(
        SharefprefConstants.shareMiddleName,
      ),
      "lastName": Prefs.getLastName(
        SharefprefConstants.sharedLastName,
      ),
      "imagename": attachid, //imagename,
      "imageurl": imageurl //camfilepath //camfilepath
    };

    setState(() {
      loading = true;
    });
    ApiService.updatemaster(json).then((response) {
      setState(() {
        loading = false;
      });
      if (response.statusCode == 200) {
        if (jsonDecode(response.body)['status'].toString() == "true") {
          Prefs.setImageURL(SharefprefConstants.sharedImgUrl, imageurl);

          AppUtils.showSingleDialogPopup(
              context,
              jsonDecode(response.body)['message'],
              "ok",
              onrefresh,
              AssetsImageWidget.successimage);
        } else {
          AppUtils.showSingleDialogPopup(
              context,
              jsonDecode(response.body)['message'],
              "Ok",
              onexitpopup,
              AssetsImageWidget.warningimage);
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

  Widget _tabSection() {
    return SliverPersistentHeader(
      pinned: true,
      delegate: StickyTabBarDelegate(
        tabBar:
            TabBar(isScrollable: true, labelColor: Colors.black, tabs: _tabs),
      ),
    );
  }

  Widget primarydetails() {
    return Card(
      elevation: 3,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppUtils.buildNormalText(
                    text: "Primary Details",
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
                AppUtils.buildNormalText(
                    text: "", fontSize: 16, color: Appcolor.twitterBlue),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppUtils.buildNormalText(
                          text: "FIRST NAME",
                          fontSize: 12,
                          color: Colors.grey.shade600),
                      const SizedBox(height: 5),
                      AppUtils.buildNormalText(
                          text: empinfomodel.message != null
                              ? empinfomodel.message!.firstName.toString()
                              : "-",
                          fontSize: 14,
                          color: Colors.black),
                      const SizedBox(
                        height: 15,
                      ),
                      AppUtils.buildNormalText(
                          text: "LAST NAME",
                          fontSize: 12,
                          color: Colors.grey.shade600),
                      const SizedBox(height: 5),
                      AppUtils.buildNormalText(
                          text: empinfomodel.message != null
                              ? empinfomodel.message!.lastName.toString()
                              : "-",
                          fontSize: 14,
                          color: Colors.black),
                      const SizedBox(
                        height: 15,
                      ),
                      AppUtils.buildNormalText(
                          text: "TITLE",
                          fontSize: 12,
                          color: Colors.grey.shade600),
                      const SizedBox(height: 5),
                      AppUtils.buildNormalText(
                          text: empinfomodel.message != null
                              ? empinfomodel.message!.title.toString()
                              : "-",
                          fontSize: 14,
                          color: Colors.black),
                      const SizedBox(
                        height: 15,
                      ),
                      AppUtils.buildNormalText(
                          text: "GENDER",
                          fontSize: 12,
                          color: Colors.grey.shade600),
                      const SizedBox(height: 5),
                      AppUtils.buildNormalText(
                          text: empinfomodel.message != null &&
                                  empinfomodel.message!.gender.toString() !=
                                      "null"
                              ? empinfomodel.message!.gender.toString()
                              : "-",
                          fontSize: 14,
                          color: Colors.black),
                      const SizedBox(
                        height: 15,
                      ),
                      AppUtils.buildNormalText(
                          text: "MARITIAL STATUS",
                          fontSize: 12,
                          color: Colors.grey.shade600),
                      const SizedBox(height: 5),
                      AppUtils.buildNormalText(
                          text: empinfomodel.message != null &&
                                  empinfomodel.message!.maritalStatus
                                          .toString() !=
                                      "null"
                              ? empinfomodel.message!.maritalStatus.toString()
                              : "-",
                          fontSize: 14,
                          color: Colors.black),
                      const SizedBox(
                        height: 15,
                      ),
                      AppUtils.buildNormalText(
                          text: "EMAIL ID",
                          fontSize: 12,
                          color: Colors.grey.shade600),
                      const SizedBox(height: 5),
                      AppUtils.buildNormalText(
                          text: empinfomodel.message != null &&
                                  empinfomodel.message!.mobileemail
                                          .toString() !=
                                      "null"
                              ? empinfomodel.message!.mobileemail.toString()
                              : "-",
                          fontSize: 14,
                          color: Colors.black),
                      const SizedBox(
                        height: 15,
                      ),
                      AppUtils.buildNormalText(
                          text: "DEPT",
                          fontSize: 12,
                          color: Colors.grey.shade600),
                      const SizedBox(height: 5),
                      AppUtils.buildNormalText(
                          text: empinfomodel.message != null &&
                                  empinfomodel.message!.department.toString() !=
                                      "null"
                              ? empinfomodel.message!.department.toString()
                              : "-",
                          fontSize: 14,
                          color: Colors.black),
                      const SizedBox(
                        height: 15,
                      ),
                      AppUtils.buildNormalText(
                          text: "Bank Name",
                          fontSize: 12,
                          color: Colors.grey.shade600),
                      const SizedBox(height: 5),
                      AppUtils.buildNormalText(
                          text: empinfomodel.message != null &&
                                  empinfomodel.message!.bankName.toString() !=
                                      "null"
                              ? empinfomodel.message!.bankName.toString()
                              : "-",
                          fontSize: 14,
                          color: Colors.black),
                      const SizedBox(
                        height: 15,
                      ),
                      AppUtils.buildNormalText(
                          text: "Band",
                          fontSize: 12,
                          color: Colors.grey.shade600),
                      const SizedBox(height: 5),
                      AppUtils.buildNormalText(
                          text: empinfomodel.message != null &&
                                  empinfomodel.message!.band.toString() !=
                                      "null"
                              ? empinfomodel.message!.band.toString()
                              : "-",
                          fontSize: 14,
                          color: Colors.black),
                      const SizedBox(
                        height: 15,
                      ),
                      AppUtils.buildNormalText(
                          text: "Sub Band",
                          fontSize: 12,
                          color: Colors.grey.shade600),
                      const SizedBox(height: 5),
                      AppUtils.buildNormalText(
                          text: empinfomodel.message != null &&
                                  empinfomodel.message!.subBand.toString() !=
                                      "null"
                              ? empinfomodel.message!.subBand.toString()
                              : "-",
                          fontSize: 14,
                          color: Colors.black),
                      const SizedBox(
                        height: 15,
                      ),
                      AppUtils.buildNormalText(
                          text: "Mobile No",
                          fontSize: 12,
                          color: Colors.grey.shade600),
                      const SizedBox(height: 5),
                      AppUtils.buildNormalText(
                          text: empinfomodel.message != null &&
                                  empinfomodel.message!.mobileNo.toString() !=
                                      "null"
                              ? empinfomodel.message!.mobileNo.toString()
                              : "-",
                          fontSize: 14,
                          color: Colors.black),
                      const SizedBox(
                        height: 15,
                      ),
                      AppUtils.buildNormalText(
                          text: "Job Status",
                          fontSize: 12,
                          color: Colors.grey.shade600),
                      const SizedBox(height: 5),
                      AppUtils.buildNormalText(
                          text: empinfomodel.message != null &&
                                  empinfomodel.message!.jobStatus.toString() !=
                                      "null"
                              ? empinfomodel.message!.jobStatus.toString()
                              : "-",
                          fontSize: 14,
                          color: Colors.black),
                      const SizedBox(
                        height: 15,
                      ),
                      AppUtils.buildNormalText(
                          text: "Account No",
                          fontSize: 12,
                          color: Colors.grey.shade600),
                      const SizedBox(height: 5),
                      AppUtils.buildNormalText(
                          text: empinfomodel.message != null &&
                                  empinfomodel.message!.bankAccountNo
                                          .toString() !=
                                      "null"
                              ? empinfomodel.message!.bankAccountNo.toString()
                              : "-",
                          fontSize: 14,
                          color: Colors.black),
                      const SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                ),
                Expanded(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppUtils.buildNormalText(
                        text: "MIDDLE NAME",
                        fontSize: 12,
                        color: Colors.grey.shade600),
                    const SizedBox(height: 5),
                    AppUtils.buildNormalText(
                        text: empinfomodel.message != null
                            ? empinfomodel.message!.middleName.toString()
                            : "-",
                        fontSize: 14,
                        color: Colors.black),
                    const SizedBox(
                      height: 15,
                    ),
                    AppUtils.buildNormalText(
                        text: "EMP CODE",
                        fontSize: 12,
                        color: Colors.grey.shade600),
                    const SizedBox(height: 5),
                    AppUtils.buildNormalText(
                        text: empinfomodel.message != null
                            ? empinfomodel.message!.employeeCode.toString()
                            : "-",
                        fontSize: 14,
                        color: Colors.black),
                    const SizedBox(
                      height: 15,
                    ),
                    AppUtils.buildNormalText(
                        text: "DISPLAY NAME",
                        fontSize: 12,
                        color: Colors.grey.shade600),
                    const SizedBox(height: 5),
                    AppUtils.buildNormalText(
                        text: empinfomodel.message != null &&
                                empinfomodel.message!.firstName.toString() !=
                                    "null"
                            ? empinfomodel.message!.firstName.toString()
                            : "-",
                        fontSize: 14,
                        color: Colors.black),
                    const SizedBox(
                      height: 15,
                    ),
                    AppUtils.buildNormalText(
                        text: "DATE OF BIRTH",
                        fontSize: 12,
                        color: Colors.grey.shade600),
                    const SizedBox(height: 5),
                    AppUtils.buildNormalText(
                        text: empinfomodel.message != null
                            ? empinfomodel.message!.dateOfBirth.toString()
                            : "-",
                        fontSize: 14,
                        color: Colors.black),
                    const SizedBox(
                      height: 15,
                    ),
                    AppUtils.buildNormalText(
                        text: "ROLE",
                        fontSize: 12,
                        color: Colors.grey.shade600),
                    const SizedBox(height: 5),
                    AppUtils.buildNormalText(
                        text: empinfomodel.message != null
                            ? empinfomodel.message!.role.toString()
                            : "-",
                        fontSize: 14,
                        color: Colors.black),
                    const SizedBox(
                      height: 15,
                    ),
                    AppUtils.buildNormalText(
                        text: "SUBSIDIARY",
                        fontSize: 12,
                        color: Colors.grey.shade600),
                    const SizedBox(height: 5),
                    AppUtils.buildNormalText(
                        text: empinfomodel.message != null
                            ? empinfomodel.message!.subsidiary.toString()
                            : "-",
                        fontSize: 14,
                        color: Colors.black),
                    const SizedBox(
                      height: 15,
                    ),
                    AppUtils.buildNormalText(
                        text: "CATEGORY",
                        fontSize: 12,
                        color: Colors.grey.shade600),
                    const SizedBox(height: 5),
                    AppUtils.buildNormalText(
                        text: empinfomodel.message != null
                            ? empinfomodel.message!.employeeCategory.toString()
                            : "-",
                        fontSize: 14,
                        color: Colors.black),
                    const SizedBox(
                      height: 15,
                    ),
                    AppUtils.buildNormalText(
                        text: "RELIGION",
                        fontSize: 12,
                        color: Colors.grey.shade600),
                    const SizedBox(height: 5),
                    AppUtils.buildNormalText(
                        text: empinfomodel.message != null
                            ? empinfomodel.message!.religion.toString()
                            : "-",
                        fontSize: 14,
                        color: Colors.black),
                    const SizedBox(
                      height: 15,
                    ),
                    AppUtils.buildNormalText(
                        text: "Working region",
                        fontSize: 12,
                        color: Colors.grey.shade600),
                    const SizedBox(height: 5),
                    AppUtils.buildNormalText(
                        text: empinfomodel.message != null &&
                                empinfomodel.message!.workRegion.toString() !=
                                    "null"
                            ? empinfomodel.message!.workRegion.toString()
                            : "-",
                        fontSize: 14,
                        color: Colors.black),
                    const SizedBox(
                      height: 15,
                    ),
                    AppUtils.buildNormalText(
                        text: "Marital Status",
                        fontSize: 12,
                        color: Colors.grey.shade600),
                    const SizedBox(height: 5),
                    AppUtils.buildNormalText(
                        text: empinfomodel.message != null &&
                                empinfomodel.message!.maritalStatus
                                        .toString() !=
                                    "null"
                            ? empinfomodel.message!.maritalStatus.toString()
                            : "-",
                        fontSize: 14,
                        color: Colors.black),
                    const SizedBox(
                      height: 15,
                    ),
                    AppUtils.buildNormalText(
                        text: "Bank Name",
                        fontSize: 12,
                        color: Colors.grey.shade600),
                    const SizedBox(height: 5),
                    AppUtils.buildNormalText(
                        text: empinfomodel.message != null &&
                                empinfomodel.message!.bankName.toString() !=
                                    "null"
                            ? empinfomodel.message!.bankName.toString()
                            : "-",
                        fontSize: 14,
                        color: Colors.black),
                    const SizedBox(
                      height: 15,
                    ),
                    AppUtils.buildNormalText(
                        text: "Routing No",
                        fontSize: 12,
                        color: Colors.grey.shade600),
                    const SizedBox(height: 5),
                    AppUtils.buildNormalText(
                        text: empinfomodel.message != null &&
                                empinfomodel.message!.bankRoutingNo
                                        .toString() !=
                                    "null"
                            ? empinfomodel.message!.bankRoutingNo.toString()
                            : "-",
                        fontSize: 14,
                        color: Colors.black),
                    const SizedBox(
                      height: 15,
                    ),
                  ],
                ))
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget contactdetails() {
    return empinfomodel.message != null &&
            empinfomodel.message!.emergencyContact!.isNotEmpty
        ? Card(
            elevation: 3,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppUtils.buildNormalText(
                          text: "Emergency Contact Details",
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                      AppUtils.buildNormalText(
                          text: "", fontSize: 16, color: Appcolor.twitterBlue),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppUtils.buildNormalText(
                                text: "MAIL ID",
                                fontSize: 12,
                                color: Colors.grey.shade600),
                            const SizedBox(height: 5),
                            AppUtils.buildNormalText(
                                text: empinfomodel.message != null
                                    ? empinfomodel.message!.mobileemail
                                        .toString()
                                    : "-",
                                fontSize: 14,
                                color: Colors.black,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis),
                            const SizedBox(
                              height: 15,
                            ),
                            AppUtils.buildNormalText(
                                text: "EMERGENCY CONTACT PERSON",
                                fontSize: 12,
                                maxLines: 2,
                                color: Colors.grey.shade600),
                            const SizedBox(height: 5),
                            AppUtils.buildNormalText(
                                text: empinfomodel.message != null &&
                                        empinfomodel.message!.emergencyContact!
                                            .isNotEmpty
                                    ? empinfomodel.message!.emergencyContact!
                                        .first.emergencyContactName
                                    : "-".toString(),
                                fontSize: 14,
                                color: Colors.black),
                            const SizedBox(
                              height: 15,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppUtils.buildNormalText(
                              text: "PHONE",
                              fontSize: 12,
                              color: Colors.grey.shade600),
                          const SizedBox(height: 5),
                          AppUtils.buildNormalText(
                              text: "-", fontSize: 14, color: Colors.black),
                          const SizedBox(
                            height: 15,
                          ),
                          AppUtils.buildNormalText(
                              text: "EMERGENCY CONTACT NUMBER",
                              fontSize: 12,
                              maxLines: 2,
                              color: Colors.grey.shade600),
                          const SizedBox(height: 5),
                          AppUtils.buildNormalText(
                              text: empinfomodel.message != null &&
                                      empinfomodel
                                          .message!.emergencyContact!.isNotEmpty
                                  ? empinfomodel.message!.emergencyContact!
                                      .first.emergencyContactNo
                                  : "-".toString(),
                              fontSize: 14,
                              color: Colors.black),
                          const SizedBox(
                            height: 15,
                          ),
                        ],
                      ))
                    ],
                  ),
                )
              ],
            ),
          )
        : Container();
  }

  Widget addressdetails() {
    return empinfomodel.message != null &&
            empinfomodel.message!.contacts!.isNotEmpty
        ? Card(
            elevation: 3,
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  AppUtils.buildNormalText(
                      text: empinfomodel.message!.contacts![0].defaultBilling
                                  .toString() ==
                              "true"
                          ? "Primary Details"
                          : "Contact Details",
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                  const SizedBox(height: 5),
                  AppUtils.buildNormalText(
                      text: "ADDRESS",
                      fontSize: 12,
                      color: Colors.grey.shade600),
                  const SizedBox(height: 5),
                  AppUtils.buildNormalText(
                      text: empinfomodel.message != null
                          ? empinfomodel.message!.contacts![0].address
                              .toString()
                          : "-",
                      fontSize: 14,
                      maxLines: null,
                      color: Colors.black),
                  const SizedBox(
                    height: 5,
                  ),
                  AppUtils.buildNormalText(
                      text: "ADDRESS 1 ",
                      fontSize: 12,
                      color: Colors.grey.shade600),
                  const SizedBox(height: 5),
                  AppUtils.buildNormalText(
                      text: empinfomodel.message != null
                          ? empinfomodel.message!.contacts![0].address1
                              .toString()
                          : "-",
                      fontSize: 14,
                      color: Colors.black),
                  const SizedBox(
                    height: 5,
                  ),
                  AppUtils.buildNormalText(
                      text: "ADDRESS 2 ",
                      fontSize: 12,
                      color: Colors.grey.shade600),
                  const SizedBox(height: 5),
                  AppUtils.buildNormalText(
                      text: empinfomodel.message != null
                          ? empinfomodel.message!.contacts![0].address2
                              .toString()
                          : "-",
                      fontSize: 14,
                      color: Colors.black),
                  const SizedBox(
                    height: 5,
                  ),
                  AppUtils.buildNormalText(
                      text: "COUNTRY",
                      fontSize: 12,
                      color: Colors.grey.shade600),
                  const SizedBox(height: 5),
                  AppUtils.buildNormalText(
                      text: empinfomodel.message != null
                          ? empinfomodel.message!.contacts![0].country
                              .toString()
                          : "-",
                      fontSize: 14,
                      color: Colors.black),
                  const SizedBox(
                    height: 5,
                  ),
                  AppUtils.buildNormalText(
                      text: "STATE  ",
                      fontSize: 12,
                      color: Colors.grey.shade600),
                  const SizedBox(height: 5),
                  AppUtils.buildNormalText(
                      text: empinfomodel.message != null
                          ? empinfomodel.message!.contacts![0].state.toString()
                          : "-",
                      fontSize: 14,
                      color: Colors.black),
                  const SizedBox(
                    height: 5,
                  ),
                  AppUtils.buildNormalText(
                      text: "CITY", fontSize: 12, color: Colors.grey.shade600),
                  const SizedBox(height: 5),
                  AppUtils.buildNormalText(
                      text: empinfomodel.message != null
                          ? empinfomodel.message!.contacts![0].city.toString()
                          : "-",
                      fontSize: 14,
                      color: Colors.black),
                  const SizedBox(
                    height: 5,
                  ),
                  AppUtils.buildNormalText(
                      text: "ZIPCODE",
                      fontSize: 12,
                      color: Colors.grey.shade600),
                  const SizedBox(height: 5),
                  AppUtils.buildNormalText(
                      text: empinfomodel.message != null
                          ? empinfomodel.message!.contacts![0].zipCode
                              .toString()
                          : "-",
                      fontSize: 14,
                      color: Colors.black),
                  const SizedBox(
                    height: 5,
                  ),
                ],
              ),
            ),
          )
        : Container();
  }

  Widget addressdetails2() {
    return empinfomodel.message != null &&
            empinfomodel.message!.contacts!.isNotEmpty &&
            empinfomodel.message!.contacts!.length > 1
        ? Card(
            elevation: 3,
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  AppUtils.buildNormalText(
                      text: "Address Details",
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                  const SizedBox(height: 5),
                  AppUtils.buildNormalText(
                      text: "ADDRESS",
                      fontSize: 12,
                      color: Colors.grey.shade600),
                  const SizedBox(height: 5),
                  AppUtils.buildNormalText(
                      text: empinfomodel.message != null
                          ? empinfomodel.message!.contacts![1].address
                              .toString()
                          : "-",
                      fontSize: 14,
                      maxLines: null,
                      color: Colors.black),
                  const SizedBox(
                    height: 5,
                  ),
                  AppUtils.buildNormalText(
                      text: "ADDRESS 1 ",
                      fontSize: 12,
                      color: Colors.grey.shade600),
                  const SizedBox(height: 5),
                  AppUtils.buildNormalText(
                      text: empinfomodel.message != null
                          ? empinfomodel.message!.contacts![1].address1
                              .toString()
                          : "-",
                      fontSize: 14,
                      color: Colors.black),
                  const SizedBox(
                    height: 5,
                  ),
                  AppUtils.buildNormalText(
                      text: "ADDRESS 2 ",
                      fontSize: 12,
                      color: Colors.grey.shade600),
                  const SizedBox(height: 5),
                  AppUtils.buildNormalText(
                      text: empinfomodel.message != null
                          ? empinfomodel.message!.contacts![1].address2
                              .toString()
                          : "-",
                      fontSize: 14,
                      color: Colors.black),
                  const SizedBox(
                    height: 5,
                  ),
                  AppUtils.buildNormalText(
                      text: "COUNTRY",
                      fontSize: 12,
                      color: Colors.grey.shade600),
                  const SizedBox(height: 5),
                  AppUtils.buildNormalText(
                      text: empinfomodel.message != null
                          ? empinfomodel.message!.contacts![1].country
                              .toString()
                          : "-",
                      fontSize: 14,
                      color: Colors.black),
                  const SizedBox(
                    height: 5,
                  ),
                  AppUtils.buildNormalText(
                      text: "STATE  ",
                      fontSize: 12,
                      color: Colors.grey.shade600),
                  const SizedBox(height: 5),
                  AppUtils.buildNormalText(
                      text: empinfomodel.message != null
                          ? empinfomodel.message!.contacts![1].state.toString()
                          : "-",
                      fontSize: 14,
                      color: Colors.black),
                  const SizedBox(
                    height: 5,
                  ),
                  AppUtils.buildNormalText(
                      text: "CITY", fontSize: 12, color: Colors.grey.shade600),
                  const SizedBox(height: 5),
                  AppUtils.buildNormalText(
                      text: empinfomodel.message != null
                          ? empinfomodel.message!.contacts![1].city.toString()
                          : "-",
                      fontSize: 14,
                      color: Colors.black),
                  const SizedBox(
                    height: 5,
                  ),
                  AppUtils.buildNormalText(
                      text: "ZIPCODE",
                      fontSize: 12,
                      color: Colors.grey.shade600),
                  const SizedBox(height: 5),
                  AppUtils.buildNormalText(
                      text: empinfomodel.message != null
                          ? empinfomodel.message!.contacts![1].zipCode
                              .toString()
                          : "-",
                      fontSize: 14,
                      color: Colors.black),
                  const SizedBox(
                    height: 5,
                  ),
                ],
              ),
            ),
          )
        : Container();
  }

  Widget qualificationdetails() {
    return Card(
      elevation: 3,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppUtils.buildNormalText(
                    text: "Qualification Details",
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditEducation(
                              model: empinfomodel,
                              iseditable: false,
                              position: 0)),
                    ).then((_) => getdata());
                  },
                  child: AppUtils.buildNormalText(
                      text: "ADD", fontSize: 14, color: Appcolor.twitterBlue),
                ),
              ],
            ),
          ),
          empinfomodel.message != null &&
                  empinfomodel.message!.qualification!.isNotEmpty
              ? ListView.builder(
                  itemCount: empinfomodel.message!.qualification!.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 4,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AppUtils.buildNormalText(
                                        text: "ID",
                                        fontSize: 12,
                                        color: Colors.grey.shade600),
                                    const SizedBox(height: 5),
                                    AppUtils.buildNormalText(
                                        text: empinfomodel
                                            .message!
                                            .qualification![index]
                                            .qualificationId
                                            .toString(),
                                        fontSize: 12,
                                        color: Colors.black),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    AppUtils.buildNormalText(
                                        text: "COLLEGE",
                                        fontSize: 12,
                                        color: Colors.grey.shade600),
                                    const SizedBox(height: 5),
                                    AppUtils.buildNormalText(
                                        text: empinfomodel.message!
                                            .qualification![index].college
                                            .toString(),
                                        fontSize: 14,
                                        color: Colors.black),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    AppUtils.buildNormalText(
                                        text: "PERCENTAGE",
                                        fontSize: 12,
                                        color: Colors.grey.shade600),
                                    const SizedBox(height: 5),
                                    AppUtils.buildNormalText(
                                        text: empinfomodel.message!
                                            .qualification![index].percentage
                                            .toString(),
                                        fontSize: 14,
                                        color: Colors.black),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    // AppUtils.buildNormalText(
                                    //     text: "LEVEL OF EDUCATION",
                                    //     fontSize: 12,
                                    //     color: Colors.grey.shade600),
                                    // const SizedBox(height: 5),
                                    // AppUtils.buildNormalText(
                                    //     text: empinfomodel
                                    //                 .message!
                                    //                 .qualification![index]
                                    //                 .levelofeducation
                                    //                 .toString() ==
                                    //             "null"
                                    //         ? ""
                                    //         : empinfomodel
                                    //             .message!
                                    //             .qualification![index]
                                    //             .levelofeducation
                                    //             .toString(),
                                    //     fontSize: 14,
                                    //     color: Colors.black),
                                  ],
                                ),
                              ),
                              Expanded(
                                  flex: 4,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      AppUtils.buildNormalText(
                                          text: "EDUCATION",
                                          fontSize: 12,
                                          color: Colors.grey.shade600),
                                      const SizedBox(height: 5),
                                      AppUtils.buildNormalText(
                                          text: empinfomodel.message!
                                              .qualification![index].education
                                              .toString(),
                                          fontSize: 14,
                                          color: Colors.black),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      AppUtils.buildNormalText(
                                          text: "PASSING YEAR",
                                          fontSize: 12,
                                          color: Colors.grey.shade600),
                                      const SizedBox(height: 5),
                                      AppUtils.buildNormalText(
                                          text: empinfomodel.message!
                                              .qualification![index].passingYear
                                              .toString(),
                                          fontSize: 12,
                                          color: Colors.black),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      AppUtils.buildNormalText(
                                          text: "ATTACHMENT",
                                          fontSize: 12,
                                          color: Colors.grey.shade600),
                                      const SizedBox(height: 5),
                                      // AppUtils.buildNormalText(
                                      //     text: empinfomodel.message!
                                      //         .qualification![index].certificate
                                      //         .toString(),
                                      //     fontSize: 12,
                                      //     color: Colors.black),
                                      (empinfomodel
                                                  .message!
                                                  .qualification![index]
                                                  .certificate
                                                  .toString()
                                                  .isEmpty ||
                                              empinfomodel
                                                      .message!
                                                      .qualification![index]
                                                      .certificate
                                                      .toString() ==
                                                  "null")
                                          ? Container()
                                          : RichText(
                                              text: TextSpan(
                                                text: "",
                                                style: const TextStyle(
                                                  fontSize: 15.0,
                                                  color: Colors.black,
                                                ),
                                                children: [
                                                  TextSpan(
                                                      text: "View Attachment",
                                                      style: const TextStyle(
                                                        fontSize: 15.0,
                                                        color:
                                                            Colors.blueAccent,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                      recognizer:
                                                          TapGestureRecognizer()
                                                            ..onTap = () {
                                                              _launchUrl(
                                                                  empinfomodel
                                                                      .message!
                                                                      .qualification![
                                                                          index]
                                                                      .certificate
                                                                      .toString(),
                                                                  isNewTab:
                                                                      true);
                                                              // Navigator.push(
                                                              //     context,
                                                              //     MaterialPageRoute(
                                                              //         builder: (context) => AllFileViewer(
                                                              //             sourcefile: empinfomodel
                                                              //                 .message!
                                                              //                 .qualification![index]
                                                              //                 .certificate
                                                              //                 .toString())));
                                                            })
                                                ],
                                              ),
                                            ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                    ],
                                  )),
                              Expanded(
                                  flex: 1,
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => EditEducation(
                                                model: empinfomodel,
                                                iseditable: true,
                                                position: index)),
                                      ).then((_) => getdata());
                                    },
                                    child: const Icon(
                                      CupertinoIcons.pencil_circle,
                                      size: 24,
                                      color: Appcolor.grey,
                                    ),
                                  ))
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Divider(
                          height: 1,
                          thickness: 0.5,
                          color: Colors.grey.shade300,
                        ),
                      ],
                    );
                  })
              : const Center(
                  child: Text('No Data Found!'),
                ),
        ],
      ),
    );
  }

  Widget documentdetails() {
    return Card(
      elevation: 3,
      child: Column(
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => EditDocuments(
                        model: empinfomodel, iseditable: false, position: 0)),
              ).then((_) => getdata());
            },
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppUtils.buildNormalText(
                      text: "Document Details",
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                  AppUtils.buildNormalText(
                      text: "ADD", fontSize: 14, color: Appcolor.twitterBlue),
                ],
              ),
            ),
          ),
          empinfomodel.message != null &&
                  empinfomodel.message!.documents!.isNotEmpty
              ? ListView.builder(
                  itemCount: empinfomodel.message!.documents!.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 4,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AppUtils.buildNormalText(
                                        text: "ID NUMBER",
                                        fontSize: 12,
                                        color: Colors.grey.shade600),
                                    const SizedBox(height: 5),
                                    AppUtils.buildNormalText(
                                        text: empinfomodel.message!
                                                .documents![index].idNo ??
                                            "-",
                                        fontSize: 12,
                                        color: Colors.black),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    AppUtils.buildNormalText(
                                        text: "COMPANY NAME",
                                        fontSize: 12,
                                        color: Colors.grey.shade600),
                                    const SizedBox(height: 5),
                                    AppUtils.buildNormalText(
                                        text: empinfomodel
                                                .message!
                                                .documents![index]
                                                .companyName ??
                                            "-",
                                        fontSize: 12,
                                        color: Colors.black),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    AppUtils.buildNormalText(
                                        text: "ISSUE DATE",
                                        fontSize: 12,
                                        color: Colors.grey.shade600),
                                    const SizedBox(height: 5),
                                    AppUtils.buildNormalText(
                                        text: empinfomodel.message!
                                                .documents![index].issueDate ??
                                            "-",
                                        fontSize: 12,
                                        color: Colors.black),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    AppUtils.buildNormalText(
                                        text: "DESIGNATION",
                                        fontSize: 12,
                                        color: Colors.grey.shade600),
                                    const SizedBox(height: 5),
                                    AppUtils.buildNormalText(
                                        text: empinfomodel
                                                .message!
                                                .documents![index]
                                                .designation ??
                                            "-",
                                        fontSize: 12,
                                        color: Colors.black),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    AppUtils.buildNormalText(
                                        text: "REMAINDER",
                                        fontSize: 12,
                                        color: Colors.grey.shade600),
                                    const SizedBox(height: 5),
                                    AppUtils.buildNormalText(
                                        text: empinfomodel.message!
                                                .documents![index].remainder ??
                                            "-",
                                        fontSize: 12,
                                        color: Colors.black),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    AppUtils.buildNormalText(
                                        text: "ATTACHMENTS",
                                        fontSize: 12,
                                        color: Colors.grey.shade600),
                                    const SizedBox(height: 5),
                                    (empinfomodel.message!.documents![index]
                                                .attachment
                                                .toString()
                                                .isEmpty ||
                                            empinfomodel
                                                    .message!
                                                    .documents![index]
                                                    .attachment
                                                    .toString() ==
                                                "null")
                                        ? Container()
                                        : RichText(
                                            text: TextSpan(
                                              text: "",
                                              style: const TextStyle(
                                                fontSize: 15.0,
                                                color: Colors.black,
                                              ),
                                              children: [
                                                TextSpan(
                                                    text: "View Attachment",
                                                    style: const TextStyle(
                                                      fontSize: 15.0,
                                                      color: Colors.blueAccent,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                    recognizer:
                                                        TapGestureRecognizer()
                                                          ..onTap = () {
                                                            _launchUrl(
                                                                empinfomodel
                                                                    .message!
                                                                    .documents![
                                                                        index]
                                                                    .attachment
                                                                    .toString(),
                                                                isNewTab: true);
                                                          })
                                              ],
                                            ),
                                          ),
                                  ],
                                ),
                              ),
                              Expanded(
                                  flex: 4,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      AppUtils.buildNormalText(
                                          text: "DOCUMENT TYPE",
                                          fontSize: 12,
                                          color: Colors.grey.shade600),
                                      const SizedBox(height: 5),
                                      AppUtils.buildNormalText(
                                          text: empinfomodel
                                                  .message!
                                                  .documents![index]
                                                  .documentType ??
                                              "-",
                                          fontSize: 14,
                                          color: Colors.black),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      AppUtils.buildNormalText(
                                          text: "ISSUE OF COUNTRY",
                                          fontSize: 12,
                                          color: Colors.grey.shade600),
                                      const SizedBox(height: 5),
                                      AppUtils.buildNormalText(
                                          text: empinfomodel
                                                  .message!
                                                  .documents![index]
                                                  .countryofIssue ??
                                              "-",
                                          fontSize: 12,
                                          color: Colors.black),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      AppUtils.buildNormalText(
                                          text: "EXPIRY DATE",
                                          fontSize: 12,
                                          color: Colors.grey.shade600),
                                      const SizedBox(height: 5),
                                      AppUtils.buildNormalText(
                                          text: empinfomodel
                                                  .message!
                                                  .documents![index]
                                                  .expiryDate ??
                                              "-",
                                          fontSize: 12,
                                          color: Colors.black),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      AppUtils.buildNormalText(
                                          text: "REMARKS",
                                          fontSize: 12,
                                          color: Colors.grey.shade600),
                                      const SizedBox(height: 5),
                                      AppUtils.buildNormalText(
                                          text: empinfomodel.message!
                                                  .documents![index].remarks ??
                                              "-",
                                          fontSize: 12,
                                          color: Colors.black),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      AppUtils.buildNormalText(
                                          text: "REMAINDER DATE",
                                          fontSize: 12,
                                          color: Colors.grey.shade600),
                                      const SizedBox(height: 5),
                                      AppUtils.buildNormalText(
                                          text: empinfomodel
                                                  .message!
                                                  .documents![index]
                                                  .remainderDate ??
                                              "-",
                                          fontSize: 12,
                                          color: Colors.black),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                    ],
                                  )),
                              Expanded(
                                  flex: 1,
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => EditDocuments(
                                                model: empinfomodel,
                                                iseditable: true,
                                                position: index)),
                                      ).then((_) => getdata());
                                    },
                                    child: const Icon(
                                      CupertinoIcons.pencil_circle,
                                      size: 24,
                                      color: Appcolor.grey,
                                    ),
                                  ))
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Divider(
                          height: 1,
                          thickness: 0.5,
                          color: Colors.grey.shade300,
                        ),
                      ],
                    );
                  })
              : const Center(
                  child: Text('No Documents Found!'),
                ),
        ],
      ),
    );
  }

  Widget dependents() {
    return Card(
      elevation: 3,
      child: Column(
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => EditDepends(
                        model: empinfomodel, iseditable: false, position: 0)),
              ).then((_) => getdata());
            },
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppUtils.buildNormalText(
                      text: "Dependents Details",
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                  AppUtils.buildNormalText(
                      text: "ADD", fontSize: 14, color: Appcolor.twitterBlue),
                ],
              ),
            ),
          ),
          (empinfomodel.message != null)
              ? ListView.builder(
                  itemCount: empinfomodel.message!.dependantDetails!.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      margin: const EdgeInsets.only(top: 10, bottom: 10),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 4,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      AppUtils.buildNormalText(
                                          text: "NAME",
                                          fontSize: 12,
                                          color: Colors.grey.shade600),
                                      const SizedBox(height: 5),
                                      AppUtils.buildNormalText(
                                          text: empinfomodel
                                              .message!
                                              .dependantDetails![index]
                                              .dependantName
                                              .toString(),
                                          fontSize: 14,
                                          color: Colors.black),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      AppUtils.buildNormalText(
                                          text: "RELATION SHIP",
                                          fontSize: 12,
                                          color: Colors.grey.shade600),
                                      const SizedBox(height: 5),
                                      AppUtils.buildNormalText(
                                          text: empinfomodel
                                              .message!
                                              .dependantDetails![index]
                                              .relationship
                                              .toString(),
                                          fontSize: 14,
                                          color: Colors.black),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      AppUtils.buildNormalText(
                                          text: "INSURANCE",
                                          fontSize: 12,
                                          color: Colors.grey.shade600),
                                      const SizedBox(height: 5),
                                      AppUtils.buildNormalText(
                                          text: empinfomodel
                                              .message!
                                              .dependantDetails![index]
                                              .insurance
                                              .toString(),
                                          fontSize: 14,
                                          color: Colors.black),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      AppUtils.buildNormalText(
                                          text: "EDU.ALLOWANCE",
                                          fontSize: 12,
                                          color: Colors.grey.shade600),
                                      const SizedBox(height: 5),
                                      AppUtils.buildNormalText(
                                          text: empinfomodel
                                              .message!
                                              .dependantDetails![index]
                                              .educationAllowance
                                              .toString(),
                                          fontSize: 14,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          color: Colors.black),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                    flex: 4,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        AppUtils.buildNormalText(
                                            text: "DATE OF BIRTH",
                                            fontSize: 12,
                                            color: Colors.grey.shade600),
                                        const SizedBox(height: 5),
                                        AppUtils.buildNormalText(
                                            text: empinfomodel.message!
                                                .dependantDetails![index].dob
                                                .toString(),
                                            fontSize: 14,
                                            color: Colors.black),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        AppUtils.buildNormalText(
                                            text: "PHONE NO",
                                            fontSize: 12,
                                            color: Colors.grey.shade600),
                                        const SizedBox(height: 5),
                                        AppUtils.buildNormalText(
                                            text: empinfomodel
                                                .message!
                                                .dependantDetails![index]
                                                .phoneNo
                                                .toString(),
                                            fontSize: 12,
                                            color: Colors.black),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        AppUtils.buildNormalText(
                                            text: "AIR TICKET ELIGIBLITY",
                                            fontSize: 12,
                                            color: Colors.grey.shade600),
                                        const SizedBox(height: 5),
                                        AppUtils.buildNormalText(
                                            text: empinfomodel
                                                .message!
                                                .dependantDetails![index]
                                                .airTicket
                                                .toString(),
                                            fontSize: 14,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            color: Colors.black),
                                        // const SizedBox(
                                        //   height: 15,
                                        // ),
                                        // AppUtils.buildNormalText(
                                        //     text: "ADDRESS",
                                        //     fontSize: 13,
                                        //     color: Colors.grey.shade600),
                                        // const SizedBox(height: 5),
                                        // AppUtils.buildNormalText(
                                        //   text: empinfomodel.message!
                                        //       .dependantDetails![index].address
                                        //       .toString(),
                                        //   fontSize: 14,
                                        //   color: Colors.black,
                                        // ),
                                      ],
                                    )),
                                Expanded(
                                    flex: 1,
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => EditDepends(
                                                  model: empinfomodel,
                                                  iseditable: true,
                                                  position: index)),
                                        ).then((_) => getdata());
                                      },
                                      child: const Icon(
                                        CupertinoIcons.pencil_circle,
                                        size: 24,
                                        color: Appcolor.grey,
                                      ),
                                    ))
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Divider(
                            height: 1,
                            thickness: 0.5,
                            color: Colors.grey.shade300,
                          ),
                        ],
                      ),
                    );
                  })
              : const Center(
                  child: Text('No Depends Found!'),
                ),
        ],
      ),
    );
  }

  // Widget workdetails() {
  //   return (empinfomodel.message != null)
  //       ? ListView.builder(
  //           itemCount: empinfomodel.message!.workExperience!.length,
  //           shrinkWrap: true,
  //           physics: const NeverScrollableScrollPhysics(),
  //           itemBuilder: (BuildContext context, int index) {
  //             return Column(
  //               children: [
  //                 Padding(
  //                   padding: const EdgeInsets.all(8.0),
  //                   child: Row(
  //                     mainAxisAlignment: MainAxisAlignment.start,
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       Expanded(
  //                         flex: 4,
  //                         child: Column(
  //                           mainAxisAlignment: MainAxisAlignment.start,
  //                           crossAxisAlignment: CrossAxisAlignment.start,
  //                           children: [
  //                             AppUtils.buildNormalText(
  //                                 text: "COMPANY",
  //                                 fontSize: 12,
  //                                 color: Colors.grey.shade600),
  //                             const SizedBox(height: 5),
  //                             AppUtils.buildNormalText(
  //                                 text: empinfomodel.message!
  //                                         .workExperience![index].company ??
  //                                     "-",
  //                                 fontSize: 14,
  //                                 maxLines: 2,
  //                                 overflow: TextOverflow.ellipsis,
  //                                 color: Colors.black),
  //                             const SizedBox(
  //                               height: 15,
  //                             ),
  //                             AppUtils.buildNormalText(
  //                                 text: "FROM DATE",
  //                                 fontSize: 12,
  //                                 color: Colors.grey.shade600),
  //                             const SizedBox(height: 5),
  //                             AppUtils.buildNormalText(
  //                                 text: empinfomodel.message!
  //                                         .workExperience![index].fromDate ??
  //                                     "-",
  //                                 fontSize: 14,
  //                                 color: Colors.black),
  //                             const SizedBox(
  //                               height: 15,
  //                             ),
  //                             AppUtils.buildNormalText(
  //                                 text: "COMMENTS",
  //                                 fontSize: 12,
  //                                 color: Colors.grey.shade600),
  //                             const SizedBox(height: 5),
  //                             AppUtils.buildNormalText(
  //                                 text: empinfomodel.message!
  //                                         .workExperience![index].comments ??
  //                                     "-",
  //                                 fontSize: 14,
  //                                 overflow: TextOverflow.ellipsis,
  //                                 color: Colors.black),
  //                           ],
  //                         ),
  //                       ),
  //                       Expanded(
  //                           flex: 4,
  //                           child: Column(
  //                             mainAxisAlignment: MainAxisAlignment.start,
  //                             crossAxisAlignment: CrossAxisAlignment.start,
  //                             children: [
  //                               AppUtils.buildNormalText(
  //                                   text: "JOB TITLE",
  //                                   fontSize: 12,
  //                                   color: Colors.grey.shade600),
  //                               const SizedBox(height: 5),
  //                               AppUtils.buildNormalText(
  //                                   text: empinfomodel.message!
  //                                           .workExperience![index].jobTitle ??
  //                                       "-",
  //                                   fontSize: 14,
  //                                   color: Colors.black),
  //                               const SizedBox(
  //                                 height: 15,
  //                               ),
  //                               AppUtils.buildNormalText(
  //                                   text: "TO DATE ",
  //                                   fontSize: 12,
  //                                   color: Colors.grey.shade600),
  //                               const SizedBox(height: 5),
  //                               AppUtils.buildNormalText(
  //                                   text: empinfomodel.message!
  //                                           .workExperience![index].toDate ??
  //                                       "-",
  //                                   fontSize: 12,
  //                                   color: Colors.black),
  //                             ],
  //                           )),
  //                       Expanded(
  //                           flex: 1,
  //                           child: InkWell(
  //                             onTap: () {
  //                               // Navigator.push(
  //                               //   context,
  //                               //   MaterialPageRoute(
  //                               //       builder: (context) => EditWorkExperience(
  //                               //           model: empinfomodel,
  //                               //           iseditable: true,
  //                               //           position: index)),
  //                               // ).then((_) => getdata());
  //                             },
  //                             child: const Icon(
  //                               CupertinoIcons.pencil_circle,
  //                               size: 24,
  //                               color: Appcolor.grey,
  //                             ),
  //                           ))
  //                     ],
  //                   ),
  //                 ),
  //                 const SizedBox(
  //                   height: 5,
  //                 ),
  //                 Divider(
  //                   height: 1,
  //                   thickness: 0.5,
  //                   color: Colors.grey.shade300,
  //                 ),
  //               ],
  //             );
  //           })
  //       : const Center(
  //           child: Text('No Work Experience Found!'),
  //         );
  // }

  // Widget salarydetails() {
  //   return (empinfomodel.message != null)
  //       ? ListView.builder(
  //           itemCount: empinfomodel.message!.sa!.length,
  //           shrinkWrap: true,
  //           physics: const NeverScrollableScrollPhysics(),
  //           itemBuilder: (BuildContext context, int index) {
  //             return Column(
  //               children: [
  //                 Padding(
  //                   padding: const EdgeInsets.all(8.0),
  //                   child: Row(
  //                     mainAxisAlignment: MainAxisAlignment.start,
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       Expanded(
  //                         child: Column(
  //                           mainAxisAlignment: MainAxisAlignment.start,
  //                           crossAxisAlignment: CrossAxisAlignment.start,
  //                           children: [
  //                             AppUtils.buildNormalText(
  //                                 text: "COMPONENT NAME",
  //                                 fontSize: 12,
  //                                 color: Colors.grey.shade600),
  //                             const SizedBox(height: 5),
  //                             AppUtils.buildNormalText(
  //                                 text: empinfomodel
  //                                     .message!.salary![index].componentName
  //                                     .toString(),
  //                                 fontSize: 12,
  //                                 color: Colors.black),
  //                             const SizedBox(
  //                               height: 15,
  //                             ),
  //                             AppUtils.buildNormalText(
  //                                 text: "MONTHLY",
  //                                 fontSize: 12,
  //                                 color: Colors.grey.shade600),
  //                             const SizedBox(height: 5),
  //                             AppUtils.buildNormalText(
  //                                 text: empinfomodel
  //                                     .message!.salary![index].monthly
  //                                     .toString(),
  //                                 fontSize: 14,
  //                                 color: Colors.black),
  //                             const SizedBox(
  //                               height: 15,
  //                             ),
  //                             AppUtils.buildNormalText(
  //                                 text: "CURRENCY",
  //                                 fontSize: 12,
  //                                 color: Colors.grey.shade600),
  //                             const SizedBox(height: 5),
  //                             AppUtils.buildNormalText(
  //                                 text: empinfomodel
  //                                     .message!.salary![index].currency
  //                                     .toString(),
  //                                 fontSize: 14,
  //                                 color: Colors.black),
  //                           ],
  //                         ),
  //                       ),
  //                       Expanded(
  //                           child: Column(
  //                         mainAxisAlignment: MainAxisAlignment.start,
  //                         crossAxisAlignment: CrossAxisAlignment.start,
  //                         children: [
  //                           AppUtils.buildNormalText(
  //                               text: "TYPE",
  //                               fontSize: 12,
  //                               color: Colors.grey.shade600),
  //                           const SizedBox(height: 5),
  //                           AppUtils.buildNormalText(
  //                               text: empinfomodel.message!.s![index].type
  //                                   .toString(),
  //                               fontSize: 14,
  //                               color: Colors.black),
  //                           const SizedBox(
  //                             height: 15,
  //                           ),
  //                           AppUtils.buildNormalText(
  //                               text: "ANUALLY",
  //                               fontSize: 12,
  //                               color: Colors.grey.shade600),
  //                           const SizedBox(height: 5),
  //                           AppUtils.buildNormalText(
  //                               text: empinfomodel
  //                                   .message!.salary![index].annually
  //                                   .toString(),
  //                               fontSize: 12,
  //                               color: Colors.black),
  //                         ],
  //                       ))
  //                     ],
  //                   ),
  //                 )
  //               ],
  //             );
  //           })
  //       : const Center(
  //           child: Text('No Salary Details Found!'),
  //         );
  // }

  Widget skillsdetails() {
    return Card(
      elevation: 3,
      child: Column(
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => EditSkills(
                        model: empinfomodel, iseditable: false, position: 0)),
              ).then((_) => getdata());
            },
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppUtils.buildNormalText(
                      text: "Skill Details",
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                  AppUtils.buildNormalText(
                      text: "ADD", fontSize: 14, color: Appcolor.twitterBlue),
                ],
              ),
            ),
          ),
          (empinfomodel.message != null &&
                  empinfomodel.message!.skill!.isNotEmpty)
              ? ListView.builder(
                  itemCount: empinfomodel.message!.skill!.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 4,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AppUtils.buildNormalText(
                                        text: "SKILL CODE",
                                        fontSize: 12,
                                        color: Colors.grey.shade600),
                                    const SizedBox(height: 5),
                                    AppUtils.buildNormalText(
                                        text: empinfomodel.message!
                                                .skill![index].skillCode ??
                                            "-",
                                        fontSize: 12,
                                        color: Colors.black),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    AppUtils.buildNormalText(
                                        text: "YEAR OF EXPERIENCE",
                                        fontSize: 12,
                                        color: Colors.grey.shade600),
                                    const SizedBox(height: 5),

                                    AppUtils.buildNormalText(
                                        text: empinfomodel
                                                .message!
                                                .skill![index]
                                                .skillexperience ??
                                            "-",
                                        fontSize: 12,
                                        color: Colors.black),
                                    // AppUtils.buildNormalText(
                                    //     text: empinfomodel
                                    //             .message!
                                    //             .skill![index]
                                    //             .skillCertificate ??
                                    //         "-",
                                    //     fontSize: 12,
                                    //     color: Colors.black),
                                  ],
                                ),
                              ),
                              Expanded(
                                  flex: 4,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      AppUtils.buildNormalText(
                                          text: "SKILL NAME",
                                          fontSize: 12,
                                          color: Colors.grey.shade600),
                                      const SizedBox(height: 5),
                                      AppUtils.buildNormalText(
                                          text: empinfomodel.message!
                                                  .skill![index].skillName ??
                                              "-",
                                          fontSize: 14,
                                          color: Colors.black),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      AppUtils.buildNormalText(
                                          text: "ATTACHMENT",
                                          fontSize: 12,
                                          color: Colors.grey.shade600),
                                      const SizedBox(height: 5),
                                      (empinfomodel.message!.skill![index]
                                                  .skillCertificate
                                                  .toString()
                                                  .isEmpty ||
                                              empinfomodel
                                                      .message!
                                                      .skill![index]
                                                      .skillCertificate
                                                      .toString() ==
                                                  "null")
                                          ? Container()
                                          : RichText(
                                              text: TextSpan(
                                                text: "",
                                                style: const TextStyle(
                                                  fontSize: 15.0,
                                                  color: Colors.black,
                                                ),
                                                children: [
                                                  TextSpan(
                                                      text: "View Attachment",
                                                      style: const TextStyle(
                                                        fontSize: 15.0,
                                                        color:
                                                            Colors.blueAccent,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                      recognizer:
                                                          TapGestureRecognizer()
                                                            ..onTap = () {
                                                              _launchUrl(
                                                                  empinfomodel
                                                                      .message!
                                                                      .skill![
                                                                          index]
                                                                      .skillCertificate
                                                                      .toString(),
                                                                  isNewTab:
                                                                      true);
                                                            })
                                                ],
                                              ),
                                            ),
                                    ],
                                  )),
                              Expanded(
                                  flex: 1,
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => EditSkills(
                                                model: empinfomodel,
                                                iseditable: true,
                                                position: index)),
                                      ).then((_) => getdata());
                                    },
                                    child: const Icon(
                                      CupertinoIcons.pencil_circle,
                                      size: 24,
                                      color: Appcolor.grey,
                                    ),
                                  ))
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Divider(
                          height: 1,
                          thickness: 0.5,
                          color: Colors.grey.shade300,
                        ),
                      ],
                    );
                  })
              : const Center(
                  child: Text('No Skill Details Found!'),
                ),
        ],
      ),
    );
  }

  Widget dependentIDdetails() {
    return Card(
      elevation: 3,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EditDependsIdDetails(
                          model: empinfomodel, iseditable: false, position: 0)),
                ).then((_) => getdata());
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppUtils.buildNormalText(
                      text: "Dependent ID Details",
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                  AppUtils.buildNormalText(
                      text: "ADD", fontSize: 14, color: Appcolor.twitterBlue),
                ],
              ),
            ),
          ),
          (empinfomodel.message != null &&
                  empinfomodel.message!.dependantIdDetails!.isNotEmpty)
              ? ListView.builder(
                  itemCount:
                      empinfomodel.message!.dependantIdDetails!.length ?? 0,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 4,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AppUtils.buildNormalText(
                                        text: "ID NO",
                                        fontSize: 12,
                                        color: Colors.grey.shade600),
                                    const SizedBox(height: 5),
                                    AppUtils.buildNormalText(
                                        text: empinfomodel
                                                .message!
                                                .dependantIdDetails![index]
                                                .idNo ??
                                            "-",
                                        fontSize: 12,
                                        color: Colors.black),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    AppUtils.buildNormalText(
                                        text: "RELATION NAME",
                                        fontSize: 12,
                                        color: Colors.grey.shade600),
                                    const SizedBox(height: 5),
                                    AppUtils.buildNormalText(
                                        text: empinfomodel
                                                .message!
                                                .dependantIdDetails![index]
                                                .dependantIdName ??
                                            "-",
                                        fontSize: 12,
                                        color: Colors.black),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    AppUtils.buildNormalText(
                                        text: "ISSUE DATE",
                                        fontSize: 12,
                                        color: Colors.grey.shade600),
                                    const SizedBox(height: 5),
                                    AppUtils.buildNormalText(
                                        text: empinfomodel
                                                .message!
                                                .dependantIdDetails![index]
                                                .issueDate ??
                                            "-",
                                        fontSize: 12,
                                        color: Colors.black),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    AppUtils.buildNormalText(
                                        text: "DESIGATION",
                                        fontSize: 12,
                                        color: Colors.grey.shade600),
                                    const SizedBox(height: 5),
                                    AppUtils.buildNormalText(
                                        text: empinfomodel
                                                .message!
                                                .dependantIdDetails![index]
                                                .designation ??
                                            "-",
                                        fontSize: 12,
                                        color: Colors.black),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    AppUtils.buildNormalText(
                                        text: "REMAINDER",
                                        fontSize: 12,
                                        color: Colors.grey.shade600),
                                    const SizedBox(height: 5),
                                    AppUtils.buildNormalText(
                                        text: empinfomodel
                                            .message!
                                            .dependantIdDetails![index]
                                            .remainder
                                            .toString(),
                                        fontSize: 12,
                                        color: Colors.black),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    AppUtils.buildNormalText(
                                        text: "ATTACHMENT",
                                        fontSize: 12,
                                        color: Colors.grey.shade600),
                                    const SizedBox(height: 5),
                                    (empinfomodel
                                                .message!
                                                .dependantIdDetails![index]
                                                .attachment
                                                .toString()
                                                .isEmpty ||
                                            empinfomodel
                                                    .message!
                                                    .dependantIdDetails![index]
                                                    .attachment
                                                    .toString() ==
                                                "null")
                                        ? Container()
                                        : RichText(
                                            text: TextSpan(
                                              text: "",
                                              style: const TextStyle(
                                                fontSize: 15.0,
                                                color: Colors.black,
                                              ),
                                              children: [
                                                TextSpan(
                                                    text: "View Attachment",
                                                    style: const TextStyle(
                                                      fontSize: 15.0,
                                                      color: Colors.blueAccent,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                    recognizer:
                                                        TapGestureRecognizer()
                                                          ..onTap = () {
                                                            _launchUrl(
                                                                empinfomodel
                                                                    .message!
                                                                    .dependantIdDetails![
                                                                        index]
                                                                    .attachment
                                                                    .toString(),
                                                                isNewTab: true);
                                                          })
                                              ],
                                            ),
                                          ),
                                  ],
                                ),
                              ),
                              Expanded(
                                  flex: 4,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      AppUtils.buildNormalText(
                                          text: "ID TYPE",
                                          fontSize: 12,
                                          color: Colors.grey.shade600),
                                      const SizedBox(height: 5),
                                      AppUtils.buildNormalText(
                                          text: empinfomodel
                                                  .message!
                                                  .dependantIdDetails![index]
                                                  .idType ??
                                              "-",
                                          fontSize: 12,
                                          color: Colors.black,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      AppUtils.buildNormalText(
                                          text: "COUNTRY OF ISSUE",
                                          fontSize: 12,
                                          color: Colors.grey.shade600),
                                      const SizedBox(height: 5),
                                      AppUtils.buildNormalText(
                                          text: empinfomodel
                                                  .message!
                                                  .dependantIdDetails![index]
                                                  .countryOfIssue ??
                                              "-",
                                          fontSize: 12,
                                          color: Colors.black,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      AppUtils.buildNormalText(
                                          text: "EXPIRY DATE",
                                          fontSize: 12,
                                          color: Colors.grey.shade600),
                                      const SizedBox(height: 5),
                                      AppUtils.buildNormalText(
                                          text: empinfomodel
                                                  .message!
                                                  .dependantIdDetails![index]
                                                  .expiryDate ??
                                              "-",
                                          fontSize: 12,
                                          color: Colors.black,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      AppUtils.buildNormalText(
                                          text: "REMARKS",
                                          fontSize: 12,
                                          color: Colors.grey.shade600),
                                      const SizedBox(height: 5),
                                      AppUtils.buildNormalText(
                                          text: empinfomodel
                                                  .message!
                                                  .dependantIdDetails![index]
                                                  .remarks ??
                                              "-",
                                          fontSize: 12,
                                          color: Colors.black,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      AppUtils.buildNormalText(
                                          text: "REMAINDER DATE",
                                          fontSize: 12,
                                          color: Colors.grey.shade600),
                                      const SizedBox(height: 5),
                                      AppUtils.buildNormalText(
                                          text: empinfomodel
                                                  .message!
                                                  .dependantIdDetails![index]
                                                  .remainderDate ??
                                              "-",
                                          fontSize: 12,
                                          color: Colors.black,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis),
                                    ],
                                  )),
                              Expanded(
                                  flex: 1,
                                  child: InkWell(
                                    onTap: () {
                                      print(empinfomodel.message!
                                          .dependantIdDetails![index].sId);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                EditDependsIdDetails(
                                                    model: empinfomodel,
                                                    iseditable: true,
                                                    position: index)),
                                      ).then((_) => getdata());
                                    },
                                    child: const Icon(
                                      CupertinoIcons.pencil_circle,
                                      size: 24,
                                      color: Appcolor.grey,
                                    ),
                                  ))
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Divider(
                          height: 1,
                          thickness: 0.5,
                          color: Colors.grey.shade300,
                        ),
                      ],
                    );
                  })
              : const Center(
                  child: Text('No Dependents Found!'),
                ),
        ],
      ),
    );
  }

  void getdata() async {
    setState(() {
      loading = true;
    });
    ApiService.getemployeedetailsdata().then((response) {
      setState(() {
        loading = false;
      });
      if (response.statusCode == 200) {
        if (jsonDecode(response.body)['status'].toString() == "true") {
          empinfomodel = EmpInfoModel.fromJson(jsonDecode(response.body));
        } else {
          AppUtils.showSingleDialogPopup(
              context,
              jsonDecode(response.body)['message'],
              "Ok",
              onexitpopup,
              AssetsImageWidget.warningimage);
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

  void onrefresh() {
    Navigator.of(context).pop();
    getdata();
    // Navigator.pushReplacement(
    //     context, MaterialPageRoute(builder: (context) => const ProfilePage()));
  }

  void onsuccessimagerefresh() {
    Navigator.of(context).pop();
  }

  Future<void> _launchUrl(url, {bool isNewTab = true}) async {
    if (Platform.isAndroid) {
      if (!await launchUrl(Uri.parse(url),
          mode: LaunchMode.externalNonBrowserApplication)) {
        throw Exception('Could not launch $url');
      }
    } else if (Platform.isIOS) {
      if (!await launchUrl(Uri.parse(url),
          mode: LaunchMode.externalApplication)) {
        throw Exception('Could not launch $url');
      }
    }
  }
}
