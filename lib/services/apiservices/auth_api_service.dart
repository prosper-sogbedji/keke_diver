import 'package:dio/dio.dart';
import '../../models/api_response.dart';
import '../../utils/api_constants.dart';
import 'api_client.dart';

class AuthApiService {
  final ApiClient _apiClient;

  AuthApiService(this._apiClient);

  Dio get _dio => _apiClient.dio;

  /// Envoie un code OTP par SMS
  Future<ApiResponse> sendOtp(String phone) async {
    try {
      final response = await _dio.post(
        ApiConstants.sendOtp,
        data: {
          'type': 'phone',
          'phone': phone,
        },
      );
      return ApiResponse.fromJson(response.data);
    } catch (e) {
      return _handleError(e);
    }
  }

  /// Vérifie le code OTP (simple vérification)
  Future<ApiResponse> verifyOtp(String phone, String otp) async {
    try {
      final response = await _dio.post(
        ApiConstants.verifyOtp,
        data: {
          'type': 'phone',
          'phone': phone,
          'otp': otp,
        },
      );
      return ApiResponse.fromJson(response.data);
    } catch (e) {
      return _handleError(e);
    }
  }

  /// Vérifie le code OTP et connecte l'utilisateur (Login)
  Future<ApiResponse> login(String phone, String otp) async {
    try {
      final response = await _dio.post(
        ApiConstants.verifyPhoneLogin,
        data: {
          'phone': phone,
          'otp': otp,
          'is_login': true,
        },
      );
      return ApiResponse.fromJson(response.data);
    } catch (e) {
      return _handleError(e);
    }
  }

  /// Déconnecte l'utilisateur
  Future<ApiResponse> logout() async {
    try {
      final response = await _dio.get(ApiConstants.logout);
      return ApiResponse.fromJson(response.data);
    } catch (e) {
      return _handleError(e);
    }
  }

  /// Envoie le dossier complet du chauffeur en multipart/form-data
  Future<ApiResponse> registerContract({
    required String nom,
    required String prenom,
    required String telephone,
    required String email,
    required String ville,
    required String urgenceNom,
    required String urgencePrenom,
    required String urgenceTel,
    required String garantNom,
    required String garantPrenom,
    required String garantTel,
    required String garant2Nom,
    required String garant2Prenom,
    required String garant2Tel,
    required String vehiculeType,
    required String immatriculation,
    required String docIdentitePath,
    required String docResidencePath,
    required String docCasierPath,
    required String docPhotoPath,
    required String rdvDate,
    required String rdvStartTime,
    required String rdvEndTime,
  }) async {
    try {
      final formData = FormData.fromMap({
        'driver_nom': nom,
        'driver_prenom': prenom,
        'driver_telephone': telephone,
        'driver_mail': email,
        'driver_ville': ville,
        'urgence_nom': urgenceNom,
        'urgence_prenom': urgencePrenom,
        'urgence_telephone': urgenceTel,
        'garant_nom': garantNom,
        'garant_prenom': garantPrenom,
        'garant_telephone': garantTel,
        'garant2_nom': garant2Nom,
        'garant2_prenom': garant2Prenom,
        'garant2_telephone': garant2Tel,
        'vehicule_type': vehiculeType,
        'vehicule_immatriculation': immatriculation,
        'rdv_date': rdvDate,
        'rdv_start_time': rdvStartTime,
        'rdv_end_time': rdvEndTime,
        'doc_identite': await MultipartFile.fromFile(docIdentitePath, filename: 'identite'),
        'doc_residence': await MultipartFile.fromFile(docResidencePath, filename: 'residence'),
        'doc_casier': await MultipartFile.fromFile(docCasierPath, filename: 'casier'),
        'doc_photo': await MultipartFile.fromFile(docPhotoPath, filename: 'photo'),
      });

      final response = await _dio.post(
        ApiConstants.registerContract,
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );
      return ApiResponse.fromJson(response.data);
    } catch (e) {
      return _handleError(e);
    }
  }

  /// Gestion générique des erreurs réseau ou serveur
  ApiResponse _handleError(dynamic error) {
    if (error is DioException) {
      final statusCode = error.response?.statusCode;

      // Erreur 413 : fichier trop volumineux
      if (statusCode == 413) {
        return ApiResponse(
          status: 'error',
          message: 'Vos fichiers sont trop volumineux. Essayez avec des images plus légères.',
        );
      }

      // Erreur 422 : données invalides
      if (statusCode == 422) {
        final responseData = error.response?.data;
        if (responseData is Map<String, dynamic>) {
          String errorMessage = responseData['message'] ?? 'Données invalides.';
          
          // Si le backend renvoie des détails sur les champs invalides
          if (responseData.containsKey('errors') && responseData['errors'] is Map) {
            final errors = responseData['errors'] as Map;
            List<String> errorMessages = [];
            errors.forEach((key, value) {
              if (value is List) {
                errorMessages.add("- $key : ${value.join(', ')}");
              } else {
                errorMessages.add("- $key : $value");
              }
            });
            if (errorMessages.isNotEmpty) {
              errorMessage = "Erreurs de validation :\n${errorMessages.join('\n')}";
            }
          }
          
          return ApiResponse(status: 'error', message: errorMessage);
        }
        return ApiResponse(status: 'error', message: 'Données invalides. Vérifiez vos informations.');
      }

      // Erreur serveur générale
      final responseData = error.response?.data;
      if (responseData is Map<String, dynamic> && responseData.containsKey('message')) {
        return ApiResponse(
          status: 'error',
          message: responseData['message'],
        );
      }
      return ApiResponse(
        status: 'error',
        message: error.message ?? 'Une erreur réseau est survenue.',
      );
    }
    return ApiResponse(
      status: 'error',
      message: 'Une erreur inattendue est survenue.',
    );
  }
}
