import 'package:dirve_society/app/modules/profile/controllers/change_password_controller.dart';
import 'package:dirve_society/common/app_images/app_images.dart';
import 'package:dirve_society/common/widgets/custom_snackbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/app_color/app_colors.dart';
import '../../../../common/app_text_style/styles.dart';
import '../../../../common/size_box/custom_sizebox.dart';
import '../../../../common/widgets/custom_button.dart';
import '../../../../common/widgets/custom_circular_container.dart';
import '../../../../common/widgets/custom_textfield.dart';

class ChangedPasswordView extends StatefulWidget {
  const ChangedPasswordView({super.key});

  @override
  State<ChangedPasswordView> createState() => _ChangedPasswordViewState();
}

class _ChangedPasswordViewState extends State<ChangedPasswordView> {
  final TextEditingController oldPassworfController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmNewPasswordController =
      TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final ChangePasswordController changePasswordController =
      Get.put(ChangePasswordController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainColor,
      appBar: AppBar( 
        backgroundColor: AppColors.mainColor,
        title: Text(
          'Change Password',
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
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              sh30,
              CustomTextField(
                onChange: (String value) {},
                controller: oldPassworfController,
                hintText: 'Current Password',
                isPassword: true,
              ),
              sh16,
              CustomTextField(
                onChange: (String value) {},
                controller: newPasswordController,
                hintText: 'New Password',
                isPassword: true,
              ),
              sh16,
              CustomTextField(
                onChange: (String value) {},
                controller: confirmNewPasswordController,
                hintText: 'Confirm New Password',
                isPassword: true,
              ),
              sh16,
              // GestureDetector(
              //   onTap: () {
              //     Get.to(() => ForgotPasswordView());
              //   },
              //   child: Text(
              //     'Forgot the password?',
              //     style: h5.copyWith(color: AppColors.darkRed),
              //   ),
              // ),
              // sh30,
              Obx(
                () => CustomButton(
                  text: 'Confirm',
                  isLoading: changePasswordController.inProgress,
                  onPressedAsync: () async {
                    await changePassword(
                        oldPassworfController.text, newPasswordController.text);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> changePassword(String oldPassword, String newPassword) async {
    final bool isSuccess =
        await changePasswordController.changePassword(oldPassword, newPassword);

    if (isSuccess) {
      showSnackBarMessage(context, 'Successfully done');
    } else {
      showSnackBarMessage(
        context,
        changePasswordController.errorMessage ?? 'failed',
        true,
      );
    }
  }

  @override
  void dispose() {
    oldPassworfController.dispose();
    newPasswordController.dispose();
    confirmNewPasswordController.dispose();
    super.dispose();
  }
}
