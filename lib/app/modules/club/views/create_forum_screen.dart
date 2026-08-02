import 'package:dirve_society/app/modules/club/controllers/all_club_forum_controller.dart';
import 'package:dirve_society/app/modules/club/controllers/create_forum_controller.dart';
import 'package:dirve_society/common/widgets/custom_snackbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/app_color/app_colors.dart';
import '../../../../common/app_images/app_images.dart';
import '../../../../common/app_text_style/styles.dart';
import '../../../../common/size_box/custom_sizebox.dart';
import '../../../../common/widgets/custom_button.dart';
import '../../../../common/widgets/custom_circular_container.dart';
import '../../../../common/widgets/custom_textfield.dart';

// ignore: must_be_immutable
class CreateForumView extends StatefulWidget { 
  String? clubId;
  String? authorId;

  CreateForumView({super.key, this.clubId, this.authorId});

  @override
  State<CreateForumView> createState() => _CreateForumViewState();
}

class _CreateForumViewState extends State<CreateForumView> {
  static const int _titleMaxLength = 80;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final CreateForumController createForumController =
      Get.put(CreateForumController());
  final AllClubForunController allClubForumController =
      Get.put(AllClubForunController());
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainColor,
      appBar: AppBar(
        backgroundColor: AppColors.mainColor,
        scrolledUnderElevation: 0, 
        title: Text(
          'Create forum',
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
                  'Title',
                  style: h5,
                ),
                sh8,
                CustomTextField(
                  onChange: (String value) {},
                  controller: titleController,
                  hintText: 'Enter title',
                  maxLength: _titleMaxLength,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    final title = value?.trim() ?? '';
                    if (title.isEmpty) {
                      return 'Title is required';
                    }
                    if (title.length > _titleMaxLength) {
                      return 'Title must be $_titleMaxLength characters or fewer';
                    }
                    return null;
                  },
                ),
                sh8,
                ValueListenableBuilder<TextEditingValue>(
                  valueListenable: titleController,
                  builder: (context, value, child) {
                    return Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        '${value.text.characters.length}/$_titleMaxLength',
                        style: h6.copyWith(color: AppColors.grey),
                      ),
                    );
                  },
                ),
                sh16,
                Text(
                  'Description',
                  style: h5,
                ),
                sh8,
                CustomTextField(
                  height: 120,
                  onChange: (String value) {},
                  controller: descriptionController,
                  hintText: 'Describe about your club',
                  maxLines: 5,
                ),
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
            text: 'Create Forum',
            isLoading: createForumController.inProgress,
            onPressedAsync: () async {
              await createForum();
            },
          ),
        ),
      ),
    );
  }

  Future<void> createForum() async {
    if (formKey.currentState!.validate()) {
      final bool isSuccess = await createForumController.createForun(
          titleController.text.trim(),
          descriptionController.text,
          widget.clubId ?? '');

      if (isSuccess) {
        await allClubForumController.refreshClubForum(widget.clubId ?? '');

        if (mounted) {
          titleController.clear();
          descriptionController.clear();
          formKey.currentState?.reset();
          showSnackBarMessage(context, 'Forum uploaded successfully');
          Navigator.of(context).pop(true);
        }
      } else {
        if (mounted) {
          showSnackBarMessage(
            context,
            createForumController.errorMessage ?? 'Failed to create club',
            true,
          );
        }
      }
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}
