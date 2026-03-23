import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../data/models/item_model.dart';
import '../../../../core/ui/components/base_button.dart';
import '../../../../core/ui/components/base_alert.dart';
import '../../../../logic/cubits/item_cubit.dart';
import '../../../../core/di/injection_container.dart';

class ItemFormPage extends StatelessWidget {
  final ItemModel? item;

  const ItemFormPage({super.key, this.item});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ItemCubit>(
      create: (context) => sl<ItemCubit>(),
      child: _ItemFormView(item: item),
    );
  }
}

class _ItemFormView extends StatefulWidget {
  final ItemModel? item;

  const _ItemFormView({this.item});

  @override
  State<_ItemFormView> createState() => _ItemFormViewState();
}

class _ItemFormViewState extends State<_ItemFormView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _salePriceController;
  late final TextEditingController _purchasePriceController;
  late String _type;

  bool get isEditing => widget.item != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.item?.name ?? '');
    _descriptionController = TextEditingController(text: widget.item?.description ?? '');
    _type = widget.item?.type ?? 'product';
    _salePriceController = TextEditingController(
      text: widget.item != null ? widget.item!.salePrice.toString() : '',
    );
    _purchasePriceController = TextEditingController(
      text: widget.item != null ? widget.item!.purchasePrice.toString() : '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _salePriceController.dispose();
    _purchasePriceController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final data = {
      'name': _nameController.text.trim(),
      'description': _descriptionController.text.trim(),
      'type': _type,
      'sale_price': double.tryParse(_salePriceController.text) ?? 0.0,
      'purchase_price': double.tryParse(_purchasePriceController.text) ?? 0.0,
      'enabled': 1,
    };

    final cubit = context.read<ItemCubit>();
    if (isEditing) {
      cubit.updateItem(widget.item!.id, data);
    } else {
      cubit.createItem(data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ItemCubit, ItemState>(
      listener: (context, state) {
        if (state is ItemSaved) {
          Navigator.of(context).pop(state.item);
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
              isEditing ? 'Edit Item' : 'Create Item',
              style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (state is ItemError) ...[
                    BaseAlert(
                      type: AlertType.danger,
                      content: Text(state.message),
                      icon: Icons.error_outline,
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Name
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Name *',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Name is required' : null,
                  ),
                  const SizedBox(height: 16),

                  // Type
                  DropdownButtonFormField<String>(
                    value: _type,
                    decoration: const InputDecoration(
                      labelText: 'Type *',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    items: const [
                      DropdownMenuItem(value: 'product', child: Text('Product')),
                      DropdownMenuItem(value: 'service', child: Text('Service')),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _type = value;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 16),

                  // Description
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),

                  // Sale Price
                  TextFormField(
                    controller: _salePriceController,
                    decoration: const InputDecoration(
                      labelText: 'Sale Price',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                      prefixText: '\$ ',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),

                  // Purchase Price
                  TextFormField(
                    controller: _purchasePriceController,
                    decoration: const InputDecoration(
                      labelText: 'Purchase Price',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                      prefixText: '\$ ',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 24),

                  // Submit
                  BaseButton(
                    onPressed: isLoading ? null : _submit,
                    type: ButtonType.primary,
                    block: true,
                    child: isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : Text(isEditing ? 'Update Item' : 'Create Item'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
