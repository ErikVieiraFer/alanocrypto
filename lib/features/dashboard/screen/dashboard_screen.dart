import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:alanoapp/theme/app_theme.dart';
import 'package:alanoapp/features/home/screens/group_chat_screen.dart';
import 'package:alanoapp/features/profile/screens/profile_screen.dart';
import 'package:alanoapp/features/alano_posts/screens/alano_posts_screen.dart';
import 'package:alanoapp/features/ai_chat/screens/ai_chat_screen.dart';
import 'package:alanoapp/features/signals/screens/signals_screen.dart';
import 'package:alanoapp/features/notifications/screens/notifications_screen.dart';
import 'package:alanoapp/services/notification_service.dart';
import '../../../widgets/app_drawer.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _currentIndex = 0;

  final NotificationService _notificationService = NotificationService();
  final String? _userId = FirebaseAuth.instance.currentUser?.uid;

  final List<Widget> _screens = [
    const GroupChatScreen(),
    const ProfileScreen(),
    const AlanoPostsScreen(),
    const AIChatScreen(),
    const SignalsScreen(),
    const NotificationsScreen(), // Tela adicionada
  ];

  void _navigateToNotifications() {
    setState(() {
      _currentIndex = 5; // Índice da tela de notificações
    });
  }

  @override
  Widget build(BuildContext context) {
    final textColor = AppTheme.getTextColor(context);
    final backgroundColor = AppTheme.getBackgroundColor(context);
    final secondaryBackground = AppTheme.getSecondaryBackgroundColor(context);
    final primaryColor = AppTheme.getPrimaryColor(context);
    final primaryColor20 = AppTheme.getPrimaryColor20(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final startColor = isDark ? AppTheme.greenDark : AppTheme.greenPrimary;
    final endColor = isDark ? AppTheme.darkBackground : AppTheme.greenDark;

    return Scaffold(
      key: _scaffoldKey,
      drawer: AppDrawer(
        currentIndex: _currentIndex,
        onNavigate: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      backgroundColor: backgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [startColor, endColor],
              tileMode: TileMode.clamp,
            ),
          ),
        ),
        title: Row(
          children: const [
            Text(
              'AC',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 8),
            Text(
              'AlanoCryptoFX',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          if (_userId != null)
            StreamBuilder<int>(
              stream: _notificationService.getUnreadCount(_userId!),
              builder: (context, snapshot) {
                final unreadCount = snapshot.data ?? 0;
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.notifications_outlined,
                        color: Colors.white,
                      ),
                      onPressed: _navigateToNotifications,
                    ),
                    if (unreadCount > 0)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                            border: Border.all(color: secondaryBackground, width: 2),
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          child: Text(
                            '$unreadCount',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: secondaryBackground,
          boxShadow: [
            BoxShadow(
              color: AppTheme.black30,
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  icon: Icons.chat_outlined,
                  activeIcon: Icons.chat,
                  label: 'Chat',
                  index: 0,
                  textColor: textColor,
                  primaryColor: primaryColor,
                  primaryColor20: primaryColor20,
                ),
                _buildNavItem(
                  icon: Icons.person_outline,
                  activeIcon: Icons.person,
                  label: 'Perfil',
                  index: 1,
                  textColor: textColor,
                  primaryColor: primaryColor,
                  primaryColor20: primaryColor20,
                ),
                _buildNavItem(
                  icon: FontAwesomeIcons.youtube,
                  activeIcon: FontAwesomeIcons.youtube,
                  label: 'Alano',
                  index: 2,
                  textColor: textColor,
                  primaryColor: primaryColor,
                  primaryColor20: primaryColor20,
                ),
                _buildNavItem(
                  icon: Icons.chat_bubble_outline,
                  activeIcon: Icons.chat_bubble,
                  label: 'AI Chat',
                  index: 3,
                  textColor: textColor,
                  primaryColor: primaryColor,
                  primaryColor20: primaryColor20,
                ),
                _buildNavItem(
                  icon: Icons.trending_up_outlined,
                  activeIcon: Icons.trending_up,
                  label: 'Sinais',
                  index: 4,
                  textColor: textColor,
                  primaryColor: primaryColor,
                  primaryColor20: primaryColor20,
                ),
                 if (_userId != null)
                  StreamBuilder<int>(
                    stream: _notificationService.getUnreadCount(_userId!),
                    builder: (context, snapshot) {
                      return _buildNavItem(
                        icon: Icons.notifications_outlined,
                        activeIcon: Icons.notifications,
                        label: 'Alertas',
                        index: 5,
                        textColor: textColor,
                        primaryColor: primaryColor,
                        primaryColor20: primaryColor20,
                        badgeCount: snapshot.data ?? 0,
                      );
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int index,
    required Color textColor,
    required Color primaryColor,
    required Color primaryColor20,
    int badgeCount = 0,
  }) {
    final isActive = _currentIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isActive ? primaryColor20 : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isActive ? activeIcon : icon,
                  color: isActive ? primaryColor : textColor,
                  size: 24,
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: TextStyle(
                    color: isActive ? primaryColor : textColor,
                    fontSize: 10,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
          if (badgeCount > 0)
            Positioned(
              top: -4,
              right: -4,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                  border: Border.all(color: Theme.of(context).canvasColor, width: 1),
                ),
                constraints: const BoxConstraints(
                  minWidth: 16,
                  minHeight: 16,
                ),
                child: Text(
                  '$badgeCount',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }
}