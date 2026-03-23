class ItemModel {
  final int id;
  final int companyId;
  final String? type;
  final String name;
  final String? description;
  final double salePrice;
  final String? salePriceFormatted;
  final double purchasePrice;
  final String? purchasePriceFormatted;
  final int? categoryId;
  final bool enabled;
  final String? createdFrom;
  final int? createdBy;
  final String? createdAt;
  final String? updatedAt;

  const ItemModel({
    required this.id,
    required this.companyId,
    this.type,
    required this.name,
    this.description,
    this.salePrice = 0.0,
    this.salePriceFormatted,
    this.purchasePrice = 0.0,
    this.purchasePriceFormatted,
    this.categoryId,
    this.enabled = true,
    this.createdFrom,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
  });

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      id: json['id'] as int,
      companyId: json['company_id'] as int,
      type: json['type'] as String?,
      name: json['name'] as String,
      description: json['description'] as String?,
      salePrice: (json['sale_price'] as num?)?.toDouble() ?? 0.0,
      salePriceFormatted: json['sale_price_formatted'] as String?,
      purchasePrice: (json['purchase_price'] as num?)?.toDouble() ?? 0.0,
      purchasePriceFormatted: json['purchase_price_formatted'] as String?,
      categoryId: json['category_id'] as int?,
      enabled: json['enabled'] == true || json['enabled'] == 1,
      createdFrom: json['created_from'] as String?,
      createdBy: json['created_by'] as int?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'type': type,
        'name': name,
        'description': description,
        'sale_price': salePrice,
        'purchase_price': purchasePrice,
        'category_id': categoryId,
        'enabled': enabled ? 1 : 0,
      };

  ItemModel copyWith({
    int? id,
    int? companyId,
    String? type,
    String? name,
    String? description,
    double? salePrice,
    String? salePriceFormatted,
    double? purchasePrice,
    String? purchasePriceFormatted,
    int? categoryId,
    bool? enabled,
    String? createdFrom,
    int? createdBy,
    String? createdAt,
    String? updatedAt,
  }) {
    return ItemModel(
      id: id ?? this.id,
      companyId: companyId ?? this.companyId,
      type: type ?? this.type,
      name: name ?? this.name,
      description: description ?? this.description,
      salePrice: salePrice ?? this.salePrice,
      salePriceFormatted: salePriceFormatted ?? this.salePriceFormatted,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      purchasePriceFormatted: purchasePriceFormatted ?? this.purchasePriceFormatted,
      categoryId: categoryId ?? this.categoryId,
      enabled: enabled ?? this.enabled,
      createdFrom: createdFrom ?? this.createdFrom,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() => 'ItemModel(id: $id, name: $name, type: $type)';
}
