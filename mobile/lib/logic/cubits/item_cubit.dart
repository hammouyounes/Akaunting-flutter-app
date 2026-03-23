import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/item_model.dart';
import '../../features/items/domain/repositories/item_repository.dart';

// ─── States ───────────────────────────────────────────────────────────────────

abstract class ItemState {}

class ItemInitial extends ItemState {}

class ItemLoading extends ItemState {}

class ItemsLoaded extends ItemState {
  final List<ItemModel> items;
  ItemsLoaded(this.items);
}

class ItemLoaded extends ItemState {
  final ItemModel item;
  ItemLoaded(this.item);
}

class ItemSaved extends ItemState {
  final ItemModel item;
  ItemSaved(this.item);
}

class ItemDeleted extends ItemState {}

class ItemError extends ItemState {
  final String message;
  ItemError(this.message);
}

// ─── Cubit ────────────────────────────────────────────────────────────────────

class ItemCubit extends Cubit<ItemState> {
  final ItemRepository _itemRepo;

  ItemCubit({required ItemRepository itemRepository})
      : _itemRepo = itemRepository,
        super(ItemInitial());

  Future<void> loadItems({String? search}) async {
    emit(ItemLoading());
    try {
      final items = await _itemRepo.getItems(search: search);
      emit(ItemsLoaded(items));
    } catch (e) {
      emit(ItemError(_parseError(e)));
    }
  }

  Future<void> loadItem(int id) async {
    emit(ItemLoading());
    try {
      final item = await _itemRepo.getItem(id);
      emit(ItemLoaded(item));
    } catch (e) {
      emit(ItemError(_parseError(e)));
    }
  }

  Future<void> createItem(Map<String, dynamic> data) async {
    emit(ItemLoading());
    try {
      final item = await _itemRepo.createItem(data);
      emit(ItemSaved(item));
    } catch (e) {
      emit(ItemError(_parseError(e)));
    }
  }

  Future<void> updateItem(int id, Map<String, dynamic> data) async {
    emit(ItemLoading());
    try {
      final item = await _itemRepo.updateItem(id, data);
      emit(ItemSaved(item));
    } catch (e) {
      emit(ItemError(_parseError(e)));
    }
  }

  Future<void> deleteItem(int id) async {
    emit(ItemLoading());
    try {
      await _itemRepo.deleteItem(id);
      emit(ItemDeleted());
    } catch (e) {
      emit(ItemError(_parseError(e)));
    }
  }

  Future<void> enableItem(int id) async {
    try {
      final item = await _itemRepo.enableItem(id);
      emit(ItemSaved(item));
    } catch (e) {
      emit(ItemError(_parseError(e)));
    }
  }

  Future<void> disableItem(int id) async {
    try {
      final item = await _itemRepo.disableItem(id);
      emit(ItemSaved(item));
    } catch (e) {
      emit(ItemError(_parseError(e)));
    }
  }

  String _parseError(Object e) {
    final msg = e.toString();
    if (msg.startsWith('Exception: ')) return msg.substring(11);
    return 'An unexpected error occurred. Please try again.';
  }
}
