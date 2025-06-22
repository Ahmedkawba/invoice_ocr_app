import 'package:supabase_flutter/supabase_flutter.dart';

class AppSupabaseClient {
  static final SupabaseClient client = Supabase.instance.client;

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: 'https://lraulqkzyfapjdalozqf.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImxyYXVscWt6eWZhcGpkYWxvenFmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDk1MDA2OTgsImV4cCI6MjA2NTA3NjY5OH0.dfemEPSIt9q_vaUyOnljRRLno18ekDA5w1T_-LJW9bw',
    );
  }
}
