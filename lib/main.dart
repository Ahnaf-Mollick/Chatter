import 'package:chatter/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'firebase_options.dart';

late Size mq;
const supabaseUrl = 'https://foftthezgcjbivyiivle.supabase.co';
const supabaseKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZvZnR0aGV6Z2NqYml2eWlpdmxlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzE0MzEyNjAsImV4cCI6MjA0NzAwNzI2MH0.P5OdToccFOfFETjR2MXG59N9wdf8RADnUzGGvSTfHv8';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((value) {
    _initializeFirebase();
    _initializeSupabase();
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chatter',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 1,
          iconTheme: IconThemeData(color: Colors.brown),
          titleTextStyle: TextStyle(
              color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 26),
          backgroundColor: Colors.white70,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

_initializeSupabase() async {
  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseKey);
}

_initializeFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}
