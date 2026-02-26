import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:bindhaeness/routenames.dart';
import 'package:bindhaeness/utils/constants.dart';
import 'package:bindhaeness/views/widgets/custom_scaffold.dart';

class Menuspage extends StatelessWidget {
  const Menuspage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: SingleChildScrollView(
        child: Column(
          children: [
            trendingProducts(),
          ],
        ),
      ),
    );
  }

  Widget trendingProducts() {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(5),
      child: GridView.builder(
        itemCount: AppConstants.categories.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return CategoryCard(
            index: index,
            icon: AppConstants.categories[index]["icon"],
            text: AppConstants.categories[index]["text"],
            press: () {
              // if (index == 0) {
              //   Navigator.pushNamed(context, RouteNames.attendancehistory);
              // }
              // if (index == 1) {
              //   Navigator.pushNamed(context, RouteNames.overtimehistory);
              // }
              if (index == 0) {
                Navigator.pushNamed(context, RouteNames.viewleave);
              }
              if (index == 1) {
                Navigator.pushNamed(context, RouteNames.viewcompoffleave);
              }
              if (index == 2) {
                Navigator.pushNamed(context, RouteNames.viewletter);
              }

              if (index == 3) {
                Navigator.pushNamed(context, RouteNames.payslip);
              }
              // if (index == 5) {
              //   Navigator.pushNamed(context, RouteNames.viewasset);
              // }
              // if (index == 6) {
              //   Navigator.pushNamed(context, RouteNames.viewrejoin);
              // }
              // if (index == 6) {
              //   Navigator.pushNamed(context, RouteNames.reimview);
              // }
              // if (index == 7) {
              //   Navigator.pushNamed(context, RouteNames.addgrievance);
              // }
            },
          );
        },
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, childAspectRatio: 1.2),
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

  final String icon, text;
  final int index;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            height: 56,
            width: 56,
            decoration: BoxDecoration(
              color: Colors.white60,
              borderRadius: BorderRadius.circular(30),
            ),
            child: SvgPicture.asset(icon),
          ),
          const SizedBox(height: 4),
          Text(text, textAlign: TextAlign.center)
        ],
      ),
    );
  }
}
