import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:studentapp/Screens/commonclass/bottombar/Bottombar.dart';

import '../commonclass/ApiConfigClass/ApiConfig_class.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final Color primaryColor = const Color(0xFF4869b1);
  bool isLoading = false;
  String errorMsg = '';

  Future<void> loginUser() async {
    setState(() {
      isLoading = true;
      errorMsg = '';
    });

    final url = Uri.parse(ApiConfig.loginUrl);

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "username": _idController.text.trim(),
          "password": _passwordController.text.trim(),
        }),
      );

      final result = json.decode(response.body);
      final token = result["token"];
      final message = result["responseMessage"];
      final Id = result["id"];
      final box = GetStorage();

      if (response.statusCode == 200) {
        if (message == "Already logged in on another device") {
          errorMsg = "You are already logged in on another device.";
        } else if (token != null &&
            token.toString().isNotEmpty &&
            message == "Success") {
          box.write("userId", Id);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => BottomBar()),
          );
          return;
        } else {
          errorMsg = message ?? "Invalid credentials";
        }
      } else {
        errorMsg = "Invalid credentials";
      }
    } catch (e) {
      print("Error: $e");
      errorMsg = e.toString();
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenH = MediaQuery.of(context).size.height;
    final screenW = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Column(
        children: [
          Container(
            width: screenW,
            height: screenH * 0.28,
            decoration: BoxDecoration(
              color: primaryColor,
              image: const DecorationImage(
                image: AssetImage('assets/images/moden1.png'),
                fit: BoxFit.cover,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              width: screenW,
              padding: EdgeInsets.symmetric(horizontal: screenW * 0.08),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    spreadRadius: 3,
                    blurRadius: 15,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: screenH * 0.04),
                      Center(
                        child: Image.asset(
                          'assets/images/login.png',
                          width: screenW * 0.3,
                        ),
                      ),
                      SizedBox(height: screenH * 0.03),
                      Text(
                        'Login ID',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _idController,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Login ID is required';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.person),
                          hintText: 'Enter your login ID',
                          hintStyle: TextStyle(fontSize: 14.sp),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 14,
                          ),
                        ),
                      ),
                      SizedBox(height: screenH * 0.02),
                      Text(
                        'Password',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Password is required';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.lock),
                          hintText: 'Enter your password',
                          hintStyle: TextStyle(fontSize: 14.sp),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 14,
                          ),
                        ),
                      ),
                      SizedBox(height: screenH * 0.03),
                      if (errorMsg.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Center(
                            child: Text(
                              errorMsg,
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 14.sp,
                              ),
                            ),
                          ),
                        ),
                      Center(
                        child: SizedBox(
                          width: screenW * 0.90,
                          height: screenH * 0.06,
                          child:
                              isLoading
                                  ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                  : ElevatedButton(
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        loginUser();
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      backgroundColor: primaryColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: Text(
                                      'Login',
                                      style: TextStyle(fontSize: 18.sp),
                                    ),
                                  ),
                        ),
                      ),
                      SizedBox(height: screenH * 0.05),
                      Center(
                        child: RichText(
                          text: TextSpan(
                            text: 'Power By ',
                            style: TextStyle(
                              fontSize: screenW * 0.035,
                              color: Colors.black,
                            ),
                            children: [
                              TextSpan(
                                text: 'Jove Infoverse & Edunest(JIE)',
                                style: TextStyle(
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: screenW * 0.035,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: screenH * 0.02),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
