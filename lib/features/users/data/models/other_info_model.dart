class OtherInfoModel {
  final String course;
  final String yearLevel;
  final String block;

  OtherInfoModel({
    required this.course,
    required this.yearLevel,
    required this.block,
  });

  Map<String, dynamic> toMap() {
    return {'course': course, 'yearLevel': yearLevel, 'block': block};
  }

  factory OtherInfoModel.fromMap(Map<String, dynamic> map) {
    return OtherInfoModel(
      course: map['course'] ?? '',
      yearLevel: map['yearLevel'] ?? '',
      block: map['block'] ?? '',
    );
  }
}
