import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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
  DateTime _selectedDate = DateTime.now();
  int _selectedColor = 0;

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
              const InputField(
                  title: 'Title', hint: 'Enter title here', widget: null),
              const InputField(
                  title: 'Description',
                  hint: 'Enter description here',
                  widget: null),
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
                              child: _selectedColor==index ? const Icon(
                                Icons.done,
                                color: Colors.white,
                                size: 16,
                              ):Container(),
                            ),
                          ),
                        );
                      }))
                    ],
                  ),
                  Button(label: 'Create Task', onTap: null),
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
