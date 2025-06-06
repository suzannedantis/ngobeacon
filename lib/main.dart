import 'package:flutter/material.dart';
import 'package:ngobeacon/Auth/auth_gate.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  //Supabase setup
  WidgetsFlutterBinding.ensureInitialized();
  // Supabase setup here
  await Supabase.initialize(
    url:
        'https://xwdyhyumbmtxtftynset.supabase.co', // Replace with your Supabase project URL
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inh3ZHloeXVtYm10eHRmdHluc2V0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDM0MTY1OTAsImV4cCI6MjA1ODk5MjU5MH0.vP9DXi8yHtkL-7NzO4mU5iZssQY11lID9afQvGx6gyU', // Replace with your Supabase anon key
  );
  runApp(NGOBeaconApp());
}

class NGOBeaconApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: AuthGate());
  }
}
