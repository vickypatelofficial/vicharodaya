import 'dart:convert';
import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:async'; // For Timer
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
//code commented(previous)
// OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
// OneSignal.initialize("7737912d-e7a0-4fcf-a063-1c2896d52b13");

// // Handle Notification Click
// OneSignal.Notifications.addClickListener((event) async {
//   _handleNotificationClick(event);
// });

// OneSignal.Notifications.requestPermission(true);

//code(new)

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   FirebaseMessaging.instance.getInitialMessage();
//   RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
// //   // OneSignal setup
// //   OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
// //   OneSignal.Debug.setAlertLevel(OSLogLevel.none);
// //   OneSignal.consentRequired(false);
// //   OneSignal.initialize("7737912d-e7a0-4fcf-a063-1c2896d52b13");
// //   OneSignal.Notifications.requestPermission(true);

// //   // Show notification in foreground
// //   OneSignal.Notifications.addForegroundWillDisplayListener((event) {
// //     print('NOTIFICATION WILL DISPLAY LISTENER CALLED WITH: ${event.notification.jsonRepresentation()}');
// //     event.preventDefault();
// //     event.notification.display();
// //   });

// //   // Handle notification click
// //  OneSignal.Notifications.addClickListener((event) {
// //   print('🔔 Notification Clicked');

// //   // Access the custom data
// //   final additionalData = event.notification.additionalData;
// //   final url = additionalData?['target_url'];

// //   if (url != null) {
// //     print('🌐 Opening URL in WebView: $url');

// //     WidgetsBinding.instance.addPostFrameCallback((_) {
// //       navigatorKey.currentState?.push(
// //         MaterialPageRoute(
// //           builder: (context) => SplashScreen(),
// //         ),
// //       );
// //     });
// //   } else {
// //     print('⚠️ No target_url found in notification');
// //   }
// // });

