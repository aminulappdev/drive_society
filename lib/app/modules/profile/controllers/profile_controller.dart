// ignore_for_file: curly_braces_in_flow_control_structures, avoid_print

import 'package:dirve_society/app/modules/profile/model/profile_model.dart';
import 'package:dirve_society/get_storage.dart';
import 'package:dirve_society/services/network_caller/network_caller.dart';
import 'package:dirve_society/services/network_caller/network_response.dart';
import 'package:dirve_society/urls.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  final NetworkCaller networkCaller = Get.put(NetworkCaller());
 
  final RxBool _inProgress = false.obs;
  bool get inProgress => _inProgress.value;

  final RxString _errorMessage = ''.obs;
  String? get errorMessage =>
      _errorMessage.value.isEmpty ? null : _errorMessage.value;

  final Rx<ProfileDetailsModel?> profileModel = Rx<ProfileDetailsModel?>(null);
  final Rx<ProfileData?> profileData = Rx<ProfileData?>(null);

  String? _otpToken;
  String? get otpToken => _otpToken;

  @override
  void onInit() {
    super.onInit();
    // Bind profileData to profileModel's data field reactively
    ever(profileModel, (ProfileDetailsModel? model) {
      profileData.value = model?.data;
    });
  }

  Future<bool> fetchProfileData() async {
    _inProgress.value = true;

    final NetworkResponse response = await networkCaller.getRequest(
      Urls.profileUrl,
      accesToken: StorageUtil.getData(StorageUtil.userAccessToken),
    );

    if (response.isSuccess) {
      _errorMessage.value = '';
      profileModel.value = ProfileDetailsModel.fromJson(response.responseData);
      print('Profile data: ${profileModel.value?.data}');

      // Save profile data to local storage
      final profile = profileModel.value?.data;
      if (profile != null) {
        await _cacheProfileValue(StorageUtil.profileId, profile.id);
        await _cacheProfileValue(StorageUtil.profileName, profile.name);
        await _cacheProfileValue(StorageUtil.profileEmail, profile.email);
        await _cacheProfileValue(
            StorageUtil.isPaid, profile.isPremiumAccount);
        await _cacheProfileValue(
            StorageUtil.profilePhotoUrl, profile.photoUrl);
        await _cacheProfileValue(StorageUtil.profileBio, profile.bio);
        await _cacheProfileValue(StorageUtil.profileAddress, profile.address);
        await _cacheProfileValue(
            StorageUtil.profileAddressTwo, profile.addressTwo);
        await _cacheProfileValue(StorageUtil.profilePoBox, profile.poBox);
        await _cacheProfileValue(StorageUtil.profileCity, profile.city);
        await _cacheProfileValue(
            StorageUtil.profilePostalCode, profile.postalCode);
        await _cacheProfileValue(StorageUtil.profileCountry, profile.country);
        await _cacheProfileValue(
            StorageUtil.profileAddressOnePoBox, profile.addressLine1?.poBox);
        await _cacheProfileValue(
            StorageUtil.profileAddressOneCity, profile.addressLine1?.city);
        await _cacheProfileValue(StorageUtil.profileAddressOnePostalCode,
            profile.addressLine1?.postalCode);
        await _cacheProfileValue(StorageUtil.profileAddressOneCountry,
            profile.addressLine1?.country);
        await _cacheProfileValue(StorageUtil.profileAddressOneLatitude,
            profile.addressLine1?.latitude);
        await _cacheProfileValue(StorageUtil.profileAddressOneLongitude,
            profile.addressLine1?.longitude);
        await _cacheProfileValue(
            StorageUtil.profileAddressTwoPoBox, profile.addressLine2?.poBox);
        await _cacheProfileValue(
            StorageUtil.profileAddressTwoCity, profile.addressLine2?.city);
        await _cacheProfileValue(StorageUtil.profileAddressTwoPostalCode,
            profile.addressLine2?.postalCode);
        await _cacheProfileValue(StorageUtil.profileAddressTwoCountry,
            profile.addressLine2?.country);
        await _cacheProfileValue(StorageUtil.profileAddressTwoLatitude,
            profile.addressLine2?.latitude);
        await _cacheProfileValue(StorageUtil.profileAddressTwoLongitude,
            profile.addressLine2?.longitude);
        await _cacheProfileValue(StorageUtil.profileScores, profile.scores);
        await _cacheProfileValue(StorageUtil.profileStatus, profile.status);
        await _cacheProfileValue(StorageUtil.profileDataId, profile.dataId);
        await _cacheProfileValue(
            StorageUtil.profileCreatedAt, profile.createdAt?.toIso8601String());
        await _cacheProfileValue(
            StorageUtil.profileAvgRating, profile.avgRating);
        await _cacheProfileValue(
            StorageUtil.profileCoverPhoto, profile.coverPhoto);
      }

      _inProgress.value = false;
      return true;
    } else {
      _errorMessage.value = response.errorMessage;
      _inProgress.value = false;
      return false;
    }
  }

  Future<void> _cacheProfileValue(String key, dynamic value) async {
    if (value == null) {
      await StorageUtil.deleteData(key);
    } else {
      await StorageUtil.saveData(key, value);
    }
  }

  Future<bool> forgotPassword(String email) async {
    _inProgress.value = true;

    Map<String, dynamic> requestBody = {"email": email};

    final NetworkResponse response = await Get.find<NetworkCaller>()
        .postRequest(Urls.forgotPasswordUrl, requestBody);

    if (response.isSuccess) {
      _errorMessage.value = '';
      _otpToken = response.responseData['data']['verifyToken'];
      await StorageUtil.saveData(
        StorageUtil.otpToken,
        _otpToken,
      );

      print('Response token: $_otpToken');
      print('Response data: ${response.responseData}');

      _inProgress.value = false;
      return true;
    } else {
      _errorMessage.value = response.errorMessage;
      _inProgress.value = false;
      return false;
    }
  }
}
