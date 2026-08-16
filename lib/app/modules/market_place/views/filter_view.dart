import 'dart:developer';

import 'package:dirve_society/common/widgets/custom_button.dart';
import 'package:dirve_society/common/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/app_color/app_colors.dart';
import '../../../../common/app_images/app_images.dart';
import '../../../../common/app_text_style/styles.dart';
import '../../../../common/size_box/custom_sizebox.dart';
import '../controllers/filter_controller.dart';

class FilterView extends GetView<FilterController> {
  const FilterView({super.key}); 

  @override
  Widget build(BuildContext context) {
    final FilterController filterController = Get.put(FilterController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        title: const Text('Filter'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Image.asset(AppImages.close, scale: 4),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        child: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              sh16,
              _buildSectionTitle('Search'),
              sh8,
              CustomTextField(
                controller: filterController.keywordController,
                hintText: 'Search make, model, derivative or title',
              ),
              sh12,
              CustomTextField(
                controller: filterController.postcodeController,
                hintText: 'Enter postcode',
              ),
              sh12,
              _buildDropdown(
                hint: 'Select radius',
                items: FilterController.radiusOptions,
                selected: filterController.selectedRadius.value,
                onChanged: (value) {
                  if (value != null) {
                    filterController.selectedRadius.value = value;
                    if (value == 'National') {
                      filterController.postcodeController.clear();
                    }
                  }
                },
              ),
              sh16,
              _buildSectionTitle('Make & Model'),
              sh8,
              _buildDropdown(
                hint: filterController.isLoadingCars.value
                    ? 'Loading makes...'
                    : 'Select make',
                items: filterController.brands,
                selected: filterController.selectedBrand.value,
                onChanged: filterController.isLoadingCars.value
                    ? null
                    : (value) {
                        if (value != null) {
                          filterController.selectBrand(value);
                        }
                      },
              ),
              sh12,
              _buildDropdown(
                hint: filterController.selectedBrand.value.isEmpty
                    ? 'Select make first'
                    : 'Select model',
                items: filterController.models,
                selected: filterController.selectedModel.value,
                onChanged: filterController.selectedBrand.value.isEmpty
                    ? null
                    : (value) {
                        if (value != null) {
                          filterController.selectModel(value);
                        }
                      },
              ),
              sh12,
              CustomTextField(
                controller: filterController.derivativeController,
                hintText: 'Derivative / Trim e.g. M Sport',
              ),
              sh16,
              _buildSectionTitle('Price'),
              sh8,
              _buildDualDropdownRow(
                minHint: 'Min price',
                maxHint: 'Max price',
                minItems: filterController.priceOptions,
                maxItems: filterController.priceOptions,
                minSelected: filterController.selectedMinPrice.value,
                maxSelected: filterController.selectedMaxPrice.value,
                onMinChanged: (value) =>
                    filterController.selectedMinPrice.value = value ?? '',
                onMaxChanged: (value) =>
                    filterController.selectedMaxPrice.value = value ?? '',
              ),
              sh12,
              _buildDropdown(
                hint: 'Max monthly payment',
                items: filterController.monthlyPaymentOptions,
                selected: filterController.selectedMonthlyPayment.value,
                onChanged: (value) =>
                    filterController.selectedMonthlyPayment.value = value ?? '',
              ),
              sh16,
              _buildSectionTitle('Year'),
              sh8,
              _buildDualDropdownRow(
                minHint: 'Min year',
                maxHint: 'Max year',
                minItems: filterController.yearOptions,
                maxItems: filterController.yearOptions,
                minSelected: filterController.selectedMinYear.value,
                maxSelected: filterController.selectedMaxYear.value,
                onMinChanged: (value) =>
                    filterController.selectedMinYear.value = value ?? '',
                onMaxChanged: (value) =>
                    filterController.selectedMaxYear.value = value ?? '',
              ),
              sh16,
              _buildSectionTitle('Mileage'),
              sh8,
              _buildDualDropdownRow(
                minHint: 'Min mileage',
                maxHint: 'Max mileage',
                minItems: filterController.mileageOptions,
                maxItems: filterController.mileageOptions,
                minSelected: filterController.selectedMinMileage.value,
                maxSelected: filterController.selectedMaxMileage.value,
                onMinChanged: (value) =>
                    filterController.selectedMinMileage.value = value ?? '',
                onMaxChanged: (value) =>
                    filterController.selectedMaxMileage.value = value ?? '',
              ),
              sh16,
              _buildSectionTitle('Body Type'),
              sh8,
              _buildMultiChips(
                items: FilterController.bodyTypes,
                selectedItems: filterController.selectedBodyTypes,
                onTap: (value) => filterController.toggleMultiValue(
                  filterController.selectedBodyTypes,
                  value,
                ),
              ),
              sh16,
              _buildSectionTitle('Fuel Type'),
              sh8,
              _buildMultiChips(
                items: FilterController.fuelTypes,
                selectedItems: filterController.selectedFuelTypes,
                onTap: (value) => filterController.toggleMultiValue(
                  filterController.selectedFuelTypes,
                  value,
                ),
              ),
              sh16,
              _buildSectionTitle('Transmission'),
              sh8,
              _buildMultiChips(
                items: FilterController.transmissions,
                selectedItems: filterController.selectedTransmissions,
                onTap: (value) => filterController.toggleMultiValue(
                  filterController.selectedTransmissions,
                  value,
                ),
              ),
              sh16,
              _buildSectionTitle('Engine / Performance'),
              sh8,
              _buildDualDropdownRow(
                minHint: 'Min engine size',
                maxHint: 'Max engine size',
                minItems: filterController.engineSizeOptions,
                maxItems: filterController.engineSizeOptions,
                minSelected: filterController.selectedMinEngineSize.value,
                maxSelected: filterController.selectedMaxEngineSize.value,
                onMinChanged: (value) =>
                    filterController.selectedMinEngineSize.value = value ?? '',
                onMaxChanged: (value) =>
                    filterController.selectedMaxEngineSize.value = value ?? '',
              ),
              sh12,
              _buildDualDropdownRow(
                minHint: 'Min power',
                maxHint: 'Max power',
                minItems: filterController.powerOptions,
                maxItems: filterController.powerOptions,
                minSelected: filterController.selectedMinPower.value,
                maxSelected: filterController.selectedMaxPower.value,
                onMinChanged: (value) =>
                    filterController.selectedMinPower.value = value ?? '',
                onMaxChanged: (value) =>
                    filterController.selectedMaxPower.value = value ?? '',
              ),
              sh12,
              _buildDropdown(
                hint: '0-60 mph',
                items: FilterController.zeroToSixtyOptions,
                selected: filterController.selectedZeroToSixty.value,
                onChanged: (value) =>
                    filterController.selectedZeroToSixty.value = value ?? '',
              ),
              sh12,
              _buildMultiChips(
                items: FilterController.drivetrainOptions,
                selectedItems: filterController.selectedDrivetrains,
                onTap: (value) => filterController.toggleMultiValue(
                  filterController.selectedDrivetrains,
                  value,
                ),
              ),
              sh12,
              _buildDropdown(
                hint: 'Max CO2 emissions',
                items: filterController.co2Options,
                selected: filterController.selectedCo2Max.value,
                onChanged: (value) =>
                    filterController.selectedCo2Max.value = value ?? '',
              ),
              sh16,
              _buildSectionTitle('Doors & Seats'),
              sh8,
              _buildSingleChoiceChips(
                items: FilterController.doorOptions,
                selected: filterController.selectedDoors.value,
                onTap: (value) =>
                    filterController.toggleSingleValue(filterController.selectedDoors, value),
              ),
              sh12,
              _buildSingleChoiceChips(
                items: FilterController.seatOptions,
                selected: filterController.selectedSeats.value,
                onTap: (value) =>
                    filterController.toggleSingleValue(filterController.selectedSeats, value),
              ),
              sh16,
              _buildSectionTitle('Colour'),
              sh8,
              _buildColorChips(
                items: FilterController.colorOptions,
                selectedItems: filterController.selectedColors,
                onTap: (value) => filterController.toggleMultiValue(
                  filterController.selectedColors,
                  value,
                ),
              ),
              sh16,
              _buildSectionTitle('Condition'),
              sh8,
              _buildMultiChips(
                items: FilterController.conditions,
                selectedItems: filterController.selectedConditions,
                onTap: (value) => filterController.toggleMultiValue(
                  filterController.selectedConditions,
                  value,
                ),
              ),
              sh16,
              _buildSectionTitle('Owners & History'),
              sh8,
              _buildDropdown(
                hint: 'Max previous owners',
                items: filterController.maxPreviousOwnersOptions,
                selected: filterController.selectedMaxPreviousOwners.value,
                onChanged: (value) => filterController.selectedMaxPreviousOwners.value =
                    value ?? '',
              ),
              sh12,
              _buildMultiChips(
                items: FilterController.serviceHistoryOptions,
                selectedItems: filterController.selectedServiceHistories,
                onTap: (value) => filterController.toggleMultiValue(
                  filterController.selectedServiceHistories,
                  value,
                ),
              ),
              sh12,
              _buildDropdown(
                hint: 'Number of keys',
                items: filterController.numberOfKeysOptions,
                selected: filterController.selectedNumberOfKeys.value,
                onChanged: (value) =>
                    filterController.selectedNumberOfKeys.value = value ?? '',
              ),
              sh12,
              _buildMultiChips(
                items: FilterController.writeOffCategoryOptions,
                selectedItems: filterController.selectedWriteOffCategories,
                onTap: (value) => filterController.toggleMultiValue(
                  filterController.selectedWriteOffCategories,
                  value,
                ),
              ),
              sh16,
              _buildSectionTitle('Running Costs'),
              sh8,
              _buildMultiChips(
                items: FilterController.roadTaxBandOptions,
                selectedItems: filterController.selectedRoadTaxBands,
                onTap: (value) => filterController.toggleMultiValue(
                  filterController.selectedRoadTaxBands,
                  value,
                ),
              ),
              sh12,
              _buildBooleanChoice(
                title: 'ULEZ compliant',
                value: filterController.ulezCompliant.value,
                onTap: (selected) =>
                    filterController.setNullableBool(filterController.ulezCompliant, selected),
              ),
              sh12,
              _buildDropdown(
                hint: 'Minimum MPG',
                items: filterController.mpgOptions,
                selected: filterController.selectedMinMpg.value,
                onChanged: (value) =>
                    filterController.selectedMinMpg.value = value ?? '',
              ),
              sh16,
              _buildSectionTitle('Seller Type'),
              sh8,
              _buildMultiChips(
                items: FilterController.sellerTypes,
                selectedItems: filterController.selectedSellerTypes,
                onTap: (value) => filterController.toggleMultiValue(
                  filterController.selectedSellerTypes,
                  value,
                ),
              ),
              sh16,
              _buildSectionTitle('Features'),
              ...FilterController.featureGroups.entries.map(
                (entry) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    sh8,
                    Text(
                      entry.key,
                      style: h5.copyWith(fontWeight: FontWeight.w700),
                    ),
                    sh8,
                    _buildMultiChips(
                      items: entry.value,
                      selectedItems: filterController.selectedFeatures,
                      onTap: (value) => filterController.toggleMultiValue(
                        filterController.selectedFeatures,
                        value,
                      ),
                    ),
                  ],
                ),
              ),
              sh16,
              _buildSectionTitle('Drive Society'),
              sh8,
              _buildMultiChips(
                items: FilterController.buildStatusOptions,
                selectedItems: filterController.selectedBuildStatuses,
                onTap: (value) => filterController.toggleMultiValue(
                  filterController.selectedBuildStatuses,
                  value,
                ),
              ),
              sh12,
              _buildDropdown(
                hint: filterController.isLoadingClubs.value
                    ? 'Loading clubs...'
                    : 'Club affiliation',
                items: filterController.clubAffiliations,
                selected: filterController.selectedClubAffiliation.value,
                onChanged: filterController.clubAffiliations.isEmpty
                    ? null
                    : (value) => filterController.selectedClubAffiliation.value =
                        value ?? '',
              ),
              sh12,
              _buildBooleanChoice(
                title: 'Event-ready',
                value: filterController.eventReady.value,
                onTap: (selected) =>
                    filterController.setNullableBool(filterController.eventReady, selected),
              ),
              sh16,
              _buildSectionTitle('Sort'),
              sh8,
              _buildDropdown(
                hint: 'Select sort order',
                items: FilterController.sortOptions,
                selected: filterController.selectedSort.value,
                onChanged: (value) => filterController.selectedSort.value = value ?? '',
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.silver)),
          color: AppColors.bottomNavbar,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            CustomButton(
              width: 90,
              text: 'Reset',
              onPressed: () {
                filterController.resetFilters();
                log('Reset tapped');
              },
              borderColor: AppColors.black,
              textStyle: h4.copyWith(fontWeight: FontWeight.bold),
              backgroundColor: AppColors.transparent,
            ),
            sw12,
            CustomButton(
              width: 180,
              text: 'Show results',
              onPressed: () {
                final String postcode =
                    filterController.postcodeController.text.trim();
                if (filterController.selectedRadius.value != 'National' &&
                    postcode.isNotEmpty &&
                    !filterController.isValidUkPostcode(postcode)) {
                  Get.snackbar(
                    'Invalid postcode',
                    'Please enter a valid UK postcode or use National radius.',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                  return;
                }

                final Map<String, dynamic> filters =
                    filterController.getSelectedFilters();
                log('Selected Filters: $filters');
                Get.back(result: filters);
              },
              textStyle: h4.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title, style: h4.copyWith(fontWeight: FontWeight.bold));
  }

