import '../../data/models/company_model.dart';

abstract class CompanyState {
  const CompanyState();
}

class CompanyInitial extends CompanyState {}

class CompanyLoading extends CompanyState {}

class CompanyLoaded extends CompanyState {
  final List<CompanyModel> companies;
  final int? selectedCompanyId;

  const CompanyLoaded({
    required this.companies,
    this.selectedCompanyId,
  });

  CompanyLoaded copyWith({
    List<CompanyModel>? companies,
    int? selectedCompanyId,
  }) {
    return CompanyLoaded(
      companies: companies ?? this.companies,
      selectedCompanyId: selectedCompanyId ?? this.selectedCompanyId,
    );
  }
}

class CompanySaved extends CompanyState {
  final CompanyModel company;

  const CompanySaved(this.company);
}

class CompanyDeleted extends CompanyState {}

class CompanyOwnerChecked extends CompanyState {
  final bool isOwner;
  final int companyId;

  const CompanyOwnerChecked(this.isOwner, this.companyId);
}

class CompanyError extends CompanyState {
  final String message;

  const CompanyError(this.message);
}
