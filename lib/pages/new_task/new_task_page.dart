import 'package:flutter/material.dart';
import '/models/task_model.dart';
import 'widgets/due_date_form.dart';
import 'widgets/member_form.dart';
import 'widgets/description_form.dart';
import 'widgets/title_form.dart';
import '/routing/app_routes.dart';
import '/models/meta_user_model.dart';
import '/models/project_model.dart';
import '/base/base_state.dart';
import '/constants/constants.dart';
import '/util/extension/dimens.dart';
import '/util/extension/widget_extension.dart';
import '/widgets/primary_button.dart';
import 'new_task_provider.dart';
import 'new_task_vm.dart';
import 'widgets/in_form.dart';

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
  List<MetaUserModel> selectUsers = [];

  ProjectModel? dropValue;
  DateTime? dueDateValue;
  TimeOfDay? dueTimeValue;
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
                  buildMemberForm(),
                  SizedBox(height: 24.w),
                  buildDoneButton(),
                  SizedBox(height: 30.w),
                ],
              ),
            ),
          ),
        ).pad(0, 16),
      );

  void setValueInForm(ProjectModel? value) {
    setState(() {
      dropValue = value;
    });
  }

  Widget buildInForm() {
    return StreamBuilder<List<ProjectModel>?>(
      stream: getVm().bsListProject,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return AppStrings.somethingWentWrong.text12().tr().center();
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return AppStrings.loading.text12().tr().center();
        }

        List<ProjectModel> data = snapshot.data!;
        return InForm(
          value: dropValue,
          listValue: data,
          press: setValueInForm,
        );
      },
    );
  }

  Widget buildTitleForm() {
    return TitleForm(controller: titleController);
  }

  Widget buildDesForm() {
    return DescriptionForm(controller: descriptionController);
  }

  void setValueDate(DateTime? date) {
    setState(() {
      dueDateValue = date;
    });
  }

  void setValueTime(TimeOfDay? time) {
    setState(() {
      dueTimeValue = time;
    });
  }

  Widget buildDueDateForm() {
    return DueDateForm(
      valueDate: dueDateValue,
      valueTime: dueTimeValue,
      pressDate: setValueDate,
      pressTime: setValueTime,
    );
  }

  void selectListUser() {
    Get.toNamed(
      AppRoutes.LIST_USER_FORM,
      arguments: selectUsers,
    )?.then((value) {
      print(value);
      setState(() {
        this.selectUsers = value;
      });
    });
  }

  Widget buildMemberForm() {
    return MemberForm(listUser: selectUsers, press: selectListUser);
  }

  void addTaskClick() async {
    List<String> list = [];

    for (var userDate in selectUsers) {
      list.add(userDate.uid);
    }

    if (formKey.currentState!.validate() &&
        dropValue != null &&
        dueDateValue != null &&
        dueTimeValue != null) {
      dueDateValue = new DateTime(dueDateValue!.year, dueDateValue!.month,
          dueDateValue!.day, dueTimeValue!.hour, dueTimeValue!.minute);
      TaskModel task = new TaskModel(
        idProject: dropValue!.id,
        idAuthor: getVm().user!.uid,
        title: titleController.text,
        description: descriptionController.text,
        startDate: DateTime.now(),
        dueDate: dueDateValue!,
        listMember: list,
      );
      await getVm().newTask(task, dropValue!);
      Get.back();
    }
  }

  Widget buildDoneButton() => PrimaryButton(
        text: StringTranslateExtension(AppStrings.addTask).tr(),
        press: () => addTaskClick(),
        disable: !onRunning,
      ).pad(0, 24);

  AppBar buildAppBar() =>
      StringTranslateExtension(AppStrings.newTask).tr().plainAppBar().bAppBar();

  @override
  NewTaskViewModel getVm() => widget.watch(viewModelProvider).state;
}
