class ClassModel {
  final String className;
  final int classCode;
  final String classTime;
  final String classDay;
  final int classCredit;
  final String classProf;
  final String classLoc;
  ClassModel.fromJson(Map<String, dynamic> json)
      : className = json['class_name'],
        classCode = json['class_num'],
        classTime = json['class_time'],
        classProf = json['class_professor'],
        classLoc = json['class_location'],
        classDay = json['class_day'],
        classCredit = json['class_credit'];
}
