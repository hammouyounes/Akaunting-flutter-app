import 'package:dio/dio.dart';
import '../../domain/repositories/profile_repository.dart';
import '../models/user_profile_model.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final Dio _dio;

  ProfileRepositoryImpl({required Dio dio}) : _dio = dio;

  @override
  Future<UserProfileModel> getProfile() async {
    try {
      final response = await _dio.get('/api/profile');
      final data = response.data as Map<String, dynamic>;
      return UserProfileModel.fromJson(data['data']);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return Exception('Connection timeout. Please try again.');
    }

    if (e.type == DioExceptionType.connectionError) {
      return Exception('Network error. Please check your connection.');
    }

    if (e.response != null) {
      final statusCode = e.response!.statusCode;
      final data = e.response!.data;

      if (statusCode == 401) {
        return Exception('Unauthorized. Please login again.');
      }

      if (statusCode == 403) {
        return Exception('Access forbidden.');
      }

      if (data is Map && data['message'] != null) {
        return Exception(data['message']);
      }

      return Exception('Server error: $statusCode');
    }

    return Exception('An unexpected error occurred.');
  }
}
