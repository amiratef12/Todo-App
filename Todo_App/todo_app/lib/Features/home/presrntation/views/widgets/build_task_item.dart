import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/Features/home/presrntation/manger/cubit/app_cubit.dart';

class BuildTaskItem extends StatelessWidget {
  const BuildTaskItem({super.key, required this.model});
  final Map model;
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(model['id'].toString()),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              child: Text(model["time"]),
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    model["title"],
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    model["date"],
                    style: const TextStyle(color: Colors.grey),
                  )
                ],
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            IconButton(
                onPressed: () {
                  BlocProvider.of<AppCubit>(context)
                      .updateData(status: 'done', id: model['id']);
                },
                icon: const Icon(
                  Icons.check_box,
                  color: Colors.green,
                )),
            IconButton(
                onPressed: () {
                  BlocProvider.of<AppCubit>(context)
                      .updateData(status: 'archive', id: model['id']);
                },
                icon: const Icon(
                  Icons.archive,
                  color: Colors.black45,
                ))
          ],
        ),
      ),
      onDismissed: (direction) {
        BlocProvider.of<AppCubit>(context).deleteData(id: model['id']);
      },
    );
  }
}
