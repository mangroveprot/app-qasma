import '../../domain/entities/other_info.dart';

class OtherInfoModel extends OtherInfo {
  const OtherInfoModel({super.course, super.yearLevel, super.block});

  // helper value safety
  static String? _getValue(Map<String, dynamic> map, String key) {
    final value = map[key];
    return value != null ? value.toString() : null;
  }

  // convert from for API
  factory OtherInfoModel.fromMap(Map<String, dynamic> map) {
    return OtherInfoModel(
      course: _getValue(map, 'course'),
      yearLevel: _getValue(map, 'year_level'),
      block: _getValue(map, 'block'),
    );
  }

  // for sqlite
  @override
  Map<String, dynamic> toMap() {
    return {'course': course, 'year_level': yearLevel, 'block': block};
  }

  // convert to entity
  OtherInfo toEntity() {
    return OtherInfo(course: course, yearLevel: yearLevel, block: block);
  }

  // convert from entity
  factory OtherInfoModel.fromEntity(OtherInfo entity) {
    return OtherInfoModel(
      course: entity.course,
      yearLevel: entity.yearLevel,
      block: entity.block,
    );
  }
}
