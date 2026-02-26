import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bindhaeness/services/apiservice.dart';
import 'package:bindhaeness/services/pref.dart';
import 'package:bindhaeness/utils/app_utils.dart';
import 'package:bindhaeness/utils/appcolor.dart';
import 'package:bindhaeness/views/widgets/assets_image_widget.dart';
import 'package:bindhaeness/views/widgets/custom_button.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';

class ApplyReqularization extends StatefulWidget {
  final String id;
  final String docdate;
  final String fromtime;
  final String totime;
  const ApplyReqularization(
      {super.key,
      required this.id,
      required this.docdate,
      required this.fromtime,
      required this.totime});

  @override
  State<ApplyReqularization> createState() => _ApplyReqularizationState();
}

class _ApplyReqularizationState extends State<ApplyReqularization> {
  TextEditingController fromtimeController = TextEditingController();
  TextEditingController totimeController = TextEditingController();
  TextEditingController attachcontroller = TextEditingController();
  TextEditingController reasoncontroller = TextEditingController();
  TextEditingController datepickercontroller = TextEditingController();

  List<String> files = [];
  List<File> filelist = [];
  List<PlatformFile>? _paths;
  bool loading = false;

  @override
  void initState() {
    if (widget.id.toString().isEmpty) {
      fromtimeController.text = "";
      totimeController.text = "";
      datepickercontroller.text = widget.docdate;
    } else {
      fromtimeController.text = widget.fromtime.toString();
      // totimeController.text = widget.totime.toString();
      datepickercontroller.text = widget.docdate;
    }
    super.initState();
  }

