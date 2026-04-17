import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:resize/resize.dart';

import '../../multi_language/language_constants.dart';
import '../config/app_colors.dart';
import '../config/app_text_styles.dart';
import 'button_widget.dart';

class TeacherCardWidget extends StatelessWidget {
  final Widget teacherImage, categories;
  final String teacherName, teacherRating;
  final double initRating;
  final VoidCallback onTap;
  const TeacherCardWidget(
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
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
        margin: const EdgeInsets.fromLTRB(18, 0, 18, 18),
        decoration: BoxDecoration(
          color: AppColors.white,
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
                padding: const EdgeInsets.fromLTRB(12, 0, 6, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                      teacherName,
                      textAlign: TextAlign.start,
                      style: AppTextStyles.bodyTextStyle11,
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
                              SizedBox(width: 5.w),
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
                            innerBorderColor: AppColors.white,
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
