import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../../../models/alano_post_model.dart';
import '../../../services/alano_post_service.dart';

class AlanoPostsScreen extends StatefulWidget {
  const AlanoPostsScreen({super.key});

  @override
  State<AlanoPostsScreen> createState() => _AlanoPostsScreenState();
}

class _AlanoPostsScreenState extends State<AlanoPostsScreen> {
  final AlanoPostService _alanoPostService = AlanoPostService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _openVideo(String? videoUrl) async {
  if (videoUrl == null || videoUrl.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Link do vídeo não disponível'),
        backgroundColor: Colors.orange,
      ),
    );
    return;
  }

  try {
    final Uri url = Uri.parse(videoUrl);
    
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Não foi possível abrir: $videoUrl'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  } catch (e) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao abrir vídeo: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

  String _formatTimestamp(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays < 1) {
      return 'Hoje';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d atrás';
    } else {
      return DateFormat('dd/MM/yyyy').format(dateTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              border: Border(
                bottom: BorderSide(
                  color: isDark ? Colors.grey[800]! : Colors.grey[300]!,
                ),
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Row(
                children: [
                  const Icon(Icons.video_library, size: 28),
                  const SizedBox(width: 12),
                  Text(
                    'Conteúdo Exclusivo',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<AlanoPost>>(
              stream: _alanoPostService.getAlanoPosts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text('Erro ao carregar posts: ${snapshot.error}'),
                  );
                }

                final posts = snapshot.data ?? [];

                if (posts.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.video_library_outlined,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Nenhum conteúdo disponível ainda',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Novos vídeos em breve!',
                          style: TextStyle(
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    setState(() {});
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      return AlanoPostCard(
                        post: posts[index],
                        currentUserId: _auth.currentUser?.uid ?? '',
                        onVideoTap: _openVideo,
                        onViewIncrement: _alanoPostService.incrementViews,
                        formatTimestamp: _formatTimestamp,
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class AlanoPostCard extends StatelessWidget {
  final AlanoPost post;
  final String currentUserId;
  final Function(String?) onVideoTap;
  final Function(String) onViewIncrement;
  final String Function(DateTime) formatTimestamp;

  const AlanoPostCard({
    super.key,
    required this.post,
    required this.currentUserId,
    required this.onVideoTap,
    required this.onViewIncrement,
    required this.formatTimestamp,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isLiked = post.likedBy.contains(currentUserId);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: isDark ? Colors.grey[800]! : Colors.grey[300]!,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'EXCLUSIVO',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      formatTimestamp(post.createdAt),
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  post.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (post.content.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    post.content,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (post.videoUrl != null && post.videoUrl!.isNotEmpty)
            GestureDetector(
              onTap: () {
                onVideoTap(post.videoUrl);
                onViewIncrement(post.id);
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CachedNetworkImage(
                    imageUrl: post.autoThumbnailUrl ?? '',
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      height: 200,
                      color: Colors.grey[300],
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                    errorWidget: (context, url, error) => Container(
                      height: 200,
                      color: Colors.grey[300],
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.play_circle_outline, size: 64),
                          SizedBox(height: 8),
                          Text('Assistir no YouTube'),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.black.withAlpha(153),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 48,
                    ),
                  ),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                InkWell(
                  onTap: () => AlanoPostService().toggleLike(post.id),
                  child: Row(
                    children: [
                      Icon(
                        isLiked ? Icons.favorite : Icons.favorite_border,
                        color: isLiked ? Colors.red : Colors.grey[600],
                        size: 22,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${post.likedBy.length}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 24),
                Row(
                  children: [
                    Icon(Icons.visibility_outlined,
                        color: Colors.grey[600], size: 22),
                    const SizedBox(width: 6),
                    Text(
                      '${post.views}',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}