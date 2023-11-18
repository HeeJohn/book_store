class StudentModel {
  final String studentName;
  final int studentID;
  final String studentPhoneNum;
  final int sessionID;

  StudentModel.fromJson(Map<String, dynamic> json)
      : studentName = json['student_name'],
        studentID = json['studnet_ID'],
        studentPhoneNum = json['student_phone_num'],
        sessionID = json['sessionID'];
}
