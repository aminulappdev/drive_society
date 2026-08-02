import 'package:get/get.dart';

import '../controllers/all_filter_controller.dart';

class FilterController extends GetxController {
  final AllFilterController allFilterController = Get.find();

  final searchTerm = ''.obs;
  final minPrice = ''.obs;
  final maxPrice = ''.obs;
  final minMileage = ''.obs;
  final maxMileage = ''.obs;
  final minYear = ''.obs;
  final maxYear = ''.obs;
  final selectedBrand = ''.obs;
  final selectedModel = ''.obs;
  final derivative = ''.obs;
  final selectedBodyType = ''.obs;
  final selectedColor = ''.obs;
  final doors = ''.obs;
  final postcode = ''.obs;
  final national = false.obs;
  final sort = ''.obs;

  final RxList<String> selectedFuelTypes = <String>[].obs;
  final RxList<String> selectedTransmissions = <String>[].obs;
  final RxList<String> selectedSellerTypes = <String>[].obs;
  final RxList<String> selectedConditions = <String>[].obs;

  final RxList<String> brands = <String>[].obs;
  final RxList<String> models = <String>[].obs;
  final RxList<String> conditions = <String>[].obs;
  final RxList<String> years = <String>[].obs;
  final RxList<String> colors = <String>[].obs;
  final RxList<String> transmissions = <String>[].obs;
  final RxList<String> fuelTypes = <String>[].obs;

  final List<String> sellerTypes = const ['Private', 'Trade'];
  final List<String> bodyTypes = const [
    'SUV',
    'Saloon',
    'Hatchback',
    'Estate',
    'Coupe',
    'Convertible',
    'MPV',
    'Pickup',
    'Van',
  ];
  final List<String> sortOptions = const [
    'price_asc',
    'price_desc',
    'mileage_asc',
    'mileage_desc',
    'newest_listed',
    'distance_from_postcode',
  ];

  @override
  void onInit() {
    super.onInit();
    fetchFilterData();
  }

  Future<void> fetchFilterData() async {
    final success = await allFilterController.getAllFilter('filter');
    if (success && allFilterController.allReviewModel != null) {
      final data = allFilterController.allReviewModel!;
      brands.assignAll(data.brand);
      models.assignAll(data.model);
      conditions.assignAll(data.condition);
      years.assignAll(data.year);
      colors.assignAll(data.color);
      transmissions.assignAll(data.transmission);
      fuelTypes.assignAll(data.fuelType);
    }
  }

  void selectBrand(String value) {
    selectedBrand.value = selectedBrand.value == value ? '' : value;
  }

  void selectModel(String value) {
    selectedModel.value = selectedModel.value == value ? '' : value;
  }

  void selectBodyType(String value) {
    selectedBodyType.value = selectedBodyType.value == value ? '' : value;
  }

  void selectColor(String value) {
    selectedColor.value = value;
  }

  void toggleNational(bool value) {
    national.value = value;
    if (value) {
      postcode.value = '';
    }
  }

  void toggleMultiValue(RxList<String> values, String item) {
    if (values.contains(item)) {
      values.remove(item);
    } else {
      values.add(item);
    }
  }

  void resetFilters() {
    searchTerm.value = '';
    minPrice.value = '';
    maxPrice.value = '';
    minMileage.value = '';
    maxMileage.value = '';
    minYear.value = '';
    maxYear.value = '';
    selectedBrand.value = '';
    selectedModel.value = '';
    derivative.value = '';
    selectedBodyType.value = '';
    selectedColor.value = '';
    doors.value = '';
    postcode.value = '';
    national.value = false;
    sort.value = '';
    selectedFuelTypes.clear();
    selectedTransmissions.clear();
    selectedSellerTypes.clear();
    selectedConditions.clear();
  }

  Map<String, dynamic> getSelectedFilters() {
    final Map<String, dynamic> filters = {};

    if (searchTerm.value.isNotEmpty) filters['searchTerm'] = searchTerm.value;
    if (selectedBrand.value.isNotEmpty) filters['make'] = selectedBrand.value;
    if (selectedModel.value.isNotEmpty) filters['model'] = selectedModel.value;
    if (derivative.value.isNotEmpty) filters['derivative'] = derivative.value;
    if (minPrice.value.isNotEmpty) filters['priceMin'] = minPrice.value;
    if (maxPrice.value.isNotEmpty) filters['priceMax'] = maxPrice.value;
    if (minMileage.value.isNotEmpty) filters['mileageMin'] = minMileage.value;
    if (maxMileage.value.isNotEmpty) filters['mileageMax'] = maxMileage.value;
    if (minYear.value.isNotEmpty) filters['yearMin'] = minYear.value;
    if (maxYear.value.isNotEmpty) filters['yearMax'] = maxYear.value;
    if (selectedFuelTypes.isNotEmpty) {
      filters['fuel'] = selectedFuelTypes.join(',');
    }
    if (selectedTransmissions.isNotEmpty) {
      filters['transmission'] = selectedTransmissions.join(',');
    }
    if (selectedBodyType.value.isNotEmpty) {
      filters['bodyType'] = selectedBodyType.value;
    }
    if (selectedColor.value.isNotEmpty) filters['color'] = selectedColor.value;
    if (doors.value.isNotEmpty) filters['doors'] = doors.value;
    if (selectedSellerTypes.isNotEmpty) {
      filters['sellerType'] = selectedSellerTypes.join(',');
    }
    if (selectedConditions.isNotEmpty) {
      filters['condition'] = selectedConditions.join(',');
    }
    if (national.value) {
      filters['national'] = 'true';
    } else if (postcode.value.isNotEmpty) {
      filters['postcode'] = postcode.value;
    }
    if (sort.value.isNotEmpty) filters['sort'] = sort.value;

    return filters;
  }
}
