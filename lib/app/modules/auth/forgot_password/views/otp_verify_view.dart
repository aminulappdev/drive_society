// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:developer';
import 'package:dirve_society/app/modules/auth/forgot_password/controllers/otp_verify_controller.dart';
import 'package:dirve_society/app/modules/auth/forgot_password/controllers/resend_otp_cpntroller.dart';
import 'package:dirve_society/app/modules/auth/forgot_password/views/reset_password_view.dart';
import 'package:dirve_society/app/modules/auth/login/views/login_view.dart';
import 'package:dirve_society/common/widgets/custom_background.dart';
import 'package:dirve_society/common/widgets/custom_snackbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../../../common/app_color/app_colors.dart';
import '../../../../../common/app_images/app_images.dart';
import '../../../../../common/app_text_style/styles.dart';
import '../../../../../common/size_box/custom_sizebox.dart';
import '../../../../../common/widgets/custom_button.dart';

class OtpVerifyView extends StatefulWidget {
  final String previousPage;
  final String email;
  const OtpVerifyView(this.email, {super.key, required this.previousPage});

  @override
  State<OtpVerifyView> createState() => _OtpVerifyViewState();
}

class _OtpVerifyViewState extends State<OtpVerifyView> {
  final OtpVerifyController _otpVerifyController =
      Get.put(OtpVerifyController());
  final TextEditingController otpCtrl = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ResendOtpController resendOtpController = ResendOtpController();

  RxInt remainingTime = 60.obs; // Observable for countdown timer
  late Timer timer; // Timer for countdown
  RxBool enableResendCodeButton =
      false.obs; // Observable for resend button state

  @override
  void initState() {
    super.initState();
    // Start the timer for countdown
    remainingTime.value = 60;
    enableResendCodeButton.value = false;
    timer = Timer.periodic(
      const Duration(seconds: 1),
      (t) {
        remainingTime.value--;
        if (remainingTime.value == 0) {
          t.cancel();
          enableResendCodeButton.value = true;
        }
      },
    );
  }

  void resendOTP() async {
    print('resendOTP called'); // For debugging
    enableResendCodeButton.value = false;
    remainingTime.value = 60;
    timer = Timer.periodic(
      const Duration(seconds: 1),
      (t) {
        remainingTime.value--;
        if (remainingTime.value == 0) {
          t.cancel();
          enableResendCodeButton.value = true;
        }
      },
    );

    // Assuming OtpVerifyController has a method to resend OTP
    final bool isSuccess = await resendOtpController.resendOtp(widget.email);

    if (isSuccess) {
      if (mounted) {
        showSnackBarMessage(context, 'OTP Successfully sent');
        otpCtrl.clear(); // Clear OTP field after successful resend
        setState(() {}); // Update UI to reflect cleared field
      }
    } else {
      if (mounted) {
        showSnackBarMessage(context,
            _otpVerifyController.errorMessage ?? 'Failed to resend OTP', true);
      }
    }
  }

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
          'Verify',
          style: appBarStyle.copyWith(color: primaryTextColor),
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
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                sh100,
                Text(
                  'Code has been sent to ${widget.email}',
                  style: h5.copyWith(color: secondaryTextColor),
                  textAlign: TextAlign.center,
                ),
                sh30,
                PinCodeTextField(
                  controller: otpCtrl,
                  length: 6,
                  obscureText: false,
                  keyboardType: TextInputType.number,
                  animationType: AnimationType.fade,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(8),
                    fieldHeight: 45,
                    fieldWidth: 45,
                    activeColor: AppColors.borderColor,
                    activeFillColor: AppColors.white,
                    inactiveColor: AppColors.borderColor,
                    inactiveFillColor: AppColors.white,
                    selectedColor: AppColors.blue,
                    selectedFillColor: AppColors.white,
                  ),
                  animationDuration: const Duration(milliseconds: 300),
                  backgroundColor: AppColors.white,
                  cursorColor: AppColors.blue,
                  textStyle: h4.copyWith(color: primaryTextColor),
                  enablePinAutofill: true,
                  enableActiveFill: true,
                  onCompleted: (v) {},
                  onChanged: (value) {
                    setState(() {}); // Update UI on OTP change
                  },
                  beforeTextPaste: (text) {
                    log("Allowing to paste $text");
                    return true;
                  },
                  appContext: context,
                ),
                sh20,
                Obx(
                  () => Visibility(
                    visible: !enableResendCodeButton.value,
                    replacement: GestureDetector(
                      onTap: () {
                        resendOTP();
                      },
                      child: Text(
                        'Resend code',
                        style: h5.copyWith(
                          color: AppColors.blue,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Resend code in ',
                            style: h5.copyWith(color: secondaryTextColor),
                          ),
                          TextSpan(
                            text: '${remainingTime.value}',
                            style: h5.copyWith(color: AppColors.blue),
                          ),
                          TextSpan(
                            text: 's',
                            style: h5.copyWith(color: secondaryTextColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                sh20,
                Obx(
                  () => CustomButton(
                    text: 'Confirm',
                    isLoading: _otpVerifyController.inProgress,
                    onPressedAsync: otpCtrl.text.length == 6
                        ? () async {
                            await otpVerifyFunction(otpCtrl.text);
                          }
                        : null, // Disable button if OTP is not 6 digits
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> otpVerifyFunction(String otp) async {
    final bool isSuccess = await _otpVerifyController.otpVerify(otp);

    if (isSuccess) {
      showSnackBarMessage(context, 'Successfully done');
      widget.previousPage == 'sp'
          ? Get.to(() => const LoginView())
          : Get.to(() => ResetPasswordView(email: widget.email));
    } else {
      showSnackBarMessage(
        context,
        _otpVerifyController.errorMessage ?? 'Verification failed',
        true,
      );
    }
  }

  @override
  void dispose() {
    timer.cancel(); // Prevent memory leaks
    otpCtrl.dispose();
    super.dispose();
  }
}
