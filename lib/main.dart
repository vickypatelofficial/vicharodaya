import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async'; // For Timer
import 'package:onesignal_flutter/onesignal_flutter.dart';
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

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
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

void main() async {
   runApp(MyApp());
  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  OneSignal.initialize("7737912d-e7a0-4fcf-a063-1c2896d52b13");

  // Ask for permission (iOS only)
  OneSignal.Notifications.requestPermission(true);

  // Handle notification opens
  OneSignal.Notifications.addClickListener((event) {
    print("Notification clicked: ${event.notification.jsonRepresentation()}");

    // Handle deep linking here
    final url = event.notification.launchUrl;
    if (url != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        navigatorKey.currentState?.push(
          MaterialPageRoute(
            builder: (context) => SplashScreen(),
          ),
        );
      });
    } else {
      print('⚠️ No target_url found in notification');
    }
    // Navigate inside your app or show a WebView
    // print("Navigate to: $url");
  });
 
}

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

//     try {
//       print('+++++++url++++++');
//       if (url != null) {
//         print('+++++++enter in try++++++');
//         WidgetsBinding.instance.addPostFrameCallback((_) {
//           navigatorKey.currentState?.push(
//             MaterialPageRoute(builder: (context) => SplashScreen()),
//           );
//         });
//       }
//     } catch (e) {
//       print('=========================');
//       print(e.toString());
//     }
//   });

//   runApp(MyApp());
// }

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

// 🚀 SPLASH SCREEN (3 SECONDS)
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => WebViewWithBottomNav(),
        ),
      );
    });
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
  const WebViewWithBottomNav({super.key});

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

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(_urls[_selectedIndex]));
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _controller.loadRequest(Uri.parse(_urls[index]));
    });
  }

  @override
  Widget build(BuildContext context) {
    Size selectedIconSize = Size(24, 24);
    Size unSeletecedIconSize = Size(20, 20);
    Color selectedIconColor = Colors.yellow.shade700;
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

Future<dynamic> showExitConfirmationDialog(BuildContext context) async {
  return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          titlePadding: const EdgeInsets.all(20),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          title: const Column(
            children: [
              Icon(Icons.exit_to_app, size: 50, color: Colors.redAccent),
              SizedBox(height: 10),
              Text(
                'Exit Application?',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: const Text(
            'Are you sure you want to exit?',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () => Navigator.of(context).pop(false),
              child:
                  const Text('Cancel', style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () => SystemNavigator.pop(),
              child: const Text('Exit', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ) ??
      false;
}
