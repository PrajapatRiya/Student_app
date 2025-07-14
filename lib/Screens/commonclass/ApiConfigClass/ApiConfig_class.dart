class ApiConfig {
  static const String baseUrl = "https://7e76519d54be.ngrok-free.app/api/app";
  static const String baseUrl1 = "https://7e76519d54be.ngrok-free.app";
  // Auth APIs
  static String get loginUrl => "$baseUrl/Account/Login";
  static String get logoutUrl => "$baseUrl/Account/Logout";
  static String getStudentInfoUrl(String userId) => "$baseUrl/HomeScreen/GetStudentInfo?id=$userId";
  static String getStudentFeesOverviewUrl(String userId) =>
      "$baseUrl/HomeScreen/GetStudentFeesOverview?id=$userId";
  static String getlastfees(String userId) =>
      "$baseUrl/HomeScreen/getlastfees?id=$userId";
  static String receiptDownload(String userId,String trnId) =>
      "$baseUrl1/api/student/Account/printFeeRecipt2?id=$userId&trnId=$trnId";
  static String getAttendanceUrl(String userId) =>
      "$baseUrl/Attendance/GetAttendance?id=$userId";

}
