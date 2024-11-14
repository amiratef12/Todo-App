import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/Features/home/presrntation/manger/cubit/app_cubit.dart';
import 'package:todo_app/Features/home/presrntation/views/home_layout.dart';
import 'package:todo_app/simple_bloc_observer.dart';

void main() {
  runApp(const TodoApp());
  Bloc.observer = MyBlocObserver();
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()..createDatabase(),
      child: MaterialApp(
        theme: ThemeData(useMaterial3: false),
        debugShowCheckedModeBanner: false,
        home: const HomeLayout(),
      ),
    );
  }
}
