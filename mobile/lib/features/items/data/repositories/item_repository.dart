import 'package:dio/dio.dart';
import '../../domain/repositories/item_repository.dart';
import '../../../../data/models/item_model.dart';

class ApiItemRepository implements ItemRepository {
  final Dio _dio;

  ApiItemRepository({required Dio dio}) : _dio = dio;

  @override
  Future<List<ItemModel>> getItems({String? search, int page = 1}) async {
    try {
      final queryParams = <String, dynamic>{'page': page};
      if (search != null && search.isNotEmpty) {
        queryParams['search'] = 'name:$search';
      }

      final response = await _dio.get('/api/items', queryParameters: queryParams);
      final data = response.data as Map<String, dynamic>;
      final List items = data['data'] as List;
      return items.map((json) => ItemModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<ItemModel> getItem(int id) async {
    try {
      final response = await _dio.get('/api/items/$id');
      final data = response.data as Map<String, dynamic>;
      return ItemModel.fromJson(data['data']);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<ItemModel> createItem(Map<String, dynamic> data) async {
    try {
      final response = await _dio.post('/api/items', data: data);
      final responseData = response.data as Map<String, dynamic>;
      return ItemModel.fromJson(responseData['data']);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<ItemModel> updateItem(int id, Map<String, dynamic> data) async {
    try {
      final response = await _dio.patch('/api/items/$id', data: data);
      final responseData = response.data as Map<String, dynamic>;
      return ItemModel.fromJson(responseData['data']);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> deleteItem(int id) async {
    try {
      await _dio.delete('/api/items/$id');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<ItemModel> enableItem(int id) async {
    try {
      final response = await _dio.get('/api/items/$id/enable');
      final data = response.data as Map<String, dynamic>;
      return ItemModel.fromJson(data['data']);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<ItemModel> disableItem(int id) async {
    try {
      final response = await _dio.get('/api/items/$id/disable');
      final data = response.data as Map<String, dynamic>;
      return ItemModel.fromJson(data['data']);
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
