import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/Features/home/presrntation/manger/cubit/app_cubit.dart';
import 'package:todo_app/Features/home/presrntation/manger/cubit/app_state.dart';
import 'package:todo_app/Features/home/presrntation/views/widgets/custom_text_form_field.dart';

class HomeLayout extends StatefulWidget {
  const HomeLayout({super.key});

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  var scaffoldKey = GlobalKey<ScaffoldState>();

  var titleController = TextEditingController();

  var timeController = TextEditingController();

  var dateController = TextEditingController();

  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is AppInsertDatabaseState) {
          Navigator.pop(context);
          titleController.clear();
          timeController.clear();
          dateController.clear();
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
                      time: timeController.text,
                      date: dateController.text);
                  cubit.changeBottomSheet(isShow: false, icon: Icons.edit);
                }
              } else {
                scaffoldKey.currentState!
                    .showBottomSheet((context) {
                      return Container(
                        color: Colors.white,
                        padding: const EdgeInsets.all(20),
                        child: Form(
                          key: formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CustomTextFormField(
                                  controller: titleController,
                                  keyboardType: TextInputType.text,
                                  hintText: "Task Title",
                                  prefixIcon: const Icon(Icons.title)),
                              const SizedBox(
                                height: 15,
                              ),
                              CustomTextFormField(
                                  onTap: () {
                                    showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay.now())
                                        .then((value) {
                                      if (value != null) {
                                        String period =
                                            value.hour >= 12 ? 'PM' : 'AM';
                                        if (value.hour > 12) {
                                          String formattedTime =
                                              "${((value.hour) - 12).toString()}:${value.minute.toString().padLeft(2, '0')} $period";
                                          timeController.text = formattedTime;
                                        } else {
                                          String formattedTime =
                                              "${value.hour.toString()}:${value.minute.toString().padLeft(2, '0')} $period";
                                          timeController.text = formattedTime;
                                        }
                                      }
                                    });
                                  },
                                  controller: timeController,
                                  keyboardType: TextInputType.datetime,
                                  hintText: "Task Time",
                                  prefixIcon:
                                      const Icon(Icons.watch_later_outlined)),
                              const SizedBox(
                                height: 15,
                              ),
                              CustomTextFormField(
                                  onTap: () {
                                    showDatePicker(
                                            context: context,
                                            firstDate: DateTime.now(),
                                            lastDate:
                                                DateTime.parse("2026-10-17"))
                                        .then((value) {
                                      dateController.text =
                                          DateFormat.yMMMd().format(value!);
                                    });
                                  },
                                  controller: dateController,
                                  keyboardType: TextInputType.datetime,
                                  hintText: "Task Date",
                                  prefixIcon: const Icon(Icons.calendar_today)),
                            ],
                          ),
                        ),
                      );
                    }, elevation: 20)
                    .closed
                    .then((value) {
                      cubit.changeBottomSheet(isShow: false, icon: Icons.edit);
                    });
                cubit.changeBottomSheet(isShow: true, icon: Icons.add);
              }
            },
            child: Icon(cubit.fabIcon),
          ),
          bottomNavigationBar: BottomNavigationBar(
            selectedLabelStyle: const TextStyle(fontSize: 18),
            unselectedLabelStyle: const TextStyle(fontSize: 18),
            onTap: (value) {
              cubit.changeIndex(value);
            },
            currentIndex: cubit.currentIndex,
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.menu,
                    size: 35,
                  ),
                  label: 'Tasks'),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.check_circle_outline,
                    size: 35,
                  ),
                  label: 'Done'),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.archive_outlined,
                    size: 35,
                  ),
                  label: 'Archived'),
            ],
            type: BottomNavigationBarType.fixed,
          ),
          body: cubit.screens[cubit.currentIndex],
        );
      },
    );
  }
}
