import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CertificateScreen extends StatefulWidget {
  const CertificateScreen({super.key});

  @override
  State<CertificateScreen> createState() => _CertificateScreenState();
}

class _CertificateScreenState extends State<CertificateScreen> {
  @override
  Widget build(BuildContext context) {
    final screenH = MediaQuery.of(context).size.height;
    final screenW = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF4869b1),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Certificate Screen',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20.sp, // <- sp used here
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Top Image Section - 45% of screen height
          SizedBox(
            height: screenH * 0.45,
            width: screenW,
            child: Image.asset(
              'assets/images/certificate.png',
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),
          ),

          // Spacing to push button upward
          SizedBox(height: screenH * 0.08),

          // Button Section
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenW * 0.05),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4869b1),
                minimumSize: Size(double.infinity, screenH * 0.065),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(screenW * 0.03),
                ),
              ),
              icon: const Icon(Icons.workspace_premium_rounded, color: Colors.white),
              label: Text(
                'Get your certificate',
                style: TextStyle(fontSize: 16.sp, color: Colors.white), // <- sp used here
              ),
              onPressed: () {
                // TODO: Add action here
              },
            ),
          ),
        ],
      ),
    );
  }
}
