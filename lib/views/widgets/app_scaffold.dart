import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:powergroupess/views/widgets/network_status_service.dart';
import 'package:provider/provider.dart';

class AppScaffold extends StatelessWidget {
  final Widget child;
  const AppScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    var networkstatus = Provider.of<NetworkStatusService>(context);
    return Scaffold(
        body: networkstatus == NetworkStatus.Online
            ? child
            : const Center(
                child: Text('You are Offile'),
              ));
  }
}
