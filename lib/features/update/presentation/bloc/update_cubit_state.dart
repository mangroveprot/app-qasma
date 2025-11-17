part of 'update_cubit.dart';

abstract class UpdateCubitState extends Equatable {
  final String? currentVersion;
  final String? currentBuild;

  const UpdateCubitState({
    this.currentVersion,
    this.currentBuild,
  });

  @override
  List<Object?> get props => [currentVersion, currentBuild];
}

class UpdateInitial extends UpdateCubitState {
  const UpdateInitial({
    super.currentVersion,
    super.currentBuild,
  });
}

class UpdateChecking extends UpdateCubitState {
  const UpdateChecking({
    super.currentVersion,
    super.currentBuild,
  });
}

class UpdateAvailable extends UpdateCubitState {
  final ReleaseInfoModel latestRelease;

  const UpdateAvailable({
    required String currentVersion,
    required String currentBuild,
    required this.latestRelease,
  }) : super(
          currentVersion: currentVersion,
          currentBuild: currentBuild,
        );

  @override
  List<Object?> get props => [currentVersion, currentBuild, latestRelease];
}

class UpdateNotAvailable extends UpdateCubitState {
  const UpdateNotAvailable({
    required String currentVersion,
    required String currentBuild,
  }) : super(
          currentVersion: currentVersion,
          currentBuild: currentBuild,
        );

  @override
  List<Object?> get props => [currentVersion, currentBuild];
}

class UpdateCheckFailed extends UpdateCubitState {
  final String message;

  const UpdateCheckFailed(
    this.message, {
    super.currentVersion,
    super.currentBuild,
  });

  @override
  List<Object?> get props => [message, currentVersion, currentBuild];
}

class UpdateDismissed extends UpdateCubitState {
  const UpdateDismissed({
    super.currentVersion,
    super.currentBuild,
  });
}
