import 'dart:convert';
import 'dart:io'; // Adicionado para SocketException
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
- Se perguntarem sobre preços específicos ou previsões exatas, explique que não pode prever o mercado
- Ajude com estratégias, análises e educação sobre trading

Tópicos que você domina:
- Análise técnica e gráfica
- Indicadores (RSI, MACD, Bandas de Bollinger, etc)
- Padrões de candles
- Suporte e resistência
- Gestão de risco e money management
- Psicologia do trading
- Fundamentos de blockchain e criptomoedas

Sempre termine respostas sobre operações com: "⚠️ Lembre-se: isso não é conselho financeiro. Sempre faça sua própria análise."
''';

  Future<String> sendMessage(String message, List<Map<String, String>> conversationHistory) async {
    print('AIService: Iniciando sendMessage');
    if (_apiKey == null || _apiKey!.isEmpty) {
      print('AIService: Erro - OPENAI_API_KEY não encontrada no .env');
      return 'Erro: API Key não configurada. Por favor, configure a chave no arquivo .env';
    }

    print('AIService: Enviando requisição para a OpenAI...');
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
      ).timeout(const Duration(seconds: 30)); // Timeout reduzido para 30s

      print('AIService: Resposta recebida. Status code: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        final content = data['choices'][0]['message']['content'] as String;
        print('AIService: Resposta processada com sucesso.');
        return content.trim();
      } else {
        final error = jsonDecode(response.body);
        print('AIService: Erro da API OpenAI: ${error.toString()}');
        
        if (response.statusCode == 401) {
          return 'Erro: API Key inválida. Verifique sua chave no arquivo .env';
        } else if (response.statusCode == 429) {
          return 'Erro: Limite de requisições excedido. Aguarde alguns minutos.';
        } else {
          return 'Erro ao processar sua mensagem (Código: ${response.statusCode}). Tente novamente.';
        }
      }
    } on SocketException catch (e) {
      print('AIService: Exceção de Socket capturada - ${e.toString()}');
      return 'Erro de conexão: Não foi possível conectar ao servidor. Verifique sua internet.';
    } catch (e) {
      print('AIService: Exceção genérica capturada - ${e.toString()}');
      return 'Ocorreu um erro inesperado. Tente novamente.';
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