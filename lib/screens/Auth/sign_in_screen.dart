import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rive/rive.dart' as rive;
import 'package:task_manager/screens/Auth/sign_up_screen.dart';
import 'package:task_manager/screens/home/home_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  var animationLink = 'assets/rive/login.riv';
  rive.SMIInput<bool>? isChecking;
  rive.SMIInput<bool>? isHandsUp;
  rive.SMIInput<bool>? trigSuccess;
  rive.SMIInput<bool>? trigFail;

  rive.StateMachineController? stateMachineController;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<bool> loginUserWithEmailAndPassword() async {
    try {
      final userCredentials =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _usernameController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (userCredentials.user != null) {
        return true; // Login successful
      } else {
        return false; // Login failed
      }
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        "Login Failed", // Title
        e.message ?? "Something went wrong. Please try again.", // Message
        backgroundColor: Colors.black87,
        borderColor: Colors.red,
        borderWidth: 1,
        colorText: Colors.white,
        icon: const Icon(
          Icons.dangerous_outlined,
          size: 28,
        ),
        snackPosition: SnackPosition.TOP,
        // Position (BOTTOM/TOP)
        duration: const Duration(seconds: 3),
      );
      return false; // Login failed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            // Aligns content to center vertically
            children: [
              ClipOval(
                child: SizedBox(
                  height: 230,
                  width: 230,
                  child: rive.RiveAnimation.asset(
                    animationLink,
                    fit: BoxFit.fill,
                    stateMachines: const ['Login Machine'],
                    onInit: (artBoard) {
                      stateMachineController =
                          rive.StateMachineController.fromArtboard(
                              artBoard, 'Login Machine');
                      if (stateMachineController == null) return;
                      artBoard.addController(stateMachineController!);
                      isChecking =
                          stateMachineController?.findInput('isChecking');
                      isHandsUp =
                          stateMachineController?.findInput('isHandsUp');
                      trigSuccess =
                          stateMachineController?.findInput('trigSuccess');
                      trigFail = stateMachineController?.findInput('trigFail');
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              Form(
                key: _formkey,
                child: Column(
                  children: [
                    TextFormField(
                      onTapOutside: (event) {
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                      style: const TextStyle(color: Colors.white),
                      onChanged: (value) {
                        if (isHandsUp != null) {
                          isHandsUp!.change(false);
                        }
                        if (isChecking == null) return;
                        isChecking!.change(true);
                      },
                      decoration: InputDecoration(
                        labelText: 'Email',
                        focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.white,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(12)),
                        enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.white,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(12)),
                        errorBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.red, width: 1)),
                        focusedErrorBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red)),
                      ),
                      controller: _usernameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    TextFormField(
                      onTapOutside: (event) {
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                      style: const TextStyle(color: Colors.white),
                      onChanged: (value) {
                        if (isChecking != null) {
                          isChecking!.change(false);
                        }
                        if (isHandsUp == null) return;
                        isHandsUp!.change(true);
                      },
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.white,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(12)),
                        enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.white,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(12)),
                        errorBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.red, width: 1)),
                        focusedErrorBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red)),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                      controller: _passwordController,
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    GestureDetector(
                      onTap: () async {
                        if (_formkey.currentState!.validate()) {
                          setState(() {
                            _isLoading = true; // Show loader
                          });

                          // Reset animations to default states
                          isChecking!.change(false);
                          isHandsUp!.change(false);
                          trigFail!.change(false);
                          trigSuccess!.change(false);

                          try {
                            // Attempt login and handle result
                            final isSuccess =
                                await loginUserWithEmailAndPassword();

                            if (isSuccess) {
                              // Trigger success animation
                              trigSuccess!.change(true);

                              // Navigate only if login is successful
                              Get.to(() => HomeScreen());
                            } else {
                              // Trigger failure animation
                              trigFail!.change(true);
                            }
                          } finally {
                            setState(() {
                              _isLoading = false; // Hide loader
                            });

                            // Reset animations
                            isChecking!.change(false);
                            isHandsUp!.change(false);
                            trigSuccess!.change(false);
                          }
                        }
                      },
                      child: Stack(
                        children: [
                          Container(
                            width: double.infinity,
                            height: 60,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Colors.deepPurple, Colors.pinkAccent],
                                begin: Alignment.topLeft, // Starting point
                                end: Alignment.bottomRight, // Ending point
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Container(
                                height: 60,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.black45.withOpacity(1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: _isLoading
                                      ? const CircularProgressIndicator(
                                          color: Colors.white,
                                        ) // Show loader when loading
                                      : const Text(
                                          "Sign Up",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ), // Show text when not loading
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          " Don't have an account ?",
                          style: TextStyle(color: Colors.white),
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SignUpScreen(),
                                ),
                              );
                            },
                            child: const Text("Sign Up"))
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
