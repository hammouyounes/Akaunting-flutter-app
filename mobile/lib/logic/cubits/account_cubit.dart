import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/account_model.dart';
import '../../features/accounts/domain/repositories/account_repository.dart';

// ─── States ───────────────────────────────────────────────────────────────────

abstract class AccountState {}

class AccountInitial extends AccountState {}

class AccountLoading extends AccountState {}

class AccountsLoaded extends AccountState {
  final List<AccountModel> accounts;
  AccountsLoaded(this.accounts);
}

class AccountLoaded extends AccountState {
  final AccountModel account;
  AccountLoaded(this.account);
}

class AccountSaved extends AccountState {
  final AccountModel account;
  AccountSaved(this.account);
}

class AccountDeleted extends AccountState {}

class AccountError extends AccountState {
  final String message;
  AccountError(this.message);
}

// ─── Cubit ────────────────────────────────────────────────────────────────────

class AccountCubit extends Cubit<AccountState> {
  final AccountRepository _accountRepo;

  AccountCubit({required AccountRepository accountRepository})
      : _accountRepo = accountRepository,
        super(AccountInitial());

  Future<void> loadAccounts({String? search}) async {
    emit(AccountLoading());
    try {
      final accounts = await _accountRepo.getAccounts(search: search);
      emit(AccountsLoaded(accounts));
    } catch (e) {
      emit(AccountError(_parseError(e)));
    }
  }

  Future<void> loadAccount(int id) async {
    emit(AccountLoading());
    try {
      final account = await _accountRepo.getAccount(id);
      emit(AccountLoaded(account));
    } catch (e) {
      emit(AccountError(_parseError(e)));
    }
  }

  Future<void> createAccount(Map<String, dynamic> data) async {
    emit(AccountLoading());
    try {
      final account = await _accountRepo.createAccount(data);
      emit(AccountSaved(account));
    } catch (e) {
      emit(AccountError(_parseError(e)));
    }
  }

  Future<void> updateAccount(int id, Map<String, dynamic> data) async {
    emit(AccountLoading());
    try {
      final account = await _accountRepo.updateAccount(id, data);
      emit(AccountSaved(account));
    } catch (e) {
      emit(AccountError(_parseError(e)));
    }
  }

  Future<void> deleteAccount(int id) async {
    emit(AccountLoading());
    try {
      await _accountRepo.deleteAccount(id);
      emit(AccountDeleted());
    } catch (e) {
      emit(AccountError(_parseError(e)));
    }
  }

  Future<void> enableAccount(int id) async {
    try {
      final account = await _accountRepo.enableAccount(id);
      emit(AccountSaved(account));
    } catch (e) {
      emit(AccountError(_parseError(e)));
    }
  }

  Future<void> disableAccount(int id) async {
    try {
      final account = await _accountRepo.disableAccount(id);
      emit(AccountSaved(account));
    } catch (e) {
      emit(AccountError(_parseError(e)));
    }
  }

  String _parseError(Object e) {
    final msg = e.toString();
    if (msg.startsWith('Exception: ')) return msg.substring(11);
    return 'An unexpected error occurred. Please try again.';
  }
}
