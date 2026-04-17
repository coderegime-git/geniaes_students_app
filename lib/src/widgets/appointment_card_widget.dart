import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resize/resize.dart';

import '../../multi_language/language_constants.dart';
import '../config/app_colors.dart';
import '../config/app_text_styles.dart';
import 'button_widget.dart';

class AppointmentCardWidget extends StatelessWidget {
  final Widget teacherImage, appointmentStatus;
  final String teacherName, appointmentTypeName, dateAndTime;

  final VoidCallback onTap;
  const AppointmentCardWidget(
      {super.key,
      required this.teacherImage,
      required this.teacherName,
      required this.onTap,
      required this.appointmentStatus,
      required this.appointmentTypeName,
      required this.dateAndTime});

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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          teacherName,
                          textAlign: TextAlign.start,
                          style: AppTextStyles.bodyTextStyle11,
                        ),
                        appointmentStatus
                      ],
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Row(
                      children: [
                        Text(
                          "${LanguageConstant.appointment.tr}: ",
                          textAlign: TextAlign.start,
                          style: AppTextStyles.bodyTextStyle3,
                        ),
                        Text(
                          appointmentTypeName,
                          textAlign: TextAlign.start,
                          style: AppTextStyles.bodyTextStyle9,
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 6.h, 0, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            dateAndTime,
                            textAlign: TextAlign.start,
                            style: AppTextStyles.bodyTextStyle15,
                          ),
                          ButtonWidgetFour(
                            buttonText: "",
                            onTap: onTap,
                            innerBorderColor: AppColors.white,
                            icon: const Icon(
                              Icons.remove_red_eye_outlined,
                              color: AppColors.white,
                              size: 18,
                            ),
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
