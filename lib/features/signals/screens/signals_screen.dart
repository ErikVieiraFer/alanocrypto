import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:alanoapp/theme/app_theme.dart';

class SignalsScreen extends StatefulWidget {
  const SignalsScreen({super.key});

  @override
  State<SignalsScreen> createState() => _SignalsScreenState();
}

class _SignalsScreenState extends State<SignalsScreen> {
  String _selectedFilter = 'Todos';

  final List<Map<String, dynamic>> _signals = [
    {
      'id': '1',
      'coin': 'BTC/USDT',
      'type': 'LONG',
      'entry': '49500',
      'targets': ['50000', '50500', '51000'],
      'stopLoss': '48800',
      'status': 'Ativo',
      'profit': '+2.5%',
      'time': DateTime.now().subtract(const Duration(hours: 2)),
      'confidence': 'Alta',
    },
    {
      'id': '2',
      'coin': 'ETH/USDT',
      'type': 'LONG',
      'entry': '2950',
      'targets': ['3000', '3050', '3100'],
      'stopLoss': '2900',
      'status': 'Target 1 atingido',
      'profit': '+1.7%',
      'time': DateTime.now().subtract(const Duration(hours: 5)),
      'confidence': 'Média',
    },
    {
      'id': '3',
      'coin': 'SOL/USDT',
      'type': 'SHORT',
      'entry': '155',
      'targets': ['150', '145', '140'],
      'stopLoss': '160',
      'status': 'Ativo',
      'profit': '0%',
      'time': DateTime.now().subtract(const Duration(hours: 1)),
      'confidence': 'Alta',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredSignals = _selectedFilter == 'Todos'
        ? _signals
        : _signals.where((s) => s['type'] == _selectedFilter).toList();

    final backgroundColor = AppTheme.getBackgroundColor(context);
    final secondaryBackground = AppTheme.getSecondaryBackgroundColor(context);
    final primaryColor = AppTheme.getPrimaryColor(context);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: secondaryBackground,
            child: Row(
              children: [
                _buildFilterChip('Todos'),
                const SizedBox(width: 8),
                _buildFilterChip('LONG'),
                const SizedBox(width: 8),
                _buildFilterChip('SHORT'),
              ],
            ),
          ),

          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshSignals,
              color: primaryColor,
              backgroundColor: secondaryBackground,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: filteredSignals.length,
                itemBuilder: (context, index) {
                  return _buildSignalCard(filteredSignals[index]);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _selectedFilter == label;
    final textColor = AppTheme.getTextColor(context);
    final backgroundColor = AppTheme.getBackgroundColor(context);
    final primaryColor = AppTheme.getPrimaryColor(context);

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor : backgroundColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected 
                ? (Theme.of(context).brightness == Brightness.dark 
                    ? AppTheme.black 
                    : AppTheme.white)
                : textColor,
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildSignalCard(Map<String, dynamic> signal) {
    final isLong = signal['type'] == 'LONG';
    final typeColor = isLong ? Colors.green : Colors.red;
    final textColor = AppTheme.getTextColor(context);
    final secondaryBackground = AppTheme.getSecondaryBackgroundColor(context);
    final backgroundColor = AppTheme.getBackgroundColor(context);
    final textColor60 = AppTheme.getTextColor60(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: secondaryBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color.lerp(typeColor, Colors.transparent, 0.7)!, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color.lerp(typeColor, Colors.transparent, 0.9)!,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: typeColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    signal['type'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    signal['coin'],
                    style: TextStyle(
                      color: textColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                _buildConfidenceBadge(signal['confidence']),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow('Entrada', '${signal['entry']}', Icons.login, textColor60, textColor),
                const SizedBox(height: 12),

                _buildTargetsSection(signal['targets'], backgroundColor, textColor60, textColor),
                const SizedBox(height: 12),

                _buildInfoRow(
                  'Stop Loss',
                  '${signal['stopLoss']}',
                  Icons.stop_circle,
                  textColor60,
                  textColor,
                  color: Colors.red,
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: backgroundColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Status',
                              style: TextStyle(
                                color: textColor60,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              signal['status'],
                              style: TextStyle(
                                color: AppTheme.getPrimaryColor(context),
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: backgroundColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Lucro',
                              style: TextStyle(
                                color: textColor60,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              signal['profit'],
                              style: TextStyle(
                                color: signal['profit'].contains('+')
                                    ? Colors.green
                                    : textColor,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 14,
                      color: textColor60,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _formatTime(signal['time']),
                      style: TextStyle(
                        color: textColor60,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _copySignal(signal),
                    icon: const Icon(Icons.copy),
                    label: const Text('Copiar Sinal'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfidenceBadge(String confidence) {
    Color badgeColor;
    switch (confidence) {
      case 'Alta':
        badgeColor = Colors.green;
        break;
      case 'Média':
        badgeColor = Colors.orange;
        break;
      default:
        badgeColor = Colors.red;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Color.lerp(badgeColor, Colors.transparent, 0.8)!,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: badgeColor, width: 1),
      ),
      child: Text(
        confidence,
        style: TextStyle(
          color: badgeColor,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    String label,
    String value,
    IconData icon,
    Color textColor60,
    Color textColor, {
    Color? color,
  }) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color ?? AppTheme.getPrimaryColor(context)),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            color: textColor60,
            fontSize: 14,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            color: color ?? textColor,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildTargetsSection(
    List<String> targets,
    Color backgroundColor,
    Color textColor60,
    Color textColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.flag, size: 16, color: AppTheme.getPrimaryColor(context)),
            const SizedBox(width: 8),
            Text(
              'Alvos',
              style: TextStyle(
                color: textColor60,
                fontSize: 14,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: targets.asMap().entries.map((entry) {
            final index = entry.key;
            final target = entry.value;
            return Expanded(
              child: Container(
                margin: EdgeInsets.only(
                  right: index < targets.length - 1 ? 8 : 0,
                ),
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Text(
                      'T${index + 1}',
                      style: TextStyle(
                        color: textColor60,
                        fontSize: 10,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      target,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
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

  Future<void> _refreshSignals() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {});
  }

  void _copySignal(Map<String, dynamic> signal) {
    final signalText = '''
🚀 ${signal['coin']} - ${signal['type']}

📍 Entrada: ${signal['entry']}
🎯 Alvos: ${signal['targets'].join(', ')}
🛑 Stop Loss: ${signal['stopLoss']}

Confiança: ${signal['confidence']}
Status: ${signal['status']}
    ''';

    Clipboard.setData(ClipboardData(text: signalText));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Sinal copiado para a área de transferência!'),
        backgroundColor: AppTheme.getPrimaryColor(context),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}