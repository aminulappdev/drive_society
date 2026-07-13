// get_storage.dart
import 'package:get_storage/get_storage.dart';

class StorageUtil {
  static final box = GetStorage();

  static Future<void> saveData(String key, dynamic value) async {
    await box.write(key, value);
  }

  static dynamic getData(String key) {
    return box.read(key);
  }

  static Future<void> deleteData(String key) async {
    await box.remove(key);
  }

  // Existing keys
  static String userAccessToken = 'user-access-token';
  static String userId = 'user-id';
  static String otpToken = 'otp-token';

  // New keys for profile data
  static String profileId = 'profile-id';
  static String profileName = 'profile-name';
  static String profileEmail = 'profile-email';
  static String profilePhotoUrl = 'profile-photo-url';
  static String profileBio = 'profile-bio';
  static String profileAddress = 'profile-address';
  static String profileAddressTwo = 'profile-address-two';
  static String profilePoBox = 'profile-po-box';
  static String profileCity = 'profile-city';
  static String profilePostalCode = 'profile-postal-code';
  static String profileScores = 'profile-scores';
  static String profileStatus = 'profile-status';
  static String profileDataId = 'profile-data-id';
  static String profileCreatedAt = 'profile-created-at';
  static String profileAvgRating = 'profile-avg-rating';
  static String profileCoverPhoto = 'profile-cover-photo';
  static String isPaid = 'profile-is-paid';
}
