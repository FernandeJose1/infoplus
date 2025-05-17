import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  static Future<void> load() async {
    await dotenv.load(fileName: '.env');
  }
  
  static String get apiBaseUrl => dotenv.env['API_BASE_URL'] ?? '';
  static String get mpesaUssdCode => dotenv.env['MPESA_USSD_CODE'] ?? '*840*{amount}#';
  static String get emolaUssdCode => dotenv.env['EMOLA_USSD_CODE'] ?? '*860*{amount}#';
}