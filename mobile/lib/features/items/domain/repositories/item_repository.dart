import '../../../../data/models/item_model.dart';

abstract class ItemRepository {
  Future<List<ItemModel>> getItems({String? search, int page = 1});
  Future<ItemModel> getItem(int id);
  Future<ItemModel> createItem(Map<String, dynamic> data);
  Future<ItemModel> updateItem(int id, Map<String, dynamic> data);
  Future<void> deleteItem(int id);
  Future<ItemModel> enableItem(int id);
  Future<ItemModel> disableItem(int id);
}
