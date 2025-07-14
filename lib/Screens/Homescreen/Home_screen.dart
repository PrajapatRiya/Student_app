import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:open_filex/open_filex.dart';
import 'package:studentapp/Screens/Attendencescreen/Attendence_screen.dart';
import 'package:studentapp/Screens/Profilescreen/profiles_screen.dart';
import '../Examscreen/Examscreen.dart';
import '../MettingScreen/MettingScreen.dart';
import '../commonclass/ApiConfigClass/ApiConfig_class.dart';
import '../commonclass/Drawer/AppDrawerscreen.dart';
import '../commonclass/VideoBackground/VideoBackgroundHeader.dart';
import '../commonclass/piechart/studentfees.dart';
import '../loginscreen/login_screen.dart';

class StudentInfo {
  final String name;
  final String rollNo;
  final String training;

  StudentInfo({
    required this.name,
    required this.rollNo,
    required this.training,
  });

  factory StudentInfo.fromJson(Map<String, dynamic> json) {
    return StudentInfo(
      name: json['name']?.toString() ?? 'N/A',
      rollNo:
          json['studentId']?.toString() ??
          json['id']?.toString() ??
          json['rollNo']?.toString() ??
          'N/A',
      training:
          json['course']?.toString() ?? json['training']?.toString() ?? 'N/A',
    );
  }
}

class FeesOverview {
  final double paidFees;
  final double unpaidFees;
  final String nextInstallmentDate;

  FeesOverview({
    required this.paidFees,
    required this.unpaidFees,
    required this.nextInstallmentDate,
  });

