import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:alanoapp/theme/app_theme.dart';
import 'package:alanoapp/features/home/screens/home_screen.dart';
import 'package:alanoapp/features/profile/screens/profile_screen.dart';
import 'package:alanoapp/features/alano_posts/screens/alano_posts_screen.dart';
import 'package:alanoapp/features/ai_chat/screens/ai_chat_screen.dart';
import 'package:alanoapp/features/signals/screens/signals_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;
  bool _hasNotifications = true;

  final List<Widget> _screens = [
    const HomeScreen(),
    const ProfileScreen(),
    const AlanoPostsScreen(),
    const AIChatScreen(),
    const SignalsScreen(),
  ];

  final List<String> _titles = [
    'Home',
    'Perfil',
    'Posts do Alano',
    'AI Chat',
    'Sinais',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBlueBackground,
      appBar: AppBar(
        backgroundColor: AppTheme.darkBlueSecondary,
        elevation: 0,
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: const Color.fromRGBO(0, 255, 1, 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.currency_bitcoin,
                color: AppTheme.greenPrimary,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'AC',
              style: TextStyle(
                color: AppTheme.greenSecondary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'AlanoCryptoFX',
              style: TextStyle(
                color: AppTheme.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.notifications_outlined,
                  color: AppTheme.white,
                ),
                onPressed: () {
                  _showNotifications(context);
                },
              ),
              if (_hasNotifications)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppTheme.darkBlueSecondary,
                        width: 2,
                      ),
                    ),
                  ),
                ),
            ],
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
          color: AppTheme.darkBlueSecondary,
          boxShadow: [
            BoxShadow(
              color: const Color.fromRGBO(0, 0, 0, 0.3),
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
                  icon: Icons.home_outlined,
                  activeIcon: Icons.home,
                  label: 'Home',
                  index: 0,
                ),
                _buildNavItem(
                  icon: Icons.person_outline,
                  activeIcon: Icons.person,
                  label: 'Perfil',
                  index: 1,
                ),
                _buildNavItem(
                  icon: FontAwesomeIcons.youtube,
                  activeIcon: FontAwesomeIcons.youtube,
                  label: 'Alano',
                  index: 2,
                ),
                _buildNavItem(
                  icon: Icons.chat_bubble_outline,
                  activeIcon: Icons.chat_bubble,
                  label: 'AI Chat',
                  index: 3,
                ),
                _buildNavItem(
                  icon: Icons.trending_up_outlined,
                  activeIcon: Icons.trending_up,
                  label: 'Sinais',
                  index: 4,
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
  }) {
    final isActive = _currentIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isActive
              ? const Color.fromRGBO(0, 255, 1, 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive ? activeIcon : icon,
              color: isActive ? AppTheme.greenPrimary : AppTheme.white,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isActive ? AppTheme.greenPrimary : AppTheme.white,
                fontSize: 10,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showNotifications(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.darkBlueSecondary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Notificações',
                    style: TextStyle(
                      color: AppTheme.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: AppTheme.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildNotificationItem(
                'João comentou no seu post',
                '5 min atrás',
                Icons.comment,
              ),
              _buildNotificationItem(
                'Maria respondeu seu comentário',
                '1 hora atrás',
                Icons.reply,
              ),
              _buildNotificationItem(
                'Novo sinal postado pelo Alano',
                '2 horas atrás',
                Icons.trending_up,
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNotificationItem(String title, String time, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.darkBlueBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color.fromRGBO(0, 255, 1, 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: AppTheme.greenPrimary,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppTheme.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: const TextStyle(
                    color: Color.fromRGBO(255, 255, 255, 0.6),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}