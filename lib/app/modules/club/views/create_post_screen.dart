import 'dart:io';

import 'package:dirve_society/app/modules/club/controllers/all_club_field_controller.dart';
import 'package:dirve_society/app/modules/club/controllers/create_post_controller.dart';
import 'package:dirve_society/app/modules/home/controllers/feed/all_feed_controller.dart';
import 'package:dirve_society/app/modules/profile/controllers/my_feed_controller.dart';
import 'package:dirve_society/common/app_color/app_colors.dart';
import 'package:dirve_society/common/app_images/app_images.dart';
import 'package:dirve_society/common/app_text_style/styles.dart';
import 'package:dirve_society/common/size_box/custom_sizebox.dart';
import 'package:dirve_society/common/widgets/custom_button.dart';
import 'package:dirve_society/common/widgets/custom_circular_container.dart';
import 'package:dirve_society/common/widgets/custom_snackbar_widget.dart';
import 'package:dirve_society/common/widgets/custom_textfield.dart';
import 'package:dirve_society/common/widgets/image_picker.dart';
import 'package:dirve_society/common/widgets/location_autocomplete_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class CreatePostView extends StatefulWidget {
  String? clubId;
  String? authorId;

  CreatePostView({super.key, this.clubId, this.authorId});

  @override
  State<CreatePostView> createState() => _CreatePostViewState();
}

class _CreatePostViewState extends State<CreatePostView> {
  final TextEditingController tagController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  final MyFeedController myFeedController = Get.put(MyFeedController());
  final CreatePostController createPostController =
      Get.put(CreatePostController());
  final AllClubFeedController allClubFeedController =
      Get.put(AllClubFeedController());

  final formKey = GlobalKey<FormState>();
  final List<File> selectedImages = [];
  final List<String> tags = [];
  final ImagePickerHelper _imagePickerHelper = ImagePickerHelper();

  String? selectedLocationAddress;

  @override
  void initState() {
    super.initState();
    locationController.addListener(_handleLocationTyping);
  }

  void _handleLocationTyping() {
    if (locationController.text.trim() != selectedLocationAddress) {
      selectedLocationAddress = null;
    }
  }

  void _addTag() {
    final String tag = tagController.text.trim();
    if (tag.isEmpty) return;

    if (!tags.contains(tag)) {
      setState(() {
        tags.add(tag);
      });
    }

    tagController.clear();
  }

  void _removeTag(String tag) {
    setState(() {
      tags.remove(tag);
    });
  }

  Future<void> createPost() async {
    _addTag();

    if (!formKey.currentState!.validate()) return;

    if (tags.isEmpty) {
      showSnackBarMessage(context, 'Please add at least one tag', true);
      return;
    }

    if (locationController.text.trim().isEmpty) {
      showSnackBarMessage(context, 'Please select a location', true);
      return;
    }

    final bool isSuccess = await createPostController.createPost(
      description: descriptionController.text.trim(),
      images: selectedImages,
      clubId: widget.clubId,
      tags: tags,
      location: {
        "address": locationController.text.trim(),
        "type": "Point",
        "coordinates": [0.0, 0.0],
      },
    );

    if (!mounted) return;

    if (isSuccess) {
      if (widget.clubId != null) {
        final refreshRequests = <Future<bool>>[
          allClubFeedController.refreshClubFeed(widget.clubId!),
        ];

        if (Get.isRegistered<AllFeedController>()) {
          refreshRequests.add(Get.find<AllFeedController>().refreshFeed());
        }

        await Future.wait(refreshRequests);
      } else {
        final refreshRequests = <Future<bool>>[
          myFeedController.getMyFeed(),
        ];

        if (Get.isRegistered<AllFeedController>()) {
          refreshRequests.add(Get.find<AllFeedController>().refreshFeed());
        }

        await Future.wait(refreshRequests);
      }

      if (!mounted) return;

      _clearFormData();
      showSnackBarMessage(context, 'Post uploaded successfully');
      Navigator.of(context).pop(true);
      return;
    }

    showSnackBarMessage(
      context,
      createPostController.errorMessage ?? 'Failed to create post',
      true,
    );
  }

  void _clearFormData() {
    tagController.clear();
    descriptionController.clear();
    locationController.clear();
    selectedLocationAddress = null;
    formKey.currentState?.reset();

    setState(() {
      tags.clear();
      selectedImages.clear();
    });
  }

  Widget _buildTagSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Tags', style: h5),
        sh8,
        CustomTextField(
          controller: tagController,
          hintText: 'Enter tag and tap +',
          onChange: (String value) {},
          sufIcon: IconButton(
            onPressed: _addTag,
            icon: const Icon(Icons.add_circle_outline),
          ),
        ),
        if (tags.isNotEmpty) ...[
          sh12,
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: tags
                .map(
                  (tag) => Chip(
                    label: Text(tag),
                    deleteIcon: const Icon(Icons.close, size: 18),
                    onDeleted: () => _removeTag(tag),
                  ),
                )
                .toList(),
          ),
        ],
      ],
    );
  }

  Widget _buildLocationSection() {
    return LocationAutocompleteField(
      controller: locationController,
      label: 'Location',
      hintText: 'Search address',
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Location is required';
        }
        return null;
      },
      onSelected: (result) {
        selectedLocationAddress = result.address;
      },
    );
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
      final List<File> images =
          await _imagePickerHelper.pickMultiImageFromGallery(
        aspectRatioX: 1,
        aspectRatioY: 1,
      );
      if (images.isEmpty || !mounted) return;

      final existingPaths = selectedImages.map((image) => image.path).toSet();
      setState(() {
        selectedImages.addAll(
          images.where((image) => !existingPaths.contains(image.path)),
        );
      });
    } catch (error) {
      if (mounted) {
        showSnackBarMessage(context, 'Failed to select images: $error', true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainColor,
      appBar: AppBar(
        backgroundColor: AppColors.mainColor,
        scrolledUnderElevation: 0,
        title: Text('Create Post', style: appBarStyle),
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: CustomCircularContainer(
            imagePath: AppImages.back,
            onTap: Get.back,
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
                Text('Description', style: h5),
                sh8,
                CustomTextField(
                  height: 120,
                  controller: descriptionController,
                  hintText: widget.clubId == null
                      ? 'Write about your feed post'
                      : 'Write about your club post',
                  maxLines: 4,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Description is required';
                    }
                    return null;
                  },
                  onChange: (String value) {},
                ),
                sh16,
                _buildLocationSection(),
                sh16,
                _buildTagSection(),
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
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
        child: Obx(
          () => CustomButton(
            text: 'Create',
            isLoading: createPostController.inProgress,
            onPressedAsync: () async => createPost(),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    locationController.removeListener(_handleLocationTyping);
    tagController.dispose();
    descriptionController.dispose();
    locationController.dispose();
    super.dispose();
  }
}
