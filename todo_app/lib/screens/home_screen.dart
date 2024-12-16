import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/config/routes/route_location.dart';
import 'package:todo_app/data/data.dart';
import 'package:todo_app/providers/providers.dart';
import 'package:todo_app/utils/utils.dart';
import 'package:todo_app/widgets/display_list_of_tasks.dart';
import 'package:todo_app/widgets/display_white_text.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  static HomeScreen builder(BuildContext context, GoRouterState state) =>
      const HomeScreen();

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors =
        Theme
            .of(context)
            .colorScheme; // Sử dụng Theme để lấy colorScheme
    final deviceSize = MediaQuery
        .of(context)
        .size; // Sử dụng MediaQuery để lấy kích thước thiết bị
    final taskState = ref.watch(taskProvider);
    final completedTasks = _completedTasks(taskState.tasks, ref);
    final incompletedTasks = _incompletedTasks(taskState.tasks, ref);
    final selectedDate = ref.watch(dateProvider);

    return Scaffold(
      body: Column(
        children: [
          Container(
            height: deviceSize.height * 0.3,
            width: deviceSize.width,
            color: colors.primary,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () => Helpers.selectDate(context, ref),
                  child: DisplayWhiteText(
                    text: DateFormat.yMMMd().format(selectedDate),
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                const DisplayWhiteText(
                  text: 'My Todo List',
                  fontSize: 40,
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DisplayListOfTasks(tasks: incompletedTasks),
                  const Gap(20),
                  Text('Completed',
                      style: Theme
                          .of(context)
                          .textTheme
                          .headlineMedium),
                  const Gap(20),
                  DisplayListOfTasks(
                    tasks: completedTasks,
                    isCompletedTasks: true,
                  ),
                  const Gap(20),
                  ElevatedButton(
                    onPressed: () => context.push(RouteLocation.createTask),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: DisplayWhiteText(text: 'Add New Task'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Task> _completedTasks(List<Task> tasks, WidgetRef ref) {
    final selectedDate = ref.watch(dateProvider);
    final List<Task> filteredTasks = [];
    for (var task in tasks) {
      final isTaskDay = Helpers.isTaskFromSelectedDate(task, selectedDate);
      if (task.isCompleted && isTaskDay) {
        filteredTasks.add(task);
      }
    }
    return filteredTasks
    ;
  }

  List<Task> _incompletedTasks(List<Task> tasks, WidgetRef ref) {
    final selectedDate = ref.watch(dateProvider);
    final List<Task> filteredTasks = [];
    for (var task in tasks) {
      final isTaskDay = Helpers.isTaskFromSelectedDate(task, selectedDate);
      if (!task.isCompleted && isTaskDay) {
        final isTaskDay = Helpers.isTaskFromSelectedDate(task, selectedDate);
        filteredTasks.add(task);
      }
    }
    return filteredTasks;
  }
}
