import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/core/di/injection_container.dart'
    as di;

void main()async {
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false);
  }
}
