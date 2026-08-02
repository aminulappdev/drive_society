import 'package:dirve_society/common/size_box/custom_sizebox.dart';
import 'package:flutter/material.dart';

import '../app_color/app_colors.dart';
import '../app_text_style/styles.dart';

class InfoContainer extends StatelessWidget {
  final String imagePath;
  final String label;
  final String value;

  const InfoContainer({
    super.key,
    required this.imagePath,
    required this.label,
    required this.value, 
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 120,
      decoration: BoxDecoration(
        //border: Border.all(color: AppColors.grey),
        borderRadius: BorderRadius.circular(8),
        color: AppColors.bottomNavbar,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            imagePath,
            scale: 4,
            fit: BoxFit.cover,
          ),
          sh8,
          Text(
            label,
            style: h7,
          ),
          sh5,
          Text(
            value,
            style: h1.copyWith(
              fontSize: 16,
              color: AppColors.darkRed,
            ),
          ),
        ],
      ),
    );
  }
}