//   FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//     final targetUrl = message.data['target_url'];
//     if (targetUrl != null) {
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         navigatorKey.currentState?.push(
//           MaterialPageRoute(
//             builder: (context) => SplashScreen(),
//           ),
//         );
//       });
//     }
//   });

//   runApp(MyApp());
// }

// final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// void main() {
//   WidgetsFlutterBinding.ensureInitialized();

//   OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
//   OneSignal.Debug.setAlertLevel(OSLogLevel.none);
//   OneSignal.consentRequired(false);
//   OneSignal.initialize("7737912d-e7a0-4fcf-a063-1c2896d52b13");
//   OneSignal.Notifications.requestPermission(true);

//   // Foreground display
//   OneSignal.Notifications.addForegroundWillDisplayListener((event){
//     print(
//         'NOTIFICATION WILL DISPLAY LISTENER CALLED WITH: ${event.notification.jsonRepresentation()}');
//     event.preventDefault();
//     event.notification.display();
//   });

//   // Handle notification clicks
//   OneSignal.Notifications.addClickListener((event) {
//     print('clicked notification');
//     String? url = event.notification.launchUrl;

// try {
//   print('+++++++url++++++');
//   if (url != null) {
//     print('+++++++enter in try++++++');
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       navigatorKey.currentState?.push(
//         MaterialPageRoute(builder: (context) => SplashScreen()),
//       );
//     });
//   }
// } catch (e) {
//   print('=========================');
//   print(e.toString());
// }
//   });

//   runApp(MyApp());
// }
Map<String, dynamic>? initialNotificationData;
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

const platform = MethodChannel("onesignal/launch");
Future<String?> getInitialUrlFromNative() async {
  try {
    const platform = MethodChannel('onesignal/launch');
    final initialUrl = await platform.invokeMethod('getInitialUrl');
    return initialUrl as String?;
  } on PlatformException catch (e) {
    print("Failed to get initial URL: ${e.message}");
    return null;
  }
}

void handleNotificationUrl(String url) {
  Fluttertoast.showToast(
    msg: "Notification URL: $url",
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: Colors.black87,
    textColor: Colors.white,
  );

  navigatorKey.currentState?.push(MaterialPageRoute(
    builder: (context) => WebViewWithBottomNav(initialUrl: url),
  ));
}

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
//   OneSignal.initialize("7737912d-e7a0-4fcf-a063-1c2896d52b13");
//   OneSignal.Notifications.requestPermission(true);

//   OneSignal.Notifications.addClickListener((event) async {
//     print("🔔 Notification clicked");

//     final rawPayload = event.notification.rawPayload;
//     final customRawString = rawPayload?['custom'];

//     if (customRawString != null) {
//       final customMap = jsonDecode(customRawString);
//       final targetUrl = customMap['a']['target_url'];

//       if (targetUrl != null && targetUrl != "null") {
//         // Save the data temporarily
//         initialNotificationData = {'target_url': targetUrl};

//         // If app is already running, navigate immediately
//         if (navigatorKey.currentState != null) {
//           navigatorKey.currentState?.push(
//             MaterialPageRoute(
//               builder: (context) => WebViewWithBottomNav(
//                 initialUrl: targetUrl,
//               ),
//             ),
//           );
//         }
//       }
//     }
//   });

//   // String? targetUrl;

//   // try {
//   //   // Listen for launchFromNotification call from Kotlin
//   //   platform.setMethodCallHandler((call) async {
//   //     if (call.method == "launchFromNotification") {
//   //       final url = call.arguments as String?;
//   //       Fluttertoast.showToast(
//   //           msg: "Notification URL: ${url.toString()}",
//   //           toastLength: Toast.LENGTH_LONG,
//   //           gravity: ToastGravity.BOTTOM,
//   //           backgroundColor: Colors.black87,
//   //           textColor: Colors.white,
//   //         );
//   //       if (url != null) {
//   //         print("📲 App launched from notification with URL: $url");
//   //         targetUrl = url;
//   //         Fluttertoast.showToast(
//   //           msg: "Notification URL: $url",
//   //           toastLength: Toast.LENGTH_LONG,
//   //           gravity: ToastGravity.BOTTOM,
//   //           backgroundColor: Colors.black87,
//   //           textColor: Colors.white,
//   //         );

//   //         // Here you can navigate to WebView or any screen with this URL
//   //         navigatorKey.currentState?.push(MaterialPageRoute(
//   //           builder: (context) => WebViewWithBottomNav(initialUrl: url),
//   //         ));
//   //       }
//   //     }
//   //   });
//   // } on PlatformException catch (e) {
//   //   print("❌ Failed to get target URL from native: ${e.message}");
//   // }

//   runApp(MyApp());
// }
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
// final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
dynamic forgroundData;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Initialize local notifications
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);
  await FirebaseMessaging.instance.requestPermission();

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  // // Foreground Message Handling
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Foreground message received: ${message.data}');
    _showNotification(message);
  });
  // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
  //   print('Notification clicked!');
  //   _handleMessage(message);
  // });
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) {
      // This runs when the user taps the notification (foreground)
      try {
        print('+++++++++++++++ FOREGROUND NOTIFICATION TAPPED +++++++++++++++');
        print('===========${response.payload.toString()}====================');
        print(response.payload);
        final data = jsonDecode(response.payload ?? '{}');
        print('=========================');
        print(data['target_url']);
        print(
          'after the payload data',
        );
        _handleMessage(RemoteMessage(data: data));
      } catch (e) {
        print(e.toString());
      }
    },
  );
  try {
    await FirebaseMessaging.instance.subscribeToTopic('all');
  } catch (e) {
    print('Error subscribing to topic: $e');
  }

  runApp(MyApp());
}

/// Background message handler
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling background message: ${message.messageId}');
  _showNotification(message);
}

/// Show notification in notification bar
void _showNotification(RemoteMessage message) async {
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;

  if (notification != null && android != null) {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'high_importance_channel', // channel id
      'High Importance Notifications', // channel name
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      platformChannelSpecifics,
      payload: jsonEncode({
        'title': notification.title,
        'body': notification.body,
        // Add any other data you want to pass
        'click_action': 'FLUTTER_NOTIFICATION_CLICK',
        'screen': 'notification_screen',
        'target_url': message.data['target_url']
      }),
    );
  }
}

/// Handle notification when clicked
void _handleMessage(RemoteMessage message) {
  print('Notification clicked!');
  // print('Title: ${message.notification?.title}');
  // print('Body: ${message.notification?.body}');
  print('Data: ${message.data}');

  String? url = message.data['target_url'];
  if (url != null && url.isNotEmpty) {
    print("Opening URL: $url"); // Log the URL to verify it's passed correctly

    // Open the URL in a WebView or the desired screen
    navigatorKey.currentState?.push(
      MaterialPageRoute(
          builder: (context) => WebViewWithBottomNav(initialUrl: url)),
    );
  } else {
    print('No URL found in the notification data');
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();

    _firebaseMessaging.requestPermission();

    _firebaseMessaging.getToken().then((token) {
      print("Firebase Token: $token");
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("onMessage: $message");
      // Handle the message when the app is in the foreground.
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('++++++++++++++++onMessageOpenedApp+++++++++');
      print('----------${message.toString()}---=========');
      _handleMessage(message);
      print(jsonEncode(message.toString()));

      // Handle the message when the app is terminated, and the user taps the notification.
      //Get.to(NotificationScreen());
    });
    // // When app is opened directly after being killed
    killedFunc();
  }

  Future<void> killedFunc() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      await prefs.setString(
          'cold_start_message', initialMessage.data.toString());
      _handleMessage(initialMessage);
    } else {
      await prefs.setString('cold_start_message', 'No initial message');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}

