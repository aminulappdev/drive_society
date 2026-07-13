import 'dart:io';

import 'package:dirve_society/app/modules/profile/controllers/add_car_controller.dart';
import 'package:dirve_society/app/modules/profile/controllers/my_garage_controller.dart';
import 'package:dirve_society/common/widgets/custom_snackbar_widget.dart';
import 'package:dirve_society/common/widgets/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../common/app_color/app_colors.dart';
import '../../../../common/app_images/app_images.dart';
import '../../../../common/app_text_style/styles.dart';
import '../../../../common/helper/upload_widget.dart';
import '../../../../common/size_box/custom_sizebox.dart';
import '../../../../common/widgets/custom_button.dart';
import '../../../../common/widgets/custom_circular_container.dart';
import '../../../../common/widgets/custom_textfield.dart';

class AddCarView extends StatefulWidget {
  const AddCarView({super.key});

  @override
  State<AddCarView> createState() => _AddCarViewState();
}

class _AddCarViewState extends State<AddCarView> {
  final TextEditingController brandController = TextEditingController();
  final TextEditingController modelController = TextEditingController();
  final TextEditingController fuelTypeController = TextEditingController(text: 'Gasoline');
  final TextEditingController mileageController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController transmissionController = TextEditingController(text: 'Manual');
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController conditionController = TextEditingController(text: 'New');
  final TextEditingController colorController = TextEditingController();
  final TextEditingController yearController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final AddCarController addCarController = Get.put(AddCarController());
  final MyGarageController myGarageController =
      Get.put(MyGarageController());

