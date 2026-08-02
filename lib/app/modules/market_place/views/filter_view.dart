import 'dart:developer';

import 'package:dirve_society/common/widgets/custom_button.dart';
import 'package:dirve_society/common/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../common/app_color/app_colors.dart';
import '../../../../common/app_images/app_images.dart';
import '../../../../common/app_text_style/styles.dart';
import '../../../../common/size_box/custom_sizebox.dart';
import '../controllers/all_filter_controller.dart';
import '../controllers/filter_controller.dart';

class FilterView extends GetView<FilterController> {
  const FilterView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(AllFilterController());
    Get.put(FilterController());

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
      body: GetBuilder<AllFilterController>(
        builder: (allFilterController) {
          if (allFilterController.inProgress) {
            return const Center(child: CircularProgressIndicator());
          }
          if (allFilterController.errorMessage != null) {
            return Center(
              child: Text('Error: ${allFilterController.errorMessage}'),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                sh16,
                _buildSectionTitle('Search'),
                sh8,
                CustomTextField(
                  hintText: 'Search make, model or keyword',
                  onChange: (value) => controller.searchTerm.value = value,
                ),
                sh16,
                _buildSectionTitle('Price'),
                sh8,
                _buildRangeRow(
                  minHint: 'Min price',
                  maxHint: 'Max price',
                  onMinChanged: (value) => controller.minPrice.value = value,
                  onMaxChanged: (value) => controller.maxPrice.value = value,
                ),
                sh16,
                Obx(
                  () => _buildDropdown(
                    hint: 'Select Brand',
                    items: controller.brands,
                    selected: controller.selectedBrand.value,
                    onChanged: (value) => controller.selectBrand(value!),
                  ),
                ),
                sh12,
                Obx(
                  () => _buildDropdown(
                    hint: 'Select Model',
                    items: controller.models,
                    selected: controller.selectedModel.value,
                    onChanged: (value) => controller.selectModel(value!),
                  ),
                ),
                sh16,
                _buildSectionTitle('Derivative'),
                sh8,
                CustomTextField(
                  hintText: 'e.g. 1.8 Hybrid Design',
                  onChange: (value) => controller.derivative.value = value,
                ),
                sh16,
                _buildSectionTitle('Mileage'),
                sh8,
                _buildRangeRow(
                  minHint: 'Min mileage',
                  maxHint: 'Max mileage',
                  onMinChanged: (value) => controller.minMileage.value = value,
                  onMaxChanged: (value) => controller.maxMileage.value = value,
                ),
                sh16,
                _buildSectionTitle('Year'),
                sh8,
                _buildRangeRow(
                  minHint: 'Min year',
                  maxHint: 'Max year',
                  onMinChanged: (value) => controller.minYear.value = value,
                  onMaxChanged: (value) => controller.maxYear.value = value,
                ),
                sh16,
                _buildSectionTitle('Fuel Type'),
                sh8,
                Obx(
                  () => _buildMultiChips(
                    items: controller.fuelTypes,
                    selectedItems: controller.selectedFuelTypes,
                    onTap: (value) => controller.toggleMultiValue(
                      controller.selectedFuelTypes,
                      value,
                    ),
                  ),
                ),
                sh16,
                _buildSectionTitle('Transmission'),
                sh8,
                Obx(
                  () => _buildMultiChips(
                    items: controller.transmissions,
                    selectedItems: controller.selectedTransmissions,
                    onTap: (value) => controller.toggleMultiValue(
                      controller.selectedTransmissions,
                      value,
                    ),
                  ),
                ),
                sh16,
                _buildSectionTitle('Condition'),
                sh8,
                Obx(
                  () => _buildMultiChips(
                    items: controller.conditions,
                    selectedItems: controller.selectedConditions,
                    onTap: (value) => controller.toggleMultiValue(
                      controller.selectedConditions,
                      value,
                    ),
                  ),
                ),
                sh16,
                _buildSectionTitle('Body Type'),
                sh8,
                Obx(
                  () => _buildDropdown(
                    hint: 'Select Body Type',
                    items: controller.bodyTypes,
                    selected: controller.selectedBodyType.value,
                    onChanged: (value) => controller.selectBodyType(value!),
                  ),
                ),
                sh16,
                _buildSectionTitle('Colour'),
                sh8,
                Obx(
                  () => _buildDropdown(
                    hint: 'Select Colour',
                    items: [...controller.colors, 'Custom'],
                    selected: controller.selectedColor.value,
                    onChanged: (value) {
                      if (value == 'Custom') {
                        _showCustomColorDialog(context);
                      } else if (value != null) {
                        controller.selectColor(value);
                      }
                    },
                  ),
                ),
                sh16,
                _buildSectionTitle('Doors'),
                sh8,
                CustomTextField(
                  hintText: 'Enter number of doors',
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChange: (value) => controller.doors.value = value,
                ),
                sh16,
                _buildSectionTitle('Seller Type'),
                sh8,
                Obx(
                  () => _buildMultiChips(
                    items: controller.sellerTypes,
                    selectedItems: controller.selectedSellerTypes,
                    onTap: (value) => controller.toggleMultiValue(
                      controller.selectedSellerTypes,
                      value,
                    ),
                  ),
                ),
                sh16,
                Obx(
                  () => SwitchListTile.adaptive(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      'Search Nationally',
                      style: h4.copyWith(fontWeight: FontWeight.bold),
                    ),
                    subtitle: const Text(
                      'Ignore postcode when enabled.',
                    ),
                    value: controller.national.value,
                    activeColor: AppColors.darkRed,
                    onChanged: controller.toggleNational,
                  ),
                ),
                Obx(
                  () => controller.national.value
                      ? const SizedBox.shrink()
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            sh8,
                            _buildSectionTitle('Postcode'),
                            sh8,
                            CustomTextField(
                              hintText: 'Enter postcode',
                              onChange: (value) =>
                                  controller.postcode.value = value,
                            ),
                          ],
                        ),
                ),
                sh16,
                _buildSectionTitle('Sort'),
                sh8,
                Obx(
                  () => _buildDropdown(
                    hint: 'Select sort order',
                    items: controller.sortOptions,
                    selected: controller.sort.value,
                    onChanged: (value) {
                      controller.sort.value = value ?? '';
                    },
                  ),
                ),
                sh24,
              ],
            ),
          );
        },
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
              width: 80,
              text: 'Reset',
              onPressed: () {
                controller.resetFilters();
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
                final filters = controller.getSelectedFilters();
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

  Widget _buildRangeRow({
    required String minHint,
    required String maxHint,
    required ValueChanged<String> onMinChanged,
    required ValueChanged<String> onMaxChanged,
  }) {
    return Row(
      children: [
        Expanded(
          child: CustomTextField(
            hintText: minHint,
            borderColor: AppColors.darkRed,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChange: onMinChanged,
          ),
        ),
        sw16,
        Expanded(
          child: CustomTextField(
            hintText: maxHint,
            borderColor: AppColors.darkRed,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChange: onMaxChanged,
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
    final safeItems = items.where((item) => item.trim().isNotEmpty).toSet().toList();
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      ),
      value: selected.isEmpty || !safeItems.contains(selected) ? null : selected,
      items: safeItems
          .map((item) => DropdownMenuItem(value: item, child: Text(item)))
          .toList(),
      onChanged: onChanged,
      dropdownColor: Colors.white,
      icon: const Icon(Icons.keyboard_arrow_down),
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
        final isSelected = selectedItems.contains(item);
        return _chip(
          label: item,
          selected: isSelected,
          onTap: () => onTap(item),
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

  void _showCustomColorDialog(BuildContext context) {
    final textController = TextEditingController();
    Get.dialog(
      AlertDialog(
        title: const Text('Enter Custom Colour'),
        content: CustomTextField(
          controller: textController,
          hintText: 'e.g. Midnight Blue',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final color = textController.text.trim();
              if (color.isNotEmpty) controller.selectColor(color);
              Get.back();
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
