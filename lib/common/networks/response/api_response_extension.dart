part of 'api_response.dart';

extension ApiResponseExtension<T> on ApiResponse<T> {
  /// Convert to Either<AppError, T> for single document
  Either<AppError, T> toEitherDocument() {
    if (hasError) {
      return Left(error!);
    }
    if (document != null) {
      return Right(document!);
    }
    return Left(
      AppError.create(message: 'No document found', type: ErrorType.server),
    );
  }

  /// Convert to Either<AppError, List<T>> for multiple documents
  Either<AppError, List<T>> toEitherDocuments() {
    if (hasError) {
      return Left(error!);
    }
    return Right(documents ?? []);
  }
}
