import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../firebase_options.dart';
import '../../shared/models/user_model.dart';
import 'notification_service.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

class FcmService {
  static final FcmService _instance = FcmService._internal();
  factory FcmService() => _instance;
  FcmService._internal();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  bool _initialized = false;
  Set<String> _currentTopics = <String>{};

  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessage.listen((message) async {
      await NotificationService().showRemoteMessage(message);
    });

    _messaging.onTokenRefresh.listen((_) async {
      if (_currentTopics.isEmpty) return;
      for (final topic in _currentTopics) {
        await _messaging.subscribeToTopic(topic);
      }
    });
  }

  Future<void> syncUser(AppUser? user) async {
    final nextTopics = _topicsFor(user);
    if (_sameTopics(nextTopics, _currentTopics)) return;

    final toUnsubscribe = _currentTopics.difference(nextTopics);
    final toSubscribe = nextTopics.difference(_currentTopics);

    for (final topic in toUnsubscribe) {
      await _messaging.unsubscribeFromTopic(topic);
    }

    for (final topic in toSubscribe) {
      await _messaging.subscribeToTopic(topic);
    }

    _currentTopics = nextTopics;
  }

  Set<String> _topicsFor(AppUser? user) {
    if (user == null) return <String>{};
    return <String>{'user_${user.uid}', 'role_${user.role.name}'};
  }

  bool _sameTopics(Set<String> left, Set<String> right) {
    if (left.length != right.length) return false;
    return left.containsAll(right);
  }
}
