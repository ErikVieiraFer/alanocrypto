import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AIService {
  static const String _baseUrl = 'https://api.openai.com/v1/chat/completions';
  final String? _apiKey = dotenv.env['OPENAI_API_KEY'];

  final String _systemPrompt = '''
Você é um assistente especializado em trading e criptomoedas, com foco em análise técnica e fundamentalista.

Diretrizes:
- Seja objetivo e direto nas respostas
- Use linguagem profissional mas acessível
- Explique conceitos complexos de forma simples
- Sempre inclua disclaimer: suas respostas são educacionais e não constituem conselho financeiro
- Foque em análise técnica, padrões gráficos, indicadores e gestão de risco

Sempre termine respostas sobre operações com: "⚠️ Lembre-se: isso não é conselho financeiro. Sempre faça sua própria análise."
''';

  Future<String> sendMessage(String message, List<Map<String, String>> conversationHistory) async {
    if (_apiKey == null || _apiKey!.isEmpty) {
      return '❌ Erro de Configuração\n\nA chave da API não está configurada corretamente. Entre em contato com o suporte.';
    }

    try {
      final messages = [
        {'role': 'system', 'content': _systemPrompt},
        ...conversationHistory,
        {'role': 'user', 'content': message},
      ];

      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': 'gpt-3.5-turbo',
          'messages': messages,
          'temperature': 0.7,
          'max_tokens': 500,
        }),
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw TimeoutException('Tempo limite excedido');
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        final content = data['choices'][0]['message']['content'] as String;
        return content.trim();
      } else if (response.statusCode == 401) {
        return '❌ Serviço indisponível no momento.\n\nPor favor, entre em contato com o suporte.';
      } else if (response.statusCode == 429) {
        return '⏱️ O chat está com alto volume de requisições no momento.\n\nAguarde alguns instantes e tente novamente. Se o erro persistir, entre em contato com o suporte';
      } else if (response.statusCode == 402 || response.statusCode == 403) {
        return '❌ Não foi possível processar sua solicitação no momento.\n\nPor favor, entre em contato com o suporte.';
      } else {
        final error = jsonDecode(response.body);
        final errorMessage = error['error']?['message'] ?? 'Erro desconhecido';
        return '❌ Erro no Servidor\n\n$errorMessage\n\nSe o problema persistir, entre em contato com o suporte.';
      }
    } on SocketException {
      return '📡 Sem Conexão\n\nVerifique sua conexão com a internet e tente novamente.';
    } on TimeoutException {
      return '⏱️ A requisição demorou muito.\n\nPor favor, tente novamente.';
    } on FormatException {
      return '❌ Erro de Formato\n\nResposta inválida do servidor. Entre em contato com o suporte.';
    } catch (e) {
      return '❌ Erro Inesperado\n\nNão foi possível obter uma resposta no momento.\n\nDetalhes: ${e.toString()}\n\nPor favor, entre em contato com o suporte.';
    }
  }

  List<String> getSuggestedQuestions() {
    return [
      'Como identificar tendências de alta?',
      'O que é RSI e como usar?',
      'Explique suporte e resistência',
      'Como fazer gestão de risco?',
      'O que são stop loss e take profit?',
      'Diferença entre LONG e SHORT',
    ];
  }
}

class TimeoutException implements Exception {
  final String message;
  TimeoutException(this.message);
  
  @override
  String toString() => message;
}