import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  
  static const String _tokenKey = 'driverToken';
  static const String _statusKey = 'driverStatus';

  /// Sauvegarde le token JWT de manière sécurisée
  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  /// Récupère le token JWT
  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  /// Supprime le token (pour la déconnexion)
  Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
  }

  /// Sauvegarde le statut du chauffeur (ex: new, pending, active)
  Future<void> saveDriverStatus(String status) async {
    await _storage.write(key: _statusKey, value: status);
  }

  /// Récupère le statut du chauffeur
  Future<String?> getDriverStatus() async {
    return await _storage.read(key: _statusKey);
  }

  /// Supprime le statut du chauffeur
  Future<void> deleteDriverStatus() async {
    await _storage.delete(key: _statusKey);
  }
}
