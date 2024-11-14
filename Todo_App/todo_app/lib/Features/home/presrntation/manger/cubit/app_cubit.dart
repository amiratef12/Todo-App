import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/Features/home/presrntation/manger/cubit/app_state.dart';
import 'package:todo_app/Features/home/presrntation/views/widgets/archived_tasks_screen.dart';
import 'package:todo_app/Features/home/presrntation/views/widgets/done_tasks_screen.dart';
import 'package:todo_app/Features/home/presrntation/views/widgets/new_tasks_screen.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());
  int currentIndex = 0;
  List<Widget> screens = const [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen()
  ];
  List<String> titles = ['New Tasks', 'Done Tasks', 'Archived Tasks'];
  late Database database;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archiveTasks = [];
  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;

  void changeIndex(int index) {
    currentIndex = index;
    emit(AppChangeBottomNavBarState());
  }

  void createDatabase() {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database, version) {
        log('database is created');
        database
            .execute(
                'CREATE TABLE tasks (id INTEGER PRIMARY KEY , title TEXT , date TEXT , time TEXT , status TEXT )')
            .then((value) {
          log('table is created');
        }).catchError((error) {
          log('error is ${error.toString()}');
        });
      },
      onOpen: (database) {
        getDataFromDatabase(database);
        log('database is opened');
      },
    ).then((value) {
      database = value;
      emit(AppCreateDatabaseState());
    });
  }

  insertToDatabase(
      {required String title,
      required String time,
      required String date}) async {
    await database.transaction((txn) async {
      txn
          .rawInsert(
              'INSERT INTO tasks(title, time, date, status) VALUES("$title", "$time", "$date", "new")')
          .then((value) {
        log("$value is inserted successfully");
        emit(AppInsertDatabaseState());
        getDataFromDatabase(database);
      }).catchError((error) {
        log('error is ${error.toString()}');
      });
    });
  }

  void getDataFromDatabase(database) {
    newTasks = [];
    doneTasks = [];
    archiveTasks = [];
    database.rawQuery('SELECT * FROM tasks').then((value) {
      value.forEach((element) {
        if (element['status'] == 'new') {
          newTasks.add(element);
        } else if (element['status'] == 'done') {
          doneTasks.add(element);
        } else {
          archiveTasks.add(element);
        }
      });
      emit(AppGetDatabaseState());
    });
  }

  void changeBottomSheet({required bool isShow, required IconData icon}) {
    isBottomSheetShown = isShow;
    fabIcon = icon;
    emit(AppChangeBottomSheetState());
  }

  void updateData({required String status, required int id}) {
    database.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ?', [status, id]).then((value) {
      emit(AppUpdateDatabaseState());
      getDataFromDatabase(database);
    });
  }

  void deleteData({required int id}) async {
    database.rawDelete('DELETE FROM tasks WHERE id = ?', [id]).then((value) {
      emit(AppDeleteDatabaseState());
      getDataFromDatabase(database);
    });
  }
}