// 🚀 SPLASH SCREEN (3 SECONDS)
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Timer(const Duration(seconds: 3), () {
    //   // if (initialNotificationData != null &&
    //   //     initialNotificationData!['target_url'] != null) {
    //   //   Navigator.pushReplacement(
    //   //     context,
    //   //     MaterialPageRoute(
    //   //       builder: (context) => WebViewWithBottomNav(
    //   //         initialUrl: initialNotificationData!['target_url'],
    //   //       ),
    //   //     ),
    //   //   );
    //   //   initialNotificationData = null; // Clear after use
    //   // } else {
    //   Navigator.pushReplacement(
    //     context,
    //     MaterialPageRoute(
    //       builder: (context) => const WebViewWithBottomNav(),
    //     ),
    //   );
    //   // }
    // });
    checkColdStartLog();
  }

  void checkColdStartLog() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? message = prefs.getString('cold_start_message');
    try {
      if (message != null && message.contains('{') && message.contains('}')) {
        // Convert string to Map using RegExp (since it's not valid JSON)
        final cleanMessage = message.replaceAll(RegExp(r'[{}]'), '');
        final parts = cleanMessage.split(':');
        if (parts.length == 2) {
          final key = parts[0].trim();
          final value = parts[1].trim();
          if (key == 'target_url') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => WebViewWithBottomNav(
                  initialUrl: value,
                ),
              ),
            );
            // ScaffoldMessenger.of(context).showSnackBar(
            //   SnackBar(content: Text('Target URL: $value')),
            // );
            if (kDebugMode) print('Target URL: $value');
          } else {
            Timer(const Duration(seconds: 3), () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const WebViewWithBottomNav(),
                ),
              );
            });
          }
        }
      } else {
        Timer(const Duration(seconds: 3), () {
          Navigator.pushReplacement(
          context,
            MaterialPageRoute(
              builder: (context) => const WebViewWithBottomNav(),
            ),
          );
        });
      }
    } catch (e) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const WebViewWithBottomNav(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('asset/logo.png', width: 150, height: 150),
            const SizedBox(height: 20),
            const Text(
              'न पक्ष.. न विपक्ष.. मात्र निष्पक्ष...',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: Colors.black,
              ),
            )
          ],
        ),
      ),
    );
  }
}

// MAIN APP WITH WEBVIEW & BOTTOM NAVIGATION
class WebViewWithBottomNav extends StatefulWidget {
  const WebViewWithBottomNav({super.key, this.initialUrl});
  final String? initialUrl;
  @override
  // ignore: library_private_types_in_public_api
  _WebViewWithBottomNavState createState() => _WebViewWithBottomNavState();
}

class _WebViewWithBottomNavState extends State<WebViewWithBottomNav> {
  late final WebViewController _controller;
  int _selectedIndex = 0;

  final List<String> _urls = [
    "https://vicharodaya.com/",
    "https://vicharodaya.com/category/latest-update/",
    "https://vicharodaya.com/web-stories/",
    "https://youtube.com/@vicharodaya?si=xan0cXfWowfkVVQ9",
  ];

  String? _initialUrl;
  final MethodChannel _channel = const MethodChannel('onesignal/launch');

