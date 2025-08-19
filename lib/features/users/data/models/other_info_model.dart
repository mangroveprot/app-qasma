import '../../domain/entities/other_info.dart';

class OtherInfoModel extends OtherInfo {
  const OtherInfoModel(Map<String, dynamic> data) : super(data);

  factory OtherInfoModel.fromMap(Map<String, dynamic> map) =>
      OtherInfoModel(Map<String, dynamic>.from(map));

  @override
  Map<String, dynamic> toMap() => Map<String, dynamic>.from(data);

  OtherInfo toEntity() => OtherInfo(Map<String, dynamic>.from(data));

  factory OtherInfoModel.fromEntity(OtherInfo entity) =>
      OtherInfoModel(Map<String, dynamic>.from(entity.toMap()));

  OtherInfoModel copyWith(Map<String, dynamic> patch) =>
      OtherInfoModel({...data, ...patch});

  @override
  String toString() => 'OtherInfoModel($data)';
}
