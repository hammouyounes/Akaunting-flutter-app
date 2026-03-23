import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/ui/components/akaunting_search.dart';
import '../../../../core/ui/components/badge.dart';
import '../../../../core/ui/components/cards/card.dart';
import '../../../../core/ui/components/base_alert.dart';
import '../../../../logic/cubits/item_cubit.dart';
import 'item_detail_page.dart';
import 'item_form_page.dart';

class ItemsListPage extends StatelessWidget {
  const ItemsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ItemCubit>(
      create: (context) => sl<ItemCubit>()..loadItems(),
      child: const ItemsListView(),
    );
  }
}

class ItemsListView extends StatefulWidget {
  const ItemsListView({super.key});

  @override
  State<ItemsListView> createState() => _ItemsListViewState();
}

class _ItemsListViewState extends State<ItemsListView> {
  String _searchQuery = '';

  Future<void> _onRefresh() async {
    context.read<ItemCubit>().loadItems(search: _searchQuery);
  }

  void _onSearch(String value) {
    setState(() {
      _searchQuery = value;
    });
    context.read<ItemCubit>().loadItems(search: value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        title: const Text('Items', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'items_fab',
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const ItemFormPage(),
            ),
          ).then((_) => _onRefresh());
        },
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: AkauntingSearch(
              placeholder: 'Search items...',
              onSearch: _onSearch,
              onClear: () => _onSearch(''),
            ),
          ),
          Expanded(
            child: BlocBuilder<ItemCubit, ItemState>(
              builder: (context, state) {
                if (state is ItemLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ItemError) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: BaseAlert(
                      type: AlertType.danger,
                      content: Text(state.message),
                      icon: Icons.error_outline,
                    ),
                  );
                } else if (state is ItemsLoaded) {
                  if (state.items.isEmpty) {
                    return const Center(child: Text('No items found.'));
                  }
                  return RefreshIndicator(
                    onRefresh: _onRefresh,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: state.items.length,
                      itemBuilder: (context, index) {
                        final item = state.items[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: AppCard(
                            hover: true,
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => ItemDetailPage(item: item),
                                  ),
                                ).then((_) => _onRefresh());
                              },
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              item.name,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black87,
                                              ),
                                            ),
                                            if (!item.enabled) ...[
                                              const SizedBox(width: 8),
                                              const AppBadge(
                                                type: BadgeType.danger,
                                                child: Text('Disabled'),
                                              ),
                                            ]
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          item.description ?? '',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey.shade600,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    item.salePriceFormatted ??
                                        '\$${item.salePrice.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
