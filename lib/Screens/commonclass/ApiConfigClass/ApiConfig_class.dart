class ApiConfig {
  static const String baseUrl = "https://api.tcpindia.in/api/app";
  static const String baseUrl1 = "https://api.tcpindia.in";

  // Auth APIs
  static String get loginUrl => "$baseUrl/Account/Login";

  static String get logoutUrl => "$baseUrl/Account/Logout";

  static String getStudentInfoUrl(String userId) =>
      "$baseUrl/HomeScreen/GetStudentInfo?id=$userId";

  static String getStudentFeesOverviewUrl(String userId) =>
      "$baseUrl/HomeScreen/GetStudentFeesOverview?id=$userId";

  static String getlastfees(String userId) =>
      "$baseUrl/HomeScreen/getlastfees?id=$userId";

  static String receiptDownload(String userId, String trnId) =>
      "$baseUrl1/api/student/Account/printFeeReciptApp?id=$userId&trnId=$trnId";

  static String getAttendanceUrl(String userId) =>
      "$baseUrl/Attendance/GetAttendance?id=$userId";

  static String getAttendanceDayWiseUrl(String userId, String month,
      String year) =>
      "$baseUrl/Attendance/GetAttendanceDayWise?id=$userId&month=$month&year=$year";

  static String getChartAttendanceUrl(String userId) =>
      "$baseUrl/Attendance/GetChartAttendance?id=$userId";

  static String get createLeaveRequestUrl => "$baseUrl/Leaverequest/createReq";

  static String getRecentLeaveRequestUrl(String userId) =>
      "$baseUrl/Leaverequest/getRecentReq?id=$userId";

  static String getLeaveRequestByIdUrl(String userId) =>
      "$baseUrl/Leaverequest/getById?id=$userId";

  static String getBatchListUrl(String userId) =>
      "$baseUrl/Batch/GetBatchList?id=$userId";

  static String getFeedbackQuestionsUrl(String userId) =>
      "$baseUrl/Feedback/GetQuestions?id=$userId";

  static String getFeedbackSubmitUrl(String userId) =>
      "$baseUrl/Feedback/submitfeedback?id=$userId";

  static String getFeedbackListUrl(String userId) =>
      "$baseUrl/Feedback/GetFeedbackList?id=$userId";

  static String getFeedbackByIdUrl(String userId) =>
      "$baseUrl/Feedback/GetFeedbackById?id=$userId";

  static String getReceiptUrl(String userId) =>
      "$baseUrl/Fees/GetReceipts?id=$userId";

  static String getMeetingsUrl(String userId) =>
      "$baseUrl/PMeeting/GetMeetings?id=$userId";

}

