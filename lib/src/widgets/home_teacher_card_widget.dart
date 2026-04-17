import 'package:flutter/material.dart';
import 'package:resize/resize.dart';

import '../config/app_colors.dart';
import '../config/app_text_styles.dart';

class HomeTeacherCardWidget extends StatelessWidget {
  final Widget image, premiumImage;
  final VoidCallback onSearchTap;

  final String name, categoryName;
  const HomeTeacherCardWidget({
    super.key,
    required this.image,
    required this.name,
    required this.categoryName,
    required this.premiumImage,
    required this.onSearchTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSearchTap,
      child: Container(
        padding: EdgeInsets.fromLTRB(10.w, 10.h, 10.w, 10.h),
        margin: EdgeInsets.fromLTRB(0.w, 12.h, 0.w, 12.h),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 7,
              blurRadius: 10,
            )
          ],
          color: AppColors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            image,
            SizedBox(height: 6.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  // "Jhon Doe",
                  name,
                  textAlign: TextAlign.start,
                  style: AppTextStyles.bodyTextStyle6,
                ),
                SizedBox(width: 12.w),
                premiumImage,
              ],
            ),
            SizedBox(height: 4.h),
            Text(
              categoryName,
              textAlign: TextAlign.start,
              style: AppTextStyles.bodyTextStyle7,
            ),
          ],
        ),
      ),
    );
  }
}
