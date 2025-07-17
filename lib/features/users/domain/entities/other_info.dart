import 'package:equatable/equatable.dart';

class OtherInfo extends Equatable {
  final String? course;
  final String? yearLevel;
  final String? block;

  const OtherInfo({this.course, this.yearLevel, this.block});

  factory OtherInfo.fromMap(Map<String, dynamic> map) {
    return OtherInfo(
      course: map['course'],
      yearLevel: map['yearLevel'],
      block: map['block'],
    );
  }

  Map<String, dynamic> toMap() {
    return {'course': course, 'yearLevel': yearLevel, 'block': block};
  }

  @override
  List<Object?> get props => [course, yearLevel, block];
}
