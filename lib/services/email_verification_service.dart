import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';

class EmailVerificationService {
  final FirebaseFunctions _functions = FirebaseFunctions.instance;

  /// Envia código de verificação para o email
  Future<bool> sendVerificationCode(String email, String displayName) async {
    try {
      final callable = _functions.httpsCallable('sendEmailVerification');
      await callable.call({
        'email': email,
        'displayName': displayName,
      });
      debugPrint('Código de verificação enviado para $email');
      return true;
    } catch (e) {
      debugPrint('Erro ao enviar código de verificação: $e');
      return false;
    }
  }

  /// Verifica o código digitado pelo usuário
  Future<bool> verifyCode(String email, String code) async {
    try {
      final callable = _functions.httpsCallable('verifyEmailCode');
      final result = await callable.call({
        'email': email,
        'code': code,
      });
      debugPrint('Código verificado com sucesso');
      return result.data['valid'] == true;
    } catch (e) {
      debugPrint('Erro ao verificar código: $e');
      return false;
    }
  }
}
