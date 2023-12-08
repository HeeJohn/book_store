class ClassModel {
  final String className;
  final int classID;
  final int classCredit;
  final String classProf;

  ClassModel.fromJson(Map<String, dynamic> json)
      : className = json['class_name'],
        classID = json['class_id'],
        classProf = json['professor'],
        classCredit = json['credit'];
}
