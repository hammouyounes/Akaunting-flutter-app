import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/company_cubit.dart';
import '../cubit/company_state.dart';
import 'company_form_page.dart';
import 'company_detail_page.dart';

class CompaniesListPage extends StatefulWidget {
  const CompaniesListPage({super.key});

  @override
  State<CompaniesListPage> createState() => _CompaniesListPageState();
}

class _CompaniesListPageState extends State<CompaniesListPage> {
  @override
  void initState() {
    super.initState();
    _loadCompanies();
  }

  void _loadCompanies() {
    context.read<CompanyCubit>().getCompanies();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CompanyCubit, CompanyState>(
      listener: (context, state) {
        if (state is CompanyError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        } else if (state is CompanySaved || state is CompanyDeleted) {
          _loadCompanies();
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: const Color(0xFFF4F6F8),
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: const Text(
              'Companies',
              style: TextStyle(
                color: Color(0xFF1F2937),
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            iconTheme: const IconThemeData(color: Color(0xFF1F2937)),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: _loadCompanies,
              ),
            ],
          ),
          body: _buildBody(state),
          floatingActionButton: FloatingActionButton(
            backgroundColor: const Color(0xFF00D084),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CompanyFormPage(),
                ),
              );
            },
            child: const Icon(Icons.add, color: Colors.white),
          ),
        );
      },
    );
  }

  Widget _buildBody(CompanyState state) {
    if (state is CompanyLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFF00D084)),
      );
    }

    if (state is CompanyLoaded) {
      if (state.companies.isEmpty) {
        return const Center(
          child: Text(
            'No companies found.\nTap + to add one.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
        );
      }

      return RefreshIndicator(
        color: const Color(0xFF00D084),
        onRefresh: () async => _loadCompanies(),
        child: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: state.companies.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final company = state.companies[index];
            final bool isEnabled = company.enabled ?? false;

            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CompanyDetailPage(companyId: company.id),
                  ),
                );
              },
              child: Container(
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
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFF00D084).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Center(
                        child: Text(
                          company.name.isNotEmpty
                              ? company.name.substring(0, 1).toUpperCase()
                              : 'C',
                          style: const TextStyle(
                            color: Color(0xFF00D084),
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            company.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Color(0xFF1F2937),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            company.email ?? 'No email',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 13,
                            ),
                          ),
                        ],
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
              ),
            );
          },
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
