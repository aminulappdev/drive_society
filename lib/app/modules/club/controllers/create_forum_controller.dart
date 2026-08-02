// ignore_for_file: avoid_print

import 'package:dirve_society/get_storage.dart';
import 'package:dirve_society/services/network_caller/network_caller.dart';
import 'package:dirve_society/services/network_caller/network_response.dart';
import 'package:dirve_society/urls.dart';
import 'package:get/get.dart';

class CreateForumController extends GetxController {
  static const int maxTitleLength = 80;
  final NetworkCaller networkCaller = Get.put(NetworkCaller());

  var _inProgress = false.obs; // Changed to RxBool
  bool get inProgress => _inProgress.value; // Updated getter to use .value

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  int? lastPage;

  @override
  void onInit() {
    super.onInit();
  }

  Future<bool> createForun(
      String title, String description, String clubId) async {
    if (_inProgress.value) { // Updated to use .value
      return false;
    }

    final normalizedTitle = title.trim();
    if (normalizedTitle.isEmpty || normalizedTitle.length > maxTitleLength) {
      _errorMessage =
          'Title must be between 1 and $maxTitleLength characters.';
      update();
      return false;
    }

    bool isSuccess = false;

    _inProgress.value = true; // Updated to use .value
    update();

    Map<String, dynamic> jsonFields = {
      "author": StorageUtil.getData(StorageUtil.profileId),
      "club": clubId,
      "title": normalizedTitle,
      "description": description,
    };

    final NetworkResponse response = await networkCaller.postRequest(
      Urls.createForumUrl,
      jsonFields,
      accesToken: StorageUtil.getData(StorageUtil.userAccessToken),
    );

    if (response.isSuccess) {
      _errorMessage = null;
      isSuccess = true;
      _errorMessage = null; // Note: This line overwrites the previous null assignment, which might be intentional but could be simplified
    } else {
      _errorMessage = response.errorMessage;
    }

    _inProgress.value = false; // Updated to use .value
    update();
    return isSuccess;
  }
}
