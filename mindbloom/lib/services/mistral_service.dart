import 'dart:convert';
import 'package:http/http.dart' as http;

class MistralService {
  final String apiKey;

  MistralService({required this.apiKey});

  Future<String> generateAffirmation(String feeling) async {
    final url = Uri.parse("https://api.mistral.ai/v1/chat/completions");

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $apiKey",
      },
      body: jsonEncode({
        "model": "mistral-small-latest",
        "messages": [
          {
            "role": "system",
            "content": "You generate short, warm, supportive affirmations.",
          },
          {
            "role": "user",
            "content":
                "Give me a short affirmation for someone feeling $feeling.",
          },
        ],
        "max_tokens": 50,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception("Mistral API error: ${response.body}");
    }

    final data = jsonDecode(response.body);
    return data["choices"][0]["message"]["content"].trim();
  }
}
