import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:schedule_profs/auth/auth.dart';
import 'package:schedule_profs/box/boxes.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  
  await Supabase.initialize(
    url: "***REMOVED***",
    anonKey: "***REMOVED***",
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