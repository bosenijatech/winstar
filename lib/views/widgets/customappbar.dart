import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Customappbar extends StatelessWidget implements PreferredSizeWidget {
  const Customappbar(
      {super.key,
      this.title,
      this.actions,
      this.leadingIcon,
      this.leadingOnPressed,
      this.showBackArrow = false});

  final Widget? title;
  final bool showBackArrow;
  final IconData? leadingIcon;
  final List<Widget>? actions;
  final VoidCallback? leadingOnPressed;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      titleTextStyle: const TextStyle(color: Colors.white),
      //backgroundColor: Appcolor.primarycolor,
      automaticallyImplyLeading: false,
      leading: showBackArrow
          ? IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(CupertinoIcons.back))
          : leadingIcon != null
              ? IconButton(onPressed: leadingOnPressed, icon: Icon(leadingIcon))
              : null,
      title: title,

      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
