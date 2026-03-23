import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../data/models/contact_model.dart';
import '../../../../core/ui/components/badge.dart';
import '../../../../core/ui/components/cards/card.dart';
import '../../../../core/ui/components/base_button.dart';
import '../../../../logic/cubits/contact_cubit.dart';
import '../../../../core/di/injection_container.dart';
import 'contact_form_page.dart';

class ContactDetailPage extends StatelessWidget {
  final ContactModel contact;

  const ContactDetailPage({super.key, required this.contact});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ContactCubit>(
      create: (context) => sl<ContactCubit>(),
      child: _ContactDetailView(initialContact: contact),
    );
  }
}

class _ContactDetailView extends StatefulWidget {
  final ContactModel initialContact;

  const _ContactDetailView({required this.initialContact});

  @override
  State<_ContactDetailView> createState() => _ContactDetailViewState();
}

class _ContactDetailViewState extends State<_ContactDetailView> {
  late ContactModel _contact;

  @override
  void initState() {
    super.initState();
    _contact = widget.initialContact;
  }

  void _onContactDeleted() {
    Navigator.of(context).pop(true);
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Contact'),
        content: const Text('Are you sure you want to delete this contact?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              context.read<ContactCubit>().deleteContact(_contact.id);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ContactCubit, ContactState>(
      listener: (context, state) {
        if (state is ContactDeleted) {
          _onContactDeleted();
        } else if (state is ContactSaved) {
            setState(() {
              _contact = state.contact;
            });
        } else if (state is ContactError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is ContactLoading;

        return Scaffold(
          backgroundColor: const Color(0xFFF4F6F8),
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: const BackButton(color: Colors.black87),
            title: Text(
              _contact.name,
              style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.black87),
                onPressed: () async {
                  final updatedContact = await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ContactFormPage(contact: _contact),
                    ),
                  );
                  if (updatedContact != null) {
                    setState(() {
                      _contact = updatedContact;
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
                          Row(
                            children: [
                              AppBadge(
                                type: BadgeType.primary,
                                child: Text(_contact.type.toUpperCase()),
                              ),
                              const SizedBox(width: 8),
                              if (!_contact.enabled)
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
                
                // Details Card
                const Text('Contact Information', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                AppCard(
                  child: Column(
                    children: [
                      _DetailRow(label: 'Email', value: _contact.email ?? 'N/A'),
                      const Divider(),
                      _DetailRow(label: 'Phone', value: _contact.phone ?? 'N/A'),
                      const Divider(),
                      _DetailRow(label: 'Tax Number', value: _contact.taxNumber ?? 'N/A'),
                      const Divider(),
                      _DetailRow(label: 'Currency', value: _contact.currencyCode?.toUpperCase() ?? 'Default'),
                      const Divider(),
                      _DetailRow(label: 'Address', value: _contact.address ?? 'N/A'),
                      const Divider(),
                      _DetailRow(label: 'City', value: _contact.city ?? 'N/A'),
                      const Divider(),
                      _DetailRow(label: 'Country', value: _contact.country ?? 'N/A'),
                      const Divider(),
                      _DetailRow(label: 'Website', value: _contact.website ?? 'N/A'),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Enable/Disable button
                BaseButton(
                  onPressed: () {
                    if (_contact.enabled) {
                      context.read<ContactCubit>().disableContact(_contact.id);
                    } else {
                      context.read<ContactCubit>().enableContact(_contact.id);
                    }
                  },
                  type: _contact.enabled ? ButtonType.warning : ButtonType.success,
                  block: true,
                  child: Text(_contact.enabled ? 'Disable Contact' : 'Enable Contact'),
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
          Flexible(child: Text(value, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: Colors.black87), textAlign: TextAlign.right)),
        ],
      ),
    );
  }
}
