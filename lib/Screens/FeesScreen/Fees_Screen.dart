import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:open_filex/open_filex.dart';

import '../commonclass/ApiConfigClass/ApiConfig_class.dart';

class FeesScreen extends StatefulWidget {
  const FeesScreen({super.key});

  @override
  State<FeesScreen> createState() => _FeesScreenState();
}

class _FeesScreenState extends State<FeesScreen> {
  final storageBox = GetStorage();
  List<Map<String, dynamic>> feesData = [];
  Set<String> downloadingReceipts = {}; // track downloading items
  Map<String, dynamic>? studentInfo; // agar rollNo ki zarurat ho

  @override
  void initState() {
    super.initState();
    fetchFeesData();
  }

  /// 🔹 Fetch Fees Data
  Future<void> fetchFeesData() async {
    final userId = storageBox.read("userId"); // userId from GetStorage
    final String url = ApiConfig.getReceiptUrl(userId);

    debugPrint("👉 API URL: $url");

    try {
      final response = await http.get(Uri.parse(url));

      debugPrint("👉 API Status Code: ${response.statusCode}");
      debugPrint("👉 API Raw Response: ${response.body}");

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        setState(() {
          feesData = data.map((item) {
            return {
              'trnId': item['trnId']?.toString() ?? "",   // ✅ trnId add
              'title': item['trnTitle'] ?? "Fee Receipt", // ✅ title add
              'date': item['trnDate'] ?? "",
              'image': 'assets/images/fees1.png',
              'amount': item['trnAmount']?.toString() ?? "₹0",
            };
          }).toList();
        });

        debugPrint("👉 Final feesData: $feesData");
      } else {
        debugPrint("❌ API Error: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("❌ Exception: $e");
    }
  }

  /// 🔹 Download Receipt
  Future<void> downloadReceipt(String trnId) async {
    final userId = storageBox.read("userId");
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No user ID found")),
      );
      return;
    }

    final url = Uri.parse(ApiConfig.receiptDownload(userId, trnId));
    debugPrint("👉 Receipt Download URL: $url");

    try {
      setState(() {
        downloadingReceipts.add(trnId);
      });

      final response = await http.get(url);

      if (response.statusCode == 200) {
        Directory downloadDir = Directory("/storage/emulated/0/Download");
        if (!await downloadDir.exists()) {
          await downloadDir.create(recursive: true);
        }

        String fname =
            "${studentInfo?['rollNo']?.toString().replaceAll("/", "") ?? "receipt"}_${trnId}.pdf";
        String filepath = '${downloadDir.path}/$fname';

        File file = File(filepath);
        await file.writeAsBytes(response.bodyBytes);
        await OpenFilex.open(filepath);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Downloaded: $fname")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to download receipt")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error downloading receipt: $e")),
      );
    } finally {
      setState(() {
        downloadingReceipts.remove(trnId);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF4869b1),
        leading: IconButton(
          icon: Icon(
            CupertinoIcons.back,
            color: Colors.white,
            size: screenWidth * 0.06,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Fees Screen',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: screenWidth * 0.048,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: screenWidth * 0.03),
            child: Image.asset(
              'assets/images/fee.png',
              height: screenWidth * 0.07,
              width: screenWidth * 0.07,
              color: Colors.orange,
            ),
          ),
        ],
      ),
      body: feesData.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        padding: EdgeInsets.all(screenWidth * 0.04),
        itemCount: feesData.length,
        itemBuilder: (context, index) {
          final item = feesData[index];
          return buildListItem(
            item['trnId'] ?? "",
            item['title'] ?? "",
            item['date'] ?? "",
            item['image'] ?? "",
            item['amount'] ?? "₹0",
            screenWidth,
            screenHeight,
          );
        },
      ),
    );
  }

  /// 🔹 Custom List Item Widget
  Widget buildListItem(
      String trnId,
      String title,
      String date,
      String imagePath,
      String amount,
      double screenWidth,
      double screenHeight,
      ) {
    return Container(
      margin: EdgeInsets.only(bottom: screenHeight * 0.02),
      padding: EdgeInsets.all(screenWidth * 0.04),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(screenWidth * 0.04),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔹 Left Image
          ClipRRect(
            borderRadius: BorderRadius.circular(screenWidth * 0.03),
            child: Image.asset(
              imagePath,
              height: screenWidth * 0.14,
              width: screenWidth * 0.14,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: screenWidth * 0.04),

          /// 🔹 Middle Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: screenWidth * 0.042,
                  ),
                ),
                SizedBox(height: screenHeight * 0.005),
                Text(
                  "Date: $date",
                  style: TextStyle(fontSize: screenWidth * 0.035),
                ),
                Text(
                  "Amount: $amount",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                    fontSize: screenWidth * 0.037,
                  ),
                ),
              ],
            ),
          ),

          /// 🔹 Download Button (Square)
          InkWell(
            onTap: () => downloadReceipt(trnId),
            child: Container(
              height: screenWidth * 0.1,
              width: screenWidth * 0.1,
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(6), // ✅ square button
              ),
              child: downloadingReceipts.contains(trnId)
                  ? const Center(
                child: SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                ),
              )
                  : Icon(
                Icons.download,
                color: Colors.white,
                size: screenWidth * 0.05,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
