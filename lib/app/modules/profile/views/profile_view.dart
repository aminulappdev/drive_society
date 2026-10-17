import 'package:dirve_society/app/modules/auth/login/views/login_view.dart';
import 'package:dirve_society/app/modules/profile/controllers/content_controller.dart';
import 'package:dirve_society/app/modules/profile/controllers/profile_controller.dart';
import 'package:dirve_society/app/modules/profile/views/changed_password_view.dart';
import 'package:dirve_society/app/modules/profile/views/edit_profile_details_view.dart';
import 'package:dirve_society/app/modules/profile/views/my_clubs_view.dart';
import 'package:dirve_society/app/modules/profile/views/my_friend_screen.dart';
import 'package:dirve_society/app/modules/profile/views/my_garage_view.dart';
import 'package:dirve_society/app/modules/profile/views/my_post_view.dart';
import 'package:dirve_society/app/modules/profile/views/privacy_and_security_view.dart';
import 'package:dirve_society/app/modules/profile/views/saved_view.dart';
import 'package:dirve_society/app/modules/profile/views/terms_and_conditions_view.dart';
import 'package:dirve_society/common/app_images/app_images.dart';
import 'package:dirve_society/common/widgets/custom_dialoge.dart';
import 'package:dirve_society/common/widgets/profile_header_layout.dart';
import 'package:dirve_society/get_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/app_color/app_colors.dart';
import '../../../../common/size_box/custom_sizebox.dart';
import '../../../../common/widgets/custom_button.dart';
import '../../../../common/widgets/custom_list_tile.dart';
import 'about_us_view.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final ContentController _contentController = Get.put(ContentController());
  final ProfileController _profileController =
      Get.isRegistered<ProfileController>()
          ? Get.find<ProfileController>()
          : Get.put(ProfileController());

  @override
  void initState() {
    _contentController.getMyContent();
    if (_profileController.profileData.value == null) {
      _profileController.fetchProfileData();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainColor,
      body: Column(
        children: [
          Obx(() {
            final profile = _profileController.profileData.value;
            return ProfileHeaderLayout(
              isBack: false,
              title: profile?.name ??
                  StorageUtil.getData(StorageUtil.profileName) ??
                  '',
              coverImageUrl: profile?.coverPhoto ??
                  StorageUtil.getData(StorageUtil.profileCoverPhoto),
              profileImageUrl: profile?.photoUrl ??
                  StorageUtil.getData(StorageUtil.profilePhotoUrl),
              onBack: Get.back,
              subtitle: profile?.bio ??
                  StorageUtil.getData(StorageUtil.profileBio) ??
                  '',
              ratingText:
                  '${profile?.avgRating ?? StorageUtil.getData(StorageUtil.profileAvgRating) ?? '0.0'}',
              pointsText:
                  '${profile?.scores ?? StorageUtil.getData(StorageUtil.profileScores) ?? '0'} Points',
            );
          }),
          sh16,
          GetBuilder<ContentController>(builder: (controller) {
            return Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomListTile(
                        onTap: () {
                          Get.to(() => EditProfileDetailsView());
                        },
                        leadingImage: AppImages.edit,
                        title: 'Edit Profile Details',
                        trailingImage: AppImages.arrowRightSmall,
                      ),
                      sh12,
                      CustomListTile(
                        onTap: () {
                          Get.to(() => MyPostView());
                        },
                        leadingImage: AppImages.gallery,
                        title: 'My Posts',
                        trailingImage: AppImages.arrowRightSmall,
                      ),
                      sh12,
                      CustomListTile(
                        onTap: () {
                          Get.to(() => MyGarageView());
                        },
                        leadingImage: AppImages.garage,
                        title: 'My Garage',
                        trailingImage: AppImages.arrowRightSmall,
                      ),
                      sh12,
                      CustomListTile(
                        onTap: () {
                          Get.to(() => MyClubsView());
                        },
                        leadingImage: AppImages.club,
                        title: 'My Clubs',
                        trailingImage: AppImages.arrowRightSmall,
                      ),
                      sh12,
                      CustomListTile(
                        onTap: () {
                          Get.to(() => MyFriendScreen());
                        },
                        leadingImage: AppImages.groupLight,
                        isIconData: true,
                        title: 'My Friends',
                        iconSize: 20,
                        trailingImage: AppImages.arrowRightSmall,
                      ),
                      sh12,
                      CustomListTile(
                        onTap: () {
                          Get.to(() => SavedView());
                        },
                        leadingImage: AppImages.favorite,
                        title: 'Saved',
                        trailingImage: AppImages.arrowRightSmall,
                      ),
                      sh12,
                      CustomListTile(
                        onTap: () {
                          Get.to(() => ChangedPasswordView());
                        },
                        leadingImage: AppImages.keyLight,
                        title: 'Change Password',
                        trailingImage: AppImages.arrowRightSmall,
                      ),
                      sh12,
                      CustomListTile(
                        onTap: () {
                          Get.to(() => PrivacyAndSecurityView(
                                data:
                                    controller.contectList?[0].privacyPolicy ??
                                        '',
                              ));
                        },
                        leadingImage: AppImages.privacy,
                        title: 'Privacy and security',
                        trailingImage: AppImages.arrowRightSmall,
                      ),
                      sh12,
                      CustomListTile(
                        onTap: () {
                          Get.to(() => TermsAndConditionsView(
                                data: controller
                                        .contectList?[0].termsAndConditions ??
                                    '',
                              ));
                        },
                        leadingImage: AppImages.termsAndConditions,
                        title: 'Terms & Conditions',
                        trailingImage: AppImages.arrowRightSmall,
                      ),
                      sh12,
                      CustomListTile(
                        onTap: () {
                          Get.to(() => AboutUsView(
                                data: controller.contectList?[0].aboutUs ?? '',
                              ));
                        },
                        leadingImage: AppImages.aboutUs,
                        title: 'About Us',
                        trailingImage: AppImages.arrowRightSmall,
                      ),
                      sh12,
                      Center(
                        child: CustomButton(
                          text: 'Log Out',
                          onPressed: () {
                            _showLeaveAccountDialog(context);
                          },
                          imageAssetPath: AppImages.logout,
                          width: 150,
                          textColor: AppColors.red,
                          backgroundColor: Colors.red[50],
                        ),
                      ),
                      sh40,
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  void _showLeaveAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomDialog(
          yesText: 'Yes',
          noText: 'No',
          noOntap: () {
            Navigator.pop(context);
          },
          yesOntap: () async {
            await Future.wait([
              StorageUtil.deleteData(StorageUtil.userAccessToken),
              StorageUtil.deleteData(StorageUtil.profileId),
              StorageUtil.deleteData(StorageUtil.profileName),
              StorageUtil.deleteData(StorageUtil.profileEmail),
              StorageUtil.deleteData(StorageUtil.profilePhotoUrl),
              StorageUtil.deleteData(StorageUtil.profileBio),
              StorageUtil.deleteData(StorageUtil.profileAddress),
              StorageUtil.deleteData(StorageUtil.profileAddressTwo),
              StorageUtil.deleteData(StorageUtil.profilePoBox),
              StorageUtil.deleteData(StorageUtil.profileCity),
              StorageUtil.deleteData(StorageUtil.profilePostalCode),
              StorageUtil.deleteData(StorageUtil.profileScores),
              StorageUtil.deleteData(StorageUtil.profileStatus),
              StorageUtil.deleteData(StorageUtil.profileDataId),
              StorageUtil.deleteData(StorageUtil.profileCreatedAt),
              StorageUtil.deleteData(StorageUtil.profileAvgRating),
              StorageUtil.deleteData(StorageUtil.profileCoverPhoto),
              StorageUtil.deleteData(StorageUtil.isPaid),
            ]);

            Get.offAll(() => LoginView());
          },
          iconData: Icons.logout,
          subtitle: '',
          title: 'Do you want to log out this profile?',
        );
      },
    );
  }
}
