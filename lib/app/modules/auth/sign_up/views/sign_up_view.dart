// ignore_for_file: use_build_context_synchronously

import 'package:dirve_society/app/modules/auth/forgot_password/views/otp_verify_view.dart';
import 'package:dirve_society/app/modules/auth/login/views/login_view.dart';
import 'package:dirve_society/app/modules/auth/sign_up/controllers/sign_up_controller.dart';
import 'package:dirve_society/common/widgets/custom_background.dart';
import 'package:dirve_society/common/widgets/custom_snackbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import '../../../../../common/app_color/app_colors.dart';
import '../../../../../common/app_images/app_images.dart';
import '../../../../../common/app_text_style/styles.dart';
import '../../../../../common/size_box/custom_sizebox.dart';
import '../../../../../common/widgets/custom_button.dart';
import '../../../../../common/widgets/custom_textfield.dart';
import '../../../../../common/widgets/location_autocomplete_field.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final SignUpController signUpController = Get.put(SignUpController());
  bool isCheck = false;
  
  // Move controllers to the state class level
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final addressController = TextEditingController();
  String _poBox = '';
  String _city = '';
  String _postalCode = '';
  String _country = '';
  double _latitude = 0.0;
  double _longitude = 0.0;

  Future<void> _applySelectedAddress(LocationSearchResult result) async {
    _latitude = result.latitude ?? 0.0;
    _longitude = result.longitude ?? 0.0;

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
      setState(() {
        _postalCode = place.postalCode ?? '';
        _poBox = place.postalCode ?? '';
        _city = place.locality ?? place.subAdministrativeArea ?? '';
        _country = place.country ?? '';
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _poBox = '';
        _city = '';
        _postalCode = '';
        _country = '';
      });
    }
  }

  @override
  void dispose() {
    // Dispose controllers to prevent memory leaks
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: AppColors.transparent,
        title: Text(
          'Signup',
          style: appBarStyle.copyWith(color: AppColors.white),
        ),
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Image.asset(
              AppImages.back,
              scale: 4,
            ),
          ),
        ),
      ),
      body: CustomBackground(
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                sh100,
                Text(
                  'Create New Account',
                  style: h2.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.white,
                  ),
                ),
                sh12,
                Text(
                  'Please fill your detail information.',
                  style: h4.copyWith(
                    color: AppColors.white,
                  ),
                ),
                sh16,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Full Name',
                      style: h4.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                    sh8,
                    CustomTextField(
                      hintTextStyle: const TextStyle(color: Colors.white),
                      textColor: Colors.white,
                      onChange: (String value) {},
                      controller: nameController,
                      hintText: 'Enter your full name',
                    ),
                    sh12,
                    Text(
                      'Address',
                      style: h4.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                    sh8,
                    LocationAutocompleteField(
                      controller: addressController,
                      hintText: 'Your address',
                      textColor: Colors.white,
                      hintTextStyle: const TextStyle(color: Colors.white),
                      borderColor: Colors.white24,
                      suffixIconColor: Colors.white,
                      onSelected: _applySelectedAddress,
                    ),
                    sh12,
                    Text(
                      'Email',
                      style: h4.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                    sh8,
                    CustomTextField(
                      hintTextStyle: const TextStyle(color: Colors.white),
                      textColor: Colors.white,
                      onChange: (String value) {},
                      controller: emailController,
                      hintText: 'Your email',
                    ),
                    sh12,
                    Text(
                      'Create a Password',
                      style: h4.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                    sh8,
                    CustomTextField(
                      hintTextStyle: const TextStyle(color: Colors.white),
                      textColor: Colors.white,
                      onChange: (String value) {},
                      controller: passwordController,
                      sufIcon: Image.asset(
                        AppImages.eyeClose, 
                        scale: 4,
                      ),
                      hintText: '**********',
                      isPassword: true,
                    ),
                    sh20,
                    Row(
                      children: [
                        Checkbox(
                          checkColor: Colors.white,
                          activeColor: Colors.red,
                          value: isCheck,
                          onChanged: (value) {
                            setState(() {
                              isCheck = value ?? false;
                            });
                          },
                        ),
                        sw16,
                        Expanded(
                          child: Text(
                            'I agree to the Terms & Conditions and Privacy Policy',
                            style: h4.copyWith(
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                sh20,
                Obx(
                  () => CustomButton(
                    text: 'Sign Up',
                    isLoading: signUpController.inProgress,
                    onPressedAsync: () async {
                      if (!isCheck) {
                        showSnackBarMessage(
                          context,
                          'Please agree to the Terms & Conditions and Privacy Policy',
                          true,
                        );
                        return;
                      }
                      await signUpFunction(
                        context,
                        nameController.text.trim(),
                        emailController.text.trim(),
                        passwordController.text.trim(),
                        {
                          "address": addressController.text.trim(),
                          "poBox": _poBox,
                          "city": _city,
                          "postalCode": _postalCode,
                          "country": _country,
                          "latitude": _latitude,
                          "longitude": _longitude,
                        },
                      );
                    },
                  ),
                ),
                sh20,
                GestureDetector(
                  onTap: () {
                    Get.offAll(() => LoginView());
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account? ',
                        style: h4.copyWith(
                          color: AppColors.white,
                        ),
                      ),
                      Text(
                        'Login',
                        style: h4.copyWith(color: AppColors.darkRed),
                      ),
                    ],
                  ),
                ),
                sh30,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> signUpFunction(
    BuildContext context,
    String name,
    String email,
    String password,
    Map<String, dynamic> addressLine1,
  ) async {
    final bool isSuccess = await signUpController.createUser(
      name,
      email,
      password,
      addressLine1,
    );

    if (isSuccess) {
      showSnackBarMessage(context, 'Successfully done');
      Get.to(() => OtpVerifyView(email, previousPage: 'sp'));
    } else {
      showSnackBarMessage(
        context,
        signUpController.errorMessage ?? 'Failed to sign up',
        true,
      );
    }
  }
} 
