class AccountModel {
  final int id;
  final int companyId;
  final String type;
  final String name;
  final String number;
  final String currencyCode;
  final double openingBalance;
  final String? openingBalanceFormatted;
  final double? currentBalance;
  final String? currentBalanceFormatted;
  final String? bankName;
  final String? bankPhone;
  final String? bankAddress;
  final bool enabled;
  final String? createdFrom;
  final int? createdBy;
  final String? createdAt;
  final String? updatedAt;

  const AccountModel({
    required this.id,
    required this.companyId,
    required this.type,
    required this.name,
    required this.number,
    required this.currencyCode,
    this.openingBalance = 0.0,
    this.openingBalanceFormatted,
    this.currentBalance,
    this.currentBalanceFormatted,
    this.bankName,
    this.bankPhone,
    this.bankAddress,
    this.enabled = true,
    this.createdFrom,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
  });

  factory AccountModel.fromJson(Map<String, dynamic> json) {
    return AccountModel(
      id: json['id'] as int,
      companyId: json['company_id'] as int,
      type: json['type'] as String? ?? 'bank',
      name: json['name'] as String,
      number: json['number'] as String,
      currencyCode: json['currency_code'] as String,
      openingBalance: (json['opening_balance'] as num?)?.toDouble() ?? 0.0,
      openingBalanceFormatted: json['opening_balance_formatted'] as String?,
      currentBalance: (json['current_balance'] as num?)?.toDouble(),
      currentBalanceFormatted: json['current_balance_formatted'] as String?,
      bankName: json['bank_name'] as String?,
      bankPhone: json['bank_phone'] as String?,
      bankAddress: json['bank_address'] as String?,
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
        'number': number,
        'currency_code': currencyCode,
        'opening_balance': openingBalance,
        'bank_name': bankName,
        'bank_phone': bankPhone,
        'bank_address': bankAddress,
        'enabled': enabled ? 1 : 0,
      };

  AccountModel copyWith({
    int? id,
    int? companyId,
    String? type,
    String? name,
    String? number,
    String? currencyCode,
    double? openingBalance,
    String? openingBalanceFormatted,
    double? currentBalance,
    String? currentBalanceFormatted,
    String? bankName,
    String? bankPhone,
    String? bankAddress,
    bool? enabled,
    String? createdFrom,
    int? createdBy,
    String? createdAt,
    String? updatedAt,
  }) {
    return AccountModel(
      id: id ?? this.id,
      companyId: companyId ?? this.companyId,
      type: type ?? this.type,
      name: name ?? this.name,
      number: number ?? this.number,
      currencyCode: currencyCode ?? this.currencyCode,
      openingBalance: openingBalance ?? this.openingBalance,
      openingBalanceFormatted: openingBalanceFormatted ?? this.openingBalanceFormatted,
      currentBalance: currentBalance ?? this.currentBalance,
      currentBalanceFormatted: currentBalanceFormatted ?? this.currentBalanceFormatted,
      bankName: bankName ?? this.bankName,
      bankPhone: bankPhone ?? this.bankPhone,
      bankAddress: bankAddress ?? this.bankAddress,
      enabled: enabled ?? this.enabled,
      createdFrom: createdFrom ?? this.createdFrom,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() => 'AccountModel(id: $id, name: $name, number: $number)';
}