  Widget _buildDualDropdownRow({
    required String minHint,
    required String maxHint,
    required List<String> minItems,
    required List<String> maxItems,
    required String minSelected,
    required String maxSelected,
    required ValueChanged<String?> onMinChanged,
    required ValueChanged<String?> onMaxChanged,
  }) {
    return Row(
      children: [
        Expanded(
          child: _buildDropdown(
            hint: minHint,
            items: minItems,
            selected: minSelected,
            onChanged: onMinChanged,
          ),
        ),
        sw12,
        Expanded(
          child: _buildDropdown(
            hint: maxHint,
            items: maxItems,
            selected: maxSelected,
            onChanged: onMaxChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String hint,
    required List<String> items,
    required String selected,
    required Function(String?)? onChanged,
  }) {
    final List<String> safeItems =
        items.where((item) => item.trim().isNotEmpty).toSet().toList();

    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.borderColor),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      ),
      value: selected.isEmpty || !safeItems.contains(selected) ? null : selected,
      items: safeItems
          .map(
            (item) => DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          )
          .toList(),
      onChanged: onChanged,
      icon: const Icon(Icons.keyboard_arrow_down),
      isExpanded: true,
    );
  }

  Widget _buildMultiChips({
    required List<String> items,
    required List<String> selectedItems,
    required ValueChanged<String> onTap,
  }) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: items.map((item) {
        final bool isSelected = selectedItems.contains(item);
        return _chip(
          label: item,
          selected: isSelected,
          onTap: () => onTap(item),
        );
      }).toList(),
    );
  }

  Widget _buildSingleChoiceChips({
    required List<String> items,
    required String selected,
    required ValueChanged<String> onTap,
  }) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: items.map((item) {
        final bool isSelected = selected == item;
        return _chip(
          label: item,
          selected: isSelected,
          onTap: () => onTap(item),
        );
      }).toList(),
    );
  }

  Widget _buildBooleanChoice({
    required String title,
    required bool? value,
    required ValueChanged<bool> onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: h5.copyWith(fontWeight: FontWeight.w700)),
        sh8,
        Row(
          children: [
            _chip(
              label: 'Yes',
              selected: value == true,
              onTap: () => onTap(true),
            ),
            sw8,
            _chip(
              label: 'No',
              selected: value == false,
              onTap: () => onTap(false),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildColorChips({
    required List<String> items,
    required List<String> selectedItems,
    required ValueChanged<String> onTap,
  }) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: items.map((item) {
        final bool isSelected = selectedItems.contains(item);
        return GestureDetector(
          onTap: () => onTap(item),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.darkRed.withOpacity(.1) : Colors.white,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: isSelected ? AppColors.darkRed : AppColors.silver,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: _mapColor(item),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black12),
                  ),
                ),
                sw8,
                Text(
                  item,
                  style: h6.copyWith(
                    color: isSelected ? AppColors.darkRed : AppColors.black,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _chip({
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

  Color _mapColor(String colorName) {
    switch (colorName) {
      case 'Black':
        return Colors.black;
      case 'White':
        return Colors.white;
      case 'Grey':
        return Colors.grey;
      case 'Silver':
        return Colors.blueGrey.shade200;
      case 'Blue':
        return Colors.blue;
      case 'Red':
        return Colors.red;
      case 'Green':
        return Colors.green;
      case 'Yellow':
        return Colors.yellow.shade700;
      case 'Orange':
        return Colors.orange;
      case 'Brown':
        return Colors.brown;
      case 'Purple':
        return Colors.purple;
      case 'Pink':
        return Colors.pink;
      case 'Gold':
        return const Color(0xFFD4AF37);
      case 'Beige':
        return const Color(0xFFF5F5DC);
      case 'Bronze':
        return const Color(0xFFCD7F32);
      case 'Turquoise':
        return const Color(0xFF40E0D0);
      case 'Maroon':
        return const Color(0xFF800000);
      case 'Multicolour':
        return const Color(0xFF7E57C2);
      default:
        return Colors.grey;
    }
  }
}
