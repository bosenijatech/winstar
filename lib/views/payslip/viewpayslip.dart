import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:bindhaeness/services/apiservice.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:bindhaeness/models/yearmodel.dart';
import 'package:bindhaeness/services/pref.dart';
import 'package:bindhaeness/utils/sharedprefconstants.dart';
import 'package:bindhaeness/views/payslip/payslipmodel.dart';
import 'package:bindhaeness/views/payslip/viewpdf.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewPaySlipPage extends StatefulWidget {
  const ViewPaySlipPage({super.key});

  @override
  State<ViewPaySlipPage> createState() => _ViewPaySlipPageState();
}

class _ViewPaySlipPageState extends State<ViewPaySlipPage> {
  final yearKey = GlobalKey<DropdownSearchState<YearModel>>();
  final now = DateTime.now();
  bool loading = false;
  String? selectedYear;
  PaySlipModel? paySlipModel;
  YearModel? selectedYearModel;
  @override
  void initState() {
    selectedYearModel =
        YearModel(name: now.year.toString(), id: "1", inactive: false);
    selectedYear = now.year.toString();
    getPayslip(selectedYear.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          "Payslip",
          style: TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🎯 Year Dropdown
                  Text(
                    "Select Year",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800]),
                  ),
                  const SizedBox(height: 8),

                  DropdownSearch<YearModel>(
                    selectedItem: selectedYearModel,
                    key: yearKey,
                    popupProps: PopupProps.menu(
                      showSearchBox: true,
                      interceptCallBacks: true, //important line
                      itemBuilder: (ctx, item, isSelected) {
                        return ListTile(
                            selected: isSelected,
                            title: Text(
                              item.name.toString(),
                            ),
                            onTap: () {
                              yearKey.currentState?.popupValidate([item]);
                              selectedYear = item.name;
                              selectedYearModel = item;
                              getPayslip(selectedYearModel?.name ?? "");
                              setState(() {});
                            });
                      },
                    ),
                    asyncItems: (String filter) => ApiService.getyearModel(
                      filter: filter,
                    ),
                    itemAsString: (YearModel item) => item.name.toString(),
                    dropdownDecoratorProps: DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                        hintText: 'Year * ',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(1),
                          borderSide:
                              const BorderSide(color: Colors.grey, width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(1),
                          borderSide:
                              const BorderSide(color: Colors.grey, width: 1),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 🧾 Payslip List
                  Expanded(
                    child: (paySlipModel != null &&
                            paySlipModel!.data != null &&
                            paySlipModel!.data!.isNotEmpty &&
                            paySlipModel!.data!.first.payslips != null &&
                            paySlipModel!.data!.first.payslips!.isNotEmpty)
                        ? ListView.separated(
                            itemCount:
                                paySlipModel!.data!.first.payslips!.length,
                            itemBuilder: (context, index) {
                              final payslip =
                                  paySlipModel!.data!.first.payslips![index];
                              return _buildPayslipCard(
                                  payslip.paymonth ?? "Unknown",
                                  payslip.payslip ?? "");
                            },
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 12),
                          )
                        : _buildEmptyState(),
                  ),
                ],
              ),
            ),
    );
  }

  // 🪄 Beautiful Payslip Card
  Widget _buildPayslipCard(String month, String pdfUrl) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        leading: Container(
          decoration: BoxDecoration(
            color: Colors.deepPurple.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(10),
          child: const Icon(
            Icons.picture_as_pdf_rounded,
            color: Colors.deepPurple,
            size: 28,
          ),
        ),
        title: Text(
          month,
          style: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87),
        ),
        subtitle: Text(
          selectedYear ?? "",
          style: TextStyle(color: Colors.grey[600], fontSize: 13),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              tooltip: "View Payslip",
              icon:
                  const Icon(CupertinoIcons.eye_fill, color: Colors.deepPurple),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ViewPdf(pdfurl: pdfUrl),
                  ),
                );
              },
            ),
            IconButton(
              tooltip: "Download",
              icon: const Icon(CupertinoIcons.arrow_down_circle_fill,
                  color: Colors.green),
              onPressed: () {
                _launchUrl(Uri.parse(pdfUrl));
              },
            ),
          ],
        ),
      ),
    );
  }

  // 🪫 Empty state
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(CupertinoIcons.doc_text_search,
              size: 60, color: Colors.grey),
          const SizedBox(height: 12),
          Text(
            "No payslips found for $selectedYear",
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // 🌐 Launch PDF URL
  Future<void> _launchUrl(url, {bool isNewTab = true}) async {
    if (kIsWeb) {
      if (!await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
        webOnlyWindowName: isNewTab ? '_blank' : '_self',
      )) {
        throw Exception('Could not launch $url');
      }
    } else if (Platform.isAndroid) {
      if (!await launchUrl(url,
          mode: LaunchMode.externalNonBrowserApplication)) {
        throw Exception('Could not launch $url');
      }
    } else if (Platform.isIOS) {
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        throw Exception('Could not launch $url');
      }
    }
  }

  // 💼 Payslip API
  void getPayslip(String year) async {
    final String employeeId =
        Prefs.getNsID(SharefprefConstants.sharednsid).toString();

    setState(() => loading = true);
    var body = {
      "employeeId": employeeId,
      "year": year,
    };
    try {
      final response = await ApiService.viewPayslip(body);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        print("Payslip API Response: $jsonResponse");

        if (jsonResponse['Status'] == true) {
          final List<dynamic> employeeList = jsonResponse['Data'] ?? [];
          final matchedEmployee = employeeList.firstWhere(
            (e) => e['employeeId'].toString() == employeeId,
            orElse: () => null,
          );

          setState(() {
            paySlipModel = matchedEmployee != null
                ? PaySlipModel.fromJson({
                    ...jsonResponse,
                    'Data': [matchedEmployee],
                  })
                : null;
            loading = false;
          });
        } else {
          setState(() {
            paySlipModel = null;
            loading = false;
          });
        }
      } else {
        print("Error: HTTP ${response.statusCode}");
        setState(() => loading = false);
      }
    } catch (e) {
      print("Exception in getPayslip: $e");
      setState(() => loading = false);
    }
  }
}
