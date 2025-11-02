import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiEndpoints {
  final baseUrl = dotenv.env['BASE_URL'];
}