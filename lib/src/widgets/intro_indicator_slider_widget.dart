import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resize/resize.dart';

import '../../multi_language/language_constants.dart';
import '../config/app_colors.dart';
import '../config/app_font.dart';
import '../config/app_text_styles.dart';

class IndicatorSliderWidget extends StatefulWidget {
  IndicatorSliderWidget({Key? key}) : super(key: key);

  @override
  State<IndicatorSliderWidget> createState() => _IndicatorSliderWidgetState();
}

class _IndicatorSliderWidgetState extends State<IndicatorSliderWidget> {
  final CarouselSliderController _controller = CarouselSliderController();
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: CarouselSlider(
            items: imageSliders,
            carouselController: _controller,
            options: CarouselOptions(
              autoPlay: true,
              viewportFraction: 1.0,
              aspectRatio: 1,
              enlargeCenterPage: false,
              onPageChanged: (index, reason) {
                setState(() => _current = index);
              },
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: imageSliders.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () => _controller.animateToPage(entry.key),
              child: Container(
                width: _current == entry.key ? 30.0 : 8.0,
                height: 8.0,
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                decoration: BoxDecoration(
                  borderRadius: _current == entry.key
                      ? BorderRadius.circular(4)
                      : null,
                  shape: _current == entry.key
                      ? BoxShape.rectangle
                      : BoxShape.circle,
                  color: _current == entry.key
                      ? AppColors.primaryColor
                      : AppColors.black,
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

final List<Widget> imageSliders = [
  SliderImageStyle(
    img: 'assets/images/intro-teachers.png',
    title: LanguageConstant.discoverTeachers.tr,
    tagLine: LanguageConstant.anywhereAnyTimewithYourSmartphone.tr,
    description:
    LanguageConstant.ourTeamOfHighlySkilledAttorneysComprisesSeasoned.tr,
  ),
  SliderImageStyle(
    img: 'assets/images/intro-academies.png',
    title: LanguageConstant.findAcademies.tr,
    tagLine: LanguageConstant.anywhereAnyTimewithYourSmartphone.tr,
    description:
    LanguageConstant.ourTeamOfHighlySkilledAttorneysComprisesSeasoned.tr,
  ),
];

class SliderImageStyle extends StatelessWidget {
  final String img, description, title, tagLine;

  const SliderImageStyle({
    Key? key,
    required this.img,
    required this.description,
    required this.tagLine,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: constraints.maxHeight * 0.55,
              width: double.infinity,
              child: Image.asset(img, fit: BoxFit.contain),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyTextStyle1,
            ),
            const SizedBox(height: 6),
            Text(
              tagLine,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyTextStyle13,
            ),
            const SizedBox(height: 6),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Text(
                description,
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.textColorOne,
                  fontFamily: AppFont.primaryFontFamily,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}