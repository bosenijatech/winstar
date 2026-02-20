// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:powergroupess/routenames.dart';
// import 'package:powergroupess/utils/app_utils.dart';
// import 'package:powergroupess/utils/appcolor.dart';
// import 'package:powergroupess/utils/constants.dart';
// import 'package:powergroupess/views/widgets/custom_scaffold.dart';
// import 'package:powergroupess/views/widgets/customappbar.dart';
// import 'package:provider/provider.dart';

// class Menuspage extends StatelessWidget {
//   const Menuspage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return CustomScaffold(
//       child: SingleChildScrollView(
//         child: Column(
//           children: [
//             trendingProducts(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget trendingProducts() {
//     return Container(
//       padding: const EdgeInsets.all(10),
//       margin: const EdgeInsets.all(5),
//       child: GridView.builder(
//         itemCount: AppConstants.categories.length,
//         shrinkWrap: true,
//         physics: const NeverScrollableScrollPhysics(),
//         itemBuilder: (context, index) {
//           return CategoryCard(
//             index: index,
//             icon: AppConstants.categories[index]["icon"],
//             text: AppConstants.categories[index]["text"],
//             press: () {
//               if (index == 0) {
//                 Navigator.pushNamed(context, RouteNames.attendancehistory);
//               }
//               if (index == 1) {
//                 Navigator.pushNamed(context, RouteNames.viewleave);
//               }
//               if (index == 2) {
//                 Navigator.pushNamed(context, RouteNames.viewletter);
//               }
//               // if (index == 3) {
//               //   Navigator.pushNamed(context, RouteNames.dutytravelview);
//               // }

//               if (index == 3) {
//                 Navigator.pushNamed(context, RouteNames.payslip);
//               }
//               if (index == 4) {
//                 Navigator.pushNamed(context, RouteNames.viewasset);
//               }
//               if (index == 5) {
//                 Navigator.pushNamed(context, RouteNames.viewrejoin);
//               }
//               // if (index == 6) {
//               //   Navigator.pushNamed(context, RouteNames.reimview);
//               // }
//               // if (index == 7) {
//               //   Navigator.pushNamed(context, RouteNames.addgrievance);
//               // }
//             },
//           );
//         },
//         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 3, childAspectRatio: 1.2),
//       ),
//     );
//   }
// }

// class CategoryCard extends StatelessWidget {
//   const CategoryCard({
//     super.key,
//     required this.index,
//     required this.icon,
//     required this.text,
//     required this.press,
//   });

//   final String icon, text;
//   final int index;
//   final GestureTapCallback press;

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: press,
//       child: Column(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(16),
//             height: 56,
//             width: 56,
//             decoration: BoxDecoration(
//               color: Colors.white60,
//               borderRadius: BorderRadius.circular(30),
//             ),
//             child: SvgPicture.asset(icon),
//           ),
//           const SizedBox(height: 4),
//           Text(text, textAlign: TextAlign.center)
//         ],
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:powergroupess/routenames.dart';
import 'package:powergroupess/utils/constants.dart';
import 'package:powergroupess/views/widgets/custom_scaffold.dart';

class Menuspage extends StatelessWidget {
  const Menuspage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFF6F8FF),
              Color(0xFFFFFFFF),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GridView.builder(
                itemCount: AppConstants.categories.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
          
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 0.90,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 14,
                ),
                itemBuilder: (context, index) {
                  return CategoryCard(
                    index: index,
                    icon: AppConstants.categories[index]["icon"],
                    text: AppConstants.categories[index]["text"],
                    press: () {
                      if (index == 0) {
                        Navigator.pushNamed(
                            context, RouteNames.attendancehistory);
                      }
                      if (index == 1) {
                        Navigator.pushNamed(context, RouteNames.viewleave);
                      }
                      if (index == 2) {
                        Navigator.pushNamed(context, RouteNames.viewletter);
                      }
                      if (index == 3) {
                        Navigator.pushNamed(context, RouteNames.payslip);
                      }
                      if (index == 4) {
                        Navigator.pushNamed(context, RouteNames.viewasset);
                      }
                      if (index == 5) {
                        Navigator.pushNamed(context, RouteNames.viewrejoin);
                      }
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    super.key,
    required this.index,
    required this.icon,
    required this.text,
    required this.press,
  });

  final int index;
  final IconData icon;
  final String text;
  final GestureTapCallback press;

  Color _getBgColor(int index) {
    switch (index) {
      case 0:
        return const Color(0xFF2563EB); // Attendance - Blue
      case 1:
        return const Color(0xFF16A34A); // Leave - Green
      case 2:
        return const Color(0xFF7C3AED); // Letter - Purple
      case 3:
        return const Color(0xFFEA580C); // Payslip - Orange
      case 4:
        return const Color(0xFFDC2626); // Asset - Red
      case 5:
        return const Color(0xFF0F766E); // Rejoin - Teal
      default:
        return const Color(0xFF334155);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bg = _getBgColor(index);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: press,
        borderRadius: BorderRadius.circular(18),
        splashColor: bg.withOpacity(0.12),
        highlightColor: bg.withOpacity(0.06),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: Colors.white,
            border: Border.all(
              color: Colors.grey.withOpacity(0.15),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 16,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 54,
                width: 54,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  color: bg,
                  boxShadow: [
                    BoxShadow(
                      color: bg.withOpacity(0.25),
                      blurRadius: 12,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Icon(
                  icon,
                  size: 26,
                  color: Colors.white, // ✅ All icons white
                ),
              ),
              const SizedBox(height: 12),
              Text(
                text,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  height: 1.1,
                  color: Color(0xFF0F172A),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
