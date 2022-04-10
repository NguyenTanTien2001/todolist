import 'package:flutter/material.dart';

import '/constants/app_colors.dart';
import '/util/extension/dimens.dart';
import '/util/extension/widget_extension.dart';

class CountTaskItem extends StatelessWidget {
  const CountTaskItem(
      {Key? key,
      this.text = '',
      this.task = 0,
      this.color = AppColors.kPrimaryColor})
      : super(key: key);

  final String text;
  final int task;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160.w,
      height: 100.w,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(5.r),
        boxShadow: [
          BoxShadow(
            offset: Offset(2, 10),
            color: AppColors.kBoxShadow,
            blurRadius: 8.0,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          text
              .plain()
              .fSize(18)
              .color(Colors.white)
              .weight(FontWeight.w500)
              .lines(1)
              .lHeight(21.09)
              .b(),
          SizedBox(height: 6.w),
          '$task Tasks'
              .plain()
              .fSize(14)
              .color(Colors.white)
              .weight(FontWeight.w400)
              .lHeight(17.23)
              .b(),
        ],
      ).pad(24, 0, 0),
    );
  }
}
