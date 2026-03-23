class ProfileCompanyModel {
  final int id;
  final String name;
  final String? email;
  final String? domain;
  final String? currency;
  final bool enabled;

  const ProfileCompanyModel({
    required this.id,
    required this.name,
    this.email,
    this.domain,
    this.currency,
    this.enabled = true,
  });

  factory ProfileCompanyModel.fromJson(Map<String, dynamic> json) {
    return ProfileCompanyModel(
      id: json['id'] as int,
      name: json['name'] as String? ?? 'Unknown Company',
      email: json['email'] as String?,
      domain: json['domain'] as String?,
      currency: json['currency'] as String?,
      enabled: json['enabled'] == true || json['enabled'] == 1,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'domain': domain,
    'currency': currency,
    'enabled': enabled,
  };
}

class UserProfileModel {
  final int id;
  final String name;
  final String email;
  final String? locale;
  final String? landingPage;
  final bool enabled;
  final String? lastLoggedInAt;
  final String? createdAt;
  final List<ProfileCompanyModel> companies;
  final List<String> roles;

  const UserProfileModel({
    required this.id,
    required this.name,
    required this.email,
    this.locale,
    this.landingPage,
    this.enabled = true,
    this.lastLoggedInAt,
    this.createdAt,
    this.companies = const [],
    this.roles = const [],
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    // Handle name with fallback: if null or 'N/A', default to 'Admin User'
    String parsedName = json['name'] as String? ?? 'N/A';
    if (parsedName == 'N/A') {
      parsedName = 'Admin User';
    }

    // Parse companies list
    final companiesJson = json['companies'] as List<dynamic>? ?? [];
    final companies = companiesJson
        .map((c) => ProfileCompanyModel.fromJson(c as Map<String, dynamic>))
        .toList();

    // Parse roles list (comes as list of strings)
    final rolesJson = json['roles'] as List<dynamic>? ?? [];
    final roles = rolesJson.map((r) => r.toString()).toList();

    return UserProfileModel(
      id: json['id'] as int,
      name: parsedName,
      email: json['email'] as String? ?? '',
      locale: json['locale'] as String?,
      landingPage: json['landing_page'] as String?,
      enabled: json['enabled'] == true || json['enabled'] == 1,
      lastLoggedInAt: json['last_logged_in_at'] as String?,
      createdAt: json['created_at'] as String?,
      companies: companies,
      roles: roles,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'locale': locale,
    'landing_page': landingPage,
    'enabled': enabled,
    'last_logged_in_at': lastLoggedInAt,
    'created_at': createdAt,
    'companies': companies.map((c) => c.toJson()).toList(),
    'roles': roles,
  };

  @override
  String toString() =>
      'UserProfileModel(id: $id, name: $name, email: $email, roles: $roles)';
}