  File? bannerImage;
  final List<File> carImages = [];
  final ImagePickerHelper _imagePickerHelper = ImagePickerHelper();
  final ImagePicker _carImagePicker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold( 
      backgroundColor: AppColors.mainColor, 
      appBar: AppBar(
        backgroundColor: AppColors.mainColor,
        scrolledUnderElevation: 0,
        title: Text(
          'Add Car',
          style: appBarStyle,
        ),
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: CustomCircularContainer(
            imagePath: AppImages.back,
            onTap: () {
              Get.back();
            },
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
                Text(
                  'Brand',
                  style: h5,
                ),
                sh8,
                CustomTextField(
                  onChange: (String value) {},
                  hintText: 'Enter your car brand name',
                  controller: brandController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Brand is required';
                    }
                    if (value.trim().length < 2) {
                      return 'Brand must be at least 2 characters';
                    }
                    return null;
                  },
                ),
                sh16,
                Text(
                  'Model',
                  style: h5,
                ),
                sh8,
                CustomTextField(
                  onChange: (String value) {},
                  hintText: 'Enter your car model name',
                  controller: modelController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Model is required';
                    }
                    if (value.trim().length < 2) {
                      return 'Model must be at least 2 characters';
                    }
                    return null;
                  },
                ),
                sh16,
                Text(
                  'Mileage (Miles)',
                  style: h5,
                ),
                sh8,
                CustomTextField(
                  onChange: (String value) {},
                  hintText: 'Enter mileage (e.g., 4000)',
                  controller: mileageController,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Mileage is required';
                    }
                    final mileage = int.tryParse(value.trim());
                    if (mileage == null || mileage <= 0) {
                      return 'Enter a valid mileage greater than 0';
                    }
                    return null;
                  },
                ),
                sh16,
                Text(
                  'Fuel Type',
                  style: h5,
                ),
                sh8,
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
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
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                  ),
                  value: fuelTypeController.text.isEmpty
                      ? 'Gasoline'
                      : fuelTypeController.text,
                  items: ['Gasoline', 'Diesel']
                      .map((String value) => DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          ))
                      .toList(),
                  onChanged: (newValue) {
                    if (newValue != null) {
                      fuelTypeController.text = newValue;
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Fuel type is required';
                    }
                    return null;
                  },
                ),
                sh16,
                Text(
                  'Transmission',
                  style: h5,
                ),
                sh8,
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
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
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                  ),
                  value: transmissionController.text.isEmpty
                      ? 'Manual'
                      : transmissionController.text,
                  items: ['Manual', 'Automatic']
                      .map((String value) => DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          ))
                      .toList(),
                  onChanged: (newValue) {
                    if (newValue != null) {
                      transmissionController.text = newValue;
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Transmission is required';
                    }
                    return null;
                  },
                ),
                sh16,
                Text(
                  'Selling Price',
                  style: h5,
                ),
                sh8,
                CustomTextField(
                  onChange: (String value) {},
                  hintText: 'Enter selling price (e.g., 15000)',
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Price is required';
                    }
                    final price = int.tryParse(value.trim().replaceAll(r'$', ''));
                    if (price == null || price <= 0) {
                      return 'Enter a valid price greater than 0';
                    }
                    return null;
                  },
                ),
                sh16,
                Text(
                  'Year',
                  style: h5,
                ),
                sh8,
                CustomTextField(
                  onChange: (String value) {},
                  hintText: 'Enter year (e.g., 2020)',
                  controller: yearController,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Year is required';
                    }
                    final year = int.tryParse(value.trim());
                    if (year == null || year < 1900 || year > DateTime.now().year) {
                      return 'Enter a valid year between 1900 and ${DateTime.now().year}';
                    }
                    return null;
                  },
                ),
                sh16,
                Text(
                  'Condition',
                  style: h5,
                ),
                sh8,
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
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
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                  ),
                  value: conditionController.text.isEmpty
                      ? 'New'
                      : conditionController.text,
                  items: ['New', 'Used']
                      .map((String value) => DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          ))
                      .toList(),
                  onChanged: (newValue) {
                    if (newValue != null) {
                      conditionController.text = newValue;
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Condition is required';
                    }
                    return null;
                  },
                ),
                sh16,
                Text(
                  'Color',
                  style: h5,
                ),
                sh8,
                CustomTextField(
                  onChange: (String value) {},
                  hintText: 'Enter color (e.g., Red)',
                  controller: colorController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Color is required';
                    }
                    if (value.trim().length < 2) {
                      return 'Color must be at least 2 characters';
                    }
                    return null;
                  },
                ),
                sh16,
                Text(
                  'Car Description',
                  style: h5,
                ),
                sh8,
                CustomTextField(
                  onChange: (String value) {},
                  height: 120,
                  hintText: 'Describe your car so people know what it\'s about.',
                  controller: descriptionController,
                  maxLines: 5,
                  validator: (value) {
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
                Text(
                  'Car Cover Photo',
                  style: h5,
                ),
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
                Text(
                  'Car Photos',
                  style: h5,
                ),
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
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
          bottom: 20,
        ),
        child: Obx(
          () => CustomButton(
            text: 'Create',
            isLoading: addCarController.inProgress,
            onPressedAsync: () async {
              await createCar();
            },
          ),
        ),
      ),
    );
  }

  Future<void> createCar() async {
    // Validate form fields
    if (!formKey.currentState!.validate()) {
      showSnackBarMessage(
        context,
        'Please fill all required fields correctly.',
        true,
      );
      return;
    }

    // Validate cover photo
    if (bannerImage == null) {
      showSnackBarMessage(
        context,
        'Please upload a cover photo.',
        true,
      );
      return;
    }

    // Validate car photos (at least one required)
    if (carImages.isEmpty) {
      showSnackBarMessage(
        context,
        'Please upload at least one car photo.',
        true,
      );
      return;
    }

    // Validate and parse numeric fields
    int mileage = int.tryParse(mileageController.text.trim()) ?? 0;
    int price = int.tryParse(priceController.text.trim().replaceAll(r'$', '')) ?? 0;
    int year = int.tryParse(yearController.text.trim()) ?? 0;

    if (mileage <= 0 || price <= 0 || year <= 0) {
      showSnackBarMessage(
        context,
        'Please enter valid numeric values for Mileage, Price, and Year.',
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
      cover: bannerImage,
    );

    if (isSuccess) {
      // Refresh GET /cars/my-car before returning to the garage screen.
      await myGarageController.getMyGarage();

      if (mounted) {
        // Clear all form data
        brandController.clear();
        modelController.clear();
        mileageController.clear();
        priceController.clear();
        descriptionController.clear();
        colorController.clear();
        yearController.clear();
        fuelTypeController.text = 'Gasoline'; // Reset to default
        transmissionController.text = 'Manual'; // Reset to default
        conditionController.text = 'New'; // Reset to default
        setState(() {
          bannerImage = null;
          carImages.clear();
        });
        Get.back(result: true);
        Get.snackbar(
          'Success',
          'Car added successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } else {
      if (mounted) {
        showSnackBarMessage(
          context,
          addCarController.errorMessage ?? 'Failed to add car',
          true,
        );
      }
    }
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
                'Upload up to 3 photos',
                style: h5.copyWith(color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    final showAddButton = carImages.length < 3;
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: carImages.length + (showAddButton ? 1 : 0),
      itemBuilder: (context, index) {
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
      final pickedImages = await _carImagePicker.pickMultiImage();
      if (pickedImages.isEmpty || !mounted) return;

      final existingPaths = carImages.map((image) => image.path).toSet();
      final newImages = pickedImages
          .where((image) => !existingPaths.contains(image.path))
          .take(3 - carImages.length)
          .map((image) => File(image.path));

      setState(() => carImages.addAll(newImages));
    } catch (error) {
      if (mounted) {
        showSnackBarMessage(context, 'Failed to select images: $error', true);
      }
    }
  }
}
