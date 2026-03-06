import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/app_theme.dart';
import 'features/onboarding/screens/showcase_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const MayaAdminApp());
}

class MayaAdminApp extends StatelessWidget {
  const MayaAdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Maya Admin ERP',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const ShowcaseScreen(),
    );
  }
}
