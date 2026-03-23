class ContactModel {
  final int id;
  final int companyId;
  final String type;
  final String name;
  final String? email;
  final String? taxNumber;
  final String? phone;
  final String? address;
  final String? city;
  final String? zipCode;
  final String? state;
  final String? country;
  final String? website;
  final String? currencyCode;
  final String? reference;
  final bool enabled;
  final String? createdAt;
  final String? updatedAt;

  const ContactModel({
    required this.id,
    required this.companyId,
    required this.type,
    required this.name,
    this.email,
    this.taxNumber,
    this.phone,
    this.address,
    this.city,
    this.zipCode,
    this.state,
    this.country,
    this.website,
    this.currencyCode,
    this.reference,
    this.enabled = true,
    this.createdAt,
    this.updatedAt,
  });

  factory ContactModel.fromJson(Map<String, dynamic> json) {
    return ContactModel(
      id: json['id'] as int,
      companyId: json['company_id'] as int,
      type: json['type'] as String? ?? 'customer',
      name: json['name'] as String,
      email: json['email'] as String?,
      taxNumber: json['tax_number'] as String?,
      phone: json['phone'] as String?,
      address: json['address'] as String?,
      city: json['city'] as String?,
      zipCode: json['zip_code'] as String?,
      state: json['state'] as String?,
      country: json['country'] as String?,
      website: json['website'] as String?,
      currencyCode: json['currency_code'] as String?,
      reference: json['reference'] as String?,
      enabled: json['enabled'] == true || json['enabled'] == 1,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'type': type,
        'name': name,
        'email': email,
        'tax_number': taxNumber,
        'phone': phone,
        'address': address,
        'city': city,
        'zip_code': zipCode,
        'state': state,
        'country': country,
        'website': website,
        'currency_code': currencyCode,
        'reference': reference,
        'enabled': enabled ? 1 : 0,
      };

  ContactModel copyWith({
    int? id,
    int? companyId,
    String? type,
    String? name,
    String? email,
    String? taxNumber,
    String? phone,
    String? address,
    String? city,
    String? zipCode,
    String? state,
    String? country,
    String? website,
    String? currencyCode,
    String? reference,
    bool? enabled,
    String? createdAt,
    String? updatedAt,
  }) {
    return ContactModel(
      id: id ?? this.id,
      companyId: companyId ?? this.companyId,
      type: type ?? this.type,
      name: name ?? this.name,
      email: email ?? this.email,
      taxNumber: taxNumber ?? this.taxNumber,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      city: city ?? this.city,
      zipCode: zipCode ?? this.zipCode,
      state: state ?? this.state,
      country: country ?? this.country,
      website: website ?? this.website,
      currencyCode: currencyCode ?? this.currencyCode,
      reference: reference ?? this.reference,
      enabled: enabled ?? this.enabled,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() => 'ContactModel(id: $id, name: $name, type: $type)';
}
