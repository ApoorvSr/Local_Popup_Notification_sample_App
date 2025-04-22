import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(MyApp());
  requestPermissions(); // Request necessary permissions
}

void requestPermissions() async {
  // Request notification permission for Android 13+
  if (await Permission.notification.isDenied) {
    await Permission.notification.request();
  }
}

class MyApp extends StatelessWidget {
  static const platform = MethodChannel('com.example.notification_app/notification_service');

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Notification Service',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: NotificationHomePage(),
    );
  }
}

class NotificationHomePage extends StatelessWidget {
  const NotificationHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Notification Service'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            _startNotificationService();
          },
          child: Text('Start Notification Service'),
        ),
      ),
    );
  }

  Future<void> _startNotificationService() async {
    try {
      // Call Kotlin service method via MethodChannel to start the notification service
      await MyApp.platform.invokeMethod('startService');
      showDialog(
        context: null!,
        builder: (context) => AlertDialog(
          title: Text('Service Started'),
          content: Text('Background notification service has been started.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    } on PlatformException catch (e) {
      // Handle error if service fails to start
      print("Failed to start notification service: ${e.message}");
    }
  }
}
