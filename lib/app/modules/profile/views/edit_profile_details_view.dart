// ignore_for_file: deprecated_member_use, avoid_print

import 'dart:io';
import 'package:dirve_society/app/modules/profile/controllers/edit_profile_controller.dart';
import 'package:dirve_society/app/modules/profile/controllers/profile_controller.dart';
import 'package:dirve_society/common/widgets/custom_button.dart';
import 'package:dirve_society/common/widgets/location_autocomplete_field.dart';
import 'package:dirve_society/common/widgets/custom_snackbar_widget.dart';
import 'package:dirve_society/common/widgets/custom_textfield.dart';
import 'package:dirve_society/common/widgets/image_picker.dart';
import 'package:dirve_society/get_storage.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';

import '../../../../common/app_color/app_colors.dart';
import '../../../../common/app_images/app_images.dart';
import '../../../../common/app_text_style/styles.dart'; 
import '../../../../common/size_box/custom_sizebox.dart';
 
class EditProfileDetailsView extends StatefulWidget {
  const EditProfileDetailsView({super.key});

  @override
  State<EditProfileDetailsView> createState() => _EditProfileDetailsViewState();
}

class _EditProfileDetailsViewState extends State<EditProfileDetailsView> {
  static const int _bioMaxLength = 160;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController addressOneController = TextEditingController();
  final TextEditingController addressOnePoBoxController =
      TextEditingController();
  final TextEditingController addressOneCityController = TextEditingController();
  final TextEditingController addressOnePostalCodeController =
      TextEditingController();
  final TextEditingController addressOneCountryController =
      TextEditingController();
  final TextEditingController addressTwoController = TextEditingController();
  final TextEditingController addressTwoPoBoxController =
      TextEditingController();
  final TextEditingController addressTwoCityController = TextEditingController();
  final TextEditingController addressTwoPostalCodeController =
      TextEditingController();
  final TextEditingController addressTwoCountryController =
      TextEditingController();
  final EditProfileController editProfileController =
      Get.put(EditProfileController());
  final ProfileController profileController = Get.put(ProfileController());
  final formKey = GlobalKey<FormState>();

  File? image;
  File? bannerImage;
  final ImagePickerHelper _imagePickerHelper = ImagePickerHelper();
  double? _addressOneLatitude;
  double? _addressOneLongitude;
  double? _addressTwoLatitude;
  double? _addressTwoLongitude;

  @override
  void initState() {
    super.initState();

    nameController.text =
        StorageUtil.getData(StorageUtil.profileName) ?? 'No name';
    emailController.text =
        StorageUtil.getData(StorageUtil.profileEmail) ?? 'No email';
    bioController.text = StorageUtil.getData(StorageUtil.profileBio) ?? '';
    addressOneController.text =
        StorageUtil.getData(StorageUtil.profileAddress) ?? '';
    addressOnePoBoxController.text =
        StorageUtil.getData(StorageUtil.profileAddressOnePoBox) ??
            StorageUtil.getData(StorageUtil.profilePoBox) ??
            '';
    addressOneCityController.text =
        StorageUtil.getData(StorageUtil.profileAddressOneCity) ??
            StorageUtil.getData(StorageUtil.profileCity) ??
            '';
    addressOnePostalCodeController.text =
        StorageUtil.getData(StorageUtil.profileAddressOnePostalCode)
                ?.toString() ??
            StorageUtil.getData(StorageUtil.profilePostalCode)?.toString() ??
            '';
    addressOneCountryController.text =
        StorageUtil.getData(StorageUtil.profileAddressOneCountry) ??
            StorageUtil.getData(StorageUtil.profileCountry) ??
            '';
    _addressOneLatitude = _toDouble(
      StorageUtil.getData(StorageUtil.profileAddressOneLatitude),
    );
    _addressOneLongitude = _toDouble(
      StorageUtil.getData(StorageUtil.profileAddressOneLongitude),
    );
    addressTwoController.text =
        StorageUtil.getData(StorageUtil.profileAddressTwo) ?? '';
    addressTwoPoBoxController.text =
        StorageUtil.getData(StorageUtil.profileAddressTwoPoBox) ?? '';
    addressTwoCityController.text =
        StorageUtil.getData(StorageUtil.profileAddressTwoCity) ?? '';
    addressTwoPostalCodeController.text =
        StorageUtil.getData(StorageUtil.profileAddressTwoPostalCode)
                ?.toString() ??
            '';
    addressTwoCountryController.text =
        StorageUtil.getData(StorageUtil.profileAddressTwoCountry) ?? '';
    _addressTwoLatitude = _toDouble(
      StorageUtil.getData(StorageUtil.profileAddressTwoLatitude),
    );
    _addressTwoLongitude = _toDouble(
      StorageUtil.getData(StorageUtil.profileAddressTwoLongitude),
    );

    print('Name: ${StorageUtil.getData(StorageUtil.profileName)}');
    print('Email: ${StorageUtil.getData(StorageUtil.profileEmail)}');
    print('Bio: ${StorageUtil.getData(StorageUtil.profileBio)}');
    print('Address: ${StorageUtil.getData(StorageUtil.profileAddress)}');
    print('Image: ${StorageUtil.getData(StorageUtil.profilePhotoUrl)}');
    print('Banner: ${StorageUtil.getData(StorageUtil.profileCoverPhoto)}');
  }

