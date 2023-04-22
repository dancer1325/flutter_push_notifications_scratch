import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

// SHA1: 1D:4F:38:94:62:06:9F:C6:75:A7:73:BD:E4:B0:DA:27:80:B1:9D:F0
// P8 - KeyID: VYZH37GGZ9

// All will be static --> Unnecessary to initialize the class or work with states / providers
class PushNotificationService {

  // Get the FirebaseMessaging instance, based on the configuration installed previously
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static String? token;

  // StreamController which emits String
  // .broadcast()     allow several objects are subscribed to changes of this stream
  static StreamController<String> _messageStream = new StreamController.broadcast();
  static Stream<String> get messagesStream => _messageStream.stream;    // .stream    It's the outcome property

  // Define a handler for one of the possible device's states  https://firebase.flutter.dev/docs/messaging/usage#receiving-messages
  // Future   Because we have async processes
  static Future _backgroundHandler( RemoteMessage message ) async {
    print( 'onBackground Handler ${ message.messageId }');
    print( message.data );

    // _messageStream.add( message.notification?.title ?? 'No data' );
    _messageStream.add( message.data['product'] as String ?? 'No data' );
  }

  // Define a handler for one of the possible device's states  https://firebase.flutter.dev/docs/messaging/usage#receiving-messages
  // Future   Because we have async processes
  static Future _onMessageHandler( RemoteMessage message ) async {
    print( 'onMessage Handler ${ message.messageId }');
    print( message.data );

    // _messageStream.add( message.notification?.title ?? 'No data' );
    _messageStream.add( message.data['product'] as String ?? 'No data' );
  }

  // Define a handler for one of the possible device's states  https://firebase.flutter.dev/docs/messaging/usage#receiving-messages
  // Future   Because we have async processes
  static Future _onMessageOpenApp( RemoteMessage message ) async {
    print( 'onMessageOpenApp Handler ${ message.messageId }');
    print( message.data );

    // _messageStream.add( message.notification?.title ?? 'No data' );
    _messageStream.add( message.data['product'] as String ?? 'No data' );
  }

  // Future   Because we have async processes
  static Future initializeApp() async {

    // Push Notifications
    await Firebase.initializeApp();
    await requestPermission();

    // Required to send notifications to the device
    token = await FirebaseMessaging.instance.getToken();
    print('Token: $token');

    // Handlers
    FirebaseMessaging.onBackgroundMessage( _backgroundHandler );  // If app is in background or terminated state
    FirebaseMessaging.onMessage.listen( _onMessageHandler );      // If app is in foreground state
    FirebaseMessaging.onMessageOpenedApp.listen( _onMessageOpenApp ); // If app is in background state

    // Local Notifications
  }

  // Apple / Web
  // Future   Because we have async processes
  static requestPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true
    );

    print('User push notification status ${ settings.authorizationStatus }');

  }

  // Recommended by Dart to define the closure of the StreamController, although it's not invoked ever
  static closeStreams() {
    _messageStream.close();
  }
}