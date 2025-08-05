import '../../../../common/utils/model_utils.dart';
import '../../domain/entities/other_info.dart';

class OtherInfoModel extends OtherInfo {
  const OtherInfoModel({super.course, super.yearLevel, super.block});

  // convert from for API
  factory OtherInfoModel.fromMap(Map<String, dynamic> map) {
    return OtherInfoModel(
      course: ModelUtils.getValue(map, 'course'),
      yearLevel: ModelUtils.getValue(map, 'year_level'),
      block: ModelUtils.getValue(map, 'block'),
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
