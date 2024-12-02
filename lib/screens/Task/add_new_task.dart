import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/core/common/widgets/button.dart';
import 'package:task_manager/core/common/widgets/input_field.dart';

import '../../core/theme/theme.dart';

class AddNewTask extends StatefulWidget {
  const AddNewTask({super.key});

  @override
  State<AddNewTask> createState() => _AddNewTaskState();
}

class _AddNewTaskState extends State<AddNewTask> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  int _selectedColor = 0;

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> uploadTaskToDb() async {
    try {
      final data = await FirebaseFirestore.instance.collection("tasks").add({
        "title": titleController.text.trim(),
        "description": descriptionController.text.trim(),
        "taskHolder": FirebaseAuth.instance.currentUser!.uid,
        "date": _selectedDate.toIso8601String(),
        "formattedDate": DateFormat('yyyy-MM-dd').format(_selectedDate),
        "color": _selectedColor,
      });
      print(data);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding:
            const EdgeInsets.only(left: 16.0, right: 16, top: 8, bottom: 8),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Add Task",
                style: TAppTheme.headingStyle,
              ),
              InputField(
                title: 'Title',
                hint: 'Enter title here',
                widget: null,
                controller: titleController,
              ),
              InputField(
                title: 'Description',
                hint: 'Enter description here',
                widget: null,
                controller: descriptionController,
              ),
              InputField(
                title: 'Date',
                hint: DateFormat.yMd().format(_selectedDate),
                widget: IconButton(
                  onPressed: () {
                    _getDateFromUser();
                  },
                  icon: const Icon(
                    Icons.calendar_month_rounded,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(
                height: 18,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Color",
                        style: TAppTheme.titleStyle,
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      Wrap(
                          children: List<Widget>.generate(3, (int index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedColor = index;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: CircleAvatar(
                              radius: 14,
                              backgroundColor: index == 0
                                  ? pinkClr
                                  : index == 1
                                      ? bluishClr
                                      : yellowClr,
                              child: _selectedColor == index
                                  ? const Icon(
                                      Icons.done,
                                      color: Colors.white,
                                      size: 16,
                                    )
                                  : Container(),
                            ),
                          ),
                        );
                      }))
                    ],
                  ),
                  Button(
                    label: 'Create Task',
                    onTap: () async {
                      if (titleController.text.isNotEmpty && descriptionController.text.isNotEmpty) {
                        await uploadTaskToDb();
                        titleController.clear(); // Clear title input
                        descriptionController.clear(); // Clear description input
                        Get.snackbar(
                          "Success",
                          "Task created successfully",
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.green,
                          colorText: Colors.white,
                          borderRadius: 8,
                          margin: const EdgeInsets.all(10),
                          icon: const Icon(
                            Icons.check_circle_outline,
                            color: Colors.white,
                          ),
                          duration: const Duration(seconds: 3),
                        );
                      } else {
                        Get.snackbar(
                          "Error",
                          "Please fill in all fields",
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                          borderRadius: 8,
                          margin: const EdgeInsets.all(10),
                          icon: const Icon(
                            Icons.error_outline,
                            color: Colors.white,
                          ),
                          duration: const Duration(seconds: 3),
                        );
                      }
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  _getDateFromUser() async {
    DateTime? pickerDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2019),
      lastDate: DateTime(2030),
    );
    if (pickerDate != null) {
      setState(() {
        _selectedDate = pickerDate;
      });
    } else {
      if (kDebugMode) {
        print("it's null something went wrong");
      }
    }
  }
}
