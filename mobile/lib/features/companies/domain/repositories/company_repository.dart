import '../../data/models/company_model.dart';

abstract class CompanyRepository {
  Future<List<CompanyModel>> getCompanies();
  Future<CompanyModel> getCompany(int id);
  Future<CompanyModel> createCompany(Map<String, dynamic> data);
  Future<CompanyModel> updateCompany(int id, Map<String, dynamic> data);
  Future<void> deleteCompany(int id);
  Future<CompanyModel> enableCompany(int id);
  Future<CompanyModel> disableCompany(int id);
  Future<bool> checkOwner(int id);
}
