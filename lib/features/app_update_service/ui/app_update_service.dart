
import 'package:supabase_flutter/supabase_flutter.dart';

class AppUpdateService {
  final _client = Supabase.instance.client;

  Future<String?> getMinVersion() async {
    final response = await _client
        .from('app_config')
        .select('value')
        .eq('key', 'min_version')
        .single();
    return response['value'] as String?;
  }
}