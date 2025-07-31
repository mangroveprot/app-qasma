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
      final List<String> errorMessages = [];

      // Check top-level message
      if (json['message'] != null) {
        errorMessages.add(json['message'].toString());
      }

      // Check top-level details
      if (json['details'] != null && json['details'] is List) {
        final details = json['details'] as List;
        errorMessages.addAll(details.map((detail) => detail.toString()));
      }

      // Check nested error object
      if (json['error'] != null && json['error'] is Map<String, dynamic>) {
        final errorObj = json['error'] as Map<String, dynamic>;
        if (errorObj['message'] != null) {
          errorMessages.add(errorObj['message'].toString());
        }
        if (errorObj['details'] != null && errorObj['details'] is List) {
          final details = errorObj['details'] as List;
          errorMessages.addAll(details.map((detail) => detail.toString()));
        }
      }

      if (errorMessages.isEmpty) {
        errorMessages.add('Unknown server error');
      }

      error = AppError.create(
        message: errorMessages.isNotEmpty
            ? errorMessages.first
            : (json['message']?.toString() ?? 'Server error'),
        messages: errorMessages,
        type: ErrorType.validation,
      );
    }

    return ApiResponse(
      success: success,
      document: json['document'] != null ? fromJsonT(json['document']) : null,
      documents: json['documents'] != null
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
