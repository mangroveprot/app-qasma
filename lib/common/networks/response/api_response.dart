import 'package:dartz/dartz.dart';

import '../../error/app_error.dart';
part 'api_response_extension.dart';

class ApiResponse<T> {
  final bool success;
  final T? document;
  final List<T>? documents;
  final int? total;
  final int? results;
  final int? page;
  final int? limit;
  final AppError? error;

  ApiResponse({
    required this.success,
    this.document,
    this.documents,
    this.total,
    this.results,
    this.page,
    this.limit,
    this.error,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    final success = json['success'] ?? false;

    AppError? error;
    if (!success) {
      final errorData = json['error'];
      if (errorData != null) {
        final message =
            errorData is Map<String, dynamic>
                ? (errorData['message'] ?? 'Server error occurred')
                : errorData.toString();

        error = AppError.create(message: message, type: ErrorType.server);
      } else {
        error = AppError.create(
          message: 'Unknown server error',
          type: ErrorType.server,
        );
      }
    }

    return ApiResponse(
      success: success,
      document: json['document'] != null ? fromJsonT(json['document']) : null,
      documents:
          json['documents'] != null
              ? List<Map<String, dynamic>>.from(
                json['documents'],
              ).map(fromJsonT).toList()
              : null,
      total: json['total'],
      results: json['results'] ?? json['_results'],
      page: json['page'],
      limit: json['limit'],
      error: error,
    );
  }

  bool get isSuccess => success && error == null;
  bool get hasError => error != null;
  bool get hasData =>
      document != null || (documents != null && documents!.isNotEmpty);
  bool get isEmpty => !hasData;
}
