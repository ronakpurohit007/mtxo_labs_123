import 'package:flutter/material.dart';
import 'package:mtxo_lab/config/theme/theme_provider.dart';
import 'package:mtxo_lab/core/utils/sizeconfig.dart';
import 'package:mtxo_lab/features/login/screens/login_screen.dart';
import 'package:mtxo_lab/main.dart';
import 'package:provider/provider.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'MTXO Labs',
      theme: themeProvider.themeData,
      home: LoginScreen(), // <- directly set to your login screen
    );
  }
}
