class ClassModel {
  final String className;
  final int classCode;
  final int classCredit;
  final String classProf;

  ClassModel.fromJson(Map<String, dynamic> json)
      : className = json['class_name'],
        classCode = json['class_id'],
        classProf = json['professor'],
        classCredit = json['credit'];
}
