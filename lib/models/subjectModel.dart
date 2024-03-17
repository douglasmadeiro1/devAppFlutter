// ignore: file_names
class SubjectModel {
  String subjectId;
  String subject;

  SubjectModel({
    required this.subjectId,
    required this.subject,
  });
  SubjectModel.fromMap(Map<String, dynamic> map)
      : subjectId = map["subjectId"],
        subject = map["subject"];

  Map<String, dynamic> toMap() {
    return {
      "subjectId": subjectId,
      "subject": subject,
    };
  }
}
