import 'github_asset_model.dart';

class GitHubReleaseModel {
  final String tagName;
  final String name;
  final String body;
  final String htmlUrl;
  final bool prerelease;
  final List<GitHubAssetModel> assets;
  final String releaseNotes;
  final String? publishedAt;

  GitHubReleaseModel({
    required this.tagName,
    required this.name,
    required this.body,
    required this.htmlUrl,
    required this.prerelease,
    required this.assets,
    required this.releaseNotes,
    this.publishedAt,
  });

  factory GitHubReleaseModel.fromJson(Map<String, dynamic> json) {
    return GitHubReleaseModel(
      tagName: json['tag_name'] as String? ?? '',
      name: json['name'] as String? ?? '',
      body: json['body'] as String? ?? '',
      htmlUrl: json['html_url'] as String? ?? '',
      prerelease: json['prerelease'] as bool? ?? false,
      assets: (json['assets'] as List<dynamic>?)
              ?.map((asset) =>
                  GitHubAssetModel.fromJson(asset as Map<String, dynamic>))
              .toList() ??
          [],
      releaseNotes: json['body'] as String? ?? '',
      publishedAt: json['published_at'] as String?,
    );
  }

  GitHubReleaseModel copyWith({
    String? tagName,
    String? name,
    String? body,
    String? htmlUrl,
    bool? prerelease,
    List<GitHubAssetModel>? assets,
    String? releaseNotes,
    String? publishedAt,
  }) {
    return GitHubReleaseModel(
      tagName: tagName ?? this.tagName,
      name: name ?? this.name,
      body: body ?? this.body,
      htmlUrl: htmlUrl ?? this.htmlUrl,
      prerelease: prerelease ?? this.prerelease,
      assets: assets ?? this.assets,
      releaseNotes: releaseNotes ?? this.releaseNotes,
      publishedAt: publishedAt ?? this.publishedAt,
    );
  }
}
