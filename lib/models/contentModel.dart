// ignore: file_names

class ContentModel {
  String contentId;
  String contentTitle;
  String content;

  ContentModel({
    required this.contentId,
    required this.contentTitle,
    required this.content,
  });
  ContentModel.fromMap(Map<String, dynamic> map)
      : contentId = map["contentId"],
        contentTitle = map["contentTitle"],
        content = map["content"];

  Map<String, dynamic> toMap() {
    return {
      "contentId": contentId,
      "contentTitle": contentTitle,
      "content": content,
    };
  }
}
