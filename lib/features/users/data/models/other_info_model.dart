import '../../domain/entities/other_info.dart';

class OtherInfoModel extends OtherInfo {
  const OtherInfoModel({super.course, super.yearLevel, super.block});

  static String _getString(
    Map<String, dynamic> map,
    String key1, [
    String? key2,
  ]) {
    if (map.containsKey(key1)) {
      final value = map[key1];
      if (value != null) return value.toString();
    }

    if (key2 != null && map.containsKey(key2)) {
      final value = map[key2];
      if (value != null) return value.toString();
    }

    return '';
  }

  factory OtherInfoModel.fromMap(Map<String, dynamic> map) {
    return OtherInfoModel(
      course: _getString(map, 'course'),
      yearLevel: _getString(map, 'yearLevel', 'year_level'),
      block: _getString(map, 'block'),
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {'course': course, 'yearLevel': yearLevel, 'block': block};
  }

  OtherInfo toEntity() {
    return OtherInfo(course: course, yearLevel: yearLevel, block: block);
  }

  factory OtherInfoModel.fromEntity(OtherInfo entity) {
    return OtherInfoModel(
      course: entity.course,
      yearLevel: entity.yearLevel,
      block: entity.block,
    );
  }

  OtherInfoModel copyWith({
    String? course,
    String? yearLevel,
    String? block,
  }) {
    return OtherInfoModel(
      course: course ?? this.course,
      yearLevel: yearLevel ?? this.yearLevel,
      block: block ?? this.block,
    );
  }

  @override
  String toString() {
    return 'OtherInfoModel(course: $course, yearLevel: $yearLevel, block: $block)';
  }
}
