import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class LeaveRequestScreen extends StatefulWidget {
  const LeaveRequestScreen({super.key});

  @override
  State<LeaveRequestScreen> createState() => _LeaveRequestScreenState();
}

class _LeaveRequestScreenState extends State<LeaveRequestScreen> {
  final List<Map<String, String>> leaveList = [
    {
      'image': 'assets/images/leave_request.png',
      'from': '21/3/2025',
      'to': '23/3/2025',
      'reason': 'Sick Leave',
      'status': 'Approved',
    },
    {
      'image': 'assets/images/leave_request.png',
      'from': '1/4/2025',
      'to': '2/4/2025',
      'reason': 'Personal Work',
      'status': 'Pending',
    },
    {
      'image': 'assets/images/leave_request.png',
      'from': '10/5/2025',
      'to': '12/5/2025',
      'reason': 'Family Function',
      'status': 'Rejected',
    },
  ];

  DateTime? fromDate;
  DateTime? toDate;

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
      body: SingleChildScrollView(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection("All Leaves", leaveList, screenWidth),
            SizedBox(height: screenHeight * 0.02),
            _buildSection("Pending Leaves", leaveList.where((e) => e['status'] == 'Pending').toList(), screenWidth),
            SizedBox(height: screenHeight * 0.02),
            _buildSection("Approved Leaves", leaveList.where((e) => e['status'] == 'Approved').toList(), screenWidth),
            SizedBox(height: screenHeight * 0.08), // spacing for FAB
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openLeaveBottomSheet(context),
        backgroundColor: const Color(0xFF4869b1),
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildSection(String title, List<Map<String, String>> items, double screenWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
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
                  ),
                ),
                title: Text('${item['from']} to ${item['to']}',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('Reason: ${item['reason']}'),
                trailing: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.04,
                    vertical: screenWidth * 0.015,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(item['status']),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    item['status']!,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  void _openLeaveBottomSheet(BuildContext context) {
    DateTime? tempFromDate = fromDate;
    DateTime? tempToDate = toDate;
    TextEditingController tempReasonController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        final screenWidth = MediaQuery.of(context).size.width;
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
                    child: Text('Apply Leave',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
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
                      if (picked != null) {
                        setStateModal(() => tempFromDate = picked);
                      }
                    },
                    child: _dateBox(
                      tempFromDate != null ? _formatDate(tempFromDate!) : 'Select From Date',
                    ),
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
                      if (picked != null) {
                        setStateModal(() => tempToDate = picked);
                      }
                    },
                    child: _dateBox(
                      tempToDate != null ? _formatDate(tempToDate!) : 'Select To Date',
                    ),
                  ),

                  const Text('Reason', style: TextStyle(fontWeight: FontWeight.bold)),
                  TextField(
                    controller: tempReasonController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: const EdgeInsets.all(12),
                    ),
                  ),

                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        if (tempFromDate != null &&
                            tempToDate != null &&
                            tempReasonController.text.isNotEmpty) {
                          Navigator.pop(context);
                          setState(() {
                            leaveList.add({
                              'image': 'assets/images/leave_request.png',
                              'from': DateFormat('dd/MM/yyyy').format(tempFromDate!),
                              'to': DateFormat('dd/MM/yyyy').format(tempToDate!),
                              'reason': tempReasonController.text,
                              'status': 'Pending',
                            });
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4869b1),
                        padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.1, vertical: 14),
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

  String _formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }

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