  factory FeesOverview.fromJson(Map<String, dynamic> json) {
    final paid = double.tryParse(json['paidFees']?.toString() ?? '0') ?? 0.0;
    final unpaid =
        double.tryParse(json['unpaidFees']?.toString() ?? '0') ?? 0.0;

    String formattedDate = 'N/A';
    try {
      final rawDate = json['nextInstallmentDate']?.toString();
      if (rawDate != null) {
        final parsedDate = DateTime.parse(rawDate);
        formattedDate = DateFormat('dd/MM/yyyy').format(parsedDate);
      }
    } catch (_) {
      formattedDate = json['nextInstallmentDate']?.toString() ?? 'N/A';
    }

    return FeesOverview(
      paidFees: paid,
      unpaidFees: unpaid,
      nextInstallmentDate: formattedDate,
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final storageBox = GetStorage();
  final Color valueColor = const Color(0xFF4869b1);

  StudentInfo? studentInfo;
  FeesOverview? feesOverview;

  bool isLoadingStudent = true;
  bool isLoadingFees = true;

  List<Map<String, String>> payments = [];
  bool isLoadingPayments = true;
  Set<String> downloadingReceipts = {};

  @override
  void initState() {
    super.initState();
    getStudentInfo();
    getStudentFeesOverview();
    getRecentPayments();
  }

  Future<void> getStudentInfo() async {
    final userId = storageBox.read("userId");
    if (userId == null) {
      setState(() {
        isLoadingStudent = false;
        studentInfo = StudentInfo(name: 'N/A', rollNo: 'N/A', training: 'N/A');
      });
      return;
    }
    final url = Uri.parse(ApiConfig.getStudentInfoUrl(userId));
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          studentInfo = StudentInfo.fromJson(data);
          isLoadingStudent = false;
        });
      } else {
        setState(() {
          isLoadingStudent = false;
          studentInfo = StudentInfo(
            name: 'N/A',
            rollNo: 'N/A',
            training: 'N/A',
          );
        });
      }
    } catch (e) {
      setState(() {
        isLoadingStudent = false;
        studentInfo = StudentInfo(name: 'N/A', rollNo: 'N/A', training: 'N/A');
      });
    }
  }

  Future<void> downloadReceipt(String trnId) async {
    final userId = storageBox.read("userId");
    if (userId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("No user ID found")));
      return;
    }

    final url = Uri.parse(ApiConfig.receiptDownload(userId, trnId));

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
            "${studentInfo?.rollNo.replaceAll("/", "") ?? "receipt"}_${trnId}.pdf";
        String filepath = '${downloadDir.path}/$fname';
        File file = File(filepath);
        await file.writeAsBytes(response.bodyBytes);
        await OpenFilex.open(filepath);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to download receipt")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error downloading receipt: $e")));
    } finally {
      setState(() {
        downloadingReceipts.remove(trnId);
      });
    }
  }

  Future<void> getStudentFeesOverview() async {
    final userId = storageBox.read("userId");
    if (userId == null) {
      setState(() => isLoadingFees = false);
      return;
    }

    final url = Uri.parse(ApiConfig.getStudentFeesOverviewUrl(userId));

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        final data = body['data'] ?? body;

        setState(() {
          feesOverview = FeesOverview.fromJson(data);
          isLoadingFees = false;
        });
      } else {
        setState(() => isLoadingFees = false);
      }
    } catch (_) {
      setState(() => isLoadingFees = false);
    }
  }

  Future<void> getRecentPayments() async {
    final userId = storageBox.read("userId");
    if (userId == null) {
      setState(() => isLoadingPayments = false);
      return;
    }
    final url = Uri.parse(ApiConfig.getlastfees(userId));

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          payments =
              data
                  .map<Map<String, String>>(
                    (item) => {
                      'date': item['trnDate']?.toString() ?? '',
                      'amount': '₹${item['trnAmount']?.toString() ?? ''}',
                      'image': 'assets/images/fee.png',
                      'trnId': item['trnId']?.toString() ?? '',
                    },
                  )
                  .toList();
          isLoadingPayments = false;
        });
      } else {
        setState(() => isLoadingPayments = false);
      }
    } catch (_) {
      setState(() => isLoadingPayments = false);
    }
  }

  Future<void> logoutUser(BuildContext context, String userId) async {
    final url = Uri.parse(ApiConfig.logoutUrl);

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({"userid": userId}),
      );

      final result = json.decode(response.body);
      if (result == "Success") {
        await storageBox.erase();
        if (context.mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
            (route) => false,
          );
        }
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Logout failed")));
      }
    } catch (_) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Logout failed")));
    }
  }

  Widget _buildFeesOverviewSection() {
    if (isLoadingFees) {
      return const Center(child: CircularProgressIndicator());
    }
    if (feesOverview == null) {
      return const Text("Unable to load Fees Overview.");
    }

    double totalFees = feesOverview!.paidFees + feesOverview!.unpaidFees;
    if (totalFees == 0) totalFees = 1;

    return CommonFeesContainer(
      pieDataMap: {
        "Paid": (feesOverview!.paidFees / totalFees) * 100,
        "Unpaid": (feesOverview!.unpaidFees / totalFees) * 100,
      },
      paidAmount: feesOverview!.paidFees,
      unpaidAmount: feesOverview!.unpaidFees,
      nextInstallmentDate: feesOverview!.nextInstallmentDate,
    );
  }

  Widget buildPaymentListSection(double screenWidth) {
    if (isLoadingPayments) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (payments.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(child: Text("No recent payments found.")),
      );
    }
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Recent Payments",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: payments.length,
            itemBuilder: (context, index) {
              final item = payments[index];
              final trnId = item['trnId'] ?? '';
              final isDownloading = downloadingReceipts.contains(trnId);

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Image.asset(
                          item['image']!,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder:
                              (context, error, stackTrace) => const Icon(
                                Icons.broken_image,
                                size: 50,
                                color: Colors.red,
                              ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['date']!,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item['amount']!,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: InkWell(
                          onTap:
                              isDownloading
                                  ? null
                                  : () => downloadReceipt(trnId),
                          child:
                              isDownloading
                                  ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  )
                                  : const Icon(
                                    Icons.download_rounded,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildImageCard(String imagePath, String label, VoidCallback? onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey.shade100,
            ),
            padding: const EdgeInsets.all(8),
            child: Image.asset(
              imagePath,
              fit: BoxFit.contain,
              errorBuilder:
                  (context, error, stackTrace) => const Icon(
                    Icons.broken_image,
                    size: 30,
                    color: Colors.red,
                  ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(
    String count,
    String label,
    Color startColor,
    Color endColor,
    double screenWidth,
    double screenHeight,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: screenWidth * 0.42,
        height: screenHeight * 0.13,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [startColor, endColor]),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.03,
                  vertical: screenHeight * 0.005,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  count,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: endColor,
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.008),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: valueColor,
        title: const Text(
          'Dashboard',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              final userId = storageBox.read("userId");
              if (userId == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("No user ID found")),
                );
                return;
              }
              showDialog(
                context: context,
                builder:
                    (_) => AlertDialog(
                      title: const Text("Logout"),
                      content: const Text("Are you sure you want to logout?"),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: () => logoutUser(context, userId),
                          child: const Text("Logout"),
                        ),
                      ],
                    ),
              );
            },
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body:
          isLoadingStudent
              ? const Center(child: CircularProgressIndicator())
              : CustomScrollView(
                slivers: [
                  // Video Header Section
                  SliverToBoxAdapter(
                    child: Stack(
                      children: [
                        VideoBackgroundHeader(height: screenHeight * 0.2),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.06,
                            vertical: screenHeight * 0.02,
                          ),
                          child: Column(
                            children: [
                              // Student Info Card
                              Container(
                                padding: EdgeInsets.all(screenWidth * 0.04),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(
                                        0xFF2E3A87,
                                      ), 
                                      Color(
                                        0xFF5A90D2,
                                      ),
                                      Color(
                                        0xFFFF648A,
                                      ),
                                      Color(
                                        0xFF8EE7F2,
                                      ),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.4),
                                      blurRadius: 6,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: screenWidth * 0.1,
                                      height: screenWidth * 0.1,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: LinearGradient(
                                          colors: [
                                            Color(0xFF4869b1),
                                            Color(0xFFF39c12),
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(4),
                                        child: Container(
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white,
                                          ),
                                          child: ClipOval(
                                            child: Lottie.asset(
                                              'assets/images/student1lottie.json',
                                              fit: BoxFit.fill,
                                              repeat: true,
                                              width: screenWidth * 0.08,
                                              height: screenWidth * 0.08,
                                              errorBuilder:
                                                  (
                                                    context,
                                                    error,
                                                    stackTrace,
                                                  ) => const Icon(
                                                    Icons.broken_image,
                                                    size: 30,
                                                    color: Colors.red,
                                                  ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: screenWidth * 0.04),
                                    // Student Details
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            studentInfo?.name ?? 'Loading...',
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          SizedBox(
                                            height: screenHeight * 0.005,
                                          ),
                                          Text(
                                            ' ${studentInfo?.rollNo ?? 'N/A'}',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.white,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          SizedBox(
                                            height: screenHeight * 0.005,
                                          ),
                                          Text(
                                            ' ${studentInfo?.training ?? 'N/A'}',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.white,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.02),
                              Container(
                                padding: EdgeInsets.all(screenWidth * 0.04),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.4),
                                      blurRadius: 6,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    _buildImageCard(
                                      'assets/images/3d-house.png',
                                      'Home',
                                      null,
                                    ),
                                    _buildImageCard(
                                      'assets/images/check.png',
                                      'Attendance',
                                      () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (_) => const AttendenceScreen(),
                                          ),
                                        );
                                      },
                                    ),
                                    _buildImageCard(
                                      'assets/images/Materiles.png',
                                      'Materials',
                                      () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => const ExamScreen(),
                                          ),
                                        );
                                      },
                                    ),
                                    _buildImageCard(
                                      'assets/images/profile1.png',
                                      'Profile',
                                      () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (_) => const ProfilesScreen(),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Upcoming Events Section
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.05,
                        vertical: screenHeight * 0.02,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildInfoCard(
                            '3',
                            'Upcoming Exam',
                            Colors.cyan,
                            Colors.teal.shade900,
                            screenWidth,
                            screenHeight,
                            () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const ExamScreen(),
                                ),
                              );
                            },
                          ),
                          _buildInfoCard(
                            '1',
                            'Upcoming Meeting',
                            Colors.orange.shade300,
                            Colors.deepOrange,
                            screenWidth,
                            screenHeight,
                            () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const UpComingMettingScreen(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Leave Request Section
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.05,
                        vertical: screenHeight * 0.02,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Leave Request",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.01),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(screenWidth * 0.04),
                            decoration: BoxDecoration(
                              color: const Color(0xFF4869b1),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  blurRadius: 6,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: const [
                                      Text(
                                        "Date:  21/3/2023 to 28/6/2023",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        "Function:  Orientation Ceremony",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 15,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(40),
                                  ),
                                  child: const Text(
                                    "Active",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Fees Overview Section
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.05,
                        vertical: screenHeight * 0.02,
                      ),
                      child: _buildFeesOverviewSection(),
                    ),
                  ),
                  // Recent Payments Section
                  SliverToBoxAdapter(
                    child: buildPaymentListSection(screenWidth),
                  ),
                  // Bottom Padding
                  SliverToBoxAdapter(
                    child: SizedBox(height: screenHeight * 0.02),
                  ),
                ],
              ),
    );
  }
}
