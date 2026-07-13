import 'dart:io';

import 'package:dirve_society/app/modules/club/controllers/all_club_field_controller.dart';
import 'package:dirve_society/app/modules/club/controllers/create_post_controller.dart';
import 'package:dirve_society/app/modules/home/controllers/feed/all_feed_controller.dart';
import 'package:dirve_society/app/modules/profile/controllers/my_feed_controller.dart';
import 'package:dirve_society/common/widgets/custom_snackbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../common/app_color/app_colors.dart';
import '../../../../common/app_images/app_images.dart';
import '../../../../common/app_text_style/styles.dart';
import '../../../../common/size_box/custom_sizebox.dart';
import '../../../../common/widgets/custom_button.dart';
import '../../../../common/widgets/custom_circular_container.dart';
import '../../../../common/widgets/custom_textfield.dart';

// ignore: must_be_immutable
class CreatePostView extends StatefulWidget {
  String? clubId;
  String? authorId;
  CreatePostView({super.key, this.clubId, this.authorId});

  @override
  State<CreatePostView> createState() => _CreatePostViewState();
}

class _CreatePostViewState extends State<CreatePostView> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final MyFeedController myFeedController = Get.put(MyFeedController());
  String privacy = 'public'; // Changed from final to non-final
  final CreatePostController createPostController =
      Get.put(CreatePostController());
  final AllClubFeedController allClubFeedController =
      Get.put(AllClubFeedController());

  final formKey = GlobalKey<FormState>();
  final List<File> selectedImages = [];
  final ImagePicker _imagePicker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainColor,
      appBar: AppBar(
        backgroundColor: AppColors.mainColor,
        scrolledUnderElevation: 0,
        title: Text(
          'Create Post',
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                sh30,
                Text(
                  'Tags',
                  style: h5,
                ),
                sh8,
                CustomTextField(
                  onChange: (String value) {},
                  controller: nameController,
                  hintText: 'Enter tag',
                ),
                sh16,
                Text(
                  'Description',
                  style: h5,
                ),
                sh8,
                CustomTextField(
                  onChange: (String value) {},
                  controller: descriptionController,
                  hintText: 'Describe about your club',
                ),
                sh16,
                Text('Photos', style: h5),
                sh8,
                _buildImagePicker(),
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
          // NEW CHANGE: Added Obx to observe inProgress
          () => CustomButton(
            text: 'Create',
            isLoading: createPostController
                .inProgress, // NEW CHANGE: Added isLoading prop
            onPressedAsync: () async {
              await createPost();
            },
          ),
        ),
      ),
    );
  }

  Future<void> createPost() async {
    if (formKey.currentState!.validate()) {
      final bool isSuccess = await createPostController.createPost(
        nameController.text,
        privacy,
        descriptionController.text,
        selectedImages,
        clubId: widget.clubId,
      );

      if (isSuccess) {
        if (mounted) {
          if (widget.clubId != null) {
            final refreshRequests = <Future<bool>>[
              allClubFeedController.refreshClubFeed(widget.clubId!),
            ];

            if (Get.isRegistered<AllFeedController>()) {
              refreshRequests.add(
                Get.find<AllFeedController>().refreshFeed(),
              );
            }

            await Future.wait(refreshRequests);
          } else {
            final refreshRequests = <Future<bool>>[
              myFeedController.getMyFeed(),
            ];

            if (Get.isRegistered<AllFeedController>()) {
              refreshRequests.add(
                Get.find<AllFeedController>().refreshFeed(),
              );
            }

            await Future.wait(refreshRequests);
          }

          if (mounted) {
            _clearFormData();
            showSnackBarMessage(context, 'Post uploaded successfully');
            Navigator.of(context).pop(true);
          }
        }
      } else {
        if (mounted) {
          showSnackBarMessage(
            context,
            createPostController.errorMessage ??
                'Failed to create post', // NEW CHANGE: Updated to use createPostController.errorMessage
            true,
          );
        }
      }
    }
  }

  void _clearFormData() {
    nameController.clear();
    descriptionController.clear();
    formKey.currentState?.reset();
    setState(() {
      privacy = 'public';
      selectedImages.clear();
    });
  }

  Widget _buildImagePicker() {
    if (selectedImages.isEmpty) {
      return InkWell(
        onTap: _pickImages,
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
                'Upload multiple photos',
                style: h5.copyWith(color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: selectedImages.length + 1,
      itemBuilder: (context, index) {
        if (index == selectedImages.length) {
          return InkWell(
            onTap: _pickImages,
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
              child: Image.file(selectedImages[index], fit: BoxFit.cover),
            ),
            Positioned(
              top: 4,
              right: 4,
              child: InkWell(
                onTap: () => setState(() => selectedImages.removeAt(index)),
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

  Future<void> _pickImages() async {
    try {
      final List<XFile> images = await _imagePicker.pickMultiImage();
      if (images.isEmpty || !mounted) return;

      final existingPaths = selectedImages.map((image) => image.path).toSet();
      setState(() {
        selectedImages.addAll(
          images
              .where((image) => !existingPaths.contains(image.path))
              .map((image) => File(image.path)),
        );
      });
    } catch (error) {
      if (mounted) {
        showSnackBarMessage(context, 'Failed to select images: $error', true);
      }
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}
