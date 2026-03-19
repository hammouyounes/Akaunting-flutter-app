import '../../data/models/user_profile_model.dart';

abstract class ProfileRepository {
  Future<UserProfileModel> getProfile();
}
