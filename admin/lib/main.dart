import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'core/app_theme.dart';
import 'features/onboarding/screens/showcase_screen.dart';
import 'core/services/auth_service.dart';
import 'features/admin/screens/admin_shell.dart';
import 'features/library/screens/library_shell.dart';
import 'features/staff/screens/staff_shell.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "assets/.env");

  final String? role = await AuthService.getUserRole();
  Widget initialHome;

  if (role == null) {
    initialHome = const ShowcaseScreen();
  } else {
    switch (role) {
      case 'Admin':
        initialHome = const AdminShell();
        break;
      case 'Staff':
        initialHome = const StaffShell();
        break;
      case 'Library':
        initialHome = const LibraryShell();
        break;
      case 'Office':
        initialHome = const Scaffold(body: Center(child: Text("Office Panel")));
        break;
      default:
        initialHome = const ShowcaseScreen();
    }
  }

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(MayaAdminApp(home: initialHome));
}

class MayaAdminApp extends StatelessWidget {
  final Widget home;
  const MayaAdminApp({super.key, required this.home});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Maya Admin ERP',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: home,
    );
  }
}
