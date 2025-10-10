import 'package:flutter/material.dart';
import 'package:alanoapp/theme/app_theme.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AlanoPostsScreen extends StatefulWidget {
  const AlanoPostsScreen({super.key});

  @override
  State<AlanoPostsScreen> createState() => _AlanoPostsScreenState();
}

class _AlanoPostsScreenState extends State<AlanoPostsScreen> {
  // Posts mockados do Alano
  final List<Map<String, dynamic>> _alanoPosts = [
    {
      'id': '1',
      'title': 'Análise BTC - Semana 10/10',
      'content': 'BTC mostrando sinais de rompimento na região de 50k. Espero uma movimentação forte nas próximas 48h. Atenção aos níveis de suporte.',
      'date': DateTime.now().subtract(const Duration(hours: 2)),
      'likes': 156,
      'comments': 23,
      'views': 1240,
      'videoUrl': 'https://youtube.com/watch?v=xxxxx',
    },
    {
      'id': '2',
      'title': 'ETH: Hora de Entrar?',
      'content': 'Ethereum apresentando um setup interessante. Análise completa no vídeo.',
      'date': DateTime.now().subtract(const Duration(days: 1)),
      'likes': 142,
      'comments': 18,
      'views': 980,
      'videoUrl': 'https://youtube.com/watch?v=yyyyy',
    },
    {
      'id': '3',
      'title': 'Altcoins em Alta',
      'content': 'Algumas altcoins prometem para este mês. Confira minha lista.',
      'date': DateTime.now().subtract(const Duration(days: 2)),
      'likes': 189,
      'comments': 31,
      'views': 1560,
      'videoUrl': 'https://youtube.com/watch?v=zzzzz',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBlueBackground,
      body: RefreshIndicator(
        onRefresh: _refreshPosts,
        color: AppTheme.greenPrimary,
        backgroundColor: AppTheme.darkBlueSecondary,
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: _alanoPosts.length,
          itemBuilder: (context, index) {
            return _buildPostCard(_alanoPosts[index]);
          },
        ),
      ),
    );
  }

  Widget _buildPostCard(Map<String, dynamic> post) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppTheme.darkBlueSecondary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppTheme.greenPrimary,
                      width: 2,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 16,
                    backgroundColor: AppTheme.greenPrimary.withOpacity(0.2),
                    child: const Icon(
                      Icons.person,
                      color: AppTheme.greenPrimary,
                      size: 16,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'Alano',
                            style: TextStyle(
                              color: AppTheme.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.verified,
                            color: AppTheme.greenPrimary,
                            size: 16,
                          ),
                        ],
                      ),
                      Text(
                        _formatDate(post['date']),
                        style: TextStyle(
                          color: AppTheme.white.withOpacity(0.6),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Conteúdo
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post['title'],
                  style: const TextStyle(
                    color: AppTheme.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  post['content'],
                  style: const TextStyle(
                    color: AppTheme.white,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),
          // Thumbnail do vídeo (simulado)
          Container(
            height: 200,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: AppTheme.darkBlueBackground,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Icon(
                  Icons.play_circle_outline,
                  color: AppTheme.greenPrimary,
                  size: 64,
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Row(
                      children: [
                        FaIcon(
                          FontAwesomeIcons.youtube,
                          color: Colors.red,
                          size: 12,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Vídeo',
                          style: TextStyle(
                            color: AppTheme.white,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Stats e ações
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _buildStatChip(
                  Icons.remove_red_eye,
                  '${post['views']}',
                ),
                const SizedBox(width: 12),
                _buildStatChip(
                  Icons.favorite,
                  '${post['likes']}',
                ),
                const SizedBox(width: 12),
                _buildStatChip(
                  Icons.comment,
                  '${post['comments']}',
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(
                    Icons.share,
                    color: AppTheme.white,
                  ),
                  onPressed: () => _sharePost(post),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildStatChip(IconData icon, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.darkBlueBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.white, size: 14),
          const SizedBox(width: 4),
          Text(
            value,
            style: const TextStyle(
              color: AppTheme.white,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inHours < 24) {
      return '${difference.inHours}h atrás';
    } else {
      return '${difference.inDays}d atrás';
    }
  }

  Future<void> _refreshPosts() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {});
  }

  void _sharePost(Map<String, dynamic> post) {
    // Implementar compartilhamento
  }
}