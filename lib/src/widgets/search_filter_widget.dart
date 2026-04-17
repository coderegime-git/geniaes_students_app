import 'package:flutter/material.dart';
import 'package:resize/resize.dart';

import '../config/app_colors.dart';
import '../config/app_text_styles.dart';

class SearchFilterWidget extends StatelessWidget {
  final VoidCallback onSearchTap;
  final String hintText;
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  const SearchFilterWidget({
    super.key,
    required this.onSearchTap,
    required this.controller,
    this.onChanged,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.w, 10.h, 18.w, 0),
      child: Material(
        elevation: 6.0,
        borderRadius: BorderRadius.circular(40),
        shadowColor: Colors.grey.withOpacity(0.4),
        child: TextField(
          controller: controller,
          onChanged: onChanged,
          decoration: InputDecoration(
              fillColor: AppColors.white,
              filled: true,
              hintText: hintText,
              hintStyle: AppTextStyles.hintTextStyle1,
              labelStyle: AppTextStyles.hintTextStyle1,
              isDense: true,
              contentPadding:
                  EdgeInsets.symmetric(vertical: 0.h, horizontal: 0.w),
              enabledBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(width: 1, color: AppColors.transparent),
                borderRadius: BorderRadius.circular(40),
              ),
              errorBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(width: 1, color: AppColors.transparent),
                borderRadius: BorderRadius.circular(40),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(width: 1, color: AppColors.transparent),
                borderRadius: BorderRadius.circular(40),
              ),
              prefixIcon: Image.asset(
                "assets/icons/Search_alt.png",
                scale: 1.5.h,
              ),
              suffixIcon: Padding(
                padding: const EdgeInsets.fromLTRB(3, 3, 3, 3),
                child: GestureDetector(
                  onTap: onSearchTap,
                  child: Container(
                    decoration: const BoxDecoration(
                        gradient: AppColors.gradientOne,
                        shape: BoxShape.circle),
                    child: Image.asset(
                      "assets/icons/Filter_alt_fill.png",
                      scale: 1.3.h,
                    ),
                  ),
                ),
              )),
        ),
      ),
    );
  }
}