  double? _toDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }

  Future<void> _applySelectedAddress({
    required LocationSearchResult result,
    required TextEditingController poBoxController,
    required TextEditingController cityController,
    required TextEditingController postalCodeController,
    required TextEditingController countryController,
    required void Function(double? latitude, double? longitude) onLatLng,
  }) async {
    onLatLng(result.latitude, result.longitude);

    if (result.latitude == null || result.longitude == null) {
      return;
    }

    try {
      final placemarks = await placemarkFromCoordinates(
        result.latitude!,
        result.longitude!,
      );

      if (placemarks.isEmpty || !mounted) return;

      final place = placemarks.first;
      final postalCode = place.postalCode ?? '';

      setState(() {
        poBoxController.text = postalCode;
        cityController.text =
            place.locality ?? place.subAdministrativeArea ?? '';
        postalCodeController.text = postalCode;
        countryController.text = place.country ?? '';
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        poBoxController.text = '';
        cityController.text = '';
        postalCodeController.text = '';
        countryController.text = '';
      });
    }
  }

  Widget _buildAddressMetaField(
    String label,
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: h5),
        sh5,
        CustomTextField(
          controller: controller,
          keyboardType: keyboardType,
          textColor: Colors.black,
          hintTextStyle: const TextStyle(color: Colors.black),
        ),
      ],
    );
  }

  Widget _buildAddressSection({
    required String title,
    required TextEditingController addressController,
    required TextEditingController poBoxController,
    required TextEditingController cityController,
    required TextEditingController postalCodeController,
    required TextEditingController countryController,
    required void Function(double? latitude, double? longitude) onLatLng,
    bool isRequired = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LocationAutocompleteField(
          controller: addressController,
          label: title,
          hintText: 'Search and select address',
          validator: (value) {
            if (isRequired && (value == null || value.trim().isEmpty)) {
              return '$title is required';
            }
            return null;
          },
          onSelected: (result) => _applySelectedAddress(
            result: result,
            poBoxController: poBoxController,
            cityController: cityController,
            postalCodeController: postalCodeController,
            countryController: countryController,
            onLatLng: onLatLng,
          ),
        ),
        sh12,
        _buildAddressMetaField('PO Box', poBoxController),
        sh12,
        _buildAddressMetaField('City', cityController),
        sh12,
        _buildAddressMetaField(
          'Postal Code',
          postalCodeController,
          keyboardType: TextInputType.number,
        ),
        sh12,
        _buildAddressMetaField('Country', countryController),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainColor,
      body: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                child: SizedBox(
                  height: 240,
                  width: double.infinity,
                  child: bannerImage != null
                      ? Image.file(
                          bannerImage!,
                          fit: BoxFit.cover,
                        )
                      : StorageUtil.getData(StorageUtil.profileCoverPhoto) != null
                          ? Image.network(
                              StorageUtil.getData(StorageUtil.profileCoverPhoto)!,
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              AppImages.noImage,
                              fit: BoxFit.cover,
                            ),
                ),
              ),
              Positioned(
                left: 20,
                top: 40,
                child: GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                    decoration: ShapeDecoration(
                      shape: const CircleBorder(),
                      color: AppColors.black.withOpacity(0.3),
                    ),
                    child: Image.asset(
                      AppImages.back,
                      scale: 4,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: -25,
                left: 20,
                child: CircleAvatar(
                  radius: 45,
                  backgroundColor: AppColors.white,
                  backgroundImage: image != null
                      ? FileImage(image!)
                      : StorageUtil.getData(StorageUtil.profilePhotoUrl) != null
                          ? NetworkImage(
                              StorageUtil.getData(StorageUtil.profilePhotoUrl)!,
                            )
                          : const AssetImage(AppImages.noImage),
                ),
              ),
              Positioned(
                bottom: -10,
                left: 90,
                child: InkWell(
                  onTap: () {
                    _imagePickerHelper.showAlertDialog(context, (File pickedImage) {
                      setState(() {
                        image = pickedImage;
                        print('Selected Image: $image');
                      });
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: AppColors.darkRed,
                    ),
                    child: Image.asset(
                      AppImages.camera,
                      scale: 4,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 40,
                right: 20,
                child: InkWell(
                  onTap: () {
                    _imagePickerHelper.showAlertDialog(context, (File pickedImage) {
                      setState(() {
                        bannerImage = pickedImage;
                        print('Selected Banner Image: $bannerImage');
                      });
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: const Color.fromARGB(255, 247, 247, 247),
                    ),
                    child: Image.asset(
                      AppImages.camera,
                      scale: 3.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
          sh40,
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Name', style: h5),
                      sh5,
                      CustomTextField(
                        onChange: (String value) {},
                        textColor: Colors.black,
                        controller: nameController,
                        hintTextStyle: const TextStyle(color: Colors.black),
                      ),
                      sh20,
                      Text('Email', style: h5),
                      sh5,
                      CustomTextField(
                        onChange: (String value) {},
                        textColor: Colors.black,
                        controller: emailController,
                        hintTextStyle: const TextStyle(color: Colors.black),
                      ),
                      sh20,
                      Text('Bio', style: h5),
                      sh5,
                      CustomTextField(
                        height: 110,
                        onChange: (String value) {},
                        textColor: Colors.black,
                        controller: bioController,
                        maxLines: 4,
                        maxLength: _bioMaxLength,
                        showCounterText: true,
                        hintTextStyle: const TextStyle(color: Colors.black),
                        validator: (value) {
                          final bio = value?.trim() ?? '';
                          if (bio.length > _bioMaxLength) {
                            return 'Bio must be within $_bioMaxLength characters';
                          }
                          return null;
                        },
                      ),
                      sh20,
                      _buildAddressSection(
                        title: 'Address 1',
                        addressController: addressOneController,
                        poBoxController: addressOnePoBoxController,
                        cityController: addressOneCityController,
                        postalCodeController: addressOnePostalCodeController,
                        countryController: addressOneCountryController,
                        onLatLng: (latitude, longitude) {
                          _addressOneLatitude = latitude;
                          _addressOneLongitude = longitude;
                        },
                      ),
                      sh20,
                      _buildAddressSection(
                        title: 'Address 2',
                        addressController: addressTwoController,
                        poBoxController: addressTwoPoBoxController,
                        cityController: addressTwoCityController,
                        postalCodeController: addressTwoPostalCodeController,
                        countryController: addressTwoCountryController,
                        isRequired: false,
                        onLatLng: (latitude, longitude) {
                          _addressTwoLatitude = latitude;
                          _addressTwoLongitude = longitude;
                        },
                      ),
                      sh20,
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
            child: Obx(
              () => CustomButton(
                text: 'Save',
                isLoading: editProfileController.inProgress,
                onPressedAsync: () async {
                  await editProfile();
                },
              ),
            ),
          )
        ],
      ),
    ); 
  }

  Future<void> editProfile() async {
    print('Edit profile called');
    if (formKey.currentState!.validate()) {
      final bool isSuccess = await editProfileController.updateProfile(
        nameController.text,
        bioController.text,
        {
          "address": addressOneController.text.trim(),
          "poBox": addressOnePoBoxController.text.trim(),
          "city": addressOneCityController.text.trim(),
          "postalCode":
              int.tryParse(addressOnePostalCodeController.text.trim()) ?? 0,
          "country": addressOneCountryController.text.trim(),
          "latitude": _addressOneLatitude ?? 0.0,
          "longitude": _addressOneLongitude ?? 0.0,
        },
        {
          "address": addressTwoController.text.trim(),
          "poBox": addressTwoPoBoxController.text.trim(),
          "city": addressTwoCityController.text.trim(),
          "postalCode":
              int.tryParse(addressTwoPostalCodeController.text.trim()) ?? 0,
          "country": addressTwoCountryController.text.trim(),
          "latitude": _addressTwoLatitude ?? 0.0,
          "longitude": _addressTwoLongitude ?? 0.0,
        },
        image,
        cover: bannerImage,
      );

      if (isSuccess) {
        if (mounted) {
          await profileController.fetchProfileData();
          Get.back();
        }
      } else {
        if (mounted) {
          showSnackBarMessage(
            context,
            editProfileController.errorMessage ?? 'Failed to update profile',
            true,
          );
        }
      }
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    bioController.dispose();
    addressOneController.dispose();
    addressOnePoBoxController.dispose();
    addressOneCityController.dispose();
    addressOnePostalCodeController.dispose();
    addressOneCountryController.dispose();
    addressTwoController.dispose();
    addressTwoPoBoxController.dispose();
    addressTwoCityController.dispose();
    addressTwoPostalCodeController.dispose();
    addressTwoCountryController.dispose();
    super.dispose();
  }
}
