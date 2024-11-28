import 'package:cloud_firestore/cloud_firestore.dart';
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

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeController homeController = Get.put(HomeController());
  final Map<int, Color> colorMap = {
    0: pinkClr,
    1: bluishClr,
    2: yellowClr,
  };

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
                    daysCount: 60,
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
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("tasks")
                    .where('taskHolder', isEqualTo: user!.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 120,
                        ),
                        Opacity(
                          opacity: 0.6,
                          child: Image.asset(
                            "assets/images/notpad.png",
                            width: 150,
                            height: 150,
                            fit: BoxFit.fill,
                            filterQuality: FilterQuality.high,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "No tasks available",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    );
                  }

                  // Initialize task states
                  homeController.initializeCheckboxStates(snapshot.data!.docs);

                  return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: ListView.builder(
                      itemCount: snapshot.data?.docs.length,
                      itemBuilder: (context, index) {
                        final task = snapshot.data!.docs[index];
                        final taskId = task.id;

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
                              color:
                                  colorMap[task.data()['color']] ?? Colors.grey,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 9,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          task.data()['title'],
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            fontSize: 16,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.watch_later_outlined,
                                              color: Colors.white,
                                              size: 20,
                                            ),
                                            const SizedBox(width: 6),
                                            Text(
                                              DateFormat.yMd().format(
                                                DateTime.parse(
                                                    task.data()['date']),
                                              ),
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 6),
                                        Flexible(
                                          child: Text(
                                            task.data()['description'],
                                            style: const TextStyle(
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
                                        onPressed: () async {
                                          await FirebaseFirestore.instance
                                              .collection("tasks")
                                              .doc(taskId)
                                              .delete();
                                        },
                                        icon: const Icon(
                                          Icons.delete_forever_outlined,
                                          color: Colors.white70,
                                        ),
                                      ),
                                      Obx(() {
                                        return Checkbox(
                                          value: homeController
                                                  .taskCheckStates[taskId]
                                                  ?.value ??
                                              false,
                                          onChanged: (bool? value) {
                                            if (value != null) {
                                              homeController.toggleTaskCheckbox(
                                                  taskId, value);
                                            }
                                          },
                                          checkColor: Colors.green,
                                          activeColor: Colors.white,
                                          side: const BorderSide(
                                              color: Colors.white),
                                        );
                                      }),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
