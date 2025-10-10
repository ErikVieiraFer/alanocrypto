import 'package:flutter/material.dart';
import 'package:alanoapp/theme/app_theme.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Dados mockados do usuário
  final String _userName = 'João Silva';
  final String _userEmail = 'joao.silva@gmail.com';

  // Stats mockados
  int _postsCount = 15;
  int _commentsCount = 42;
  int _likesCount = 128;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBlueBackground,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.darkBlueSecondary,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Column(
                children: [
                  // Foto do perfil
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: AppTheme.greenPrimary,
                    child: const Icon(
                      Icons.person,
                      size: 50,
                      color: AppTheme.darkBlueBackground,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Nome
                  Text(
                    _userName,
                    style: const TextStyle(
                      color: AppTheme.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Email
                  Text(
                    _userEmail,
                    style: TextStyle(
                      color: AppTheme.white.withOpacity(0.7),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Stats
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatItem('Posts', _postsCount),
                      Container(
                        width: 1,
                        height: 40,
                        color: AppTheme.white.withOpacity(0.2),
                      ),
                      _buildStatItem('Comentários', _commentsCount),
                      Container(
                        width: 1,
                        height: 40,
                        color: AppTheme.white.withOpacity(0.2),
                      ),
                      _buildStatItem('Curtidas', _likesCount),
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
            ),
            _buildOptionCard(
              icon: Icons.notifications,
              title: 'Notificações',
              onTap: _openNotifications,
            ),
            _buildOptionCard(
              icon: Icons.security,
              title: 'Privacidade',
              onTap: _openPrivacy,
            ),
            _buildOptionCard(
              icon: Icons.help,
              title: 'Ajuda',
              onTap: _openHelp,
            ),
            _buildOptionCard(
              icon: Icons.info,
              title: 'Sobre',
              onTap: _openAbout,
            ),
            _buildOptionCard(
              icon: Icons.logout,
              title: 'Sair',
              color: Colors.red,
              onTap: _logout,
            ),

            const SizedBox(height: 24),

            // Meus posts recentes
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Meus Posts Recentes',
                    style: TextStyle(
                      color: AppTheme.white,
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
                  ),
                  _buildRecentPostItem(
                    'Análise do mercado hoje',
                    '1 dia atrás',
                    15,
                    5,
                  ),
                  _buildRecentPostItem(
                    'Dica de segurança para iniciantes',
                    '3 dias atrás',
                    32,
                    12,
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

  Widget _buildStatItem(String label, int value) {
    return Column(
      children: [
        Text(
          value.toString(),
          style: const TextStyle(
            color: AppTheme.greenPrimary,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: AppTheme.white.withOpacity(0.7),
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
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Material(
        color: AppTheme.darkBlueSecondary,
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
                    color: (color ?? AppTheme.greenPrimary).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: color ?? AppTheme.greenPrimary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: color ?? AppTheme.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: color ?? AppTheme.white.withOpacity(0.5),
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
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.darkBlueSecondary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            content,
            style: const TextStyle(
              color: AppTheme.white,
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
                color: AppTheme.white.withOpacity(0.6),
              ),
              const SizedBox(width: 4),
              Text(
                time,
                style: TextStyle(
                  color: AppTheme.white.withOpacity(0.6),
                  fontSize: 12,
                ),
              ),
              const Spacer(),
              Icon(
                Icons.favorite,
                size: 14,
                color: AppTheme.white.withOpacity(0.6),
              ),
              const SizedBox(width: 4),
              Text(
                '$likes',
                style: TextStyle(
                  color: AppTheme.white.withOpacity(0.6),
                  fontSize: 12,
                ),
              ),
              const SizedBox(width: 12),
              Icon(
                Icons.comment,
                size: 14,
                color: AppTheme.white.withOpacity(0.6),
              ),
              const SizedBox(width: 4),
              Text(
                '$comments',
                style: TextStyle(
                  color: AppTheme.white.withOpacity(0.6),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _editProfile() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.darkBlueSecondary,
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
                    const Text(
                      'Editar Perfil',
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
                const SizedBox(height: 24),
                TextField(
                  style: const TextStyle(color: AppTheme.white),
                  decoration: InputDecoration(
                    labelText: 'Nome',
                    labelStyle: const TextStyle(color: AppTheme.white),
                    prefixIcon: const Icon(Icons.person, color: AppTheme.white),
                    hintText: _userName,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  style: const TextStyle(color: AppTheme.white),
                  decoration: InputDecoration(
                    labelText: 'Bio',
                    labelStyle: const TextStyle(color: AppTheme.white),
                    prefixIcon: const Icon(Icons.info, color: AppTheme.white),
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
                        const SnackBar(
                          content: Text('Perfil atualizado!'),
                          backgroundColor: AppTheme.greenPrimary,
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
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.darkBlueSecondary,
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
              const SizedBox(height: 24),
              SwitchListTile(
                title: const Text(
                  'Novos posts',
                  style: TextStyle(color: AppTheme.white),
                ),
                subtitle: Text(
                  'Notificar quando houver novos posts',
                  style: TextStyle(color: AppTheme.white.withOpacity(0.6)),
                ),
                value: true,
                onChanged: (value) {},
                activeColor: AppTheme.greenPrimary,
              ),
              SwitchListTile(
                title: const Text(
                  'Comentários',
                  style: TextStyle(color: AppTheme.white),
                ),
                subtitle: Text(
                  'Notificar sobre respostas aos seus posts',
                  style: TextStyle(color: AppTheme.white.withOpacity(0.6)),
                ),
                value: true,
                onChanged: (value) {},
                activeColor: AppTheme.greenPrimary,
              ),
              SwitchListTile(
                title: const Text(
                  'Sinais de trading',
                  style: TextStyle(color: AppTheme.white),
                ),
                subtitle: Text(
                  'Notificar quando houver novos sinais',
                  style: TextStyle(color: AppTheme.white.withOpacity(0.6)),
                ),
                value: true,
                onChanged: (value) {},
                activeColor: AppTheme.greenPrimary,
              ),
              SwitchListTile(
                title: const Text(
                  'Posts do Alano',
                  style: TextStyle(color: AppTheme.white),
                ),
                subtitle: Text(
                  'Notificar sobre novos posts do Alano',
                  style: TextStyle(color: AppTheme.white.withOpacity(0.6)),
                ),
                value: true,
                onChanged: (value) {},
                activeColor: AppTheme.greenPrimary,
              ),
            ],
          ),
        );
      },
    );
  }

  void _openPrivacy() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.darkBlueSecondary,
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
                  const Text(
                    'Privacidade',
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
              const SizedBox(height: 24),
              SwitchListTile(
                title: const Text(
                  'Perfil público',
                  style: TextStyle(color: AppTheme.white),
                ),
                subtitle: Text(
                  'Outros membros podem ver seu perfil',
                  style: TextStyle(color: AppTheme.white.withOpacity(0.6)),
                ),
                value: true,
                onChanged: (value) {},
                activeColor: AppTheme.greenPrimary,
              ),
              SwitchListTile(
                title: const Text(
                  'Mostrar estatísticas',
                  style: TextStyle(color: AppTheme.white),
                ),
                subtitle: Text(
                  'Exibir posts, curtidas e comentários',
                  style: TextStyle(color: AppTheme.white.withOpacity(0.6)),
                ),
                value: true,
                onChanged: (value) {},
                activeColor: AppTheme.greenPrimary,
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.shield, color: AppTheme.greenPrimary),
                title: const Text(
                  'Política de Privacidade',
                  style: TextStyle(color: AppTheme.white),
                ),
                trailing: const Icon(Icons.arrow_forward_ios, color: AppTheme.white, size: 16),
                onTap: () {
                  //política de privacidade
                },
              ),
              ListTile(
                leading: const Icon(Icons.description, color: AppTheme.greenPrimary),
                title: const Text(
                  'Termos de Uso',
                  style: TextStyle(color: AppTheme.white),
                ),
                trailing: const Icon(Icons.arrow_forward_ios, color: AppTheme.white, size: 16),
                onTap: () {
                  //termos de uso
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _openHelp() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.darkBlueSecondary,
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
                  const Text(
                    'Ajuda',
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
              const SizedBox(height: 24),
              ListTile(
                leading: const Icon(Icons.help_outline, color: AppTheme.greenPrimary),
                title: const Text(
                  'Perguntas Frequentes',
                  style: TextStyle(color: AppTheme.white),
                ),
                trailing: const Icon(Icons.arrow_forward_ios, color: AppTheme.white, size: 16),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.chat, color: AppTheme.greenPrimary),
                title: const Text(
                  'Suporte ao Cliente',
                  style: TextStyle(color: AppTheme.white),
                ),
                trailing: const Icon(Icons.arrow_forward_ios, color: AppTheme.white, size: 16),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.mail, color: AppTheme.greenPrimary),
                title: const Text(
                  'Enviar Feedback',
                  style: TextStyle(color: AppTheme.white),
                ),
                trailing: const Icon(Icons.arrow_forward_ios, color: AppTheme.white, size: 16),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.bug_report, color: AppTheme.greenPrimary),
                title: const Text(
                  'Reportar Problema',
                  style: TextStyle(color: AppTheme.white),
                ),
                trailing: const Icon(Icons.arrow_forward_ios, color: AppTheme.white, size: 16),
                onTap: () {},
              ),
            ],
          ),
        );
      },
    );
  }

  void _openAbout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.darkBlueSecondary,
        title: const Text(
          'Sobre o App',
          style: TextStyle(color: AppTheme.white),
        ),
        content: const Text(
          'AlanoCryptoFX v1.0.0\n\nApp exclusivo para membros do canal.\n\nDesenvolvido com Flutter.',
          style: TextStyle(color: AppTheme.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Fechar',
              style: TextStyle(color: AppTheme.greenPrimary),
            ),
          ),
        ],
      ),
    );
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.darkBlueSecondary,
        title: const Text(
          'Sair',
          style: TextStyle(color: AppTheme.white),
        ),
        content: const Text(
          'Tem certeza que deseja sair?',
          style: TextStyle(color: AppTheme.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancelar',
              style: TextStyle(color: AppTheme.white),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => 
                      const Placeholder(),
                ),
                (route) => false,
              );
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