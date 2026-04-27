import 'package:flutter/material.dart';
import 'package:resize/resize.dart';

import '../config/app_colors.dart';
import '../config/app_text_styles.dart';

class CategoryCardWidget extends StatelessWidget {
  final Widget categoryImage;
  final VoidCallback onTap;

  final String categoryName;
  const CategoryCardWidget({
    super.key,
    required this.categoryImage,
    required this.categoryName,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        // padding: EdgeInsets.fromLTRB(10.w, 10.h, 10.w, 10.h),
        margin: EdgeInsets.fromLTRB(0.w, 8.h, 0.w, 8.h),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 7,
              blurRadius: 10,
            )
          ],
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              // 👈 VERY IMPORTANT
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                child: categoryImage,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10.w, 10.h, 10.w, 10.h),
              child: Text(
                categoryName,
                textAlign: TextAlign.start,
                maxLines: 2, // 👈 prevents overflow
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodyTextStyle12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
