import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '/util/extension/extension.dart';
import '/constants/constants.dart';

class DescriptionForm extends StatelessWidget {
  const DescriptionForm({Key? key, required this.controller}) : super(key: key);

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppStrings.description
            .plain()
            .color(AppColors.kGrayTextC)
            .fSize(16)
            .b()
            .tr(),
        SizedBox(height: 12.w),
        Container(
          height: 120.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.r),
            border: Border.all(
              color: AppColors.kInnerBorderForm,
            ),
          ),
          child: Column(
            children: [
              Expanded(
                child: TextFormField(
                  validator: (val) => val!.isNotEmpty
                      ? null
                      : StringTranslateExtension(AppStrings.pleaseEnterYourText)
                          .tr(),
                  controller: controller,
                  maxLines: 3,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                  ),
                ).pad(0, 10),
              ),
              Container(
                width: screenWidth,
                height: 48.w,
                color: AppColors.kGrayBack50,
                child: Row(
                  children: [
                    SizedBox(width: 16.w),
                    SvgPicture.asset(
                      AppImages.attachIcon,
                      width: 19.w,
                      height: 20.w,
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    ).pad(0, 24);
  }
}
