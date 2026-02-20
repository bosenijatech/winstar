// import 'package:flutter/material.dart';

// class CustomScaffold extends StatelessWidget {
//   const CustomScaffold({super.key, this.child, this.title});
//   final Widget? child;
//   final String? title;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       extendBodyBehindAppBar: true,
//       body: Stack(
//         children: [
//           Image.asset(
//             'assets/images/waveshapes.png',
//             fit: BoxFit.cover,
//             width: double.infinity,
//             height: double.infinity,
//           ),
//           SafeArea(
//             child: child!,
//           ),
//         ],
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:winstar/utils/Appcolor.dart';

class CustomScaffold extends StatelessWidget {
  const CustomScaffold({super.key, this.child, this.title});

  final Widget? child;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // ✅ Background Color
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Appcolor.lighterBlue.withOpacity(0.1), // <-- indha color change panniko
          ),

          // Background Image
          // Image.asset(
          //   'assets/images/waveshapes.png',
          //   fit: BoxFit.cover,
          //   width: double.infinity,
          //   height: double.infinity,
          // ),

          SafeArea(
            child: child ?? const SizedBox(),
          ),
        ],
      ),
    );
  }
}
