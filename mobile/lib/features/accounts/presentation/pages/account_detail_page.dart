import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../data/models/account_model.dart';
import '../../../../core/ui/components/badge.dart';
import '../../../../core/ui/components/cards/stats_card.dart';
import '../../../../core/ui/components/cards/card.dart';
import '../../../../core/ui/components/base_button.dart';
import '../../../../logic/cubits/account_cubit.dart';
import '../../../../core/di/injection_container.dart';
import 'account_form_page.dart';

class AccountDetailPage extends StatelessWidget {
  final AccountModel account;

  const AccountDetailPage({super.key, required this.account});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AccountCubit>(
      create: (context) => sl<AccountCubit>(),
      child: _AccountDetailView(initialAccount: account),
    );
  }
}

class _AccountDetailView extends StatefulWidget {
  final AccountModel initialAccount;

  const _AccountDetailView({required this.initialAccount});

  @override
  State<_AccountDetailView> createState() => _AccountDetailViewState();
}

class _AccountDetailViewState extends State<_AccountDetailView> {
  late AccountModel _account;

  @override
  void initState() {
    super.initState();
    _account = widget.initialAccount;
  }

  void _onAccountDeleted() {
    Navigator.of(context).pop(true);
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text('Are you sure you want to delete this account?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              context.read<AccountCubit>().deleteAccount(_account.id);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AccountCubit, AccountState>(
      listener: (context, state) {
        if (state is AccountDeleted) {
          _onAccountDeleted();
        } else if (state is AccountSaved) {
            setState(() {
              _account = state.account;
            });
        } else if (state is AccountError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is AccountLoading;

        return Scaffold(
          backgroundColor: const Color(0xFFF4F6F8),
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: const BackButton(color: Colors.black87),
            title: Text(
              _account.name,
              style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.black87),
                onPressed: () async {
                  final updatedAccount = await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => AccountFormPage(account: _account),
                    ),
                  );
                  if (updatedAccount != null) {
                    setState(() {
                      _account = updatedAccount;
                    });
                  }
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: _confirmDelete,
              ),
            ],
          ),
          body: isLoading ? const Center(child: CircularProgressIndicator()) : SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _account.number,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              AppBadge(
                                type: BadgeType.primary,
                                child: Text(_account.type.toUpperCase()),
                              ),
                              const SizedBox(width: 8),
                              if (!_account.enabled)
                                const AppBadge(
                                  type: BadgeType.danger,
                                  child: Text('Disabled'),
                                ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                
                // Stat Card wrapper
                StatsCard(
                  title: 'Current Balance',
                  subTitle: _account.currentBalanceFormatted ?? 
                            '\$${_account.currentBalance?.toStringAsFixed(2) ?? "0.00"}',
                  icon: Icons.account_balance_wallet,
                  type: CardType.primary,
                ),
                const SizedBox(height: 16),
                
                // Details Card
                const Text('Account Details', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                AppCard(
                  child: Column(
                    children: [
                      _DetailRow(label: 'Currency', value: _account.currencyCode),
                      const Divider(),
                      _DetailRow(label: 'Opening Balance', value: _account.openingBalanceFormatted ?? _account.openingBalance.toString()),
                      if (_account.bankName != null && _account.bankName!.isNotEmpty) ...[
                        const Divider(),
                        _DetailRow(label: 'Bank Name', value: _account.bankName!),
                      ],
                      if (_account.bankPhone != null && _account.bankPhone!.isNotEmpty) ...[
                        const Divider(),
                        _DetailRow(label: 'Bank Phone', value: _account.bankPhone!),
                      ],
                      if (_account.bankAddress != null && _account.bankAddress!.isNotEmpty) ...[
                        const Divider(),
                        _DetailRow(label: 'Bank Address', value: _account.bankAddress!),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Enable/Disable button
                BaseButton(
                  onPressed: () {
                    if (_account.enabled) {
                      context.read<AccountCubit>().disableAccount(_account.id);
                    } else {
                      context.read<AccountCubit>().enableAccount(_account.id);
                    }
                  },
                  type: _account.enabled ? ButtonType.warning : ButtonType.success,
                  block: true,
                  child: Text(_account.enabled ? 'Disable Account' : 'Enable Account'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: Colors.black87)),
        ],
      ),
    );
  }
}