  @override
  void dispose() {
    fromtimeController.clear();
    totimeController.clear();
    attachcontroller.clear();
    reasoncontroller.clear();

    datepickercontroller.clear();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.clear, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: AppUtils.buildNormalText(
            text: widget.id.toString().isNotEmpty
                ? "Reqularization Request \n  Req Date : ${widget.docdate}"
                : "Reqularization Request",
            color: Colors.black,
            fontSize: 20),
        centerTitle: true,
      ),
      body: !loading
          ? SingleChildScrollView(
              child: Column(
                children: [getregularization()],
              ),
            )
          : Center(
              child: CupertinoActivityIndicator(
                  radius: 30.0, color: Appcolor.primarycolor),
            ),
    );
  }

  Widget getregularization() {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(left: 5, right: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            enabled: widget.id.toString().isEmpty ? true : false,
            readOnly: true,
            controller: datepickercontroller,
            maxLength: 100,
            onTap: () async {
              pickerdate(datepickercontroller);
            },
            decoration: const InputDecoration(
              counterText: '',
              labelText: 'Choose Date',
            ),
          ),
          TextField(
            readOnly: true,
            controller: fromtimeController,
            maxLength: 100,
            onTap: () async {
              pickertime(fromtimeController);
            },
            decoration: const InputDecoration(
              counterText: '',
              labelText: 'From Time',
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
            readOnly: true,
            controller: totimeController,
            maxLength: 100,
            onTap: () {
              pickertime(totimeController);
            },
            decoration: const InputDecoration(
              counterText: '',
              labelText: 'To Time',
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          AppUtils.buildNormalText(text: "Attachment", fontSize: 15),
          const SizedBox(
            height: 10,
          ),
          TextField(
            readOnly: true,
            controller: attachcontroller,
            decoration: InputDecoration(
              border: const UnderlineInputBorder(),
              hintText: "Click here to Attach file",
              suffixIcon: IconButton(
                icon: const Icon(
                  Icons.attach_file,
                  color: Colors.black,
                ),
                onPressed: () {
                  pickFiles();
                },
              ),
            ),
            textInputAction: TextInputAction.done,
          ),
          const SizedBox(
            height: 10,
          ),
          AppUtils.buildNormalText(text: "Reason", fontSize: 15),
          const SizedBox(
            height: 10,
          ),
          Container(
              //padding: EdgeInsets.all(20),
              child: TextField(
            controller: reasoncontroller,
            keyboardType: TextInputType.multiline,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: "Enter Reason",
              focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: Colors.grey)),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(1.0),
                borderSide: const BorderSide(color: Colors.black26, width: 1),
              ),
            ),
          )),
          const SizedBox(
            height: 20,
          ),
          CustomButton(
            onPressed: () {
              if (attachcontroller.text.isEmpty) {
                onapplyregularization();
              } else {
                //uploadfiles();
              }
            },
            name: "Apply Regularization",
            circularvalue: 30,
            fontSize: 14,
          )
        ],
      ),
    );
  }

  pickFiles() async {
    try {
      _paths = (await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowMultiple: false,
        onFileLoading: (FilePickerStatus status) => print(status),
        allowedExtensions: [
          'png',
          'jpg',
          'jpeg',
        ],
      ))
          ?.files;
    } on PlatformException catch (e) {
      print(e.toString());
    } catch (e) {
      print(e.toString());
    }
    setState(() {
      if (_paths != null) {
        _paths!.clear();

        files.add(_paths!.first.path.toString());

        attachcontroller.text = _paths!.first.name;
      }
    });
  }

  // Future uploadfiles() async {
  //   setState(() {
  //     loading = true;
  //   });
  //   Uri url;
  //   url = Uri.parse(AppConstants.LIVE_URL + AppConstants.uploadfiles);

  //   var request = http.MultipartRequest('POST', url);
  //   for (int i = 0; i < files.length; i++) {
  //     request.files.add(await http.MultipartFile.fromPath('files', files[i]));
  //   }

  //   http.StreamedResponse response = await request.send();
  //   response.stream.transform(utf8.decoder).listen((value) {
  //     setState(() {
  //       loading = false;
  //     });
  //     if (response.statusCode == 200) {
  //       var imagename2 = "";
  //       List<dynamic> list = json.decode(value);
  //       imagename2 = list[0]["filename"];
  //       var camfilepath = list[0]["path"];
  //       onapplyregularization();
  //     }
  //   });
  //   setState(() {
  //     loading = false;
  //   });
  // }

  void pickerdate(controller) async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        //Current month only show uptodate
        firstDate: DateTime(DateTime.now().year, DateTime.now().month,
            1), //.subtract(const Duration(days: 30)),
        lastDate: DateTime.now());

    if (pickedDate != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);

      // var dateFormate =
      //     DateFormat("dd/MM/yyyy").format(DateTime.parse(formattedDate));

      controller.text = formattedDate;
    }
  }

  void pickertime(controller) async {
    TimeOfDay? pickedTime = await showTimePicker(
      initialTime: TimeOfDay.now(),
      context: context,
      // builder: (context, child) {
      //   return MediaQuery(
      //     data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
      //     child: child ?? Container(),
      //   );
      // },
    );

    if (pickedTime != null) {
      setState(() {
        var df = DateFormat("h:mm a");
        var dt = df.parse(pickedTime.format(context));
        print(DateFormat('HH:mm:ss').format(dt));
        controller.text = DateFormat('HH:mm:ss').format(dt);
        if (fromtimeController.text.isEmpty && totimeController.text.isEmpty) {
        } else {
          validatetiming(fromtimeController.text, totimeController.text);
        }
      });
    } else {
      print("Time is not selected");
    }
  }

  validatetiming(String starttime, String endtime) {
    var format = DateFormat("HH:mm:ss");
    var start = format.parse(starttime);
    var end = format.parse(endtime);

    if (start.isBefore(end)) {
      //end = end.add(Duration(days: 1));
      Duration diff = end.difference(start);
      final hours = diff.inHours;
      final minutes = diff.inMinutes % 60;
    } else {
      AppUtils.showSingleDialogPopup(
          context,
          "From Time and To Time is Mismatched!",
          "OK",
          onclearvalues,
          AssetsImageWidget.errorimage);
    }
  }

  void onapplyregularization() async {
    String mobilecurrentdatetime =
        DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now());

    var json = {
      "refno": widget.id,
      "fromtime": fromtimeController.text.toString(),
      "totime": totimeController.text.toString(),
      "regularizationdate": datepickercontroller.text,
      "attachment": "",
      "remarks": reasoncontroller.text.toString(),
      "source": "Mob",
      "nsId": Prefs.getNsID('nsid'),
      "createdbyName": Prefs.getFullName("Name"),
      "emp_code": Prefs.getEmpID('empID'),
      "emp_name": Prefs.getFullName('Name'),
      "createdDate": mobilecurrentdatetime,
    };
    print(jsonEncode(json));

    setState(() {
      loading = true;
    });
    ApiService.postreqularization(json).then((response) {
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

          setState(() {});
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

  void onclearvalues() {
    fromtimeController.text = "";
    totimeController.text = "";
    fromtimeController.clear();
    totimeController.clear();
    Navigator.of(context).pop();
  }

  void onrefreshscreen() {
    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }
}
