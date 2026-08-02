import 'dart:io';

import 'package:dirve_society/app/modules/club/controllers/create_club_controller.dart';
import 'package:dirve_society/app/modules/dashboard/views/dashboard_view.dart';
import 'package:dirve_society/app/modules/home/controllers/feed/create_story_controller.dart';
import 'package:dirve_society/app/modules/profile/controllers/my_club_controller.dart';
import 'package:dirve_society/common/widgets/custom_snackbar_widget.dart';
import 'package:dirve_society/common/widgets/image_picker.dart';
import 'package:dirve_society/common/widgets/image_preview_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/app_color/app_colors.dart';
import '../../../../common/app_images/app_images.dart';
import '../../../../common/app_text_style/styles.dart';
import '../../../../common/helper/upload_widget.dart';
import '../../../../common/size_box/custom_sizebox.dart';
import '../../../../common/widgets/custom_button.dart';
import '../../../../common/widgets/custom_circular_container.dart';
import '../../../../common/widgets/custom_textfield.dart';

class AddStoryScreen extends StatefulWidget {
  const AddStoryScreen({super.key});

  @override
  State<AddStoryScreen> createState() => _AddStoryScreenState();
}

class _AddStoryScreenState extends State<AddStoryScreen> {
  final TextEditingController captionController = TextEditingController();

  final CreateClubController createClubController =
      Get.put(CreateClubController());
  final MyClubController myClubController = Get.put(MyClubController());
  final AddStoryController addStoryController = Get.put(AddStoryController());

  final formKey = GlobalKey<FormState>();
  File? profileImage;
  final ImagePickerHelper _imagePickerHelper = ImagePickerHelper();

  /// ইমেজ প্রিভিউ দেখানোর জন্য
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainColor,
      appBar: AppBar(
        backgroundColor: AppColors.mainColor,
        scrolledUnderElevation: 0,
        title: Text('Add Story', style: appBarStyle),
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: CustomCircularContainer(
            imagePath: AppImages.back,
            onTap: () => Get.back(),
            padding: 4,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Caption', style: h5),
                sh8,
                CustomTextField(
                  controller: captionController,
                  hintText: 'Write here',
                  maxLines: 3,
                ),
                sh16,
                Text('Profile Photo', style: h5),
                sh8,
                UploadWidget(
                  onTap: () {
                    _imagePickerHelper.showAlertDialog(context, (File picked) {
                      setState(() => profileImage = picked);
                    });
                  },
                  imagePath: AppImages.upload,
                  imageFile: profileImage,
                  label: 'Upload',
                  // ইমেজ থাকলে ট্যাপ করে প্রিভিউ দেখানো
                  onImageTap: profileImage != null
                      ? () => ImagePreviewDialog.showFile(
                            context,
                            imageFile: profileImage!,
                          )
                      : null,
                ),
                sh100,
              ],
            ),
          ),
        ),
      ),
      bottomSheet: Container(
        color: AppColors.mainColor,
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
        child: Obx(() => CustomButton(
              isLoading: addStoryController.inProgress,
              text: 'Add Story',
              onPressedAsync: () async => await _addStory(),
            )),
      ),
    );
  }

  Future<void> _addStory() async {
    if (!formKey.currentState!.validate()) return;

    final bool success = await addStoryController.addStory(
      captionController.text.trim(),
      profileImage,
    );

    if (success) {
      Get.offAll(() => const DashboardView());
    } else {
      if (mounted) {
        showSnackBarMessage(
          context,
          addStoryController.errorMessage ?? 'Failed to add story',
          true,
        );
      }
    }
  }
}
