class UpdateErrorHelper {
  static String getFriendlyMessage(String errorMessage) {
    final lowerError = errorMessage.toLowerCase();

    if (lowerError.contains('timeout') ||
        lowerError.contains('connection') ||
        lowerError.contains('took longer')) {
      return 'Connection timeout. Please check your internet and try again.';
    }

    if (lowerError.contains('network') || lowerError.contains('unreachable')) {
      return 'No internet connection detected.';
    }

    if (lowerError.contains('server') ||
        lowerError.contains('500') ||
        lowerError.contains('503')) {
      return 'Service temporarily unavailable.';
    }

    if (lowerError.contains('404')) {
      return 'Update information not found.';
    }

    return 'Unable to check for updates right now.';
  }
}
