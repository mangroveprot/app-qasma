class ReleaseInfoModel {
  final String version;
  final String buildNumber;
  final String downloadUrl;
  final String releaseNotes;
  final String? publishedAt;
  final bool isPrerelease;
  final String size;
  final bool isMandatory;

  ReleaseInfoModel({
    required this.version,
    required this.buildNumber,
    required this.downloadUrl,
    required this.releaseNotes,
    this.publishedAt,
    required this.isPrerelease,
    required this.size,
    this.isMandatory = false,
  });

  factory ReleaseInfoModel.fromJson(Map<String, dynamic> json) {
    return ReleaseInfoModel(
      version: json['version'] as String,
      buildNumber: json['buildNumber'] as String,
      downloadUrl: json['downloadUrl'] as String,
      releaseNotes: json['releaseNotes'] as String,
      publishedAt: json['publishedAt'] as String?,
      isPrerelease: json['isPrerelease'] as bool,
      size: json['size'] as String,
      isMandatory: json['isMandatory'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'version': version,
      'buildNumber': buildNumber,
      'downloadUrl': downloadUrl,
      'releaseNotes': releaseNotes,
      'publishedAt': publishedAt,
      'isPrerelease': isPrerelease,
      'size': size,
      'isMandatory': isMandatory,
    };
  }

  ReleaseInfoModel copyWith({
    String? version,
    String? buildNumber,
    String? downloadUrl,
    String? releaseNotes,
    String? publishedAt,
    bool? isPrerelease,
    String? size,
    bool? isMandatory,
  }) {
    return ReleaseInfoModel(
      version: version ?? this.version,
      buildNumber: buildNumber ?? this.buildNumber,
      downloadUrl: downloadUrl ?? this.downloadUrl,
      releaseNotes: releaseNotes ?? this.releaseNotes,
      publishedAt: publishedAt ?? this.publishedAt,
      isPrerelease: isPrerelease ?? this.isPrerelease,
      size: size ?? this.size,
      isMandatory: isMandatory ?? this.isMandatory,
    );
  }
}
