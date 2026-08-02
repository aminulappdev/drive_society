// ignore_for_file: avoid_print

import 'package:dirve_society/app/modules/market_place/model/all_marketplace_model.dart';
import 'package:dirve_society/get_storage.dart';
import 'package:dirve_society/services/network_caller/network_caller.dart';
import 'package:dirve_society/services/network_caller/network_response.dart';
import 'package:dirve_society/urls.dart';
import 'package:get/get.dart';

class AllMarketplaceController extends GetxController {
  final NetworkCaller networkCaller = Get.put(NetworkCaller());

  bool _inProgress = false;
  bool get inProgress => _inProgress;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;


  AllMarketPlaceModel? _allMarketPlaceModel;
  List<AllMarketPlaceItemModel>? get allMarketPlaceList =>
      _allMarketPlaceModel?.data;

  int? lastPage;

  Future<bool> getAllMarketPlace({Map<String, dynamic>? queryParamsData}) async {
    if (_inProgress) {
      return false;
    }
 
    bool isSuccess = false;

    _inProgress = true;
    update();

    Map<String, dynamic> queryParams = {
      'limit': 99999,
      ...?queryParamsData,
    };
    final NetworkResponse response = await networkCaller.getRequest(
      Urls.allmarketPlaceUrl,
      queryParams: queryParams,
      accesToken: StorageUtil.getData(StorageUtil.userAccessToken),
    );

    if (response.isSuccess) {
      _errorMessage = null;
      isSuccess = true;

      _allMarketPlaceModel =
          AllMarketPlaceModel.fromJson(response.responseData);

      _errorMessage = null;
    } else {
      _errorMessage = response.errorMessage;
    }

    _inProgress = false;
    update();
    return isSuccess;
  }
}
