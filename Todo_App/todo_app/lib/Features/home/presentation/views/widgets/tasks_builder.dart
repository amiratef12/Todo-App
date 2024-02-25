import 'package:flutter/material.dart';
import 'package:todo_app/Features/home/presentation/views/widgets/build_task_item.dart';

class TasksBuilder extends StatelessWidget {
  const TasksBuilder({
    super.key,
    required this.tasks,
  });

  final List<Map> tasks;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemBuilder: (context, index) => BuildTaskItem(
              model: tasks[index],
            ),
        separatorBuilder: (context, index) => Container(
              width: double.infinity,
              height: 1.0,
              color: Colors.grey[300],
            ),
        itemCount: tasks.length);
  }
}
