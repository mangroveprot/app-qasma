import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:logger/logger.dart';
import '../../../../common/utils/constant.dart';
import '../../../../infrastructure/injection/service_locator.dart';
import '../../../../infrastructure/routes/app_router.dart';
import '../../../../infrastructure/routes/app_routes.dart';

class FCMService {
  static final FCMService _instance = FCMService._internal();
  factory FCMService() => _instance;
  FCMService._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  final Logger _logger = sl<Logger>();

  String? _fcmToken;
  String? get fcmToken => _fcmToken;

  // Stream for token changes
  final _tokenController = StreamController<String>.broadcast();
  Stream<String> get tokenStream => _tokenController.stream;

  Future<void> init() async {
    try {
      _logger.i('Initializing FCM Service...');

      // Request permission
      await _requestPermission();

      // Initialize local notifications
      await _initializeLocalNotifications();

      // Setup message handlers
      _setupMessageHandlers();

      // Listen for token refresh
      _firebaseMessaging.onTokenRefresh.listen((newToken) {
        _logger.i('FCM Token refreshed: $newToken');
        _fcmToken = newToken;
        // Emit to stream so Cubit can listen
        _tokenController.add(newToken);
      });

      _logger.i('FCM Service initialized successfully');
    } catch (e) {
      _logger.e('Error initializing FCM: $e');
    }
  }

  /// Get FCM token - call this when user logs in
  Future<String?> getToken() async {
    try {
      final token = await _firebaseMessaging.getToken();
      if (token != null) {
        _logger.i('FCM Token retrieved: $token');
        _fcmToken = token;
        // Emit to stream when token is retrieved
        _tokenController.add(token);
        return token;
      }
      _logger.w('FCM Token is null');
      return null;
    } catch (e) {
      _logger.e('Error getting FCM token: $e');
      return null;
    }
  }

  /// Request notification permission
  Future<void> _requestPermission() async {
    final settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      _logger.i('User granted notification permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      _logger.i('User granted provisional notification permission');
    } else {
      _logger.w('User declined notification permission');
    }
  }

  /// Initialize local notifications (Android only)
  Future<void> _initializeLocalNotifications() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const initSettings = InitializationSettings(
      android: androidSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Create Android notification channel
    const channel = AndroidNotificationChannel(
      'appointment_notifications',
      'Appointment Notifications',
      description: 'Notifications for appointments',
      importance: Importance.high,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  /// Setup message handlers
  void _setupMessageHandlers() {
    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _logger.i('Received foreground message: ${message.messageId}');
      _handleForegroundMessage(message);
    });

    // Handle background messages (when app is in background)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _logger.i('Notification tapped (background): ${message.messageId}');
      _handleNotificationTap(message.data);
    });

    // Handle terminated state messages
    _firebaseMessaging.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        _logger.i('App opened from terminated state: ${message.messageId}');
        _handleNotificationTap(message.data);
      }
    });
  }

  /// Handle foreground message (show local notification)
  void _handleForegroundMessage(RemoteMessage message) {
    final notification = message.notification;
    if (notification == null) return;

    _localNotifications.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'appointment_notifications',
          'Appointment Notifications',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          styleInformation: BigTextStyleInformation(
            notification.body ?? '',
            contentTitle: notification.title,
            htmlFormatBigText: true,
            htmlFormatContentTitle: true,
          ),
        ),
      ),
      payload: message.data['notificationId'],
    );
  }

  /// Handle notification tap
  void _onNotificationTapped(NotificationResponse response) {
    if (response.payload != null) {
      _handleNotificationTap({'notificationId': response.payload});
    }
  }

  /// Handle notification tap navigation
  void _handleNotificationTap(Map<String, dynamic> data) {
    final notificationId = data['notificationId'] as String?;
    final type = data['type'] as String?;

    _logger.d('Notification tapped - ID: $notificationId, Type: $type');

    if (type == NotificationType.appointmentCancelled.field ||
        type == NotificationType.appointmentCompleted.field) {
      AppRouter.router
          .go(Routes.buildPath(Routes.appointment, Routes.appointment_history));
    } else {
      AppRouter.router.go(Routes.root);
    }
  }

  /// Delete FCM token (call this during logout)
  Future<void> deleteToken() async {
    try {
      await _firebaseMessaging.deleteToken();
      _fcmToken = null;
      _logger.i('FCM token deleted');
    } catch (e) {
      _logger.e('Error deleting FCM token: $e');
    }
  }

  /// Dispose - call this when app is closing
  void dispose() {
    _tokenController.close();
  }

  /// Subscribe to topic
  Future<void> subscribeToTopic(String topic) async {
    try {
      await _firebaseMessaging.subscribeToTopic(topic);
      _logger.i('Subscribed to topic: $topic');
    } catch (e) {
      _logger.e('Error subscribing to topic: $e');
    }
  }

  /// Unsubscribe from topic
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _firebaseMessaging.unsubscribeFromTopic(topic);
      _logger.i('Unsubscribed from topic: $topic');
    } catch (e) {
      _logger.e('Error unsubscribing from topic: $e');
    }
  }
}

/// Background message handler (optional - use only if you need to process data while app is terminated)
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Handling background message: ${message.messageId}');
  // Handle background message processing
}
