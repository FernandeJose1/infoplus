import 'package:http/http.dart' as http;
import '../config/env.dart';

class ApiService {
  final _client = http.Client();
  
  Future<http.Response> getData(String path) {
    final url = Uri.parse('${Env.apiBaseUrl}/$path');
    return _client.get(url);
  }
}