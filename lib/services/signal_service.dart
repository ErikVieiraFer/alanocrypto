import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/signal_model.dart';

class SignalService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Signal>> getSignals({SignalType? filter}) {
    Query query = _firestore
        .collection('signals')
        .orderBy('createdAt', descending: true);

    if (filter != null) {
      query = query.where('type', isEqualTo: filter.name);
    }

    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Signal.fromFirestore(doc)).toList();
    });
  }

  Stream<List<Signal>> getActiveSignals({SignalType? filter}) {
    Query query = _firestore
        .collection('signals')
        .where('status', isEqualTo: 'active')
        .orderBy('createdAt', descending: true);

    if (filter != null) {
      query = query.where('type', isEqualTo: filter.name);
    }

    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Signal.fromFirestore(doc)).toList();
    });
  }

  Stream<List<Signal>> getCompletedSignals({SignalType? filter}) {
    Query query = _firestore
        .collection('signals')
        .where('status', whereIn: ['completed', 'stopped'])
        .orderBy('createdAt', descending: true);

    if (filter != null) {
      query = query.where('type', isEqualTo: filter.name);
    }

    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Signal.fromFirestore(doc)).toList();
    });
  }

  String formatSignalText(Signal signal) {
    final buffer = StringBuffer();
    buffer.writeln('🎯 ${signal.coin}');
    buffer.writeln('📊 Tipo: ${signal.typeLabel}');
    buffer.writeln('💰 Entrada: \$${signal.entry.toStringAsFixed(2)}');
    buffer.writeln('🎯 Alvos:');
    for (int i = 0; i < signal.targets.length; i++) {
      buffer.writeln('   Alvo ${i + 1}: \$${signal.targets[i].toStringAsFixed(2)}');
    }
    buffer.writeln('🛑 Stop Loss: \$${signal.stopLoss.toStringAsFixed(2)}');
    buffer.writeln('⚡ Confiança: ${signal.confidence}%');
    
    return buffer.toString();
  }
}