import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import '../commonclass/ApiConfigClass/ApiConfig_class.dart';

class LeaveRequestScreen extends StatefulWidget {
  const LeaveRequestScreen({super.key, required userId});

  @override
  State<LeaveRequestScreen> createState() => _LeaveRequestScreenState();
}

class _LeaveRequestScreenState extends State<LeaveRequestScreen> {
  List<Map<String, String>> leaveList = [];
  final storageBox = GetStorage();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchLeaveRequests();
  }

  Future<void> fetchLeaveRequests() async {
    final userId = storageBox.read("userId");
    if (userId == null) {
      setState(() {
        isLoading = false;
        leaveList = [];
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User ID not found. Please login again.")),
      );
      return;
    }

    final url = Uri.parse(ApiConfig.getLeaveRequestByIdUrl(userId));
    print("Request URL: $url");

    try {
      final response = await http.get(url);
      print("Response Status: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          leaveList = data.map<Map<String, String>>((item) {
            String fromDate = 'N/A';
            String toDate = 'N/A';
            try {
              final fromRawDate = item['fromDate']?.toString();
              final toRawDate = item['toDate']?.toString();
              if (fromRawDate != null) {
                final parsedFromDate = DateTime.parse(fromRawDate);
                fromDate = DateFormat('dd/MM/yyyy').format(parsedFromDate);
              }
              if (toRawDate != null) {
                final parsedToDate = DateTime.parse(toRawDate);
                toDate = DateFormat('dd/MM/yyyy').format(parsedToDate);
              }
            } catch (_) {
              fromDate = item['fromDate']?.toString() ?? 'N/A';
              toDate = item['toDate']?.toString() ?? 'N/A';
            }

            return {
              'image': 'assets/images/leave_request.png',
              'from': fromDate,
              'to': toDate,
              'reason': item['reason']?.toString() ?? 'N/A',
              'status': item['status']?.toString() ?? 'Pending',
            };
          }).toList();
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          leaveList = [];
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to fetch leave requests.")),
        );
      }
    } catch (e) {
      print("Error fetching leave requests: $e");
      setState(() {
        isLoading = false;
        leaveList = [];
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching leave requests: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF4869b1),
        title: const Text('Leave Request', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : leaveList.isEmpty
          ? const Center(child: Text("No leave requests found."))
          : SingleChildScrollView(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: screenHeight * 0.02),
            _buildSection("Pending", leaveList.where((e) => e['status'] == 'Pending').toList(), screenWidth),
            SizedBox(height: screenHeight * 0.02),
            _buildSection("Approved", leaveList.where((e) => e['status'] == 'Approved').toList(), screenWidth),
            SizedBox(height: screenHeight * 0.08),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openLeaveBottomSheet(context),
        backgroundColor: const Color(0xFF4869b1),
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }

  Widget _buildSection(String title, List<Map<String, String>> items, double screenWidth) {
    if (items.isEmpty) return const SizedBox();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        const SizedBox(height: 10),
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return Container(
              margin: EdgeInsets.only(bottom: screenWidth * 0.035),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(color: Colors.grey.shade300, blurRadius: 4, offset: const Offset(0, 2)),
                ],
              ),
              child: ListTile(
                contentPadding: EdgeInsets.all(screenWidth * 0.035),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    item['image']!,
                    width: screenWidth * 0.13,
                    height: screenWidth * 0.13,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.broken_image, size: 40, color: Colors.red),
                  ),
                ),
                title: Text('${item['from']} to ${item['to']}', style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('Reason: ${item['reason']}'),
                trailing: Container(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: screenWidth * 0.015),
                  decoration: BoxDecoration(
                    color: _getStatusColor(item['status']),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(item['status']!,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  void _openLeaveBottomSheet(BuildContext context) {
    DateTime? tempFromDate;
    DateTime? tempToDate;
    TextEditingController tempReasonController = TextEditingController();
    final screenWidth = MediaQuery.of(context).size.width;
    bool isSubmitting = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: screenWidth * 0.05,
            right: screenWidth * 0.05,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            top: 20,
          ),
          child: StatefulBuilder(
            builder: (context, setStateModal) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                      child: Text('Apply Leave', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
                  const SizedBox(height: 16),
                  const Text('From Date', style: TextStyle(fontWeight: FontWeight.bold)),
                  GestureDetector(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                      );
                      if (picked != null) setStateModal(() => tempFromDate = picked);
                    },
                    child: _dateBox(tempFromDate != null ? _formatDate(tempFromDate!) : 'Select From Date'),
                  ),
                  const Text('To Date', style: TextStyle(fontWeight: FontWeight.bold)),
                  GestureDetector(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                      );
                      if (picked != null) setStateModal(() => tempToDate = picked);
                    },
                    child: _dateBox(tempToDate != null ? _formatDate(tempToDate!) : 'Select To Date'),
                  ),
                  const Text('Reason', style: TextStyle(fontWeight: FontWeight.bold)),
                  TextField(
                    controller: tempReasonController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      contentPadding: const EdgeInsets.all(12),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: isSubmitting
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                      onPressed: () async {
                        if (tempFromDate != null &&
                            tempToDate != null &&
                            tempReasonController.text.isNotEmpty) {
                          setStateModal(() => isSubmitting = true);

                          final userId = storageBox.read("userId");
                          final url = Uri.parse(ApiConfig.createLeaveRequestUrl);
                          final body = json.encode({
                            "samId": userId.toString(),
                            "lrmFromDate": tempFromDate!.toIso8601String(),
                            "lrmToDate": tempToDate!.toIso8601String(),
                            "lrmReason": tempReasonController.text,
                          });

                          try {
                            final response = await http.post(url,
                                headers: {"Content-Type": "application/json"}, body: body);

                            if (response.statusCode == 200 || response.statusCode == 201) {
                              Navigator.pop(context);
                              await fetchLeaveRequests();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("✅ Leave Request Submitted Successfully"),
                                  backgroundColor: Colors.green,
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(
                                        "Failed to submit leave: ${response.statusCode}")),
                              );
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Error submitting leave: $e")),
                            );
                          } finally {
                            setStateModal(() => isSubmitting = false);
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Please fill all fields.")),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4869b1),
                        padding:
                        EdgeInsets.symmetric(horizontal: screenWidth * 0.1, vertical: 14),
                      ),
                      child: const Text('Submit', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Widget _dateBox(String text) => Container(
    margin: const EdgeInsets.only(top: 6, bottom: 10),
    width: double.infinity,
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey.shade400),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Text(text),
  );

  String _formatDate(DateTime date) => DateFormat('dd MMM yyyy').format(date);

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'Approved':
        return Colors.green;
      case 'Rejected':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }
}
