import 'package:flutter/material.dart';
import 'package:to_do_list/pages/home/tab/my_task/widgets/list_task_date.dart';
import '/constants/constants.dart';
import '/util/ui/common_widget/task_card.dart';

import '/base/base_state.dart';
import '/pages/home/tab/my_task/my_task_vm.dart';
import '/util/extension/widget_extension.dart';
import '/models/task_model.dart';
import 'my_task_provider.dart';
import 'widgets/filter_button.dart';
import 'widgets/to_day_switch.dart';

class MyTaskTab extends StatefulWidget {
  final ScopedReader watch;

  static Widget instance() {
    return Consumer(builder: (context, watch, _) {
      return MyTaskTab._(watch);
    });
  }

  const MyTaskTab._(this.watch);

  @override
  State<StatefulWidget> createState() {
    return MyTaskState();
  }
}

class MyTaskState extends BaseState<MyTaskTab, MyTaskViewModel> {
  bool isToDay = true;

  @override
  void initState() {
    super.initState();

    getVm().bsIsToDay.listen((value) {
      setState(() {
        isToDay = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildBody(),
      appBar: buildAppBar(),
    );
  }

  Widget buildBody() {
    return Container(
      child: Column(
        children: [
          buildToDaySwitch(),
          buildListCard(),
        ],
      ),
    );
  }

  Widget buildToDaySwitch() => ToDaySwitch(
        isToDay: isToDay,
        press: getVm().setToDay,
      );

  Widget buildListCard() => StreamBuilder<List<TaskModel>?>(
        stream: getVm().bsListTask,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return AppStrings.somethingWentWrong.text12().tr().center();
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return AppStrings.loading.text12().tr().center();
          }

          List<TaskModel> data = snapshot.data!;

          return Column(
            children: [
              for (int i = 0; i < data.length; i++)
                if (i == 0 ||
                    data[i - 1].dueDate!.year != data[i].dueDate!.year ||
                    data[i - 1].dueDate!.month != data[i].dueDate!.month ||
                    data[i - 1].dueDate!.day != data[i].dueDate!.day)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      toDateString(data[i].dueDate!)
                          .plain()
                          .color(AppColors.kGrayTextA)
                          .b()
                          .pad(20, 0, 24, 10),
                      TaskCard(task: data[i]),
                    ],
                  )
                else
                  TaskCard(task: data[i]),
            ],
          );
        },
      );

  AppBar buildAppBar() =>
      StringTranslateExtension(AppStrings.workList).tr().plainAppBar().actions([
        FilterButton(),
      ]).bAppBar();

  @override
  MyTaskViewModel getVm() => widget.watch(viewModelProvider).state;
}