  @override
  void initState() {
    super.initState();
    // _controller = WebViewController()
    //   ..setJavaScriptMode(JavaScriptMode.unrestricted)
    //   ..loadRequest(Uri.parse(widget.initialUrl ?? _urls[_selectedIndex]));
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.initialUrl ?? _urls[_selectedIndex]));

    // _initializeNotificationHandling();
  }

  // Inside WebViewWithBottomNav
  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   if (widget.initialUrl != null) {
  //     // It's from notification, no bottom nav selection should happen.
  //     _selectedIndex = -1; // or keep as-is
  //   }
  // }

  void checkColdStartLog() async {
    print('+++++++++++++++++++=checkColdStartLog+++++++++++++++++++++==');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? message = prefs.getString('cold_start_message');
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Cold start log: $message')));
    if (kDebugMode) {
      print('Cold start log: $message');
    }
  }

  void _onItemTapped(int index) {
    // print('++++++++taped+++++++');
    // print(dataNotification.runtimeType);
    // print(dataNotification['a']['target_url'].toString());
    // checkColdStartLog();

    setState(() {
      _selectedIndex = index;
      _controller.loadRequest(Uri.parse(_urls[index]));
    });
  }

  Future<void> _initializeNotificationHandling() async {
    Fluttertoast.showToast(
      msg: "initializing",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black87,
      textColor: Colors.white,
    );
    // 1. Setup handler for when app is in foreground/background
    _channel.setMethodCallHandler((call) async {
      if (call.method == "launchFromNotification") {
        _handleNotificationUrl(call.arguments as String);
      }
    });

    // 2. Check for initial URL when app is launched from terminated state
    try {
      final url = await _channel.invokeMethod('getInitialUrl');
      if (url != null && url is String) {
        Fluttertoast.showToast(
          msg: "${url.toString()}",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.black87,
          textColor: Colors.white,
        );
        if (mounted) {
          setState(() {
            _initialUrl = url;
          });
          _handleNotificationUrl(url);
        }
      }
    } on PlatformException catch (e) {
      debugPrint("Failed to get initial URL: ${e.message}");
    }
  }

  void _handleNotificationUrl(String url) {
    debugPrint("Handling notification URL: $url");
    Fluttertoast.showToast(
      msg: "Notification URL: $url",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black87,
      textColor: Colors.white,
    );
    // Add your navigation logic here
    // For example:
    // Navigator.of(context).push(MaterialPageRoute(
    //   builder: (context) => WebViewScreen(url: url),
    // ));
  }

  @override
  Widget build(BuildContext context) {
    Size selectedIconSize = Size(24, 24);
    Size unSeletecedIconSize = Size(20, 20);
    Color selectedIconColor = Colors.yellow.shade700;
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        showExitConfirmationDialog(context);
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          body: WebViewWidget(controller: _controller),
          bottomNavigationBar: Container(
            decoration: const BoxDecoration(
              color: Colors.white, // Background color
              boxShadow: [
                BoxShadow(
                  color: Colors.black26, // Subtle shadow
                  blurRadius: 6,
                  offset: Offset(0, -3), // Shadow on top
                ),
              ],
            ),
            child: BottomNavigationBar(
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
              backgroundColor: Colors.white, // Navbar background
              selectedItemColor: Colors.yellow.shade700, // Selected item color
              unselectedItemColor: Colors.black, // Unselected item color
              selectedFontSize: 14, // Selected label font size
              unselectedFontSize: 12, // Unselected label font size
              type: BottomNavigationBarType.fixed, // Keeps icons aligned
              elevation: 10, // Adds a smooth effect
              items: [
                BottomNavigationBarItem(
                  icon: _selectedIndex == 0
                      ? Image.asset(
                          'asset/ic_homenew.png',
                          width: selectedIconSize.width,
                          height: selectedIconSize.height,
                          color: selectedIconColor,
                        )
                      : Image.asset('asset/ic_homenew.png',
                          width: unSeletecedIconSize.width,
                          height: unSeletecedIconSize.height),
                  label: "Home",
                ),
                BottomNavigationBarItem(
                  icon: _selectedIndex == 1
                      ? Image.asset(
                          'asset/ic_latest.png',
                          width: selectedIconSize.width,
                          height: selectedIconSize.height,
                          color: selectedIconColor,
                        )
                      : Image.asset('asset/ic_latest.png',
                          width: unSeletecedIconSize.width,
                          height: unSeletecedIconSize.height),
                  label: "Latest",
                ),
                BottomNavigationBarItem(
                  icon: _selectedIndex == 2
                      ? Image.asset(
                          'asset/ic_web_story.png',
                          width: selectedIconSize.width,
                          height: selectedIconSize.height,
                          color: selectedIconColor,
                        )
                      : Image.asset('asset/ic_web_story.png',
                          width: unSeletecedIconSize.width,
                          height: unSeletecedIconSize.height),
                  label: "Web Story",
                ),
                BottomNavigationBarItem(
                  icon: _selectedIndex == 3
                      ? Image.asset(
                          'asset/ic_video.png',
                          width: selectedIconSize.width,
                          height: selectedIconSize.height,
                          color: selectedIconColor,
                        )
                      : Image.asset('asset/ic_video.png',
                          width: unSeletecedIconSize.width,
                          height: unSeletecedIconSize.height),
                  label: "Video",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Future<bool> showExitConfirmationDialog(BuildContext context) async {
//   return await showDialog(
//     context: context,
//     builder: (context) => AlertDialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
//       contentPadding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
//       title: const Row(
//         children: [
//           Icon(Icons.warning_amber_rounded, size: 28, color: Colors.orange),
//           SizedBox(width: 12),
//           Text('Exit Application', style: TextStyle(
//             fontSize: 20,
//             fontWeight: FontWeight.w600,
//             color: Colors.black87,
//           )),
//         ],
//       ),
//       content: const Text(
//         'Any unsaved progress will be lost. Confirm you want to exit?',
//         style: TextStyle(fontSize: 15, color: Colors.black54),
//       ),
//       actions: [
//         TextButton(
//           onPressed: () => Navigator.pop(context, false),
//           style: TextButton.styleFrom(
//             foregroundColor: Colors.blue,
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//           ),
//           child: const Text('CANCEL'),
//         ),
//         const SizedBox(width: 8),
//         FilledButton(
//           onPressed: () => SystemNavigator.pop(),
//           style: FilledButton.styleFrom(
//             backgroundColor: Colors.red.shade700,
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//           ),
//           child: const Text('EXIT'),
//         ),
//       ],
//     ),
//   ) ?? false;
// }

// Future<bool> showExitConfirmationDialog(BuildContext context) async {
//   return await showDialog(
//         context: context,
//         builder: (context) => Dialog(
//           elevation: 0,
//           backgroundColor: Colors.transparent,
//           child: Container(
//             decoration: BoxDecoration(
//               color: Theme.of(context).dialogBackgroundColor,
//               borderRadius: BorderRadius.circular(20),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.2),
//                   blurRadius: 20,
//                   spreadRadius: 2,
//                 ),
//               ],
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(28),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Container(
//                     width: 80,
//                     height: 80,
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         colors: [
//                           Colors.red.shade400,
//                           Colors.red.shade600,
//                         ],
//                         begin: Alignment.topLeft,
//                         end: Alignment.bottomRight,
//                       ),
//                       shape: BoxShape.circle,
//                     ),
//                     child: const Icon(Icons.exit_to_app_rounded,
//                         size: 40, color: Colors.white),
//                   ),
//                   const SizedBox(height: 24),
//                   Text('Exit App?',
//                       style: Theme.of(context)
//                           .textTheme
//                           .headlineSmall
//                           ?.copyWith(fontWeight: FontWeight.w600)),
//                   const SizedBox(height: 12),
//                   Text('All unsaved changes will be lost',
//                       style: Theme.of(context)
//                           .textTheme
//                           .bodyMedium
//                           ?.copyWith(color: Theme.of(context).hintColor)),
//                   const SizedBox(height: 32),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       OutlinedButton(
//                         onPressed: () => Navigator.pop(context, false),
//                         style: OutlinedButton.styleFrom(
//                           foregroundColor: Theme.of(context).primaryColor,
//                           side:
//                               BorderSide(color: Theme.of(context).dividerColor),
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 32, vertical: 16),
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12)),
//                         ),
//                         child: const Text('Cancel'),
//                       ),
//                       const SizedBox(width: 16),
//                       ElevatedButton(
//                         onPressed: () => SystemNavigator.pop(),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.red,
//                           foregroundColor: Colors.white,
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 32, vertical: 16),
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12)),
//                         ),
//                         child: const Text('Exit'),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ) ??
//       false;
// }

Future<bool> showExitConfirmationDialog(BuildContext context) async {
  return await showDialog(
    context: context,
    builder: (context) => BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Dialog(
        backgroundColor: Colors.white.withOpacity(0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: Colors.white.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.4),
                Colors.white.withOpacity(0.1),
              ],
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.power_settings_new, size: 48, color: Colors.white),
              const SizedBox(height: 16),
              const Text(
                'Exit App?',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Are you sure you want to close the application?',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.white.withOpacity(0.2),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(color: Colors.white.withOpacity(0.3)),
                      ),
                    ),
                    child: const Text('CANCEL'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () => SystemNavigator.pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.withOpacity(0.7),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('EXIT'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  ) ?? false;
}
