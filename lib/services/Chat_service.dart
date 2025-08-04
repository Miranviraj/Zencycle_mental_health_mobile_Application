import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatService {
  final String apiKey = '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'; // Replace with your key

  Future<String> sendMessage(String message) async {
    final url = Uri.parse("https://api.openai.com/v1/chat/completions");

    final headers = {
      'Authorization': 'Bearer $apiKey',
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      "model": "gpt-3.5-turbo",
      "messages": [
        {"role": "system", "content": "You are a kind and supportive mental wellness assistant."},
        {"role": "user", "content": message},
      ],
    });

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final reply = data['choices'][0]['message']['content'];
      return reply.trim();
    } else {
      print("OpenAI API error: ${response.body}");
      return "Sorry, I couldn’t get a response.";
    }
  }
}
