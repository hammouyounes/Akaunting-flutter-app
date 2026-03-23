import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/ui/components/akaunting_search.dart';
import '../../../../core/ui/components/badge.dart';
import '../../../../core/ui/components/cards/card.dart';
import '../../../../core/ui/components/base_alert.dart';
import '../../../../logic/cubits/contact_cubit.dart';
import 'contact_detail_page.dart';
import 'contact_form_page.dart';

class ContactsListPage extends StatelessWidget {
  const ContactsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ContactCubit>(
      create: (context) => sl<ContactCubit>(),
      child: const ContactsListView(),
    );
  }
}

class ContactsListView extends StatefulWidget {
  const ContactsListView({super.key});

  @override
  State<ContactsListView> createState() => _ContactsListViewState();
}

class _ContactsListViewState extends State<ContactsListView> with SingleTickerProviderStateMixin {
  String _searchQuery = '';
  late TabController _tabController;
  final List<String> _types = ['customer', 'vendor'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _types.length, vsync: this);
    
    // Initial load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _onSearch('');
    });

    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        _onSearch(_searchQuery);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    _onSearch(_searchQuery);
  }

  void _onSearch(String value) {
    setState(() {
      _searchQuery = value;
    });
    final type = _types[_tabController.index];
    final searchParam = value.isEmpty ? 'type:$type' : 'type:$type $value';
    context.read<ContactCubit>().loadContacts(search: searchParam);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        title: const Text('Contacts', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Theme.of(context).primaryColor,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Theme.of(context).primaryColor,
          tabs: const [
            Tab(text: 'Customers'),
            Tab(text: 'Vendors'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'contacts_fab',
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const ContactFormPage(),
            ),
          ).then((_) => _onRefresh());
        },
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: AkauntingSearch(
              placeholder: 'Search contacts...',
              onSearch: _onSearch,
              onClear: () => _onSearch(''),
            ),
          ),
          Expanded(
            child: BlocBuilder<ContactCubit, ContactState>(
              builder: (context, state) {
                if (state is ContactLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ContactError) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: BaseAlert(
                      type: AlertType.danger,
                      content: Text(state.message),
                      icon: Icons.error_outline,
                    ),
                  );
                } else if (state is ContactsLoaded) {
                  if (state.contacts.isEmpty) {
                    return const Center(child: Text('No contacts found.'));
                  }
                  return RefreshIndicator(
                    onRefresh: _onRefresh,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: state.contacts.length,
                      itemBuilder: (context, index) {
                        final contact = state.contacts[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: AppCard(
                            hover: true,
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => ContactDetailPage(contact: contact),
                                  ),
                                ).then((_) => _onRefresh());
                              },
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                                    child: Text(
                                      contact.name.isNotEmpty ? contact.name[0].toUpperCase() : 'C',
                                      style: TextStyle(color: Theme.of(context).primaryColor),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                contact.name,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black87,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            if (!contact.enabled) ...[
                                              const SizedBox(width: 8),
                                              const AppBadge(
                                                type: BadgeType.danger,
                                                child: Text('Disabled'),
                                              ),
                                            ]
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          contact.email ?? contact.phone ?? 'No contact info',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey.shade600,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        AppBadge(
                                          type: BadgeType.primary,
                                          child: Text(contact.type.toUpperCase()),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Icon(Icons.chevron_right, color: Colors.grey),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
