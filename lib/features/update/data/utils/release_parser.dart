import '../models/github_release_model.dart';
import '../models/release_info_model.dart';

class ReleaseParser {
  static String extractVersion(String tagName) {
    return tagName.replaceFirst(RegExp(r'^v'), '');
  }

  static String normalizeVersion(String version) {
    return version.split(RegExp(r'[-+]')).first;
  }

  static String extractBuildNumber(String text) {
    final patterns = [
      RegExp(r'build(\d+)', caseSensitive: false), // matches "build2", "Build2"
      RegExp(r'build[:\s]+(\d+)',
          caseSensitive: false), // matches "Build: 2", "build 2"
      RegExp(r'\(build\s+(\d+)\)', caseSensitive: false), // matches "(Build 2)"
      RegExp(r'#(\d+)'), // matches "#2"
    ];

    for (final pattern in patterns) {
      final match = pattern.firstMatch(text);
      if (match != null && match.groupCount >= 1) {
        return match.group(1)!;
      }
    }

    return '';
  }

  static String findAssetUrl(GitHubReleaseModel release) {
    try {
      final apkAsset = release.assets.firstWhere(
        (asset) => asset.name.toLowerCase().endsWith('.apk'),
      );
      return apkAsset.browserDownloadUrl;
    } catch (e) {
      return release.htmlUrl;
    }
  }

  static String findAssetSize(GitHubReleaseModel release) {
    try {
      final apkAsset = release.assets.firstWhere(
        (asset) => asset.name.toLowerCase().endsWith('.apk'),
      );

      if (apkAsset.size == 0) {
        return '';
      }

      final sizeInMB = (apkAsset.size / (1024 * 1024)).toStringAsFixed(1);
      return '${sizeInMB}MB';
    } catch (e) {
      return '';
    }
  }

  static ReleaseInfoModel parseRelease(GitHubReleaseModel release) {
    final version = extractVersion(release.tagName);
    final releaseText = '${release.name} ${release.body}';
    final buildNumber = extractBuildNumber(releaseText);
    final downloadUrl = findAssetUrl(release);
    final size = findAssetSize(release);

    return ReleaseInfoModel(
      version: version,
      buildNumber: buildNumber.isNotEmpty ? buildNumber : '1',
      downloadUrl: downloadUrl,
      releaseNotes: release.body,
      publishedAt: release.publishedAt,
      isPrerelease: release.prerelease,
      size: size,
    );
  }
}
