import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/core/common/widgets/button.dart';
import 'package:task_manager/core/theme/theme.dart';
import 'package:task_manager/screens/Auth/sign_in_screen.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:task_manager/screens/Task/add_new_task.dart';
import 'package:task_manager/screens/home/controller/home_controller.dart';


class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final HomeController homeController = Get.put(HomeController());
  Future<void> _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Get.offAll(() => const SignInScreen());
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        "Logout Fail",
        e.message ?? "Unknown error occurred",
        borderColor: Colors.red,
        borderWidth: 2,
        backgroundColor: Colors.black87,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 3),
        icon: const Icon(
          Icons.error_outline,
          size: 28,
          color: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        leadingWidth: 70,
        leading: TextButton(
          onPressed: () => _logout(context),
          child: const Icon(
            Icons.login_sharp,
            color: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.black87,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DateFormat.yMMMMd().format(DateTime.now()),
                        style: TAppTheme.subHeadingStyle,
                      ),
                      Text('Today', style: TAppTheme.headingStyle),
                    ],
                  ),
                  Button(
                    label: '+ Add Task',
                    onTap: () {
                      Get.to(() => const AddNewTask());
                    },
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.only(top: 5),
                child: Obx(() {
                  return DatePicker(
                    DateTime.now(),
                    height: 100,
                    width: 80,
                    initialSelectedDate: homeController.selectedDate.value,
                    selectionColor: bluishClr,
                    selectedTextColor: Colors.white,
                    dateTextStyle: GoogleFonts.lato(
                      textStyle: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                      ),
                    ),
                    monthTextStyle: GoogleFonts.lato(
                      textStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                      ),
                    ),
                    dayTextStyle: GoogleFonts.lato(
                      textStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                      ),
                    ),
                    onDateChange: (date) {
                      homeController.updateSelectedDate(date);
                    },
                  );
                }),
              ),
              const SizedBox(height: 15),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
                child: ListView.builder(
                  itemCount: 3, // Number of items in the list
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(
                        left: 8.0,
                        right: 8,
                        bottom: 14,
                      ),
                      child: Container(
                        width: 400,
                        height: 140,
                        decoration: BoxDecoration(
                          color: Colors.pinkAccent,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Row(
                            children: [
                              const Expanded(
                                flex: 9,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Learning DSA",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                    SizedBox(height: 6),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.watch_later_outlined,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                        SizedBox(width: 6),
                                        Text(
                                          "9:07 PM - 9:59 PM",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 6),
                                    Flexible(
                                      child: Text(
                                        "First Revise Arrays Then Solve LeeCode after that Graphs",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.delete_outline,
                                      color: Colors.white70,
                                    ),
                                  ),
                                  Obx(() {
                                    return Checkbox(
                                      value: homeController.isChecked.value,
                                      onChanged: (bool? value) {
                                        homeController.toggleCheckbox(
                                            value ?? false);
                                      },
                                      checkColor: Colors.green,
                                      activeColor: Colors.white,
                                      side: const BorderSide(
                                        color: Colors.white,
                                      ),
                                    );
                                  }),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
