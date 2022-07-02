import 'package:flutter/material.dart';
import 'package:sms/Publicidad/google_ads.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Material App',
      home: GoogleAds(),
    );
  }
}
