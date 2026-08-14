import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:deegi_news/features/auth/presentation/auth_gate.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await Hive.openBox<String>('news_cache');
  await dotenv.load(fileName: '.env');

 await Supabase.initialize(
  url: dotenv.env['SUPABASE_URL']!,
  publishableKey: dotenv.env['SUPABASE_PUBLISHABLE_KEY']!,
);

  runApp(
    const ProviderScope(
      child: DeegiNewsApp(),
    ),
  );
}

class DeegiNewsApp extends StatelessWidget {
  const DeegiNewsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DeegiNews',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF8F6678),
        ),
        useMaterial3: true,
      ),
      home: const AuthGate(),
    );
  }
}