import '../../../../data/models/account_model.dart';

abstract class AccountRepository {
  Future<List<AccountModel>> getAccounts({String? search, int page = 1});
  Future<AccountModel> getAccount(int id);
  Future<AccountModel> createAccount(Map<String, dynamic> data);
  Future<AccountModel> updateAccount(int id, Map<String, dynamic> data);
  Future<void> deleteAccount(int id);
  Future<AccountModel> enableAccount(int id);
  Future<AccountModel> disableAccount(int id);
}
