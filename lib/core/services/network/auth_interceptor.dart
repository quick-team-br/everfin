import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/storage/secure_storage_service.dart';

final authInterceptorProvider = Provider<Interceptor>((ref) {
  final storage = ref.read(secureStorageProvider);
  final dio = Dio(); // usaremos para chamar /refresh

  return InterceptorsWrapper(
    onRequest: (options, handler) async {
      final token = await storage.read('access_token');
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
      return handler.next(options);
    },
    onError: (DioException error, handler) async {
      if (error.response?.statusCode == 401) {
        final refreshToken = await storage.read('refresh_token');

        if (refreshToken != null) {
          try {
            final response = await dio.post(
              'https://suaapi.com/api/auth/refresh',
              data: {'refresh_token': refreshToken},
            );

            final newToken = response.data['access_token'];
            final newRefresh = response.data['refresh_token'];

            await storage.write('access_token', newToken);
            await storage.write('refresh_token', newRefresh);

            final newRequest = error.requestOptions;
            newRequest.headers['Authorization'] = 'Bearer $newToken';

            // Reenvia a request original com novo token
            final cloneResponse = await dio.fetch(newRequest);
            return handler.resolve(cloneResponse);
          } catch (_) {
            // Falhou o refresh → logout
            await storage.clear();
            return handler.reject(error);
          }
        }
      }

      return handler.next(error);
    },
  );
});
