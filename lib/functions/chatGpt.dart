import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../database/database.dart';

class OpenAI {
  static const String _baseUrl = "https://api.openai.com/v1/completions";
  static final String _apiKey = dotenv.env['CHAT_KEY'];

  static Future<Map<String, dynamic>> getResponse(String prompt, String gptId, String userId) async {
    final gptResponse = await http.post(
      Uri.parse(_baseUrl),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_apiKey',
      },
      body: jsonEncode(<String, dynamic>{
        "model": "text-davinci-003",
        "prompt": prompt,
        "max_tokens": 100
      }),
    );

    if (gptResponse.statusCode == 200) {
      final response = jsonDecode(gptResponse.body);
      String _response = response['choices'][0]['text'].trimLeft();
      await Database(uid: userId).sendChatGpt(
          senderID: gptId,
          chatId: gptId,
          text: _response
      );
      return jsonDecode(gptResponse.body);
    } else {
      await Database(uid: userId).sendChatGpt(
          senderID: gptId,
          chatId: gptId,
          text: "Error with status code: ${gptResponse.statusCode}, reason: ${gptResponse.reasonPhrase}"
      );
      throw Exception('Failed to get response from OpenAI API as $gptResponse');
    }
  }
}
