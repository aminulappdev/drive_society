import 'package:dirve_society/get_storage.dart';
import 'package:dirve_society/services/network_caller/network_caller.dart';
import 'package:dirve_society/services/network_caller/network_response.dart';
import 'package:dirve_society/urls.dart';
import 'package:get/get.dart';

class AddInviteController extends GetxController {
  final NetworkCaller networkCaller = Get.put(NetworkCaller());

  var _inProgress = false.obs;
  bool get inProgress => _inProgress.value;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  int? lastPage;

  @override
  void onInit() {
    super.onInit();
  }

  Future<bool> addInvite(String referenceId, List<String> userId) async {
    if (_inProgress.value) {
      return false;
    }
 
    bool isSuccess = false;

    _inProgress.value = true;
    update();

    Map<String, dynamic> requestBody = {
      "user": userId,
      "modelType": "Club",
      "reference": referenceId
    };
    final NetworkResponse response = await networkCaller.putRequest(
      Urls.addInvitePeopleUrl,
      requestBody,
      accesToken: StorageUtil.getData(StorageUtil.userAccessToken),
    );

    if (response.isSuccess) {
      _errorMessage = null;
      isSuccess = true;
    } else {
      _errorMessage = response.errorMessage;
    }

    _inProgress.value = false;
    update();
    return isSuccess;
  }
}