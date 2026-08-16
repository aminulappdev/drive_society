import 'dart:convert';
import 'dart:io';

import 'package:dirve_society/app/modules/profile/controllers/add_car_controller.dart';
import 'package:dirve_society/app/modules/profile/controllers/my_club_controller.dart';
import 'package:dirve_society/app/modules/profile/controllers/my_garage_controller.dart';
import 'package:dirve_society/common/widgets/custom_button.dart';
import 'package:dirve_society/common/widgets/custom_circular_container.dart';
import 'package:dirve_society/common/widgets/custom_snackbar_widget.dart';
import 'package:dirve_society/common/widgets/custom_textfield.dart';
import 'package:dirve_society/common/widgets/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../common/app_color/app_colors.dart';
import '../../../../common/app_images/app_images.dart';
import '../../../../common/app_text_style/styles.dart';
import '../../../../common/helper/upload_widget.dart';
import '../../../../common/size_box/custom_sizebox.dart';

class AddCarView extends StatefulWidget {
  const AddCarView({super.key});

  @override
  State<AddCarView> createState() => _AddCarViewState();
}

class _AddCarViewState extends State<AddCarView> {
  static const int _maxCarImages = 6;

  static const List<String> _bodyTypes = <String>[
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

  static const List<String> _fuelTypes = <String>[
    'Petrol',
    'Diesel',
    'Electric',
    'Hybrid - Petrol',
    'Hybrid - Diesel',
    'Plug-in Hybrid',
    'LPG',
  ];

  static const List<String> _transmissions = <String>[
    'Manual',
    'Automatic',
    'Semi-Automatic',
  ];

  static const List<String> _conditions = <String>[
    'New',
    'Used',
    'Nearly New / Ex-Demo',
  ];

  static const List<String> _sellerTypes = <String>[
    'Private',
    'Trade/Dealer',
  ];

  static const List<String> _serviceHistories = <String>[
    'Full',
    'Part',
    'None',
  ];

  static const List<String> _writeOffCategories = <String>[
    'Exclude Cat N/S',
    'Include Cat N/S',
    'Cat N only',
    'Cat S only',
  ];

  static const List<String> _roadTaxBands = <String>[
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

  static const List<String> _drivetrainOptions = <String>[
    'FWD',
    'RWD',
    'AWD/4WD',
  ];

  static const List<String> _zeroToSixtyOptions = <String>[
    'Under 4s',
    '4-6s',
    '6-8s',
    '8-10s',
    '10s+',
  ];

  static const List<String> _doorOptions = <String>[
    '2',
    '3',
    '4',
    '5+',
  ];

  static const List<String> _seatOptions = <String>[
    '2',
    '4',
    '5',
    '6',
    '7+',
  ];

  static const List<String> _buildStatusOptions = <String>[
    'Stock',
    'Modified',
    'Track-prepped',
    'Project car',
  ];

  static const Map<String, List<String>> _featureGroups =
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

  final TextEditingController brandController = TextEditingController();
  final TextEditingController modelController = TextEditingController();
  final TextEditingController derivativeController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController postcodeController = TextEditingController();

  final TextEditingController fuelTypeController =
      TextEditingController(text: _fuelTypes.first);
  final TextEditingController transmissionController =
      TextEditingController(text: _transmissions[1]);
  final TextEditingController conditionController =
      TextEditingController(text: _conditions[1]);
  final TextEditingController sellerTypeController =
      TextEditingController(text: _sellerTypes.first);
  final TextEditingController bodyTypeController = TextEditingController();
  final TextEditingController colorController = TextEditingController();
  final TextEditingController yearController = TextEditingController();
  final TextEditingController mileageController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController monthlyPaymentController =
      TextEditingController();
  final TextEditingController doorsController = TextEditingController();
  final TextEditingController seatsController = TextEditingController();
  final TextEditingController engineSizeController = TextEditingController();
  final TextEditingController powerController = TextEditingController();
  final TextEditingController zeroToSixtyController = TextEditingController();
  final TextEditingController drivetrainController = TextEditingController();
  final TextEditingController co2EmissionsController = TextEditingController();
  final TextEditingController previousOwnersController =
      TextEditingController();
  final TextEditingController serviceHistoryController =
      TextEditingController();
  final TextEditingController numberOfKeysController = TextEditingController();
  final TextEditingController writeOffCategoryController =
      TextEditingController();
  final TextEditingController roadTaxBandController = TextEditingController();
  final TextEditingController mpgController = TextEditingController();
  final TextEditingController clubIdController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final AddCarController addCarController = Get.put(AddCarController());
  final MyGarageController myGarageController = Get.put(MyGarageController());
  final MyClubController myClubController = Get.put(MyClubController());

  File? bannerImage;
  final List<File> carImages = <File>[];
  final ImagePickerHelper _imagePickerHelper = ImagePickerHelper();
  final ImagePicker _carImagePicker = ImagePicker();

  final List<String> _brands = <String>[];
  final Map<String, List<String>> _modelsByBrand = <String, List<String>>{};
  final List<String> _availableModels = <String>[];
  final List<String> _clubNames = <String>[];
  final Map<String, String> _clubIdsByName = <String, String>{};
  final List<String> _selectedFeatures = <String>[];
  final List<String> _selectedBuildStatuses = <String>[];

  bool _isLoadingCarData = true;
  bool _isLoadingClubs = true;
  bool? _ulezCompliant;
  bool? _eventReady;

  @override
  void initState() {
    super.initState();
    _loadCarData();
    _loadClubs();
  }

  @override
  void dispose() {
    brandController.dispose();
    modelController.dispose();
    derivativeController.dispose();
    descriptionController.dispose();
    postcodeController.dispose();
    fuelTypeController.dispose();
    transmissionController.dispose();
    conditionController.dispose();
    sellerTypeController.dispose();
    bodyTypeController.dispose();
    colorController.dispose();
    yearController.dispose();
    mileageController.dispose();
    priceController.dispose();
    monthlyPaymentController.dispose();
    doorsController.dispose();
    seatsController.dispose();
    engineSizeController.dispose();
    powerController.dispose();
    zeroToSixtyController.dispose();
    drivetrainController.dispose();
    co2EmissionsController.dispose();
    previousOwnersController.dispose();
    serviceHistoryController.dispose();
    numberOfKeysController.dispose();
    writeOffCategoryController.dispose();
    roadTaxBandController.dispose();
    mpgController.dispose();
    clubIdController.dispose();
    super.dispose();
  }

  InputDecoration _dropdownDecoration() {
    return InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }

  Future<void> _loadCarData() async {
    try {
      final String jsonString =
          await rootBundle.loadString('assets/data/cars.json');
      final List<dynamic> jsonData = jsonDecode(jsonString) as List<dynamic>;

      final Map<String, List<String>> parsedModels = <String, List<String>>{};
      for (final dynamic item in jsonData) {
        if (item is! Map<String, dynamic>) {
          continue;
        }

        final String brand = (item['make'] ?? '').toString().trim();
        final List<String> models =
            ((item['models'] as List<dynamic>? ?? <dynamic>[]))
                .map((dynamic model) => model.toString().trim())
                .where((String model) => model.isNotEmpty)
                .toList();

        if (brand.isEmpty) {
          continue;
        }

        parsedModels[brand] = models;
      }

      if (!mounted) return;
      setState(() {
        _modelsByBrand
          ..clear()
          ..addAll(parsedModels);
        _brands
          ..clear()
          ..addAll(parsedModels.keys);
        _isLoadingCarData = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isLoadingCarData = false;
      });
    }
  }

  Future<void> _loadClubs() async {
    try {
      final bool success = await myClubController.getMyClub();
      if (!mounted) return;
      setState(() {
        if (success) {
          _clubIdsByName.clear();
          _clubNames.clear();
          for (final club in myClubController.myClubList ?? <dynamic>[]) {
            final String name = club.name?.trim() ?? '';
            final String id = club.id?.trim() ?? '';
            if (name.isEmpty || id.isEmpty) {
              continue;
            }
            _clubNames.add(name);
            _clubIdsByName[name] = id;
          }
        }
        _isLoadingClubs = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isLoadingClubs = false;
      });
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

  String _formatCurrency(int amount) => '\u00A3${_formatNumber(amount)}';

  String _clubNameFromId(String id) {
    for (final MapEntry<String, String> entry in _clubIdsByName.entries) {
      if (entry.value == id) {
        return entry.key;
      }
    }
    return '';
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

  int? _parseDisplayNumber(String value) {
    final String cleaned = value.replaceAll(RegExp(r'[^0-9.]'), '');
    if (cleaned.isEmpty) {
      return null;
    }
    return double.tryParse(cleaned)?.round();
  }

  double? _parseDisplayDouble(String value) {
    final String cleaned = value.replaceAll(RegExp(r'[^0-9.]'), '');
    if (cleaned.isEmpty) {
      return null;
    }
    return double.tryParse(cleaned);
  }

  bool _isValidUkPostcode(String value) {
    final RegExp postcodeRegex = RegExp(
      r'^[A-Z]{1,2}\d[A-Z\d]?\s?\d[A-Z]{2}$',
      caseSensitive: false,
    );
    return postcodeRegex.hasMatch(value.trim());
  }

  Widget _buildLabel(String title) {
    return Text(title, style: h5);
  }

  Widget _buildDropdownField({
    required String value,
    required String hint,
    required List<String> items,
    required ValueChanged<String?>? onChanged,
    String? Function(String?)? validator,
  }) {
    return DropdownButtonFormField<String>(
      decoration: _dropdownDecoration(),
      value: value.isEmpty || !items.contains(value) ? null : value,
      hint: Text(hint),
      items: items
          .map(
            (String item) => DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          )
          .toList(),
      onChanged: onChanged,
      validator: validator,
      isExpanded: true,
    );
  }

  Widget _buildBoolChoice(
      String title, bool? currentValue, ValueChanged<bool> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(title),
        sh8,
        Row(
          children: [
            _buildChip(
              label: 'Yes',
              selected: currentValue == true,
              onTap: () => onChanged(true),
            ),
            sw8,
            _buildChip(
              label: 'No',
              selected: currentValue == false,
              onTap: () => onChanged(false),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildChip({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: selected ? AppColors.darkRed : AppColors.silver,
        ),
        child: Text(
          label,
          style: h6.copyWith(color: selected ? Colors.white : Colors.black),
        ),
      ),
    );
  }

  Widget _buildSingleChoiceChips({
    required List<String> items,
    required String selectedValue,
    required ValueChanged<String> onChanged,
  }) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: items.map((String item) {
        return _buildChip(
          label: item,
          selected: selectedValue == item,
          onTap: () => onChanged(item),
        );
      }).toList(),
    );
  }

  Widget _buildMultiChoiceChips({
    required List<String> items,
    required List<String> selectedItems,
    required ValueChanged<String> onTap,
  }) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: items.map((String item) {
        return _buildChip(
          label: item,
          selected: selectedItems.contains(item),
          onTap: () => onTap(item),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<String> priceOptions = _buildPriceOptions();
    final List<String> monthlyPaymentOptions = _buildMonthlyPaymentOptions();
    final List<String> yearOptions = _buildYearOptions();
    final List<String> mileageOptions = _buildMileageOptions();
    final List<String> engineSizeOptions = _buildEngineSizeOptions();
    final List<String> powerOptions = _buildPowerOptions();
    final List<String> co2Options = _buildCo2Options();
    final List<String> mpgOptions = _buildMpgOptions();

    return Scaffold(
      backgroundColor: AppColors.mainColor,
      appBar: AppBar(
        backgroundColor: AppColors.mainColor,
        scrolledUnderElevation: 0,
        title: Text('Add Car', style: appBarStyle),
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: CustomCircularContainer(
            imagePath: AppImages.back,
            onTap: Get.back,
            padding: 4,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                sh30,
                _buildLabel('Brand'),
                sh8,
                _buildDropdownField(
                  value: brandController.text,
                  hint: _isLoadingCarData
                      ? 'Loading brands...'
                      : 'Select car brand',
                  items: _brands,
                  onChanged: _isLoadingCarData
                      ? null
                      : (String? value) {
                          setState(() {
                            brandController.text = value ?? '';
                            modelController.clear();
                            _availableModels
                              ..clear()
                              ..addAll(_modelsByBrand[brandController.text] ??
                                  <String>[]);
                          });
                        },
                  validator: (value) => value == null || value.isEmpty
                      ? 'Brand is required'
                      : null,
                ),
                sh16,
                _buildLabel('Model'),
                sh8,
                _buildDropdownField(
                  value: modelController.text,
                  hint: brandController.text.isEmpty
                      ? 'Select brand first'
                      : 'Select car model',
                  items: _availableModels,
                  onChanged: brandController.text.isEmpty
                      ? null
                      : (String? value) {
                          setState(() {
                            modelController.text = value ?? '';
                          });
                        },
                  validator: (value) => value == null || value.isEmpty
                      ? 'Model is required'
                      : null,
                ),
                sh16,
                _buildLabel('Derivative'),
                sh8,
                CustomTextField(
                  hintText: 'Enter trim or derivative (optional)',
                  controller: derivativeController,
                ),
                sh16,
                _buildLabel('Selling Price'),
                sh8,
                _buildDropdownField(
                  value: priceController.text,
                  hint: 'Select selling price',
                  items: priceOptions,
                  onChanged: (String? value) {
                    setState(() {
                      priceController.text = value ?? '';
                    });
                  },
                  validator: (value) => value == null || value.isEmpty
                      ? 'Price is required'
                      : null,
                ),
                sh16,
                _buildLabel('Monthly Payment'),
                sh8,
                _buildDropdownField(
                  value: monthlyPaymentController.text,
                  hint: 'Select monthly payment (optional)',
                  items: monthlyPaymentOptions,
                  onChanged: (String? value) {
                    setState(() {
                      monthlyPaymentController.text = value ?? '';
                    });
                  },
                ),
                sh16,
                _buildLabel('Year'),
                sh8,
                _buildDropdownField(
                  value: yearController.text,
                  hint: 'Select year',
                  items: yearOptions,
                  onChanged: (String? value) {
                    setState(() {
                      yearController.text = value ?? '';
                    });
                  },
                  validator: (value) => value == null || value.isEmpty
                      ? 'Year is required'
                      : null,
                ),
                sh16,
                _buildLabel('Mileage (Miles)'),
                sh8,
                _buildDropdownField(
                  value: mileageController.text,
                  hint: 'Select mileage',
                  items: mileageOptions,
                  onChanged: (String? value) {
                    setState(() {
                      mileageController.text = value ?? '';
                    });
                  },
                  validator: (value) => value == null || value.isEmpty
                      ? 'Mileage is required'
                      : null,
                ),
                sh16,
                _buildLabel('Fuel Type'),
                sh8,
                _buildDropdownField(
                  value: fuelTypeController.text,
                  hint: 'Select fuel type',
                  items: _fuelTypes,
                  onChanged: (String? value) {
                    setState(() {
                      fuelTypeController.text = value ?? '';
                    });
                  },
                  validator: (value) => value == null || value.isEmpty
                      ? 'Fuel type is required'
                      : null,
                ),
                sh16,
                _buildLabel('Transmission'),
                sh8,
                _buildDropdownField(
                  value: transmissionController.text,
                  hint: 'Select transmission',
                  items: _transmissions,
                  onChanged: (String? value) {
                    setState(() {
                      transmissionController.text = value ?? '';
                    });
                  },
                  validator: (value) => value == null || value.isEmpty
                      ? 'Transmission is required'
                      : null,
                ),
                sh16,
                _buildLabel('Body Type'),
                sh8,
                _buildDropdownField(
                  value: bodyTypeController.text,
                  hint: 'Select body type',
                  items: _bodyTypes,
                  onChanged: (String? value) {
                    setState(() {
                      bodyTypeController.text = value ?? '';
                    });
                  },
                ),
                sh16,
                _buildLabel('Condition'),
                sh8,
                _buildDropdownField(
                  value: conditionController.text,
                  hint: 'Select condition',
                  items: _conditions,
                  onChanged: (String? value) {
                    setState(() {
                      conditionController.text = value ?? '';
                    });
                  },
                  validator: (value) => value == null || value.isEmpty
                      ? 'Condition is required'
                      : null,
                ),
                sh16,
                _buildLabel('Doors'),
                sh8,
                _buildSingleChoiceChips(
                  items: _doorOptions,
                  selectedValue: doorsController.text,
                  onChanged: (String value) {
                    setState(() {
                      doorsController.text = value;
                    });
                  },
                ),
                sh16,
                _buildLabel('Seats'),
                sh8,
                _buildSingleChoiceChips(
                  items: _seatOptions,
                  selectedValue: seatsController.text,
                  onChanged: (String value) {
                    setState(() {
                      seatsController.text = value;
                    });
                  },
                ),
                sh16,
                _buildLabel('Engine Size'),
                sh8,
                _buildDropdownField(
                  value: engineSizeController.text,
                  hint: 'Select engine size (optional)',
                  items: engineSizeOptions,
                  onChanged: (String? value) {
                    setState(() {
                      engineSizeController.text = value ?? '';
                    });
                  },
                ),
                sh16,
                _buildLabel('Power'),
                sh8,
                _buildDropdownField(
                  value: powerController.text,
                  hint: 'Select power (optional)',
                  items: powerOptions,
                  onChanged: (String? value) {
                    setState(() {
                      powerController.text = value ?? '';
                    });
                  },
                ),
                sh16,
                _buildLabel('0-60 mph'),
                sh8,
                _buildDropdownField(
                  value: zeroToSixtyController.text,
                  hint: 'Select 0-60 band (optional)',
                  items: _zeroToSixtyOptions,
                  onChanged: (String? value) {
                    setState(() {
                      zeroToSixtyController.text = value ?? '';
                    });
                  },
                ),
                sh16,
                _buildLabel('Drivetrain'),
                sh8,
                _buildDropdownField(
                  value: drivetrainController.text,
                  hint: 'Select drivetrain (optional)',
                  items: _drivetrainOptions,
                  onChanged: (String? value) {
                    setState(() {
                      drivetrainController.text = value ?? '';
                    });
                  },
                ),
                sh16,
                _buildLabel('CO2 Emissions'),
                sh8,
                _buildDropdownField(
                  value: co2EmissionsController.text,
                  hint: 'Select CO2 band (optional)',
                  items: co2Options,
                  onChanged: (String? value) {
                    setState(() {
                      co2EmissionsController.text = value ?? '';
                    });
                  },
                ),
                sh16,
                _buildLabel('Previous Owners'),
                sh8,
                _buildDropdownField(
                  value: previousOwnersController.text,
                  hint: 'Select previous owners (optional)',
                  items: const <String>['1', '2', '3', '4', '5+'],
                  onChanged: (String? value) {
                    setState(() {
                      previousOwnersController.text = value ?? '';
                    });
                  },
                ),
                sh16,
                _buildLabel('Service History'),
                sh8,
                _buildDropdownField(
                  value: serviceHistoryController.text,
                  hint: 'Select service history (optional)',
                  items: _serviceHistories,
                  onChanged: (String? value) {
                    setState(() {
                      serviceHistoryController.text = value ?? '';
                    });
                  },
                ),
                sh16,
                _buildLabel('Number of Keys'),
                sh8,
                _buildDropdownField(
                  value: numberOfKeysController.text,
                  hint: 'Select number of keys (optional)',
                  items: const <String>['1', '2'],
                  onChanged: (String? value) {
                    setState(() {
                      numberOfKeysController.text = value ?? '';
                    });
                  },
                ),
                sh16,
                _buildLabel('Write-off Category'),
                sh8,
                _buildDropdownField(
                  value: writeOffCategoryController.text,
                  hint: 'Select write-off category (optional)',
                  items: _writeOffCategories,
                  onChanged: (String? value) {
                    setState(() {
                      writeOffCategoryController.text = value ?? '';
                    });
                  },
                ),
                sh16,
                _buildLabel('Road Tax Band'),
                sh8,
                _buildDropdownField(
                  value: roadTaxBandController.text,
                  hint: 'Select road tax band (optional)',
                  items: _roadTaxBands,
                  onChanged: (String? value) {
                    setState(() {
                      roadTaxBandController.text = value ?? '';
                    });
                  },
                ),
                sh16,
                _buildBoolChoice(
                  'ULEZ Compliant',
                  _ulezCompliant,
                  (bool value) {
                    setState(() {
                      _ulezCompliant = _ulezCompliant == value ? null : value;
                    });
                  },
                ),
                sh16,
                _buildLabel('Minimum MPG'),
                sh8,
                _buildDropdownField(
                  value: mpgController.text,
                  hint: 'Select MPG (optional)',
                  items: mpgOptions,
                  onChanged: (String? value) {
                    setState(() {
                      mpgController.text = value ?? '';
                    });
                  },
                ),
                sh16,
                _buildLabel('Seller Type'),
                sh8,
                _buildDropdownField(
                  value: sellerTypeController.text,
                  hint: 'Select seller type',
                  items: _sellerTypes,
                  onChanged: (String? value) {
                    setState(() {
                      sellerTypeController.text = value ?? '';
                    });
                  },
                ),
                sh16,
                _buildLabel('Color'),
                sh8,
                CustomTextField(
                  hintText: 'Enter color (e.g., Blue)',
                  controller: colorController,
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Color is required';
                    }
                    return null;
                  },
                ),
                sh16,
                _buildLabel('Features'),
                sh8,
                ..._featureGroups.entries.map(
                  (MapEntry<String, List<String>> entry) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entry.key,
                        style: h6.copyWith(fontWeight: FontWeight.w700),
                      ),
                      sh8,
                      _buildMultiChoiceChips(
                        items: entry.value,
                        selectedItems: _selectedFeatures,
                        onTap: (String value) {
                          setState(() {
                            if (_selectedFeatures.contains(value)) {
                              _selectedFeatures.remove(value);
                            } else {
                              _selectedFeatures.add(value);
                            }
                          });
                        },
                      ),
                      sh12,
                    ],
                  ),
                ),
                sh8,
                _buildLabel('Build Status'),
                sh8,
                _buildMultiChoiceChips(
                  items: _buildStatusOptions,
                  selectedItems: _selectedBuildStatuses,
                  onTap: (String value) {
                    setState(() {
                      if (_selectedBuildStatuses.contains(value)) {
                        _selectedBuildStatuses.remove(value);
                      } else {
                        _selectedBuildStatuses.add(value);
                      }
                    });
                  },
                ),
                sh16,
                _buildLabel('Club Affiliation'),
                sh8,
                _buildDropdownField(
                  value: clubIdController.text.isEmpty
                      ? ''
                      : _clubNameFromId(clubIdController.text),
                  hint: _isLoadingClubs
                      ? 'Loading clubs...'
                      : 'Select club (optional)',
                  items: _clubNames,
                  onChanged: _isLoadingClubs
                      ? null
                      : (String? value) {
                          setState(() {
                            clubIdController.text = value == null
                                ? ''
                                : (_clubIdsByName[value] ?? '');
                          });
                        },
                ),
                sh16,
                _buildBoolChoice(
                  'Event-ready',
                  _eventReady,
                  (bool value) {
                    setState(() {
                      _eventReady = _eventReady == value ? null : value;
                    });
                  },
                ),
                sh16,
                _buildLabel('Postcode'),
                sh8,
                CustomTextField(
                  hintText: 'Enter postcode (optional)',
                  controller: postcodeController,
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return null;
                    }
                    if (!_isValidUkPostcode(value)) {
                      return 'Enter a valid UK postcode';
                    }
                    return null;
                  },
                ),
                sh16,
                _buildLabel('Car Description'),
                sh8,
                CustomTextField(
                  height: 120,
                  hintText:
                      'Describe your car so people know what it\'s about.',
                  controller: descriptionController,
                  maxLines: 5,
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Description is required';
                    }
                    if (value.trim().length < 10) {
                      return 'Description must be at least 10 characters';
                    }
                    return null;
                  },
                ),
                sh16,
                _buildLabel('Car Cover Photo'),
                sh8,
                UploadWidget(
                  onTap: () {
                    _imagePickerHelper.showAlertDialog(context,
                        (File? pickedImage) {
                      if (pickedImage != null) {
                        setState(() {
                          bannerImage = pickedImage;
                        });
                      }
                    });
                  },
                  imagePath: AppImages.upload,
                  imageFile: bannerImage,
                  label: 'Upload',
                  iconSize: 18,
                ),
                sh8,
                _buildLabel('Car Photos'),
                sh8,
                _buildCarImagePicker(),
                sh100,
              ],
            ),
          ),
        ),
      ),
      bottomSheet: Container(
        color: AppColors.mainColor,
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
        child: Obx(
          () => CustomButton(
            text: 'Create',
            isLoading: addCarController.inProgress,
            onPressedAsync: createCar,
          ),
        ),
      ),
    );
  }

  Future<void> createCar() async {
    if (!formKey.currentState!.validate()) {
      showSnackBarMessage(
        context,
        'Please fill all required fields correctly.',
        true,
      );
      return;
    }

    if (bannerImage == null) {
      showSnackBarMessage(context, 'Please upload a cover photo.', true);
      return;
    }

    if (carImages.isEmpty) {
      showSnackBarMessage(
          context, 'Please upload at least one car photo.', true);
      return;
    }

    final int? mileage = _parseDisplayNumber(mileageController.text);
    final int? price = _parseDisplayNumber(priceController.text);
    final int? year = int.tryParse(yearController.text.trim());

    if (mileage == null ||
        mileage < 0 ||
        price == null ||
        price <= 0 ||
        year == null) {
      showSnackBarMessage(
        context,
        'Please enter valid values for mileage, price, and year.',
        true,
      );
      return;
    }

    final bool isSuccess = await addCarController.addCar(
      brandController.text.trim(),
      modelController.text.trim(),
      mileage,
      fuelTypeController.text,
      transmissionController.text,
      descriptionController.text.trim(),
      price,
      conditionController.text,
      colorController.text.trim(),
      year,
      carImages,
      derivative: derivativeController.text.trim(),
      bodyType: bodyTypeController.text.trim(),
      doors: _parseDisplayNumber(doorsController.text),
      postcode: postcodeController.text.trim(),
      sellerType: sellerTypeController.text.trim(),
      cover: bannerImage,
      monthlyPayment: _parseDisplayNumber(monthlyPaymentController.text),
      seats: _parseDisplayNumber(seatsController.text),
      engineSize: _parseDisplayDouble(engineSizeController.text),
      powerBhp: _parseDisplayNumber(powerController.text),
      zeroToSixtyBand: zeroToSixtyController.text.trim().isEmpty
          ? null
          : zeroToSixtyController.text.trim(),
      drivetrain: drivetrainController.text.trim().isEmpty
          ? null
          : drivetrainController.text.trim(),
      co2Emissions: _parseDisplayNumber(co2EmissionsController.text),
      previousOwners: _parseDisplayNumber(previousOwnersController.text),
      serviceHistory: serviceHistoryController.text.trim().isEmpty
          ? null
          : serviceHistoryController.text.trim(),
      numberOfKeys: _parseDisplayNumber(numberOfKeysController.text),
      writeOffCategory: writeOffCategoryController.text.trim().isEmpty
          ? null
          : writeOffCategoryController.text.trim(),
      roadTaxBand: roadTaxBandController.text.trim().isEmpty
          ? null
          : roadTaxBandController.text.trim(),
      ulezCompliant: _ulezCompliant,
      mpg: _parseDisplayNumber(mpgController.text),
      features: _selectedFeatures,
      buildStatus: _selectedBuildStatuses,
      clubId: clubIdController.text.trim().isEmpty
          ? null
          : clubIdController.text.trim(),
      eventReady: _eventReady,
    );

    if (!isSuccess) {
      if (mounted) {
        showSnackBarMessage(
          context,
          addCarController.errorMessage ?? 'Failed to add car',
          true,
        );
      }
      return;
    }

    await myGarageController.getMyGarage();

    if (!mounted) return;
    brandController.clear();
    modelController.clear();
    derivativeController.clear();
    descriptionController.clear();
    postcodeController.clear();
    bodyTypeController.clear();
    colorController.clear();
    yearController.clear();
    mileageController.clear();
    priceController.clear();
    monthlyPaymentController.clear();
    doorsController.clear();
    seatsController.clear();
    engineSizeController.clear();
    powerController.clear();
    zeroToSixtyController.clear();
    drivetrainController.clear();
    co2EmissionsController.clear();
    previousOwnersController.clear();
    serviceHistoryController.clear();
    numberOfKeysController.clear();
    writeOffCategoryController.clear();
    roadTaxBandController.clear();
    mpgController.clear();
    clubIdController.clear();

    fuelTypeController.text = _fuelTypes.first;
    transmissionController.text = _transmissions[1];
    conditionController.text = _conditions[1];
    sellerTypeController.text = _sellerTypes.first;

    setState(() {
      bannerImage = null;
      carImages.clear();
      _availableModels.clear();
      _selectedFeatures.clear();
      _selectedBuildStatuses.clear();
      _ulezCompliant = null;
      _eventReady = null;
    });

    Get.back(result: true);
    Get.snackbar(
      'Success',
      'Car added successfully',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  Widget _buildCarImagePicker() {
    if (carImages.isEmpty) {
      return InkWell(
        onTap: _pickCarImages,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 140,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.grey),
            color: Colors.grey[50],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(AppImages.upload, width: 40, height: 40),
              sh8,
              Text(
                'Upload up to 6 photos',
                style: h5.copyWith(color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    final bool showAddButton = carImages.length < _maxCarImages;
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: carImages.length + (showAddButton ? 1 : 0),
      itemBuilder: (BuildContext context, int index) {
        if (showAddButton && index == carImages.length) {
          return InkWell(
            onTap: _pickCarImages,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.grey),
                color: Colors.grey[50],
              ),
              child: const Icon(Icons.add_photo_alternate_outlined, size: 36),
            ),
          );
        }

        return Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(carImages[index], fit: BoxFit.cover),
            ),
            Positioned(
              top: 4,
              right: 4,
              child: InkWell(
                onTap: () => setState(() => carImages.removeAt(index)),
                child: const CircleAvatar(
                  radius: 13,
                  backgroundColor: Colors.black54,
                  child: Icon(Icons.close, size: 17, color: Colors.white),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickCarImages() async {
    try {
      final List<XFile> pickedImages = await _carImagePicker.pickMultiImage();
      if (pickedImages.isEmpty || !mounted) return;

      final Set<String> existingPaths =
          carImages.map((File image) => image.path).toSet();
      final Iterable<File> newImages = pickedImages
          .where((XFile image) => !existingPaths.contains(image.path))
          .take(_maxCarImages - carImages.length)
          .map((XFile image) => File(image.path));

      setState(() => carImages.addAll(newImages));
    } catch (error) {
      if (mounted) {
        showSnackBarMessage(context, 'Failed to select images: $error', true);
      }
    }
  }
}
