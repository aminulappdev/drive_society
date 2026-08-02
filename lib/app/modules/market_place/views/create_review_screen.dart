// ignore_for_file: use_build_context_synchronously

import 'package:dirve_society/app/modules/market_place/controllers/create_review_controller.dart';
import 'package:dirve_society/common/app_color/app_colors.dart';
import 'package:dirve_society/common/app_images/app_images.dart';
import 'package:dirve_society/common/app_text_style/styles.dart';
import 'package:dirve_society/common/size_box/custom_sizebox.dart';
import 'package:dirve_society/common/widgets/custom_circular_container.dart';
import 'package:dirve_society/common/widgets/custom_snackbar_widget.dart';
import 'package:dirve_society/common/widgets/custom_textfield.dart';
import 'package:dirve_society/common/widgets/custom_button.dart';
import 'package:dirve_society/get_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateReviewScreen extends StatefulWidget {
  final String listingId;
  const CreateReviewScreen({super.key, required this.listingId});

  @override
  State<CreateReviewScreen> createState() => _CreateReviewScreenState();
}

class _CreateReviewScreenState extends State<CreateReviewScreen> {
  final TextEditingController _reviewController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final CreateReviewController _createReviewController =
      Get.put(CreateReviewController());
  int _selectedRating = 0;

  Future<void> _submitReview() async {
    if (_formKey.currentState!.validate() && _selectedRating > 0) {
      final bool isSuccess = await _createReviewController.createReview(
        StorageUtil.getData(StorageUtil.profileId) ??
            'no id', // Replace with actual user ID or name
        'Car',
        widget.listingId,
        _reviewController.text,
        _selectedRating,
      );

      if (isSuccess) {
        Get.back(result: true);
        // _reviewController.clear();
      } else {
        showSnackBarMessage(
          context,
          _createReviewController.errorMessage ?? 'Failed to submit review',
          true,
        );
      }
    } else {
      showSnackBarMessage(
        context,
        _selectedRating == 0
            ? 'Please select a rating'
            : 'Please enter a review',
        true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainColor,
      appBar: AppBar(
        backgroundColor: AppColors.mainColor,
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
        title: Text(
          'Write a Review',
          style: appBarStyle,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Please share your opinion',
                style: h3,
              ),
              sh8,
              Form(
                key: _formKey,
                child: CustomTextField(
                  controller: _reviewController,
                  hintText: 'Type your review here',
                  onChange: (String value) {},
                ),
              ),
              sh16,
              Text(
                'Rate this listing',
                style: h3,
              ),
              sh8,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedRating = index + 1;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Icon(
                        index < _selectedRating
                            ? Icons.star
                            : Icons.star_border,
                        color: AppColors.darkRed,
                        size: 30,
                      ),
                    ),
                  );
                }),
              ),
              sh30,
              Obx(
                () => CustomButton(
                  text: 'Submit Review',
                  isLoading: _createReviewController.inProgress,
                  onPressedAsync: () async {
                    await _submitReview();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }
}
