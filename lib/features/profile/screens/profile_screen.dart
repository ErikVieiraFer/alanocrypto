import 'package:alanoapp/features/auth/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:alanoapp/theme/app_theme.dart';
import 'package:alanoapp/theme/theme_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final String _userName = 'João Silva';
  final String _userEmail = 'joao.silva@gmail.com';

  int _postsCount = 15;
  int _commentsCount = 42;
  int _likesCount = 128;

  @override
  Widget build(BuildContext context) {
    final textColor = AppTheme.getTextColor(context);
    final backgroundColor = AppTheme.getBackgroundColor(context);
    final secondaryBackground = AppTheme.getSecondaryBackgroundColor(context);
    final primaryColor = AppTheme.getPrimaryColor(context);
    final textColor60 = AppTheme.getTextColor60(context);
    final textColor30 = AppTheme.getTextColor30(context);
    final primaryColor20 = AppTheme.getPrimaryColor20(context);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: secondaryBackground,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: primaryColor,
                    child: Icon(
                      Icons.person,
                      size: 50,
                      color: backgroundColor,
                    ),
                  ),
                  const SizedBox(height: 16),

                  Text(
                    _userName,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  Text(
                    _userEmail,
                    style: TextStyle(
                      color: textColor60,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 24),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatItem('Posts', _postsCount, primaryColor, textColor, textColor60),
                      Container(
                        width: 1,
                        height: 40,
                        color: textColor30,
                      ),
                      _buildStatItem('Comentários', _commentsCount, primaryColor, textColor, textColor60),
                      Container(
                        width: 1,
                        height: 40,
                        color: textColor30,
                      ),
                      _buildStatItem('Curtidas', _likesCount, primaryColor, textColor, textColor60),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            _buildOptionCard(
              icon: Icons.edit,
              title: 'Editar Perfil',
              onTap: _editProfile,
              backgroundColor: secondaryBackground,
              primaryColor: primaryColor,
              primaryColor20: primaryColor20,
              textColor: textColor,
              textColor60: textColor60,
            ),
            _buildOptionCard(
              icon: Icons.palette,
              title: 'Tema',
              onTap: () => _showThemeOptions(context),
              backgroundColor: secondaryBackground,
              primaryColor: primaryColor,
              primaryColor20: primaryColor20,
              textColor: textColor,
              textColor60: textColor60,
            ),
            _buildOptionCard(
              icon: Icons.notifications,
              title: 'Notificações',
              onTap: _openNotifications,
              backgroundColor: secondaryBackground,
              primaryColor: primaryColor,
              primaryColor20: primaryColor20,
              textColor: textColor,
              textColor60: textColor60,
            ),
            _buildOptionCard(
              icon: Icons.security,
              title: 'Privacidade',
              onTap: _openPrivacy,
              backgroundColor: secondaryBackground,
              primaryColor: primaryColor,
              primaryColor20: primaryColor20,
              textColor: textColor,
              textColor60: textColor60,
            ),
            _buildOptionCard(
              icon: Icons.help,
              title: 'Ajuda',
              onTap: _openHelp,
              backgroundColor: secondaryBackground,
              primaryColor: primaryColor,
              primaryColor20: primaryColor20,
              textColor: textColor,
              textColor60: textColor60,
            ),
            _buildOptionCard(
              icon: Icons.info,
              title: 'Sobre',
              onTap: _openAbout,
              backgroundColor: secondaryBackground,
              primaryColor: primaryColor,
              primaryColor20: primaryColor20,
              textColor: textColor,
              textColor60: textColor60,
            ),
            _buildOptionCard(
              icon: Icons.logout,
              title: 'Sair',
              color: Colors.red,
              onTap: _logout,
              backgroundColor: secondaryBackground,
              primaryColor: primaryColor,
              primaryColor20: primaryColor20,
              textColor: textColor,
              textColor60: textColor60,
            ),

            const SizedBox(height: 24),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Meus Posts Recentes',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildRecentPostItem(
                    'BTC rompendo os 50k! 🚀',
                    '2 horas atrás',
                    24,
                    8,
                    secondaryBackground,
                    textColor,
                    textColor60,
                  ),
                  _buildRecentPostItem(
                    'Análise do mercado hoje',
                    '1 dia atrás',
                    15,
                    5,
                    secondaryBackground,
                    textColor,
                    textColor60,
                  ),
                  _buildRecentPostItem(
                    'Dica de segurança para iniciantes',
                    '3 dias atrás',
                    32,
                    12,
                    secondaryBackground,
                    textColor,
                    textColor60,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, int value, Color primaryColor, Color textColor, Color textColor60) {
    return Column(
      children: [
        Text(
          value.toString(),
          style: TextStyle(
            color: primaryColor,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: textColor60,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildOptionCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? color,
    required Color backgroundColor,
    required Color primaryColor,
    required Color primaryColor20,
    required Color textColor,
    required Color textColor60,
  }) {
    final displayColor = color ?? primaryColor;
    final bgColor = color != null ? const Color(0x33F44336) : primaryColor20;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Material(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: displayColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: color ?? textColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: color ?? textColor60,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRecentPostItem(
    String content,
    String time,
    int likes,
    int comments,
    Color backgroundColor,
    Color textColor,
    Color textColor60,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            content,
            style: TextStyle(
              color: textColor,
              fontSize: 14,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(
                Icons.schedule,
                size: 14,
                color: textColor60,
              ),
              const SizedBox(width: 4),
              Text(
                time,
                style: TextStyle(
                  color: textColor60,
                  fontSize: 12,
                ),
              ),
              const Spacer(),
              Icon(
                Icons.favorite,
                size: 14,
                color: textColor60,
              ),
              const SizedBox(width: 4),
              Text(
                '$likes',
                style: TextStyle(
                  color: textColor60,
                  fontSize: 12,
                ),
              ),
              const SizedBox(width: 12),
              Icon(
                Icons.comment,
                size: 14,
                color: textColor60,
              ),
              const SizedBox(width: 4),
              Text(
                '$comments',
                style: TextStyle(
                  color: textColor60,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showThemeOptions(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
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
        return Consumer<ThemeProvider>(
          builder: (context, provider, child) {
            return Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Escolher Tema',
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
                  const SizedBox(height: 24),
                  ListTile(
                    leading: const Icon(Icons.dark_mode, color: AppTheme.greenPrimary),
                    title: Text(
                      'Tema Escuro',
                      style: TextStyle(color: textColor),
                    ),
                    subtitle: Text(
                      'Fundo preto com verde suave',
                      style: TextStyle(color: AppTheme.getTextColor60(context)),
                    ),
                    trailing: provider.isDarkMode
                        ? Icon(Icons.check_circle, color: primaryColor)
                        : const Icon(Icons.circle_outlined),
                    onTap: () {
                      provider.setThemeMode(ThemeMode.dark);
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Tema escuro ativado'),
                          backgroundColor: primaryColor,
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.light_mode, color: AppTheme.greenDark),
                    title: Text(
                      'Tema Claro',
                      style: TextStyle(color: textColor),
                    ),
                    subtitle: Text(
                      'Fundo branco com verde escuro',
                      style: TextStyle(color: AppTheme.getTextColor60(context)),
                    ),
                    trailing: !provider.isDarkMode
                        ? Icon(Icons.check_circle, color: primaryColor)
                        : const Icon(Icons.circle_outlined),
                    onTap: () {
                      provider.setThemeMode(ThemeMode.light);
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Tema claro ativado'),
                          backgroundColor: primaryColor,
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _editProfile() {
    final textColor = AppTheme.getTextColor(context);
    final secondaryBackground = AppTheme.getSecondaryBackgroundColor(context);
    final primaryColor = AppTheme.getPrimaryColor(context);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: secondaryBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Editar Perfil',
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
                const SizedBox(height: 24),
                TextField(
                  style: TextStyle(color: textColor),
                  decoration: InputDecoration(
                    labelText: 'Nome',
                    labelStyle: TextStyle(color: textColor),
                    prefixIcon: Icon(Icons.person, color: textColor),
                    hintText: _userName,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  style: TextStyle(color: textColor),
                  decoration: InputDecoration(
                    labelText: 'Bio',
                    labelStyle: TextStyle(color: textColor),
                    prefixIcon: Icon(Icons.info, color: textColor),
                    hintText: 'Fale sobre você',
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Perfil atualizado!'),
                          backgroundColor: primaryColor,
                        ),
                      );
                    },
                    child: const Text('Salvar Alterações'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _openNotifications() {
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
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Notificações',
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
              const SizedBox(height: 24),
              SwitchListTile(
                title: Text(
                  'Novos posts',
                  style: TextStyle(color: textColor),
                ),
                subtitle: Text(
                  'Notificar quando houver novos posts',
                  style: TextStyle(color: AppTheme.getTextColor60(context)),
                ),
                value: true,
                onChanged: (value) {},
                activeColor: primaryColor,
              ),
              SwitchListTile(
                title: Text(
                  'Comentários',
                  style: TextStyle(color: textColor),
                ),
                subtitle: Text(
                  'Notificar sobre respostas aos seus posts',
                  style: TextStyle(color: AppTheme.getTextColor60(context)),
                ),
                value: true,
                onChanged: (value) {},
                activeColor: primaryColor,
              ),
              SwitchListTile(
                title: Text(
                  'Sinais de trading',
                  style: TextStyle(color: textColor),
                ),
                subtitle: Text(
                  'Notificar quando houver novos sinais',
                  style: TextStyle(color: AppTheme.getTextColor60(context)),
                ),
                value: true,
                onChanged: (value) {},
                activeColor: primaryColor,
              ),
              SwitchListTile(
                title: Text(
                  'Posts do Alano',
                  style: TextStyle(color: textColor),
                ),
                subtitle: Text(
                  'Notificar sobre novos posts do Alano',
                  style: TextStyle(color: AppTheme.getTextColor60(context)),
                ),
                value: true,
                onChanged: (value) {},
                activeColor: primaryColor,
              ),
            ],
          ),
        );
      },
    );
  }

  void _openPrivacy() {
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
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Privacidade',
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
              const SizedBox(height: 24),
              SwitchListTile(
                title: Text(
                  'Perfil público',
                  style: TextStyle(color: textColor),
                ),
                subtitle: Text(
                  'Outros membros podem ver seu perfil',
                  style: TextStyle(color: AppTheme.getTextColor60(context)),
                ),
                value: true,
                onChanged: (value) {},
                activeColor: primaryColor,
              ),
              SwitchListTile(
                title: Text(
                  'Mostrar estatísticas',
                  style: TextStyle(color: textColor),
                ),
                subtitle: Text(
                  'Exibir posts, curtidas e comentários',
                  style: TextStyle(color: AppTheme.getTextColor60(context)),
                ),
                value: true,
                onChanged: (value) {},
                activeColor: primaryColor,
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: Icon(Icons.shield, color: primaryColor),
                title: Text(
                  'Política de Privacidade',
                  style: TextStyle(color: textColor),
                ),
                trailing: Icon(Icons.arrow_forward_ios, color: textColor, size: 16),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.description, color: primaryColor),
                title: Text(
                  'Termos de Uso',
                  style: TextStyle(color: textColor),
                ),
                trailing: Icon(Icons.arrow_forward_ios, color: textColor, size: 16),
                onTap: () {},
              ),
            ],
          ),
        );
      },
    );
  }

  void _openHelp() {
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
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Ajuda',
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
              const SizedBox(height: 24),
              ListTile(
                leading: Icon(Icons.help_outline, color: primaryColor),
                title: Text(
                  'Perguntas Frequentes',
                  style: TextStyle(color: textColor),
                ),
                trailing: Icon(Icons.arrow_forward_ios, color: textColor, size: 16),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.chat, color: primaryColor),
                title: Text(
                  'Suporte ao Cliente',
                  style: TextStyle(color: textColor),
                ),
                trailing: Icon(Icons.arrow_forward_ios, color: textColor, size: 16),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.mail, color: primaryColor),
                title: Text(
                  'Enviar Feedback',
                  style: TextStyle(color: textColor),
                ),
                trailing: Icon(Icons.arrow_forward_ios, color: textColor, size: 16),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.bug_report, color: primaryColor),
                title: Text(
                  'Reportar Problema',
                  style: TextStyle(color: textColor),
                ),
                trailing: Icon(Icons.arrow_forward_ios, color: textColor, size: 16),
                onTap: () {},
              ),
            ],
          ),
        );
      },
    );
  }

  void _openAbout() {
    final textColor = AppTheme.getTextColor(context);
    final secondaryBackground = AppTheme.getSecondaryBackgroundColor(context);
    final primaryColor = AppTheme.getPrimaryColor(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: secondaryBackground,
        title: Text(
          'Sobre o App',
          style: TextStyle(color: textColor),
        ),
        content: Text(
          'AlanoCryptoFX v1.0.0\n\nApp exclusivo para membros do canal.\n\nDesenvolvido com Flutter.',
          style: TextStyle(color: textColor),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Fechar',
              style: TextStyle(color: primaryColor),
            ),
          ),
        ],
      ),
    );
  }

  void _logout() {
    final textColor = AppTheme.getTextColor(context);
    final secondaryBackground = AppTheme.getSecondaryBackgroundColor(context);
    final authService = AuthService();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: secondaryBackground,
        title: Text(
          'Sair',
          style: TextStyle(color: textColor),
        ),
        content: Text(
          'Tem certeza que deseja sair?',
          style: TextStyle(color: textColor),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancelar',
              style: TextStyle(color: textColor),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await authService.signOut();
            },
            child: const Text(
              'Sair',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}