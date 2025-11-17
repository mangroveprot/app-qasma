class GitHubAssetModel {
  final String name;
  final String browserDownloadUrl;
  final int size;

  GitHubAssetModel({
    required this.name,
    required this.browserDownloadUrl,
    required this.size,
  });

  factory GitHubAssetModel.fromJson(Map<String, dynamic> json) {
    return GitHubAssetModel(
      name: json['name'] as String,
      browserDownloadUrl: json['browser_download_url'] as String,
      size: json['size'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'browser_download_url': browserDownloadUrl,
      'size': size,
    };
  }
}
