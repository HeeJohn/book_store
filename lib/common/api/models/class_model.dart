class ClassModel {
  final String className;
  final int classCode;
  final int classCredit;
  final String classProf;
  final String classLoc;
  ClassModel.fromJson(Map<String, dynamic> json)
      : className = json['class_name'],
        classCode = json['class_num'],
        classProf = json['class_professor'],
        classLoc = json['class_location'],
        classCredit = json['class_credit'];
}
