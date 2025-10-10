import 'package:flutter/material.dart';
import 'package:alanoapp/theme/app_theme.dart';

class AIChatScreen extends StatefulWidget {
  const AIChatScreen({super.key});

  @override
  State<AIChatScreen> createState() => _AIChatScreenState();
}

class _AIChatScreenState extends State<AIChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, dynamic>> _messages = [
    {
      'text': 'Olá! Sou o assistente de trading do AlanoCryptoFX. Como posso te ajudar hoje?',
      'isUser': false,
      'timestamp': DateTime.now().subtract(const Duration(minutes: 5)),
    },
  ];

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    final userMessage = _messageController.text.trim();
    
    setState(() {
      _messages.add({
        'text': userMessage,
        'isUser': true,
        'timestamp': DateTime.now(),
      });
    });

    _messageController.clear();
    _scrollToBottom();
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _messages.add({
          'text': _getAIResponse(userMessage),
          'isUser': false,
          'timestamp': DateTime.now(),
        });
      });
      _scrollToBottom();
    });
  }

  String _getAIResponse(String message) {
    if (message.toLowerCase().contains('btc') || 
        message.toLowerCase().contains('bitcoin')) {
      return 'O Bitcoin está mostrando sinais interessantes. Recomendo acompanhar os níveis de suporte em \$49k e resistência em \$52k. Sempre use stop loss!';
    } else if (message.toLowerCase().contains('eth') || 
              message.toLowerCase().contains('ethereum')) {
      return 'Ethereum está com boa perspectiva. O nível de \$3000 é crítico. Assista aos vídeos do Alano para análises mais detalhadas.';
    } else {
      return 'Entendi sua pergunta. Para análises específicas, recomendo conferir os posts e vídeos do Alano. Ele sempre traz insights valiosos!';
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBlueBackground,
      body: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.darkBlueSecondary,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.greenPrimary.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.smart_toy,
                    color: AppTheme.greenPrimary,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Assistente de Trading',
                        style: TextStyle(
                          color: AppTheme.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppTheme.greenPrimary,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Online',
                            style: TextStyle(
                              color: AppTheme.white.withOpacity(0.7),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.info_outline,
                    color: AppTheme.white,
                  ),
                  onPressed: _showInfo,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _buildMessageBubble(_messages[index]);
              },
            ),
          ),
          if (_messages.length == 1)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              height: 50,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildQuickSuggestion('Como está o BTC?'),
                  _buildQuickSuggestion('Análise do ETH'),
                  _buildQuickSuggestion('Dicas para iniciantes'),
                ],
              ),
            ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.darkBlueSecondary,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      style: const TextStyle(color: AppTheme.white),
                      decoration: InputDecoration(
                        hintText: 'Digite sua mensagem...',
                        hintStyle: TextStyle(
                          color: AppTheme.white.withOpacity(0.5),
                        ),
                        filled: true,
                        fillColor: AppTheme.darkBlueBackground,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    decoration: const BoxDecoration(
                      color: AppTheme.greenPrimary,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.send,
                        color: AppTheme.darkBlueBackground,
                      ),
                      onPressed: _sendMessage,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> message) {
    final isUser = message['isUser'] as bool;
    
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: isUser
              ? AppTheme.greenPrimary
              : AppTheme.darkBlueSecondary,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message['text'],
              style: TextStyle(
                color: isUser
                    ? AppTheme.darkBlueBackground
                    : AppTheme.white,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _formatTime(message['timestamp']),
              style: TextStyle(
                color: isUser
                    ? AppTheme.darkBlueBackground.withOpacity(0.7)
                    : AppTheme.white.withOpacity(0.5),
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickSuggestion(String text) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: ActionChip(
        label: Text(text),
        labelStyle: const TextStyle(
          color: AppTheme.white,
          fontSize: 12,
        ),
        backgroundColor: AppTheme.darkBlueSecondary,
        side: BorderSide(
          color: AppTheme.greenPrimary.withOpacity(0.3),
        ),
        onPressed: () {
          _messageController.text = text;
          _sendMessage();
        },
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Agora';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m atrás';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h atrás';
    } else {
      return '${dateTime.day}/${dateTime.month} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
    }
  }

  void _showInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.darkBlueSecondary,
        title: const Text(
          'Sobre o Assistente',
          style: TextStyle(color: AppTheme.white),
        ),
        content: const Text(
          'Este assistente foi treinado para ajudar com dúvidas sobre trading e análises do mercado de criptomoedas.\n\nLembre-se: as informações fornecidas não são conselhos financeiros.',
          style: TextStyle(color: AppTheme.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Entendi',
              style: TextStyle(color: AppTheme.greenPrimary),
            ),
          ),
        ],
      ),
    );
  }
}