import 'package:flutter/material.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  const TopBar(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
      ),
      title: Text(
        title,
        overflow: TextOverflow.visible,
        style: TextStyle(
          color: const Color.fromARGB(255, 8, 102, 196),
          fontWeight: FontWeight.w700,
          fontSize: MediaQuery.widthOf(context) / 12.5,
        ),
      ),
      centerTitle: true,
      shadowColor: const Color.fromARGB(255, 8, 102, 196),
      elevation: 4,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
