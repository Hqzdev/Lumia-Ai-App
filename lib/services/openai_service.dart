import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import '../models/message.dart';
import '../utils/app_constants.dart';

/// Service for interacting with OpenAI API
class OpenAIService {
  static const String _baseUrl = 'https://api.openai.com/v1';
  static const String _chatEndpoint = '/chat/completions';
  
  String? _apiKey;
  
  /// Sets the API key for authentication
  void setApiKey(String apiKey) {
    _apiKey = apiKey;
  }
  
  /// Gets the current API key
  String? get apiKey => _apiKey;
  
  /// Checks if API key is set
  bool get isApiKeySet => _apiKey != null && _apiKey!.isNotEmpty;
  
  /// Sends a chat completion request to OpenAI
  Future<String> sendChatCompletion({
    required List<Message> messages,
    required String model,
    double temperature = 0.7,
    int maxTokens = 1000,
  }) async {
    if (!isApiKeySet) {
      throw Exception('API key is not set');
    }
    
    final url = Uri.parse('$_baseUrl$_chatEndpoint');
    
    final requestBody = {
      'model': model,
      'messages': messages.map((msg) => {
        'role': msg.role.toString().split('.').last,
        'content': msg.content,
      }).toList(),
      'temperature': temperature,
      'max_tokens': maxTokens,
      'stream': false,
    };
    
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode(requestBody),
      ).timeout(AppConstants.apiTimeout);
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'] as String;
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['error']['message'] ?? 'Unknown error occurred');
      }
    } on TimeoutException {
      throw Exception('Request timed out');
    } on FormatException {
      throw Exception('Invalid response format');
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
  
  /// Sends a streaming chat completion request
  Stream<String> sendStreamingChatCompletion({
    required List<Message> messages,
    required String model,
    double temperature = 0.7,
    int maxTokens = 1000,
  }) async* {
    if (!isApiKeySet) {
      throw Exception('API key is not set');
    }
    
    final url = Uri.parse('$_baseUrl$_chatEndpoint');
    
    final requestBody = {
      'model': model,
      'messages': messages.map((msg) => {
        'role': msg.role.toString().split('.').last,
        'content': msg.content,
      }).toList(),
      'temperature': temperature,
      'max_tokens': maxTokens,
      'stream': true,
    };
    
    try {
      final request = http.Request('POST', url);
      request.headers['Content-Type'] = 'application/json';
      request.headers['Authorization'] = 'Bearer $_apiKey';
      request.body = jsonEncode(requestBody);
      
      final streamedResponse = await request.send().timeout(AppConstants.apiTimeout);
      
      if (streamedResponse.statusCode == 200) {
        await for (final chunk in streamedResponse.stream.transform(utf8.decoder)) {
          final lines = chunk.split('\n');
          
          for (final line in lines) {
            if (line.startsWith('data: ')) {
              final data = line.substring(6);
              
              if (data == '[DONE]') {
                return;
              }
              
              try {
                final jsonData = jsonDecode(data);
                final content = jsonData['choices'][0]['delta']['content'];
                if (content != null) {
                  yield content as String;
                }
              } catch (e) {
                // Skip invalid JSON
                continue;
              }
            }
          }
        }
      } else {
        final response = await http.Response.fromStream(streamedResponse);
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['error']['message'] ?? 'Unknown error occurred');
      }
    } on TimeoutException {
      throw Exception('Request timed out');
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
  
  /// Validates the API key by making a test request
  Future<bool> validateApiKey(String apiKey) async {
    final originalKey = _apiKey;
    _apiKey = apiKey;
    
    try {
      await sendChatCompletion(
        messages: [
          Message(
            id: 'test',
            content: 'Hello',
            role: MessageRole.user,
            timestamp: DateTime.now(),
          ),
        ],
        model: 'gpt-3.5-turbo',
        maxTokens: 10,
      );
      return true;
    } catch (e) {
      _apiKey = originalKey;
      return false;
    }
  }
  
  /// Gets available models (simplified list)
  List<String> getAvailableModels() {
    return [
      'gpt-3.5-turbo',
      'gpt-3.5-turbo-16k',
      'gpt-4',
      'gpt-4-turbo',
      'gpt-4-turbo-preview',
    ];
  }
} 