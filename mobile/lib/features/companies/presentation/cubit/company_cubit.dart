import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/company_repository.dart';
import 'company_state.dart';

class CompanyCubit extends Cubit<CompanyState> {
  final CompanyRepository _repository;

  CompanyCubit({required CompanyRepository repository})
    : _repository = repository,
      super(CompanyInitial());

  Future<void> getCompanies() async {
    emit(CompanyLoading());
    try {
      final companies = await _repository.getCompanies();
      final selectedId = companies.isNotEmpty ? companies.first.id : null;
      emit(CompanyLoaded(companies: companies, selectedCompanyId: selectedId));
    } catch (e) {
      emit(CompanyError(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  void selectCompany(int companyId) {
    final currentState = state;
    if (currentState is CompanyLoaded) {
      emit(currentState.copyWith(selectedCompanyId: companyId));
    }
  }

  Future<void> getCompany(int id) async {
    emit(CompanyLoading());
    try {
      final company = await _repository.getCompany(id);
      emit(CompanySaved(company));
    } catch (e) {
      emit(CompanyError(_parseError(e)));
    }
  }

  Future<void> createCompany(Map<String, dynamic> data) async {
    emit(CompanyLoading());
    try {
      final company = await _repository.createCompany(data);
      emit(CompanySaved(company));
    } catch (e) {
      emit(CompanyError(_parseError(e)));
    }
  }

  Future<void> updateCompany(int id, Map<String, dynamic> data) async {
    emit(CompanyLoading());
    try {
      final company = await _repository.updateCompany(id, data);
      emit(CompanySaved(company));
    } catch (e) {
      emit(CompanyError(_parseError(e)));
    }
  }

  Future<void> deleteCompany(int id) async {
    emit(CompanyLoading());
    try {
      await _repository.deleteCompany(id);
      emit(CompanyDeleted());
    } catch (e) {
      emit(CompanyError(_parseError(e)));
    }
  }

  Future<void> enableCompany(int id) async {
    try {
      final company = await _repository.enableCompany(id);
      emit(CompanySaved(company));
    } catch (e) {
      emit(CompanyError(_parseError(e)));
    }
  }

  Future<void> disableCompany(int id) async {
    try {
      final company = await _repository.disableCompany(id);
      emit(CompanySaved(company));
    } catch (e) {
      emit(CompanyError(_parseError(e)));
    }
  }

  Future<void> checkOwner(int id) async {
    try {
      final isOwner = await _repository.checkOwner(id);
      emit(CompanyOwnerChecked(isOwner, id));
    } catch (e) {
      emit(CompanyError(_parseError(e)));
    }
  }

  String _parseError(Object e) {
    final msg = e.toString();
    if (msg.startsWith('Exception: ')) return msg.substring(11);
    return 'An unexpected error occurred. Please try again.';
  }
}
