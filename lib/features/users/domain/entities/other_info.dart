import 'package:equatable/equatable.dart';

class OtherInfo extends Equatable {
  final Map<String, dynamic> data;

  const OtherInfo([this.data = const {}]);

  factory OtherInfo.fromMap(Map<String, dynamic> map) =>
      OtherInfo(Map<String, dynamic>.from(map));

  Map<String, dynamic> toMap() => Map<String, dynamic>.from(data);

  String? get course => data['course']?.toString();
  String? get yearLevel => data['yearLevel']?.toString();
  String? get block => data['block']?.toString();

  @override
  List<Object?> get props => [data];
}
