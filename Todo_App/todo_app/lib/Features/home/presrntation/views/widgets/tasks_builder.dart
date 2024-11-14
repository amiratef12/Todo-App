import 'package:flutter/material.dart';
import 'package:todo_app/Features/home/presrntation/views/widgets/build_task_item.dart';

class TasksBuilder extends StatelessWidget {
  const TasksBuilder({super.key, required this.tasks});
  final List<Map> tasks;
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemBuilder: (context, index) {
          return BuildTaskItem(
            model: tasks[index],
          );
        },
        separatorBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsetsDirectional.only(start: 20),
            child: Container(
              width: double.infinity,
              height: 1,
              color: Colors.grey[300],
            ),
          );
        },
        itemCount: tasks.length);
  }
}
