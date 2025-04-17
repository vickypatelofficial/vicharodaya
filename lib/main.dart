import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async'; // For Timer
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:webview_flutter/webview_flutter.dart';

Map<String, dynamic>? initialNotificationData;
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());

  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  OneSignal.initialize("7737912d-e7a0-4fcf-a063-1c2896d52b13");
  OneSignal.Notifications.requestPermission(true);

  OneSignal.Notifications.addClickListener((event) async {
    print("🔔 Notification clicked");

    final rawPayload = event.notification.rawPayload;
    final customRawString = rawPayload?['custom'];

    if (customRawString != null) {
      final customMap = jsonDecode(customRawString);
      final targetUrl = customMap['a']['target_url'];

      if (targetUrl != null && targetUrl != "null") {
        // Save the data temporarily
        initialNotificationData = {'target_url': targetUrl};

        // If app is already running, navigate immediately
        if (navigatorKey.currentState != null) {
          navigatorKey.currentState?.push(
            MaterialPageRoute(
              builder: (context) => WebViewWithBottomNav(
                initialUrl: targetUrl,
              ),
            ),
          );
        }
      }
    }
  });
}

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
      // if (initialNotificationData != null &&
      //     initialNotificationData!['target_url'] != null) {
      //   Navigator.pushReplacement(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => WebViewWithBottomNav(
      //         initialUrl: initialNotificationData!['target_url'],
      //       ),
      //     ),
      //   );
      //   initialNotificationData = null; // Clear after use
      // } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const WebViewWithBottomNav(),
          ),
        );
      // }
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

  @override
  void initState() {
    super.initState();
    // _controller = WebViewController()
    //   ..setJavaScriptMode(JavaScriptMode.unrestricted)
    //   ..loadRequest(Uri.parse(widget.initialUrl ?? _urls[_selectedIndex]));
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.initialUrl ?? _urls[_selectedIndex]));
  }



  void _onItemTapped(int index) {
    // print('++++++++taped+++++++');
    // print(dataNotification.runtimeType);
    // print(dataNotification['a']['target_url'].toString());

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
