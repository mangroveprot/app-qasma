class ButtonIds {
  final String id;

  const ButtonIds({
    required this.id,
  });
}

class ButtonsUniqeKeys {
  static const verify = ButtonIds(
    id: 'verify-button',
  );
  static const resend = ButtonIds(
    id: 'resend-button',
  );
  static const forgotPassword = ButtonIds(
    id: 'forgot-password',
  );
  static const downloadReports = ButtonIds(
    id: 'download-reports',
  );
}
