import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/Features/home/presentation/manager/cubit/app_cubit.dart';
import 'package:todo_app/Features/home/presentation/manager/cubit/app_states.dart';
import 'package:todo_app/Features/home/presentation/views/widgets/custom_text_form_field.dart';

class HomeLayout extends StatelessWidget {
  HomeLayout({super.key});

  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is AppInsertDatabaseState) {
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        var cubit = BlocProvider.of<AppCubit>(context);
        return Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            title: Text(cubit.titles[cubit.currentIndex]),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              if (cubit.isBottomSheetShown) {
                if (formKey.currentState!.validate()) {
                  cubit.insertToDatabase(
                      title: titleController.text,
                      date: dateController.text,
                      time: timeController.text);
                }
              } else {
                scaffoldKey.currentState
                    ?.showBottomSheet(
                      (context) => Container(
                        padding: const EdgeInsets.all(20),
                        child: Form(
                          key: formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CustomTextFormField(
                                  controller: titleController,
                                  keyboardType: TextInputType.text,
                                  hintText: 'Task Title',
                                  prefixIcon: const Icon(Icons.title)),
                              const SizedBox(
                                height: 15,
                              ),
                              CustomTextFormField(
                                  controller: timeController,
                                  keyboardType: TextInputType.datetime,
                                  onTap: () {
                                    showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay.now())
                                        .then((value) {
                                      timeController.text =
                                          value!.format(context).toString();
                                    });
                                  },
                                  hintText: 'Task Time',
                                  prefixIcon:
                                      const Icon(Icons.watch_later_outlined)),
                              const SizedBox(
                                height: 15,
                              ),
                              CustomTextFormField(
                                  controller: dateController,
                                  keyboardType: TextInputType.datetime,
                                  onTap: () {
                                    showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime.now(),
                                            lastDate:
                                                DateTime.parse('2024-08-30'))
                                        .then((value) {
                                      dateController.text =
                                          DateFormat.yMMMd().format(value!);
                                    });
                                  },
                                  hintText: 'Task Date',
                                  prefixIcon: const Icon(Icons.calendar_today))
                            ],
                          ),
                        ),
                      ),
                    )
                    .closed
                    .then((value) {
                  cubit.changeBottomSheetState(isShow: false, icon: Icons.edit);
                });
                cubit.changeBottomSheetState(isShow: true, icon: Icons.add);
              }
            },
            child: Icon(cubit.fabIcon),
          ),
          bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: cubit.currentIndex,
              onTap: (index) {
                cubit.changeIndex(index);
              },
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Tasks'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.check_circle_outline), label: 'Done'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.archive_outlined), label: 'Archived')
              ]),
          body: cubit.screens[cubit.currentIndex],
        );
      },
    );
  }
}
