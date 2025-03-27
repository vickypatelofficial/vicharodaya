import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async'; // For Timer
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  OneSignal.initialize("7737912d-e7a0-4fcf-a063-1c2896d52b13");

  // Handle Notification Click
  OneSignal.Notifications.addClickListener((event) async {
    _handleNotificationClick(event);
  });

  OneSignal.Notifications.requestPermission(true);

  runApp(MyApp());
}

void _handleNotificationClick(OSNotificationClickEvent event) {
  final String? url = event.notification.launchUrl;

  if (url != null && url.isNotEmpty) {
    // Use this to handle the URL when app is in background/closed
    MyApp.navigatorKey.currentState?.openWebView(url);
  }
}

class MyApp extends StatefulWidget {
  static final GlobalKey<_MyAppState> navigatorKey = GlobalKey();

  static void openWebViewUrl(String url) {
    navigatorKey.currentState?.openWebView(url);
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? _launchUrl;

  void openWebView(String url) {
    setState(() {
      _launchUrl = url;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
    "https://www.youtube.com/channel/UCs6Ixn7lpxGOsOxLfbpmnyg",
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
  double screenWidth = MediaQuery.of(context).size.width;
  double screenHeight = MediaQuery.of(context).size.height;
  Widget mediumHeight = SizedBox(
    height: 10,
  );
  return showDialog(
        context: context,
        builder: (context) => Dialog(
          elevation: 10,
          backgroundColor: Colors.white,
          child: Container(
            height: 150.0,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                mediumHeight,
                const Expanded(child: SizedBox(height: 20)),
                Padding(
                  padding: EdgeInsets.only(left: screenWidth * .1),
                  child: const Row(
                    children: [
                      // Image.asset(LocalImages.exit,height: 20,width: 20,),
                      Text('Exit',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                            letterSpacing: 0.0,
                          )),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: screenWidth * .1, right: screenWidth * .1),
                  child: const Column(
                    children: [
                      SizedBox(height: 10),
                      Text('Are you sure you want to exit the application?'),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Text(
                        'NO',
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(color: Colors.green),
                      ),
                    ),
                    const SizedBox(width: 10),
                    TextButton(
                      onPressed: () => SystemNavigator.pop(),
                      child: Text(
                        'EXIT NOW',
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(color: Colors.red),
                      ),
                    ),
                  ],
                ),
                Expanded(child: const SizedBox(height: 20)),
                SizedBox(
                  width: 10,
                ),
              ],
            ),
          ),
        ),
      ) ??
      false;
}
