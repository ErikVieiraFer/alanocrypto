import 'package:flutter/material.dart';
import 'package:alanoapp/theme/app_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final String _currentUserId = 'user123';
  final List<Map<String, dynamic>> _posts = [
    {
      'id': '1',
      'userId': 'user456',
      'userName': 'Carlos Silva',
      'userPhoto': 'https://i.pravatar.cc/150?img=1',
      'content': 'BTC rompendo os 50k! 🚀 Quem está dentro?',
      'imageUrl': null,
      'timestamp': DateTime.now().subtract(const Duration(minutes: 30)),
      'likes': 24,
      'comments': 8,
      'isLiked': false,
    },
    {
      'id': '2',
      'userId': 'user123',
      'userName': 'João Silva',
      'userPhoto': 'https://i.pravatar.cc/150?img=2',
      'content': 'Análise técnica do ETH mostrando uma possível alta. O que vocês acham?',
      'imageUrl': 'https://picsum.photos/600/400',
      'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
      'likes': 15,
      'comments': 5,
      'isLiked': true,
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
          itemCount: _posts.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return _buildCreatePostCard();
            }
            return _buildPostCard(_posts[index - 1]);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createPost,
        backgroundColor: primaryColor,
        child: Icon(
          Icons.add,
          color: Theme.of(context).brightness == Brightness.dark 
              ? AppTheme.black 
              : AppTheme.white,
        ),
      ),
    );
  }

  Widget _buildCreatePostCard() {
    //final textColor = AppTheme.getTextColor(context);
    final secondaryBackground = AppTheme.getSecondaryBackgroundColor(context);
    final backgroundColor = AppTheme.getBackgroundColor(context);
    final primaryColor = AppTheme.getPrimaryColor(context);
    final textColor60 = AppTheme.getTextColor60(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: secondaryBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: primaryColor,
            child: Icon(
              Icons.person,
              color: Theme.of(context).brightness == Brightness.dark 
                  ? AppTheme.black 
                  : AppTheme.white,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: GestureDetector(
              onTap: _createPost,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Text(
                  'No que você está pensando?',
                  style: TextStyle(
                    color: textColor60,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostCard(Map<String, dynamic> post) {
    final bool isMyPost = post['userId'] == _currentUserId;
    final textColor = AppTheme.getTextColor(context);
    final secondaryBackground = AppTheme.getSecondaryBackgroundColor(context);
    final backgroundColor = AppTheme.getBackgroundColor(context);
    final textColor60 = AppTheme.getTextColor60(context);

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
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(post['userPhoto']),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post['userName'],
                        style: TextStyle(
                          color: textColor,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _formatTime(post['timestamp']),
                        style: TextStyle(
                          color: textColor60,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isMyPost)
                  IconButton(
                    icon: Icon(
                      Icons.more_vert,
                      color: textColor,
                    ),
                    onPressed: () => _showMyPostOptions(post),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              post['content'],
              style: TextStyle(
                color: textColor,
                fontSize: 14,
              ),
            ),
          ),
          if (post['imageUrl'] != null) ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                post['imageUrl'],
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 200,
                    color: backgroundColor,
                    child: Center(
                      child: Icon(
                        Icons.image_not_supported,
                        color: textColor,
                        size: 48,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],

          const SizedBox(height: 16),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                _buildActionButton(
                  icon: post['isLiked'] ? Icons.favorite : Icons.favorite_border,
                  label: '${post['likes']}',
                  color: post['isLiked'] ? Colors.red : textColor,
                  onTap: () => _toggleLike(post),
                ),
                const SizedBox(width: 16),
                _buildActionButton(
                  icon: Icons.comment_outlined,
                  label: '${post['comments']}',
                  color: textColor,
                  onTap: () => _showComments(post),
                ),
                const SizedBox(width: 16),
                _buildActionButton(
                  icon: Icons.share_outlined,
                  label: 'Compartilhar',
                  color: textColor,
                  onTap: () => _sharePost(post),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _refreshPosts() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {});
  }

  void _createPost() {
    final TextEditingController textController = TextEditingController();
    String? selectedImage;

    final textColor = AppTheme.getTextColor(context);
    final secondaryBackground = AppTheme.getSecondaryBackgroundColor(context);
    final primaryColor = AppTheme.getPrimaryColor(context);
    final textColor60 = AppTheme.getTextColor60(context);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: secondaryBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Criar Post',
                          style: TextStyle(
                            color: textColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.close, color: textColor),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: textController,
                      autofocus: true,
                      maxLines: 5,
                      style: TextStyle(color: textColor),
                      decoration: InputDecoration(
                        hintText: 'No que você está pensando?',
                        hintStyle: TextStyle(
                          color: textColor60,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: primaryColor),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (selectedImage != null)
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              selectedImage!,
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: IconButton(
                              onPressed: () {
                                setModalState(() {
                                  selectedImage = null;
                                });
                              },
                              icon: const Icon(Icons.close),
                              style: IconButton.styleFrom(
                                backgroundColor: AppTheme.black70,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),

                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              setModalState(() {
                                selectedImage = 'https://picsum.photos/600/400?random=${DateTime.now().millisecond}';
                              });
                            },
                            icon: const Icon(Icons.image),
                            label: const Text('Anexar Imagem'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: primaryColor,
                              side: BorderSide(color: primaryColor),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              if (textController.text.isNotEmpty) {
                                setState(() {
                                  _posts.insert(0, {
                                    'id': DateTime.now().toString(),
                                    'userId': _currentUserId,
                                    'userName': 'João Silva',
                                    'userPhoto': 'https://i.pravatar.cc/150?img=2',
                                    'content': textController.text,
                                    'imageUrl': selectedImage,
                                    'timestamp': DateTime.now(),
                                    'likes': 0,
                                    'comments': 0,
                                    'isLiked': false,
                                  });
                                });
                                Navigator.pop(context);
                              }
                            },
                            child: const Text('Publicar'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _toggleLike(Map<String, dynamic> post) {
    setState(() {
      post['isLiked'] = !post['isLiked'];
      post['likes'] += post['isLiked'] ? 1 : -1;
    });
  }

  void _showComments(Map<String, dynamic> post) {
  }

  void _sharePost(Map<String, dynamic> post) {
  }

  void _showMyPostOptions(Map<String, dynamic> post) {
    final textColor = AppTheme.getTextColor(context);
    final secondaryBackground = AppTheme.getSecondaryBackgroundColor(context);
    final primaryColor = AppTheme.getPrimaryColor(context);

    showModalBottomSheet(
      context: context,
      backgroundColor: secondaryBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.edit, color: primaryColor),
              title: Text(
                'Editar',
                style: TextStyle(color: textColor),
              ),
              onTap: () {
                Navigator.pop(context);
                _editPost(post);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text(
                'Excluir',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () {
                Navigator.pop(context);
                _deletePost(post);
              },
            ),
          ],
        );
      },
    );
  }

  void _editPost(Map<String, dynamic> post) {
    final TextEditingController textController = TextEditingController(
      text: post['content'],
    );

    final textColor = AppTheme.getTextColor(context);
    final secondaryBackground = AppTheme.getSecondaryBackgroundColor(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: secondaryBackground,
        title: Text(
          'Editar Post',
          style: TextStyle(color: textColor),
        ),
        content: TextField(
          controller: textController,
          maxLines: 5,
          style: TextStyle(color: textColor),
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                post['content'] = textController.text;
              });
              Navigator.pop(context);
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  void _deletePost(Map<String, dynamic> post) {
    final textColor = AppTheme.getTextColor(context);
    final secondaryBackground = AppTheme.getSecondaryBackgroundColor(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: secondaryBackground,
        title: Text(
          'Excluir Post',
          style: TextStyle(color: textColor),
        ),
        content: Text(
          'Tem certeza que deseja excluir este post?',
          style: TextStyle(color: textColor),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _posts.remove(post);
              });
              Navigator.pop(context);
            },
            child: const Text(
              'Excluir',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
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
      return '${difference.inDays}d atrás';
    }
  }
}