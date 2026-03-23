import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../data/models/item_model.dart';
import '../../../../core/ui/components/badge.dart';
import '../../../../core/ui/components/cards/stats_card.dart';
import '../../../../core/ui/components/cards/card.dart';
import '../../../../core/ui/components/base_button.dart';
import '../../../../logic/cubits/item_cubit.dart';
import '../../../../core/di/injection_container.dart';
import 'item_form_page.dart';

class ItemDetailPage extends StatelessWidget {
  final ItemModel item;

  const ItemDetailPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ItemCubit>(
      create: (context) => sl<ItemCubit>(),
      child: _ItemDetailView(initialItem: item),
    );
  }
}

class _ItemDetailView extends StatefulWidget {
  final ItemModel initialItem;

  const _ItemDetailView({required this.initialItem});

  @override
  State<_ItemDetailView> createState() => _ItemDetailViewState();
}

class _ItemDetailViewState extends State<_ItemDetailView> {
  late ItemModel _item;

  @override
  void initState() {
    super.initState();
    _item = widget.initialItem;
  }

  void _onItemDeleted() {
    Navigator.of(context).pop(true);
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Item'),
        content: const Text('Are you sure you want to delete this item?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              context.read<ItemCubit>().deleteItem(_item.id);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ItemCubit, ItemState>(
      listener: (context, state) {
        if (state is ItemDeleted) {
          _onItemDeleted();
        } else if (state is ItemSaved) {
            setState(() {
              _item = state.item;
            });
        } else if (state is ItemError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is ItemLoading;

        return Scaffold(
          backgroundColor: const Color(0xFFF4F6F8),
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: const BackButton(color: Colors.black87),
            title: Text(
              _item.name,
              style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.black87),
                onPressed: () async {
                  final updatedItem = await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ItemFormPage(item: _item),
                    ),
                  );
                  if (updatedItem != null) {
                    setState(() {
                      _item = updatedItem;
                    });
                  }
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: _confirmDelete,
              ),
            ],
          ),
          body: isLoading ? const Center(child: CircularProgressIndicator()) : SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (_item.description != null && _item.description!.isNotEmpty)
                            Text(
                              _item.description!,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              if (_item.type != null)
                                AppBadge(
                                  type: BadgeType.primary,
                                  child: Text(_item.type!.toUpperCase()),
                                ),
                              const SizedBox(width: 8),
                              if (!_item.enabled)
                                const AppBadge(
                                  type: BadgeType.danger,
                                  child: Text('Disabled'),
                                ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                
                // Sale Price Card
                StatsCard(
                  title: 'Sale Price',
                  subTitle: _item.salePriceFormatted ?? 
                            '\$${_item.salePrice.toStringAsFixed(2)}',
                  icon: Icons.sell,
                  type: CardType.primary,
                ),
                const SizedBox(height: 16),
                
                // Details Card
                const Text('Item Details', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                AppCard(
                  child: Column(
                    children: [
                      _DetailRow(label: 'Purchase Price', value: _item.purchasePriceFormatted ?? '\$${_item.purchasePrice.toStringAsFixed(2)}'),
                      if (_item.type != null) ...[
                        const Divider(),
                        _DetailRow(label: 'Type', value: _item.type!),
                      ],
                      if (_item.categoryId != null) ...[
                        const Divider(),
                        _DetailRow(label: 'Category ID', value: _item.categoryId.toString()),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Enable/Disable button
                BaseButton(
                  onPressed: () {
                    if (_item.enabled) {
                      context.read<ItemCubit>().disableItem(_item.id);
                    } else {
                      context.read<ItemCubit>().enableItem(_item.id);
                    }
                  },
                  type: _item.enabled ? ButtonType.warning : ButtonType.success,
                  block: true,
                  child: Text(_item.enabled ? 'Disable Item' : 'Enable Item'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: Colors.black87)),
        ],
      ),
    );
  }
}
