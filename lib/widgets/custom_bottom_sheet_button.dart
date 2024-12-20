import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomBottomSheetButton extends StatelessWidget {
  final Function()? onTap;
  final Icon icon;
  final String subtitle;
  final double size;
  final double padding;
  final double fontSize;
  const CustomBottomSheetButton({
    super.key,
    this.onTap,
    required this.subtitle,
    this.size = 60,
    this.padding = 16,
    required this.fontSize,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(200),
            ),
            child: Padding(
              padding: EdgeInsets.all(padding),
              child: CircleAvatar(
                radius: Get.width * 0.08,
                child: icon,
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          subtitle,
          style: TextStyle(fontSize: fontSize),
        )
      ],
    );
  }
}
