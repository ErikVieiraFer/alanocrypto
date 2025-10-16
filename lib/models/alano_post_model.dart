import 'package:cloud_firestore/cloud_firestore.dart';

class AlanoPost {
  final String id;
  final String title;
  final String content;
  final String? videoUrl;
  final String? thumbnailUrl;
  final List<String> likedBy;
  final int views;
  final DateTime createdAt;

  AlanoPost({
    required this.id,
    required this.title,
    required this.content,
    this.videoUrl,
    this.thumbnailUrl,
    required this.likedBy,
    required this.views,
    required this.createdAt,
  });

  factory AlanoPost.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AlanoPost(
      id: doc.id,
      title: data['title'] ?? '',
      content: data['content'] ?? '',
      videoUrl: data['videoUrl'],
      thumbnailUrl: data['thumbnailUrl'],
      likedBy: List<String>.from(data['likedBy'] ?? []),
      views: data['views'] ?? 0,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'content': content,
      'videoUrl': videoUrl,
      'thumbnailUrl': thumbnailUrl,
      'likedBy': likedBy,
      'views': views,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  String? get videoId {
    if (videoUrl == null) return null;
    
    final uri = Uri.tryParse(videoUrl!);
    if (uri == null) return null;

    if (uri.host.contains('youtube.com')) {
      return uri.queryParameters['v'];
    } else if (uri.host.contains('youtu.be')) {
      return uri.pathSegments.isNotEmpty ? uri.pathSegments[0] : null;
    }
    
    return null;
  }

  String? get autoThumbnailUrl {
    final id = videoId;
    if (id != null) {
      return 'https://img.youtube.com/vi/$id/maxresdefault.jpg';
    }
    return thumbnailUrl;
  }
}