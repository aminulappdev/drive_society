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

  static Future<void> clearUserSession() async {
    await Future.wait([
      deleteData(userAccessToken),
      deleteData(userId),
      deleteData(otpToken),
      deleteData(profileId),
      deleteData(profileName),
      deleteData(profileEmail),
      deleteData(profilePhotoUrl),
      deleteData(profileBio),
      deleteData(profileAddress),
      deleteData(profileAddressTwo),
      deleteData(profilePoBox),
      deleteData(profileCity),
      deleteData(profilePostalCode),
      deleteData(profileCountry),
      deleteData(profileAddressOnePoBox),
      deleteData(profileAddressOneCity),
      deleteData(profileAddressOnePostalCode),
      deleteData(profileAddressOneCountry),
      deleteData(profileAddressOneLatitude),
      deleteData(profileAddressOneLongitude),
      deleteData(profileAddressTwoPoBox),
      deleteData(profileAddressTwoCity),
      deleteData(profileAddressTwoPostalCode),
      deleteData(profileAddressTwoCountry),
      deleteData(profileAddressTwoLatitude),
      deleteData(profileAddressTwoLongitude),
      deleteData(profileScores),
      deleteData(profileStatus),
      deleteData(profileDataId),
      deleteData(profileCreatedAt),
      deleteData(profileAvgRating),
      deleteData(profileCoverPhoto),
      deleteData(isPaid),
    ]);
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
  static String profileCountry = 'profile-country';
  static String profileAddressOnePoBox = 'profile-address-one-po-box';
  static String profileAddressOneCity = 'profile-address-one-city';
  static String profileAddressOnePostalCode = 'profile-address-one-postal-code';
  static String profileAddressOneCountry = 'profile-address-one-country';
  static String profileAddressOneLatitude = 'profile-address-one-latitude';
  static String profileAddressOneLongitude = 'profile-address-one-longitude';
  static String profileAddressTwoPoBox = 'profile-address-two-po-box';
  static String profileAddressTwoCity = 'profile-address-two-city';
  static String profileAddressTwoPostalCode = 'profile-address-two-postal-code';
  static String profileAddressTwoCountry = 'profile-address-two-country';
  static String profileAddressTwoLatitude = 'profile-address-two-latitude';
  static String profileAddressTwoLongitude = 'profile-address-two-longitude';
  static String profileScores = 'profile-scores';
  static String profileStatus = 'profile-status';
  static String profileDataId = 'profile-data-id';
  static String profileCreatedAt = 'profile-created-at';
  static String profileAvgRating = 'profile-avg-rating';
  static String profileCoverPhoto = 'profile-cover-photo';
  static String isPaid = 'profile-is-paid';
}
