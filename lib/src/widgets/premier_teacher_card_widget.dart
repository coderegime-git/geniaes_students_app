import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:resize/resize.dart';
import 'package:tutorhub_for_students/multi_language/language_constants.dart';

import '../config/app_colors.dart';
import '../config/app_text_styles.dart';
import 'button_widget.dart';

class PremierTeacherCardWidget extends StatelessWidget {
  final Widget teacherImage, categories;
  final String teacherName, teacherRating;
  final double initRating;
  final VoidCallback onTap;
  const PremierTeacherCardWidget(
      {super.key,
      required this.teacherImage,
      required this.teacherName,
      required this.categories,
      required this.teacherRating,
      required this.initRating,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.fromLTRB(8.w, 3.h, 8.w, 3.h),
        margin: EdgeInsets.fromLTRB(8.w, 5.h, 8.w, 5.h), // was 18.h
        decoration: BoxDecoration(
          gradient: AppColors.gradientSix,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 7,
              blurRadius: 10,
            )
          ],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          // mainAxisSize: MainAxisSize.min,
          children: [
            teacherImage,
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(8.w, 0, 2.w, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                      teacherName,
                      textAlign: TextAlign.start,
                      style: AppTextStyles.bodyTextStyle10,
                    ),
                    SizedBox(
                      height: 4.h,
                    ),
                    categories,
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                      LanguageConstant
                          .ourTeamOfHighlySkilledAttorneysComprisesSeasoned.tr,
                      textAlign: TextAlign.start,
                      style: AppTextStyles.bodyTextStyle7,
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 6.h, 0, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              RatingBar.builder(
                                initialRating: initRating,
                                minRating: 1,
                                itemSize: 15.h,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemCount: 5,
                                ignoreGestures: true,
                                itemPadding:
                                    const EdgeInsets.symmetric(horizontal: 0.0),
                                itemBuilder: (context, _) => const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                onRatingUpdate: (double value) {},
                              ),
                              SizedBox(width: 1.w),
                              Text(
                                // '4.5',
                                teacherRating,

                                textAlign: TextAlign.start,
                                style: AppTextStyles.bodyTextStyle7,
                              ),
                            ],
                          ),
                          ButtonWidgetFour(
                            buttonText: LanguageConstant.profile.tr,
                            onTap: onTap,
                            innerBorderColor: AppColors.tertiaryColor,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
