import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/Features/home/presentation/manager/cubit/app_cubit.dart';
import 'package:todo_app/Features/home/presentation/views/home_layout.dart';
import 'package:todo_app/simple_bloc_observer.dart';

void main() {
  Bloc.observer = MyBlocObserver();
  runApp(const TodoApp());
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()..createDatabase(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomeLayout(),
      ),
    );
  }
}
