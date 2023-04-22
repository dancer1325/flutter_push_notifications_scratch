import 'package:flutter/material.dart';

import 'package:flutter_push_notifications_scratch/app/screens/home_screen.dart';
import 'package:flutter_push_notifications_scratch/app/screens/message_screen.dart';
import 'package:flutter_push_notifications_scratch/app/services/push_notifications_service.dart';

// void main() {
//   bootstrap(() => const App());
// }


// main() can be asynchronous !!!!
void main() async {

  // Wait for initializing the widgets --> have a context
  WidgetsFlutterBinding.ensureInitialized();

  // Once we have got a context --> initialize Firebase
  await PushNotificationService.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  // State of the Navigator
  final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();
  // State of the MaterialApp
  final GlobalKey<ScaffoldMessengerState> messengerKey = new GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();

    // We have got access to the Context!
    PushNotificationService.messagesStream.listen((message) {

      print('MyApp: $message');

      // .pushNamed()     It doesn't work, because all the MaterialApp has been already created
      //Navigator.pushNamed(context, 'message');
      // navigatorKey   has got the reference --> Possible to navigate afterwards
      // ?    Because it's possible isn't associated to some Widget yet
      navigatorKey.currentState?.pushNamed('message', arguments: message);

      // SnackBar        StatefulWidget, which is lightweight message
      final snackBar = SnackBar(content: Text(message));
      // showSnackBar     Show the previous snackBar, through all the Scaffold via it's state
      // ?    Because it's possible isn't associated to some Widget yet
      messengerKey.currentState?.showSnackBar(snackBar);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      initialRoute: 'home',
      navigatorKey: navigatorKey, // Navegar
      scaffoldMessengerKey: messengerKey, // Snacks
      routes: {
        'home'   : ( _ ) => HomeScreen(),
        'message': ( _ ) => MessageScreen(),
      },
    );
  }
}
