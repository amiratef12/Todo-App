import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/Features/home/presrntation/manger/cubit/app_cubit.dart';
import 'package:todo_app/Features/home/presrntation/manger/cubit/app_state.dart';
import 'package:todo_app/Features/home/presrntation/views/widgets/no_tasks.dart';
import 'package:todo_app/Features/home/presrntation/views/widgets/tasks_builder.dart';

class ArchivedTasksScreen extends StatelessWidget {
  const ArchivedTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppStates>(builder: (context, state) {
      var tasks = BlocProvider.of<AppCubit>(context).archiveTasks;
      if (tasks.isNotEmpty) {
        return TasksBuilder(tasks: tasks);
      } else {
        return const NoTasks();
      }
    });
  }
}
