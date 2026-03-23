import 'package:dio/dio.dart';
import '../../../../data/models/contact_model.dart';
import '../../domain/repositories/contact_repository.dart';

class ApiContactRepository implements ContactRepository {
  final Dio _dio;

  ApiContactRepository({required Dio dio}) : _dio = dio;

  @override
  Future<List<ContactModel>> getContacts({String? search, int page = 1}) async {
    try {
      final queryParams = <String, dynamic>{'page': page};
      if (search != null && search.isNotEmpty) {
        queryParams['search'] = search.contains('type:') ? search : 'type:customer $search';
      } else {
        queryParams['search'] = 'type:customer';
      }

      final response = await _dio.get('/api/contacts', queryParameters: queryParams);
      final data = response.data as Map<String, dynamic>;
      final List items = data['data'] as List;
      return items.map((json) => ContactModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<ContactModel> getContact(int id) async {
    try {
      final response = await _dio.get('/api/contacts/$id');
      final data = response.data as Map<String, dynamic>;
      return ContactModel.fromJson(data['data']);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<ContactModel> createContact(Map<String, dynamic> data) async {
    try {
      final response = await _dio.post('/api/contacts', data: data);
      final responseData = response.data as Map<String, dynamic>;
      return ContactModel.fromJson(responseData['data']);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<ContactModel> updateContact(int id, Map<String, dynamic> data) async {
    try {
      final response = await _dio.patch('/api/contacts/$id', data: data);
      final responseData = response.data as Map<String, dynamic>;
      return ContactModel.fromJson(responseData['data']);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> deleteContact(int id) async {
    try {
      await _dio.delete('/api/contacts/$id');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<ContactModel> enableContact(int id) async {
    try {
      final response = await _dio.get('/api/contacts/$id/enable');
      final data = response.data as Map<String, dynamic>;
      return ContactModel.fromJson(data['data']);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<ContactModel> disableContact(int id) async {
    try {
      final response = await _dio.get('/api/contacts/$id/disable');
      final data = response.data as Map<String, dynamic>;
      return ContactModel.fromJson(data['data']);
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
