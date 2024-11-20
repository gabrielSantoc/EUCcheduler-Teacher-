import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:schedule_profs/auth/auth.dart';
import 'package:schedule_profs/box/boxes.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();


  // Load environment variables
  if (Platform.environment.containsKey('GITHUB_ACTIONS')) {
    // CI environment
    dotenv.env['SUPABASE_URL'] = Platform.environment['SUPABASE_URL']!;
    dotenv.env['API_KEY'] = Platform.environment['API_KEY']!;
    
  } else {
    // Local environment
    await dotenv.load(fileName: '.env');
  }
  
  await Supabase.initialize(
    url: "${dotenv.env['SUPABASE_URL']}",
    anonKey: "${dotenv.env['API_KEY']}",
  );
  await Hive.initFlutter();

  // BOXES
  await Hive.initFlutter();
  boxUserCredentials = await Hive.openBox<String>('userIdBox');

  runApp(const MyApp());
}

final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  const MaterialApp(
      debugShowCheckedModeBanner: false,
      home:  AuthScreen()
    );
  }
}