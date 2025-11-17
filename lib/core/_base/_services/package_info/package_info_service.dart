import 'package:package_info_plus/package_info_plus.dart';

class PackageInfoService {
  PackageInfo? _packageInfo;

  PackageInfo get _info {
    if (_packageInfo == null) {
      throw Exception('PackageInfoService not initialized');
    }
    return _packageInfo!;
  }

  Future<void> init() async {
    _packageInfo = await PackageInfo.fromPlatform();
  }

  String get version => _info.version;
  String get buildNumber => _info.buildNumber;
  String get appName => _info.appName;
  String get packageName => _info.packageName;

  String get versionWithBuild => '$version-build$buildNumber';

  PackageInfo get info => _info;
}
