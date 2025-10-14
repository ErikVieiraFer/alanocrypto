import 'package:flutter/material.dart';
import 'package:alanoapp/theme/app_theme.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AlanoPostsScreen extends StatefulWidget {
  const AlanoPostsScreen({super.key});

  @override
  State<AlanoPostsScreen> createState() => _AlanoPostsScreenState();
}

class _AlanoPostsScreenState extends State<AlanoPostsScreen> {
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
    final backgroundColor = AppTheme.getBackgroundColor(context);
    final secondaryBackground = AppTheme.getSecondaryBackgroundColor(context);
    final primaryColor = AppTheme.getPrimaryColor(context);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: RefreshIndicator(
        onRefresh: _refreshPosts,
        color: primaryColor,
        backgroundColor: secondaryBackground,
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
    final textColor = AppTheme.getTextColor(context);
    final secondaryBackground = AppTheme.getSecondaryBackgroundColor(context);
    final backgroundColor = AppTheme.getBackgroundColor(context);
    final primaryColor = AppTheme.getPrimaryColor(context);
    final textColor60 = AppTheme.getTextColor60(context);
    final primaryColor20 = AppTheme.getPrimaryColor20(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: secondaryBackground,
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
                      color: primaryColor,
                      width: 2,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 16,
                    backgroundColor: primaryColor20,
                    child: Icon(
                      Icons.person,
                      color: primaryColor,
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
                          Text(
                            'Alano',
                            style: TextStyle(
                              color: textColor,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.verified,
                            color: primaryColor,
                            size: 16,
                          ),
                        ],
                      ),
                      Text(
                        _formatDate(post['date']),
                        style: TextStyle(
                          color: textColor60,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post['title'],
                  style: TextStyle(
                    color: textColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  post['content'],
                  style: TextStyle(
                    color: textColor,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),
          Container(
            height: 200,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  Icons.play_circle_outline,
                  color: primaryColor,
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
                      color: AppTheme.black70,
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

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _buildStatChip(
                  Icons.remove_red_eye,
                  '${post['views']}',
                  backgroundColor,
                  textColor,
                ),
                const SizedBox(width: 12),
                _buildStatChip(
                  Icons.favorite,
                  '${post['likes']}',
                  backgroundColor,
                  textColor,
                ),
                const SizedBox(width: 12),
                _buildStatChip(
                  Icons.comment,
                  '${post['comments']}',
                  backgroundColor,
                  textColor,
                ),
                const Spacer(),
                IconButton(
                  icon: Icon(
                    Icons.share,
                    color: textColor,
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

  Widget _buildStatChip(
    IconData icon,
    String value,
    Color backgroundColor,
    Color textColor,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: textColor, size: 14),
          const SizedBox(width: 4),
          Text(
            value,
            style: TextStyle(
              color: textColor,
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
  }
}