import 'dart:convert';
import 'package:http/http.dart' as http;

class OpenAI {
  static const String _baseUrl = "https://api.openai.com/v1/completions";
  static const String _apiKey = "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";

  static Future<Map<String, dynamic>> getResponse(String prompt) async {
    final response = await http.post(
      Uri.parse('$_baseUrl'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_apiKey',
      },
      body: jsonEncode(<String, dynamic>{
        "model": "text-davinci-003",
        "prompt": prompt,
        "max_tokens": 20
      }),
    );

    if (response.statusCode == 200) {
      print("response: ${response.body}");
      return jsonDecode(response.body);
    } else {
      print("status code: ${response.statusCode}");
      print("reasonPhrase: ${response.reasonPhrase}");
      throw Exception('Failed to get response from OpenAI API');
    }
  }
}
