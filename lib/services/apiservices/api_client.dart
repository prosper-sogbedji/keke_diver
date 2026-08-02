import 'package:dio/dio.dart';
import '../../utils/api_constants.dart';
import '../storage_service.dart';

class ApiClient {
  late final Dio _dio;
  final StorageService _storageService;

  ApiClient(this._storageService) {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Récupère le token avant chaque requête
          final token = await _storageService.getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) {
          // Intercepte les erreurs 401 Non Autorisé de manière globale
          if (e.response?.statusCode == 401) {
            // TODO: Déclencher un événement global pour déconnecter l'utilisateur
          }
          return handler.next(e);
        },
      ),
    );
  }

  Dio get dio => _dio;
}
