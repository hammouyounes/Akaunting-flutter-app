import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/contact_model.dart';
import '../../features/contacts/domain/repositories/contact_repository.dart';

// ─── States ───────────────────────────────────────────────────────────────────

abstract class ContactState {}

class ContactInitial extends ContactState {}

class ContactLoading extends ContactState {}

class ContactsLoaded extends ContactState {
  final List<ContactModel> contacts;
  ContactsLoaded(this.contacts);
}

class ContactLoaded extends ContactState {
  final ContactModel contact;
  ContactLoaded(this.contact);
}

class ContactSaved extends ContactState {
  final ContactModel contact;
  ContactSaved(this.contact);
}

class ContactDeleted extends ContactState {}

class ContactError extends ContactState {
  final String message;
  ContactError(this.message);
}

// ─── Cubit ────────────────────────────────────────────────────────────────────

class ContactCubit extends Cubit<ContactState> {
  final ContactRepository _contactRepo;

  ContactCubit({required ContactRepository contactRepository})
      : _contactRepo = contactRepository,
        super(ContactInitial());

  Future<void> loadContacts({String? search}) async {
    emit(ContactLoading());
    try {
      final contacts = await _contactRepo.getContacts(search: search);
      emit(ContactsLoaded(contacts));
    } catch (e) {
      emit(ContactError(_parseError(e)));
    }
  }

  Future<void> loadContact(int id) async {
    emit(ContactLoading());
    try {
      final contact = await _contactRepo.getContact(id);
      emit(ContactLoaded(contact));
    } catch (e) {
      emit(ContactError(_parseError(e)));
    }
  }

  Future<void> createContact(Map<String, dynamic> data) async {
    emit(ContactLoading());
    try {
      final contact = await _contactRepo.createContact(data);
      emit(ContactSaved(contact));
    } catch (e) {
      emit(ContactError(_parseError(e)));
    }
  }

  Future<void> updateContact(int id, Map<String, dynamic> data) async {
    emit(ContactLoading());
    try {
      final contact = await _contactRepo.updateContact(id, data);
      emit(ContactSaved(contact));
    } catch (e) {
      emit(ContactError(_parseError(e)));
    }
  }

  Future<void> deleteContact(int id) async {
    emit(ContactLoading());
    try {
      await _contactRepo.deleteContact(id);
      emit(ContactDeleted());
    } catch (e) {
      emit(ContactError(_parseError(e)));
    }
  }

  Future<void> enableContact(int id) async {
    try {
      final contact = await _contactRepo.enableContact(id);
      emit(ContactSaved(contact));
    } catch (e) {
      emit(ContactError(_parseError(e)));
    }
  }

  Future<void> disableContact(int id) async {
    try {
      final contact = await _contactRepo.disableContact(id);
      emit(ContactSaved(contact));
    } catch (e) {
      emit(ContactError(_parseError(e)));
    }
  }

  String _parseError(Object e) {
    final msg = e.toString();
    if (msg.startsWith('Exception: ')) return msg.substring(11);
    return 'An unexpected error occurred. Please try again.';
  }
}
