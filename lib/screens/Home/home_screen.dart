import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/core/common/widgets/button.dart';
import 'package:task_manager/core/theme/theme.dart';
import 'package:task_manager/screens/Auth/sign_in_screen.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime _selectedDate = DateTime.now();

  Future<void> _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      // Navigate using Get package for consistency
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
      appBar: AppBar(
        leadingWidth: 70,
        leading: TextButton(
            onPressed: () => _logout(context),
            child: const Icon(
              Icons.login_sharp,
              color: Colors.white,
            )),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.black87,
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: InkWell(
              onTap: () {
                Get.bottomSheet(
                  Container(
                    color: Colors.white,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('Your content goes here'),
                        ElevatedButton(
                          onPressed: () {
                            Get.back(); // Close bottom sheet
                          },
                          child: const Text('Close'),
                        ),
                      ],
                    ),
                  ),
                );
              },
              child: CircleAvatar(
                radius: 20,
                child: ClipOval(
                  child: Image.network(
                    user?.photoURL ?? // Use user's profile picture if available
                        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ_6k_r65VVA59_EVVyIHdkohe5wPapVJE3zg&s',
                    fit: BoxFit.fill,
                    width: 40,
                    height: 40,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.account_circle,
                      size: 40,
                    ), // Handle image load errors gracefully
                  ),
                ),
              ),
            ),
          ),
        ],
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
                        style: AppTheme.subHeadingStyle,
                      ),
                      Text('Today', style: AppTheme.headingStyle),
                    ],
                  ),
                  const Button(label: '+ Add Task', onTap: null),
                ],
              ),
              Container(
                margin: const EdgeInsets.only(top: 5),
                child: DatePicker(
                  DateTime.now(),
                  height: 100,
                  width: 80,
                  initialSelectedDate: DateTime.now(),
                  selectionColor: bluishClr,
                  selectedTextColor: Colors.white,
                  dateTextStyle: GoogleFonts.lato(
                    textStyle: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey),
                  ),
                  monthTextStyle: GoogleFonts.lato(
                    textStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey),
                  ),
                  dayTextStyle: GoogleFonts.lato(
                    textStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey),
                  ),
                  onDateChange: (date) {
                    _selectedDate = date;
                  },
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              SizedBox(
                height: 500,
                child: ListView.builder(
                  itemCount: 2, // Number of items in the list
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Container(
                        width: 400, // Set the desired width
                        height: 120, // Set the desired height
                        decoration: BoxDecoration(
                          color: yellowClr,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Row(
                            children: [
                              const Expanded(
                                flex: 8,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Learning DSA",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 6,
                                    ),
                                    Row(
                                      children: [
                                        Icon(Icons.watch_later_outlined),
                                        SizedBox(
                                          width: 6,
                                        ),
                                        Text("9:07 PM - 9:59 PM"),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 6,
                                    ),
                                    Text(
                                        "First Revise Arrays Then Solve LeetCode after that Graphs",style: TextStyle(
                                      overflow: TextOverflow.ellipsis
                                    ),)
                                  ],
                                ),
                              ),
                              const VerticalDivider(
                                endIndent: 10,
                                indent: 10,
                                color: Colors.white38,
                              ),

                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Transform.rotate(
                                    angle: -1.5708, // -90 degrees in radians (-π/2)
                                    child: const Text(
                                      "TODO",
                                      style: TextStyle(fontSize: 12, color: Colors.green),
                                    ),
                                  ),
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
