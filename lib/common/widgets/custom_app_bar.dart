import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String leadingText;
  final Color? backgroundColor;

  const CustomAppBar({
    super.key,
    this.title = '',
    this.backgroundColor = Colors.transparent,
    this.leadingText = '',
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w400),
      ),
      backgroundColor: backgroundColor,
      elevation: 0.0,
      centerTitle: true,
      leadingWidth: 100,
      leading: _buildLeadingGesture(context),
      // actions: [_buildActionGesture(context)],
    );
  }

  Widget _buildLeadingGesture(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.pop(context); // Navigate back
          },
          child: Container(
            margin: const EdgeInsets.all(10),
            alignment: Alignment.center,
            width: 30,
            decoration: BoxDecoration(
              // color: const Color(0xfff7f8f8),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.arrow_back, color: Colors.black, size: 24),
          ),
        ),
        Text(
          leadingText,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 14, color: Colors.black),
        ),
      ],
    );
  }

  // Widget _buildActionGesture(BuildContext context) {
  //   return GestureDetector(
  //     onTap: () {
  //       log('Actions tapped!');
  //     },
  //     child: Container(
  //       margin: const EdgeInsets.all(10),
  //       alignment: Alignment.center,
  //       width: 37,
  //       decoration: BoxDecoration(
  //         color: const Color(0xfff7f8f8),
  //         borderRadius: BorderRadius.circular(10),
  //       ),
  //       child: const Icon(Icons.more_vert, color: Colors.black, size: 24),
  //     ),
  //   );
  // }

  @override
  // Implementing PreferredSizeWidget
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
