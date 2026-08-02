import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/storage_service.dart';
import '../services/apiservices/api_client.dart';
import '../services/apiservices/auth_api_service.dart';

// ---------------------------------------------------------
// 1. Déclaration des Providers de dépendance
// ---------------------------------------------------------

final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageService();
});

final apiClientProvider = Provider<ApiClient>((ref) {
  final storageService = ref.watch(storageServiceProvider);
  return ApiClient(storageService);
});

final authApiServiceProvider = Provider<AuthApiService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return AuthApiService(apiClient);
});


// ---------------------------------------------------------
// 2. État de l'authentification (State)
// ---------------------------------------------------------

class AuthState {
  final bool isLoading;
  final String? error;
  final bool isAuthenticated;
  final String? driverStatus; // ex: 'new', 'pending', 'active'

  AuthState({
    this.isLoading = false,
    this.error,
    this.isAuthenticated = false,
    this.driverStatus,
  });

  AuthState copyWith({
    bool? isLoading,
    String? error,
    bool? isAuthenticated,
    String? driverStatus,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      driverStatus: driverStatus ?? this.driverStatus,
    );
  }
}


// ---------------------------------------------------------
// 3. Notifier (Logique métier)
// ---------------------------------------------------------

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthApiService _authApiService;
  final StorageService _storageService;

  AuthNotifier(this._authApiService, this._storageService) : super(AuthState()) {
    _checkAuthStatus();
  }

  /// Vérifie au démarrage si l'utilisateur a déjà un token valide
  Future<void> _checkAuthStatus() async {
    final token = await _storageService.getToken();
    final status = await _storageService.getDriverStatus();
    if (token != null) {
      state = state.copyWith(
        isAuthenticated: true,
        driverStatus: status,
      );
    }
  }

  /// Appel de l'API pour envoyer l'OTP par SMS
  Future<bool> sendOtp(String phone) async {
    state = state.copyWith(isLoading: true, error: null);
    
    final response = await _authApiService.sendOtp(phone);
    
    if (response.isSuccess) {
      state = state.copyWith(isLoading: false);
      return true;
    } else {
      state = state.copyWith(isLoading: false, error: response.message);
      return false;
    }
  }

  /// Appel de l'API pour vérifier l'OTP et connecter l'utilisateur
  Future<bool> loginWithOtp(String phone, String otp) async {
    state = state.copyWith(isLoading: true, error: null);
    
    final response = await _authApiService.login(phone, otp);
    
    if (response.isSuccess) {
      String? parsedStatus;
      if (response.data != null && response.data is Map) {
        final data = response.data as Map;
        final token = data['token'] ?? data['driverToken'];
        if (token != null) {
          await _storageService.saveToken(token.toString());
        }

        // --- MOCK STATUS --- 
        // TODO: Mettre à jour la clé quand le backend aura ajouté le champ (ex: data['driver_status'])
        parsedStatus = data['driver_status']?.toString() ?? 'new';
        await _storageService.saveDriverStatus(parsedStatus);
        // -------------------
      }
      
      state = state.copyWith(
        isLoading: false, 
        isAuthenticated: true,
        driverStatus: parsedStatus,
      );
      return true;
    } else {
      state = state.copyWith(isLoading: false, error: response.message);
      return false;
    }
  }

  /// Met à jour manuellement le statut du chauffeur (ex: après soumission dossier)
  Future<void> updateDriverStatus(String newStatus) async {
    await _storageService.saveDriverStatus(newStatus);
    state = state.copyWith(driverStatus: newStatus);
  }

  /// Déconnecte l'utilisateur et supprime le token
  Future<void> logout() async {
    state = state.copyWith(isLoading: true);
    
    await _authApiService.logout();
    await _storageService.deleteToken();
    await _storageService.deleteDriverStatus();
    
    state = AuthState(); // Réinitialise tout (isAuthenticated = false, driverStatus = null)
  }
}


// ---------------------------------------------------------
// 4. Déclaration du StateNotifierProvider
// ---------------------------------------------------------

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authApiService = ref.watch(authApiServiceProvider);
  final storageService = ref.watch(storageServiceProvider);
  return AuthNotifier(authApiService, storageService);
});
