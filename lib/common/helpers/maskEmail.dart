String maskEmail(String email) {
  final parts = email.split('@');
  if (parts.length != 2) return email;

  final username = parts[0];
  final domain = parts[1];

  final visiblePrefix =
      username.length > 2 ? username.substring(0, 2) : username;
  final maskedUsername = '$visiblePrefix****';

  final domainParts = domain.split('.');
  final tld = domainParts.isNotEmpty ? domainParts.last : domain;

  return '$maskedUsername@$tld';
}
