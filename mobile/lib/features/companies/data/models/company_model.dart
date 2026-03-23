class CompanyModel {
  final int id;
  final String name;
  final String? email;
  final String? currency;
  final String? domain;
  final String? address;
  final String? logo;
  final bool enabled;
  final String? createdFrom;
  final int? createdBy;
  final String? createdAt;
  final String? updatedAt;

  const CompanyModel({
    required this.id,
    required this.name,
    this.email,
    this.currency,
    this.domain,
    this.address,
    this.logo,
    this.enabled = true,
    this.createdFrom,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
  });

  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    // CRITICAL: Safety check for name - default to 'My Business' if null, empty, or 'N/A'
    String parsedName = json['name'] as String? ?? '';
    if (parsedName.isEmpty || parsedName == 'N/A') {
      parsedName = 'My Business';
    }

    return CompanyModel(
      id: json['id'] as int,
      name: parsedName,
      email: json['email'] as String?,
      currency: json['currency'] as String?,
      domain: json['domain'] as String?,
      address: json['address'] as String?,
      logo: json['logo'] as String?,
      enabled: json['enabled'] == true || json['enabled'] == 1,
      createdFrom: json['created_from'] as String?,
      createdBy: json['created_by'] as int?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'currency': currency,
    'domain': domain,
    'address': address,
    'logo': logo,
    'enabled': enabled,
    'created_from': createdFrom,
    'created_by': createdBy,
    'created_at': createdAt,
    'updated_at': updatedAt,
  };

  @override
  String toString() => 'CompanyModel(id: $id, name: $name, currency: $currency)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CompanyModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
