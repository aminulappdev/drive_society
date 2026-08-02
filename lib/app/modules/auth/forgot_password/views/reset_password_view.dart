import 'package:dirve_society/app/modules/auth/forgot_password/controllers/reset_password_controller.dart';
import 'package:dirve_society/app/modules/auth/login/views/login_view.dart';
import 'package:dirve_society/common/widgets/custom_background.dart';
import 'package:dirve_society/common/widgets/custom_snackbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../common/app_color/app_colors.dart';
import '../../../../../common/app_images/app_images.dart';
import '../../../../../common/app_text_style/styles.dart';
import '../../../../../common/size_box/custom_sizebox.dart';
import '../../../../../common/widgets/custom_button.dart';
import '../../../../../common/widgets/custom_textfield.dart';

class ResetPasswordView extends StatefulWidget {
  final String email;
  const ResetPasswordView({super.key, required this.email});

  @override
  State<ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<ResetPasswordView> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final ResetPasswordController _resetPasswordController = Get.put(ResetPasswordController());

  @override
  Widget build(BuildContext context) {
    const Color primaryTextColor = AppColors.greyDark;
    const Color secondaryTextColor = AppColors.black100;
    return Scaffold(
      backgroundColor: AppColors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: AppColors.transparent,
        title: Text(
          'Forgot Password',
          style: TextStyle(
            color: primaryTextColor,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
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
              scale: 5,
              color: primaryTextColor,
            ),
          ),
        ),
      ),
      body: CustomBackground(
        backgroundImage: null,
        backgroundColor: AppColors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              sh100,
              Align(
                alignment: Alignment.center,
                child: Text(
                  'Set Your New Password',
                  style: h4.copyWith(color: primaryTextColor),
                ),
              ),
              sh16,
              Align(
                alignment: Alignment.center,
                child: Text(
                  'Create a new password to secure your account.',
                  style: h5.copyWith(color: secondaryTextColor),
                ),
              ),
              sh16,
              Text(
                'Enter new password',
                style: h4.copyWith(color: primaryTextColor),
              ),
              sh12,
              CustomTextField(
                hintTextStyle: const TextStyle(color: AppColors.gray),
                textColor: primaryTextColor,
                controller: passwordController,
                onChange: (String value) {}, // Note: Corrected to onChange
                hintText: '**********',
                isPassword: true, // Enable password visibility toggle
              ),
              sh16,
              Text(
                'Confirm Password',
                style: h4.copyWith(color: primaryTextColor),
              ),
              sh12,
              CustomTextField(
                hintTextStyle: const TextStyle(color: AppColors.gray),
                textColor: primaryTextColor,
                controller: confirmPasswordController,
                onChange: (String value) {}, // Note: Corrected to onChange
                hintText: '**********',
                isPassword: true, // Enable password visibility toggle
              ),
              sh16,
              Obx(
                () => CustomButton(
                  text: 'Update Password',
                  isLoading: _resetPasswordController.inProgress,
                  onPressedAsync: () async {
                    await resetPassword(
                      widget.email,
                      passwordController.text,
                      confirmPasswordController.text,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> resetPassword(String email, String password, String confirmPassword) async {
    final bool isSuccess = await _resetPasswordController.resetPassword(email, password, confirmPassword);

    if (isSuccess) {
      showSnackBarMessage(context, 'Successfully done');
      Get.to(() => const LoginView());
    } else {
      showSnackBarMessage(
        context,
        _resetPasswordController.errorMessage ?? 'failed',
        true,
      );
    }
  }

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
