import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:to_do_list/models/meta_user_model.dart';
import 'package:to_do_list/models/project_model.dart';
import 'package:to_do_list/models/task_model.dart';

import '/base/base_state.dart';
import '/constants/constants.dart';
import '/util/extension/dimens.dart';
import '/util/extension/widget_extension.dart';
import '/widgets/primary_button.dart';
import '../../util/ui/common_widget/custom_avatar_loading_image.dart';
import 'new_task_provider.dart';
import 'new_task_vm.dart';

class NewTaskPage extends StatefulWidget {
  final ScopedReader watch;

  static Widget instance() {
    return Consumer(builder: (context, watch, _) {
      return NewTaskPage._(watch);
    });
  }

  const NewTaskPage._(this.watch);

  @override
  State<StatefulWidget> createState() {
    return NewTaskState();
  }
}

class NewTaskState extends BaseState<NewTaskPage, NewTaskViewModel> {
  final formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  ProjectModel? dropValue;
  DateTime? dueDateValue;
  final f = new DateFormat('dd/MM/yyyy');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            width: screenWidth,
            height: 44.w,
            child: Container(color: AppColors.kPrimaryColor),
          ),
          buildForm(),
        ],
      ),
    );
  }

  Widget buildForm() => Positioned(
        top: 10,
        left: 0,
        width: screenWidth,
        height: 669.h,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5.r),
            boxShadow: AppConstants.kFormShadow,
          ),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 32.w),
                  buildInForm(),
                  SizedBox(height: 24.w),
                  buildTitleForm(),
                  SizedBox(height: 16.w),
                  buildDesForm(),
                  SizedBox(height: 24.w),
                  buildDueDateForm(),
                  SizedBox(height: 24.w),
                  buildDoneButton(),
                  SizedBox(height: 24.w),
                  buildMemberForm(),
                  SizedBox(height: 30.w),
                ],
              ),
            ),
          ),
        ).pad(0, 16),
      );

  Widget buildInForm() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppStrings.in_.bold().fSize(18).b().tr(),
        SizedBox(width: 8.w),
        Container(
          width: 256.w,
          height: 48.w,
          decoration: BoxDecoration(
            color: AppColors.kGrayBack,
            borderRadius: BorderRadius.circular(50.w),
          ),
          child: StreamBuilder<List<ProjectModel>?>(
              stream: getVm().bsListProject,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text("Loading");
                }

                List<ProjectModel> data = snapshot.data!;
                return DropdownButtonFormField<ProjectModel>(
                  value: dropValue,
                  items: data
                      .map<DropdownMenuItem<ProjectModel>>(
                        (e) => DropdownMenuItem<ProjectModel>(
                          child: Container(
                            width: 200.w,
                            child: e.name
                                .plain()
                                .fSize(14)
                                .weight(FontWeight.w600)
                                .overflow(TextOverflow.ellipsis)
                                .b(),
                          ),
                          value: e,
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      dropValue = value;
                    });
                  },
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                  ),
                ).pad(16, 16, 0, 10);
              }),
        ),
      ],
    );
  }

  Widget buildTitleForm() {
    return Container(
      height: 66.w,
      color: AppColors.kGrayBack,
      child: TextFormField(
        controller: titleController,
        style: TextStyle(
          color: AppColors.kText,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        decoration: InputDecoration(
          hintText: StringTranslateExtension(AppStrings.title).tr(),
          hintStyle: TextStyle(
            color: AppColors.kText80,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
          border: InputBorder.none,
        ),
      ).pad(24, 24, 10, 0),
    );
  }

  Widget buildDesForm() {
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
                  controller: descriptionController,
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

  Widget buildDueDateForm() {
    return Container(
      color: AppColors.kGrayBack,
      child: Row(
        children: [
          AppStrings.dueDate.plain().fSize(16).b().tr(),
          SizedBox(width: 8.w),
          Container(
            decoration: BoxDecoration(
              color: AppColors.kSplashColor[1],
              borderRadius: BorderRadius.circular(5.r),
            ),
            child: (dueDateValue == null
                    ? StringTranslateExtension(AppStrings.anytime).tr()
                    : f.format(dueDateValue!))
                .plain()
                .color(Colors.white)
                .fSize(14)
                .b()
                .pad(7, 14),
          ).inkTap(
            onTap: () {
              showDatePicker(
                context: context,
                initialDate: dueDateValue ?? DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2025),
              ).then((date) {
                setState(() {
                  dueDateValue = date;
                });
              });
            },
          ),
        ],
      ).pad(17, 24),
    );
  }

  Widget buildMemberForm() {
    return Column(
      children: [
        AppStrings.addMember.plain().weight(FontWeight.w600).fSize(16).b().tr(),
        SizedBox(height: 8),
        StreamBuilder<List<MetaUserModel>>(
          stream: getVm().bsListUser,
          builder: (ct, snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("Loading");
            }

            List<MetaUserModel> data = snapshot.data!;
            return Wrap(
              children: [
                for (int i = 0; i < data.length; i++)
                  if (data[i].url != null)
                    CustomAvatarLoadingImage(
                            url: data[i].url ?? '', imageSize: 64)
                        .pad(23, 10, 24),
              ],
            );
          },
        )
      ],
    ).pad(0, 16);
  }

  Widget buildDoneButton() => PrimaryButton(
        text: StringTranslateExtension(AppStrings.addTask).tr(),
        press: () {
          if (formKey.currentState!.validate()) {
            // QuickNoteModel quickNote = new QuickNoteModel(
            //   content: descriptionController.text,
            //   indexColor: indexChooseColor,
            //   time: DateTime.now(),
            // );
            getVm().newTask(dropValue!.id!, titleController.text,
                descriptionController.text, dueDateValue!);
            Get.back();
          }
        },
      ).pad(0, 24);

  AppBar buildAppBar() =>
      StringTranslateExtension(AppStrings.newTask).tr().plainAppBar().bAppBar();

  @override
  NewTaskViewModel getVm() => widget.watch(viewModelProvider).state;
}
