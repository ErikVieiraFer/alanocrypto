import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/theme_provider.dart';
import '../services/auth_service.dart';
import '../theme/app_theme.dart';

class AppDrawer extends StatelessWidget {
  final int currentIndex;
  final Function(int) onNavigate;

  const AppDrawer({
    super.key,
    required this.currentIndex,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final user = AuthService().currentUser;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final startColor = isDark ? AppTheme.greenDark : AppTheme.greenPrimary;
    final endColor = isDark ? AppTheme.darkBackground : AppTheme.greenDark;

    return Drawer(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Material(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        color: Theme.of(context).canvasColor,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(20),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [startColor, endColor],
                  tileMode: TileMode.clamp,
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CircleAvatar(
                        radius: 32,
                        backgroundImage: user?.photoURL != null
                            ? NetworkImage(user!.photoURL!)
                            : null,
                        child: user?.photoURL == null
                            ? Text(
                                user?.displayName?.substring(0, 1).toUpperCase() ??
                                    'A',
                                style: const TextStyle(
                                    fontSize: 24, color: Colors.white),
                              )
                            : null,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        user?.displayName ?? 'Usuário',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        user?.email ?? '',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _DrawerItem(
                    icon: Icons.home,
                    title: 'Home',
                    isSelected: currentIndex == 0,
                    onTap: () {
                      Navigator.pop(context);
                      onNavigate(0);
                    },
                  ),
                  _DrawerItem(
                    icon: Icons.person,
                    title: 'Perfil',
                    isSelected: currentIndex == 1,
                    onTap: () {
                      Navigator.pop(context);
                      onNavigate(1);
                    },
                  ),
                  _DrawerItem(
                    icon: Icons.play_circle,
                    title: 'Posts do Alano',
                    isSelected: currentIndex == 2,
                    onTap: () {
                      Navigator.pop(context);
                      onNavigate(2);
                    },
                  ),
                  _DrawerItem(
                    icon: Icons.chat_bubble,
                    title: 'AI Chat',
                    isSelected: currentIndex == 3,
                    onTap: () {
                      Navigator.pop(context);
                      onNavigate(3);
                    },
                  ),
                  _DrawerItem(
                    icon: Icons.show_chart,
                    title: 'Sinais',
                    isSelected: currentIndex == 4,
                    onTap: () {
                      Navigator.pop(context);
                      onNavigate(4);
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.brightness_6),
                    title: const Text('Tema'),
                    trailing: Switch(
                      value: themeProvider.isDarkMode,
                      onChanged: (value) {
                        themeProvider.toggleTheme();
                      },
                      activeColor: AppTheme.greenPrimary,
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.logout, color: Colors.red),
                    title: const Text(
                      'Sair',
                      style: TextStyle(color: Colors.red),
                    ),
                    onTap: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Sair'),
                          content: const Text('Deseja realmente sair?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Cancelar'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text(
                                'Sair',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      );

                      if (confirm == true && context.mounted) {
                        await AuthService().signOut();
                        Navigator.of(context).pushReplacementNamed('/login');
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _DrawerItem({
    required this.icon,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? AppTheme.getPrimaryColor(context) : null,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? AppTheme.getPrimaryColor(context) : null,
          fontWeight: isSelected ? FontWeight.bold : null,
        ),
      ),
      selected: isSelected,
      onTap: onTap,
    );
  }
}

