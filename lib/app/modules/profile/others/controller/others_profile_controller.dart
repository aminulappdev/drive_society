// ignore_for_file: curly_braces_in_flow_control_structures, avoid_print

import 'package:dirve_society/app/modules/profile/model/profile_model.dart';
import 'package:dirve_society/get_storage.dart';
import 'package:dirve_society/services/network_caller/network_caller.dart';
import 'package:dirve_society/services/network_caller/network_response.dart';
import 'package:dirve_society/urls.dart';
import 'package:get/get.dart';

class OthersProfileController extends GetxController {
  final NetworkCaller networkCaller = Get.put(NetworkCaller());

  bool _inProgress = false;
  bool get inProgress => _inProgress;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  ProfileDetailsModel? profileDetailsModel;
  ProfileData? get profileData => profileDetailsModel?.data;

  String? _otpToken;
  String? get otpToken => _otpToken;

  Future<bool> fetchOthersProfileData(String id) async {
    print('Fetching profile data for id: $id');
    _inProgress = true;
    update(); // Notify UI to show loading 

    final NetworkResponse response = await networkCaller.getRequest(
      Urls.otherProfileById(id),
      accesToken: StorageUtil.getData(StorageUtil.userAccessToken),
    );

    print('Response status: ${response.isSuccess}');
    print('Response data: ${response.responseData}');
    print('Error message: ${response.errorMessage}');

    if (response.isSuccess && response.responseData != null) {
      _errorMessage = '';
      try {
        profileDetailsModel = ProfileDetailsModel.fromJson(response.responseData);
        print('Parsed profile data: ${profileDetailsModel?.data?.name}');
        _inProgress = false;
        update(); // Notify UI to rebuild with data
        return true;
      } catch (e) { 
        print('Parsing error: $e');
        _errorMessage = 'Failed to parse profile data: $e';
        _inProgress = false;
        update();
        return false;
      }
    } else {
      _errorMessage = response.errorMessage ?? 'Unknown error occurred';
      _inProgress = false;
      update();
      return false;
    }
  }
}