import 'dart:convert';

import 'package:dirve_society/app/modules/profile/controllers/my_club_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class FilterController extends GetxController {
  FilterController();

  final TextEditingController keywordController = TextEditingController();
  final TextEditingController postcodeController = TextEditingController();
  final TextEditingController derivativeController = TextEditingController();

  final selectedRadius = 'National'.obs;
  final selectedBrand = ''.obs; 
  final selectedModel = ''.obs;
  final selectedMinPrice = ''.obs;
  final selectedMaxPrice = ''.obs;
  final selectedMonthlyPayment = ''.obs;
  final selectedMinYear = ''.obs;
  final selectedMaxYear = ''.obs;
  final selectedMinMileage = ''.obs;
  final selectedMaxMileage = ''.obs;
  final selectedMinEngineSize = ''.obs;
  final selectedMaxEngineSize = ''.obs;
  final selectedMinPower = ''.obs;
  final selectedMaxPower = ''.obs;
  final selectedZeroToSixty = ''.obs;
  final selectedCo2Max = ''.obs;
  final selectedDoors = ''.obs;
  final selectedSeats = ''.obs;
  final selectedMaxPreviousOwners = ''.obs;
  final selectedNumberOfKeys = ''.obs;
  final selectedMinMpg = ''.obs;
  final selectedClubAffiliation = ''.obs;
  final selectedSort = ''.obs;

  final RxnBool ulezCompliant = RxnBool();
  final RxnBool eventReady = RxnBool();

  final RxList<String> selectedBodyTypes = <String>[].obs;
  final RxList<String> selectedFuelTypes = <String>[].obs;
  final RxList<String> selectedTransmissions = <String>[].obs;
  final RxList<String> selectedDrivetrains = <String>[].obs;
  final RxList<String> selectedColors = <String>[].obs;
  final RxList<String> selectedConditions = <String>[].obs;
  final RxList<String> selectedServiceHistories = <String>[].obs;
  final RxList<String> selectedWriteOffCategories = <String>[].obs;
  final RxList<String> selectedRoadTaxBands = <String>[].obs;
  final RxList<String> selectedSellerTypes = <String>[].obs;
  final RxList<String> selectedFeatures = <String>[].obs;
  final RxList<String> selectedBuildStatuses = <String>[].obs;

  final RxList<String> brands = <String>[].obs;
  final RxList<String> models = <String>[].obs;
  final RxList<String> clubAffiliations = <String>[].obs;
  final RxBool isLoadingCars = true.obs;
  final RxBool isLoadingClubs = false.obs;

  final Map<String, List<String>> _modelsByBrand = <String, List<String>>{};
  final Map<String, String> _clubIdsByName = <String, String>{};
  final MyClubController myClubController = Get.put(MyClubController());

  static const List<String> radiusOptions = <String>[
    '5 miles',
    '10 miles',
    '20 miles',
    '30 miles',
    '50 miles',
    '70 miles',
    '100 miles',
    'National',
  ];

  static const List<String> bodyTypes = <String>[
    'Hatchback',
    'Saloon',
    'Estate',
    'SUV',
    'Coupe',
    'Convertible',
    'MPV',
    'Pickup Truck',
    'Van',
    'Minibus',
    'Camper',
  ];

  static const List<String> fuelTypes = <String>[
    'Petrol',
    'Diesel',
    'Electric',
    'Hybrid - Petrol',
    'Hybrid - Diesel',
    'Plug-in Hybrid',
    'LPG',
  ];

  static const List<String> transmissions = <String>[
    'Manual',
    'Automatic',
    'Semi-Automatic',
  ];

  static const List<String> drivetrainOptions = <String>[
    'FWD',
    'RWD',
    'AWD/4WD',
  ];

  static const List<String> zeroToSixtyOptions = <String>[
    'Under 4s',
    '4-6s',
    '6-8s',
    '8-10s',
    '10s+',
  ];

  static const List<String> doorOptions = <String>[
    '2',
    '3',
    '4',
    '5+',
  ];

  static const List<String> seatOptions = <String>[
    '2',
    '4',
    '5',
    '6',
    '7+',
  ];

  static const List<String> colorOptions = <String>[
    'Black',
    'White',
    'Grey',
    'Silver',
    'Blue',
    'Red',
    'Green',
    'Yellow',
    'Orange',
    'Brown',
    'Purple',
    'Pink',
    'Gold',
    'Beige',
    'Bronze',
    'Turquoise',
    'Maroon',
    'Multicolour',
  ];

  static const List<String> conditions = <String>[
    'New',
    'Used',
    'Nearly New / Ex-Demo',
  ];

  static const List<String> serviceHistoryOptions = <String>[
    'Full',
    'Part',
    'None',
  ];

  static const List<String> writeOffCategoryOptions = <String>[
    'Exclude Cat N/S',
    'Include Cat N/S',
    'Cat N only',
    'Cat S only',
  ];

  static const List<String> roadTaxBandOptions = <String>[
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'H',
    'I',
    'J',
    'K',
    'L',
    'M',
  ];

  static const List<String> sellerTypes = <String>[
    'Private',
    'Trade/Dealer',
  ];

  static const List<String> buildStatusOptions = <String>[
    'Stock',
    'Modified',
    'Track-prepped',
    'Project car',
  ];

  static const List<String> sortOptions = <String>[
    'Distance (nearest first)',
    'Price: low to high',
    'Price: high to low',
    'Mileage: low to high',
    'Year: newest to oldest',
    'Recently listed',
  ];

  static const Map<String, List<String>> featureGroups =
      <String, List<String>>{
    'Comfort': <String>[
      'Air conditioning',
      'Climate control',
      'Heated seats',
      'Heated steering wheel',
      'Cruise control',
      'Adaptive cruise control',
      'Parking sensors (front/rear)',
      'Reversing camera',
      'Keyless entry',
      'Electric seats',
      'Leather seats',
      'Panoramic sunroof',
    ],
    'Safety': <String>[
      'ABS',
      'Multiple airbags',
      'Lane departure warning',
      'Blind spot monitor',
      'Autonomous emergency braking',
      'Isofix',
    ],
    'Media/Tech': <String>[
      'Bluetooth',
      'Apple CarPlay',
      'Android Auto',
      'Sat nav',
      'DAB radio',
      'USB/wireless charging',
      'Premium sound system',
    ],
    'Exterior': <String>[
      'Alloy wheels',
      'Tow bar',
      'Roof rails',
      'Privacy glass',
      'LED headlights',
    ],
  };

  List<String> get priceOptions => _buildPriceOptions();
  List<String> get monthlyPaymentOptions => _buildMonthlyPaymentOptions();
  List<String> get yearOptions => _buildYearOptions();
  List<String> get mileageOptions => _buildMileageOptions();
  List<String> get engineSizeOptions => _buildEngineSizeOptions();
  List<String> get powerOptions => _buildPowerOptions();
  List<String> get co2Options => _buildCo2Options();
  List<String> get maxPreviousOwnersOptions => const <String>[
        '1',
        '2',
        '3',
        '4',
        '5+',
      ];
  List<String> get numberOfKeysOptions => const <String>['1', '2'];
  List<String> get mpgOptions => _buildMpgOptions();

  @override
  void onInit() {
    super.onInit();
    _loadCarData();
    _loadClubAffiliations();
  }

  @override
  void onClose() {
    keywordController.dispose();
    postcodeController.dispose();
    derivativeController.dispose();
    super.onClose();
  }

  Future<void> _loadCarData() async {
    isLoadingCars.value = true;
    try {
      final String jsonString = await rootBundle.loadString(
        'assets/data/cars.json',
      );
      final List<dynamic> jsonData = jsonDecode(jsonString) as List<dynamic>;

      final Map<String, List<String>> parsedModels = <String, List<String>>{};
      for (final dynamic item in jsonData) {
        if (item is! Map<String, dynamic>) {
          continue;
        }

        final String brand = (item['make'] ?? '').toString().trim();
        final List<String> brandModels =
            ((item['models'] as List<dynamic>? ?? <dynamic>[]))
                .map((dynamic model) => model.toString().trim())
                .where((String model) => model.isNotEmpty)
                .toList();

        if (brand.isEmpty) {
          continue;
        }

        parsedModels[brand] = brandModels;
      }

      _modelsByBrand
        ..clear()
        ..addAll(parsedModels);
      brands.assignAll(parsedModels.keys.toList());
      models.assignAll(
        selectedBrand.value.isEmpty
            ? <String>[]
            : parsedModels[selectedBrand.value] ?? <String>[],
      );
    } catch (_) {
      brands.clear();
      models.clear();
    } finally {
      isLoadingCars.value = false;
    }
  }

  Future<void> _loadClubAffiliations() async {
    isLoadingClubs.value = true;
    try {
      final bool success = await myClubController.getMyClub();
      if (success) {
        final List<String> clubs = <String>[];
        _clubIdsByName.clear();
        for (final club in myClubController.myClubList ?? <dynamic>[]) {
          final String name = club.name?.trim() ?? '';
          final String id = club.id?.trim() ?? '';
          if (name.isEmpty || id.isEmpty) {
            continue;
          }
          clubs.add(name);
          _clubIdsByName[name] = id;
        }
        clubAffiliations.assignAll(clubs);
      } else {
        clubAffiliations.clear();
        _clubIdsByName.clear();
      }
    } finally {
      isLoadingClubs.value = false;
    }
  }

  void selectBrand(String value) {
    selectedBrand.value = value;
    selectedModel.value = '';
    models.assignAll(_modelsByBrand[value] ?? <String>[]);
  }

  void selectModel(String value) {
    selectedModel.value = value;
  }

  void toggleMultiValue(RxList<String> values, String item) {
    if (values.contains(item)) {
      values.remove(item);
    } else {
      values.add(item);
    }
  }

  void toggleSingleValue(RxString value, String item) {
    value.value = value.value == item ? '' : item;
  }

  void setNullableBool(RxnBool value, bool selected) {
    value.value = value.value == selected ? null : selected;
  }

  bool isValidUkPostcode(String value) {
    final RegExp postcodeRegex = RegExp(
      r'^[A-Z]{1,2}\d[A-Z\d]?\s?\d[A-Z]{2}$',
      caseSensitive: false,
    );
    return postcodeRegex.hasMatch(value.trim());
  }

  void resetFilters() {
    keywordController.clear();
    postcodeController.clear();
    derivativeController.clear();

    selectedRadius.value = 'National';
    selectedBrand.value = '';
    selectedModel.value = '';
    selectedMinPrice.value = '';
    selectedMaxPrice.value = '';
    selectedMonthlyPayment.value = '';
    selectedMinYear.value = '';
    selectedMaxYear.value = '';
    selectedMinMileage.value = '';
    selectedMaxMileage.value = '';
    selectedMinEngineSize.value = '';
    selectedMaxEngineSize.value = '';
    selectedMinPower.value = '';
    selectedMaxPower.value = '';
    selectedZeroToSixty.value = '';
    selectedCo2Max.value = '';
    selectedDoors.value = '';
    selectedSeats.value = '';
    selectedMaxPreviousOwners.value = '';
    selectedNumberOfKeys.value = '';
    selectedMinMpg.value = '';
    selectedClubAffiliation.value = '';
    selectedSort.value = '';
    ulezCompliant.value = null;
    eventReady.value = null;

    selectedBodyTypes.clear();
    selectedFuelTypes.clear();
    selectedTransmissions.clear();
    selectedDrivetrains.clear();
    selectedColors.clear();
    selectedConditions.clear();
    selectedServiceHistories.clear();
    selectedWriteOffCategories.clear();
    selectedRoadTaxBands.clear();
    selectedSellerTypes.clear();
    selectedFeatures.clear();
    selectedBuildStatuses.clear();
    models.clear();
  }

  Map<String, dynamic> getSelectedFilters() {
    final Map<String, dynamic> filters = <String, dynamic>{};

    if (keywordController.text.trim().isNotEmpty) {
      filters['searchTerm'] = keywordController.text.trim();
    }
    if (selectedRadius.value == 'National') {
      filters['national'] = 'true';
    } else {
      filters['radius'] = selectedRadius.value.replaceAll(' miles', '');
      if (postcodeController.text.trim().isNotEmpty) {
        filters['postcode'] = postcodeController.text.trim().toUpperCase();
      }
    }
    if (selectedBrand.value.isNotEmpty) filters['make'] = selectedBrand.value;
    if (selectedModel.value.isNotEmpty) filters['model'] = selectedModel.value;
    if (derivativeController.text.trim().isNotEmpty) {
      filters['derivative'] = derivativeController.text.trim();
    }
    if (selectedMinPrice.value.isNotEmpty) {
      filters['priceMin'] = _extractNumericValue(selectedMinPrice.value);
    }
    if (selectedMaxPrice.value.isNotEmpty) {
      filters['priceMax'] = _extractNumericValue(selectedMaxPrice.value);
    }
    if (selectedMonthlyPayment.value.isNotEmpty) {
      filters['monthlyPayment'] = _extractNumericValue(selectedMonthlyPayment.value);
    }
    if (selectedMinYear.value.isNotEmpty) {
      filters['yearMin'] = selectedMinYear.value;
    }
    if (selectedMaxYear.value.isNotEmpty) {
      filters['yearMax'] = selectedMaxYear.value;
    }
    if (selectedMinMileage.value.isNotEmpty) {
      filters['mileageMin'] = _extractNumericValue(selectedMinMileage.value);
    }
    if (selectedMaxMileage.value.isNotEmpty) {
      filters['mileageMax'] = _extractNumericValue(selectedMaxMileage.value);
    }
    if (selectedBodyTypes.isNotEmpty) {
      filters['bodyType'] = selectedBodyTypes.join(',');
    }
    if (selectedFuelTypes.isNotEmpty) {
      filters['fuel'] = selectedFuelTypes.join(',');
    }
    if (selectedTransmissions.isNotEmpty) {
      filters['transmission'] = selectedTransmissions.join(',');
    }
    if (selectedMinEngineSize.value.isNotEmpty) {
      filters['engineSize'] = _extractNumericValue(selectedMinEngineSize.value);
    }
    if (selectedMaxEngineSize.value.isNotEmpty) {
      filters['engineSize'] = _extractNumericValue(selectedMaxEngineSize.value);
    }
    if (selectedMinPower.value.isNotEmpty) {
      filters['powerBhp'] = _extractNumericValue(selectedMinPower.value);
    }
    if (selectedMaxPower.value.isNotEmpty) {
      filters['powerBhp'] = _extractNumericValue(selectedMaxPower.value);
    }
    if (selectedZeroToSixty.value.isNotEmpty) {
      filters['zeroToSixtyBand'] = selectedZeroToSixty.value;
    }
    if (selectedDrivetrains.isNotEmpty) {
      filters['drivetrain'] = selectedDrivetrains.join(',');
    }
    if (selectedCo2Max.value.isNotEmpty) {
      filters['co2Emissions'] = _extractNumericValue(selectedCo2Max.value);
    }
    if (selectedDoors.value.isNotEmpty) filters['doors'] = selectedDoors.value;
    if (selectedSeats.value.isNotEmpty) filters['seats'] = selectedSeats.value;
    if (selectedColors.isNotEmpty) filters['color'] = selectedColors.join(',');
    if (selectedConditions.isNotEmpty) {
      filters['condition'] = selectedConditions.join(',');
    }
    if (selectedMaxPreviousOwners.value.isNotEmpty) {
      filters['previousOwners'] = _extractNumericValue(selectedMaxPreviousOwners.value);
    }
    if (selectedServiceHistories.isNotEmpty) {
      filters['serviceHistory'] = selectedServiceHistories.join(',');
    }
    if (selectedNumberOfKeys.value.isNotEmpty) {
      filters['numberOfKeys'] = selectedNumberOfKeys.value;
    }
    if (selectedWriteOffCategories.isNotEmpty) {
      filters['writeOffCategory'] = selectedWriteOffCategories.join(',');
    }
    if (selectedRoadTaxBands.isNotEmpty) {
      filters['roadTaxBand'] = selectedRoadTaxBands.join(',');
    }
    if (ulezCompliant.value != null) {
      filters['ulezCompliant'] = ulezCompliant.value.toString();
    }
    if (selectedMinMpg.value.isNotEmpty) {
      filters['mpg'] = _extractNumericValue(selectedMinMpg.value);
    }
    if (selectedSellerTypes.isNotEmpty) {
      filters['sellerType'] = selectedSellerTypes.join(',');
    }
    if (selectedFeatures.isNotEmpty) {
      filters['features'] = selectedFeatures.join(',');
    }
    if (selectedBuildStatuses.isNotEmpty) {
      filters['buildStatus'] = selectedBuildStatuses.join(',');
    }
    if (selectedClubAffiliation.value.isNotEmpty) {
      filters['clubId'] =
          _clubIdsByName[selectedClubAffiliation.value] ?? selectedClubAffiliation.value;
    }
    if (eventReady.value != null) {
      filters['eventReady'] = eventReady.value.toString();
    }
    if (selectedSort.value.isNotEmpty) {
      filters['sort'] = _mapSortValue(selectedSort.value);
    }

    return filters;
  }

  String _extractNumericValue(String value) {
    return value.replaceAll(RegExp(r'[^0-9.]'), '');
  }

  String _mapSortValue(String value) {
    switch (value) {
      case 'Distance (nearest first)':
        return 'distance_from_postcode';
      case 'Price: low to high':
        return 'price_asc';
      case 'Price: high to low':
        return 'price_desc';
      case 'Mileage: low to high':
        return 'mileage_asc';
      case 'Year: newest to oldest':
        return 'year_desc';
      case 'Recently listed':
        return 'newest_listed';
      default:
        return value;
    }
  }

  List<String> _buildPriceOptions() {
    final List<String> values = <String>['\u00A30'];
    for (int price = 500; price < 20000; price += 500) {
      values.add(_formatCurrency(price));
    }
    for (int price = 20000; price <= 250000; price += 1000) {
      values.add(_formatCurrency(price));
    }
    values.add('\u00A3250,000+');
    return values;
  }

  List<String> _buildMonthlyPaymentOptions() {
    final List<String> values = <String>[];
    for (int amount = 100; amount <= 2000; amount += 50) {
      values.add(_formatCurrency(amount));
    }
    return values;
  }

  List<String> _buildYearOptions() {
    final List<String> values = <String>[];
    for (int year = 2026; year >= 1980; year--) {
      values.add(year.toString());
    }
    return values;
  }

  List<String> _buildMileageOptions() {
    final List<String> values = <String>['0'];
    for (int mileage = 5000; mileage <= 150000; mileage += 5000) {
      values.add(_formatNumber(mileage));
    }
    values.add('150,000+');
    return values;
  }

  List<String> _buildEngineSizeOptions() {
    final List<String> values = <String>[];
    for (int i = 10; i <= 60; i++) {
      values.add('${(i / 10).toStringAsFixed(1)}L');
    }
    values.add('6.0L+');
    return values;
  }

  List<String> _buildPowerOptions() {
    final List<String> values = <String>[];
    for (int bhp = 50; bhp <= 700; bhp += 25) {
      values.add('$bhp BHP');
    }
    values.add('700+ BHP');
    return values;
  }

  List<String> _buildCo2Options() {
    final List<String> values = <String>[];
    for (int amount = 50; amount <= 300; amount += 25) {
      values.add('$amount g/km');
    }
    values.add('300+ g/km');
    return values;
  }

  List<String> _buildMpgOptions() {
    final List<String> values = <String>[];
    for (int mpg = 20; mpg <= 80; mpg += 5) {
      values.add('$mpg mpg');
    }
    values.add('80+ mpg');
    return values;
  }

  String _formatCurrency(int amount) {
    return '\u00A3${_formatNumber(amount)}';
  }

  String _formatNumber(int number) {
    final String raw = number.toString();
    final StringBuffer buffer = StringBuffer();
    for (int i = 0; i < raw.length; i++) {
      final int position = raw.length - i;
      buffer.write(raw[i]);
      if (position > 1 && position % 3 == 1) {
        buffer.write(',');
      }
    }
    return buffer.toString();
  }
}
