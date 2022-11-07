class Diary {
  String text; // 내용
  DateTime createdAt; // 작성 시간

  Diary({
    required this.text,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['text'] = text;
    data['createdAt'] = createdAt.toString();

    return data;
  }

  factory Diary.fromJson(Map<String, dynamic> json) {
    return Diary(
      text: json["text"],
      createdAt: DateTime.parse(json["createdAt"]),
    );
  }
}
