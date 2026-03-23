import '../../../../data/models/contact_model.dart';

abstract class ContactRepository {
  Future<List<ContactModel>> getContacts({String? search, int page = 1});
  Future<ContactModel> getContact(int id);
  Future<ContactModel> createContact(Map<String, dynamic> data);
  Future<ContactModel> updateContact(int id, Map<String, dynamic> data);
  Future<void> deleteContact(int id);
  Future<ContactModel> enableContact(int id);
  Future<ContactModel> disableContact(int id);
}
