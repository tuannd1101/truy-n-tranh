import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'theme/app_theme.dart';
import 'screens/home_dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Đọc dữ liệu từ file .env
  await dotenv.load(fileName: ".env");

  // Khởi tạo kết nối với Supabase
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  runApp(const MangaFlowApp());
}

class MangaFlowApp extends StatelessWidget {
  const MangaFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MangaFlow - Studio.Ink',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      home: const HomeDashboardScreen(),
    );
  }
}
