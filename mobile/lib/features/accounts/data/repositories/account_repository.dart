import 'package:dio/dio.dart';
import '../../domain/repositories/account_repository.dart';
import '../../../../data/models/account_model.dart';

class ApiAccountRepository implements AccountRepository {
  final Dio _dio;

  ApiAccountRepository({required Dio dio}) : _dio = dio;

  @override
  Future<List<AccountModel>> getAccounts({String? search, int page = 1}) async {
    try {
      final queryParams = <String, dynamic>{'page': page};
      if (search != null && search.isNotEmpty) {
        queryParams['search'] = 'name:$search';
      }

      final response = await _dio.get('/api/accounts', queryParameters: queryParams);
      final data = response.data as Map<String, dynamic>;
      final List items = data['data'] as List;
      return items.map((json) => AccountModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<AccountModel> getAccount(int id) async {
    try {
      final response = await _dio.get('/api/accounts/$id');
      final data = response.data as Map<String, dynamic>;
      return AccountModel.fromJson(data['data']);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<AccountModel> createAccount(Map<String, dynamic> data) async {
    try {
      final response = await _dio.post('/api/accounts', data: data);
      final responseData = response.data as Map<String, dynamic>;
      return AccountModel.fromJson(responseData['data']);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<AccountModel> updateAccount(int id, Map<String, dynamic> data) async {
    try {
      final response = await _dio.patch('/api/accounts/$id', data: data);
      final responseData = response.data as Map<String, dynamic>;
      return AccountModel.fromJson(responseData['data']);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> deleteAccount(int id) async {
    try {
      await _dio.delete('/api/accounts/$id');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<AccountModel> enableAccount(int id) async {
    try {
      final response = await _dio.get('/api/accounts/$id/enable');
      final data = response.data as Map<String, dynamic>;
      return AccountModel.fromJson(data['data']);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<AccountModel> disableAccount(int id) async {
    try {
      final response = await _dio.get('/api/accounts/$id/disable');
      final data = response.data as Map<String, dynamic>;
      return AccountModel.fromJson(data['data']);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(DioException e) {
    if (e.response != null) {
      final data = e.response!.data;
      if (data is Map && data['message'] != null) {
        return Exception(data['message']);
      }
      return Exception('Server error: ${e.response!.statusCode}');
    }
    return Exception('Network error. Please check your connection.');
  }
}
