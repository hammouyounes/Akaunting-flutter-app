import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/company_cubit.dart';
import '../cubit/company_state.dart';
import 'company_form_page.dart';

class CompanyDetailPage extends StatefulWidget {
  final int companyId;
  const CompanyDetailPage({super.key, required this.companyId});

  @override
  State<CompanyDetailPage> createState() => _CompanyDetailPageState();
}

class _CompanyDetailPageState extends State<CompanyDetailPage> {
  bool _isOwner = false;
  bool _checkedOwner = false;

  @override
  void initState() {
    super.initState();
    context.read<CompanyCubit>().checkOwner(widget.companyId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CompanyCubit, CompanyState>(
      listener: (context, state) {
        if (state is CompanyDeleted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Company deleted'), backgroundColor: Colors.red),
          );
          Navigator.pop(context); // Go back after delete
        } else if (state is CompanyOwnerChecked && state.companyId == widget.companyId) {
          setState(() {
            _isOwner = state.isOwner;
            _checkedOwner = true;
          });
        }
      },
      builder: (context, state) {
        if (state is CompanyLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator(color: Color(0xFF00D084))),
          );
        }

        // We fetch the company from the loaded companies array in real time
        final loadedState = state is CompanyLoaded ? state : null;
        if (loadedState == null && state is! CompanyOwnerChecked && state is! CompanySaved && state is! CompanyError) {
          // Fallback just in case
        }
        
        // Find company from Cubit using the `context.read<CompanyCubit>().state`
        // Actually best is to just pick it from any loaded companies
        final cubitState = context.read<CompanyCubit>().state;
        var companiesList = <dynamic>[];
        if (cubitState is CompanyLoaded) {
          companiesList = cubitState.companies;
        }
        
        final companyListFiltered = companiesList.where((c) => c.id == widget.companyId).toList();
        if (companyListFiltered.isEmpty) {
          return const Scaffold(
            body: Center(child: Text("Company not found")),
          );
        }

        final company = companyListFiltered.first;
        final bool isEnabled = company.enabled ?? false;

        return Scaffold(
          backgroundColor: const Color(0xFFF4F6F8),
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: Text(
              company.name,
              style: const TextStyle(
                color: Color(0xFF1F2937),
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            iconTheme: const IconThemeData(color: Color(0xFF1F2937)),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit, color: Color(0xFF00D084)),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CompanyFormPage(company: company),
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _confirmDelete(context, company.id),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Info Card
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                  border: Border.all(color: Colors.grey.withOpacity(0.1)),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 32,
                      backgroundColor: const Color(0xFF00D084).withOpacity(0.1),
                      child: Text(
                        company.name.isNotEmpty
                            ? company.name.substring(0, 1).toUpperCase()
                            : 'C',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF00D084),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      company.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      company.email ?? 'No email associated',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 16),
                    const Divider(height: 1),
                    const SizedBox(height: 16),
                    _buildInfoRow('Currency', company.currency ?? 'USD'),
                    _buildInfoRow('Domain', company.domain ?? 'N/A'),
                    _buildInfoRow('Address', company.address ?? 'N/A'),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Status',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF6B7280),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              isEnabled ? 'Enabled' : 'Disabled',
                              style: TextStyle(
                                fontSize: 14,
                                color: isEnabled ? const Color(0xFF00D084) : Colors.red,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Switch(
                              value: isEnabled,
                              activeColor: const Color(0xFF00D084),
                              onChanged: (val) {
                                if (val) {
                                  context.read<CompanyCubit>().enableCompany(company.id);
                                } else {
                                  context.read<CompanyCubit>().disableCompany(company.id);
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    if (_checkedOwner) ...[
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Owner Access',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF6B7280),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Badge(
                            backgroundColor: _isOwner ? const Color(0xFF00D084) : Colors.grey,
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            largeSize: 22,
                            label: Text(
                              _isOwner ? 'Owner' : 'Not Owner',
                              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                          )
                        ],
                      ),
                    ]
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF6B7280),
              fontWeight: FontWeight.w500,
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF1F2937),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Delete Company'),
          content: const Text('Are you sure you want to delete this company?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                context.read<CompanyCubit>().deleteCompany(id);
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
