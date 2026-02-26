import 'package:flutter/material.dart';

class ProgressWithIcon extends StatelessWidget {
  const ProgressWithIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 100,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(
            // you can replace this with Image.asset
            'assets/images/logo2.png',
            fit: BoxFit.fill,
            height: 60,
            width: 60,
          ),
          // you can replace
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
            strokeWidth: 1,
          ),
        ],
      ),
    );
  }
}
