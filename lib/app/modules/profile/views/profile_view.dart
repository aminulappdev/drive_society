import 'package:dirve_society/app/modules/auth/login/views/login_view.dart';
import 'package:dirve_society/app/modules/profile/controllers/content_controller.dart';
import 'package:dirve_society/app/modules/profile/views/changed_password_view.dart';
import 'package:dirve_society/app/modules/profile/views/edit_profile_details_view.dart';
import 'package:dirve_society/app/modules/profile/views/my_clubs_view.dart';
import 'package:dirve_society/app/modules/profile/views/my_friend_screen.dart';
import 'package:dirve_society/app/modules/profile/views/my_garage_view.dart';
import 'package:dirve_society/app/modules/profile/views/my_post_view.dart';
import 'package:dirve_society/app/modules/profile/views/privacy_and_security_view.dart';
import 'package:dirve_society/app/modules/profile/views/saved_view.dart';
import 'package:dirve_society/app/modules/profile/views/terms_and_conditions_view.dart';
import 'package:dirve_society/common/widgets/custom_dialoge.dart';
import 'package:dirve_society/common/widgets/profile_header_layout.dart';
import 'package:dirve_society/get_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:readmore/readmore.dart';
import '../../../../common/app_color/app_colors.dart';
import '../../../../common/app_images/app_images.dart';
import '../../../../common/app_text_style/styles.dart';
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

  @override
  void initState() {
    _contentController.getMyContent();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainColor,
      body: Column(
        children: [
          ProfileHeaderLayout(
            title: StorageUtil.getData(StorageUtil.profileName) ?? '',
            coverImageUrl: StorageUtil.getData(StorageUtil.profileCoverPhoto),
            profileImageUrl: StorageUtil.getData(StorageUtil.profilePhotoUrl),
            onBack: Get.back,
            subtitle: StorageUtil.getData(StorageUtil.profileBio) ?? '',
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.star,
                  size: 22,
                  color: AppColors.darkRed,
                ),
                sw5,
                Text(
                  StorageUtil.getData(StorageUtil.profileAvgRating).toString(),
                  style: h3.copyWith(
                    color: AppColors.black,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          sh16,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Descriptions',
                      style: h5.copyWith(fontWeight: FontWeight.w600),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.orange[600],
                      ),
                      child: Center(
                        child: Text(
                          '${StorageUtil.getData(StorageUtil.profileScores)} Points',
                          style: h6,
                        ),
                      ),
                    ),
                  ],
                ),
                sh5,
                ReadMoreText(
                  StorageUtil.getData(StorageUtil.profileBio) ?? '',
                  trimLines: 2,
                  trimMode: TrimMode.Line,
                  trimCollapsedText: 'Show More',
                  trimExpandedText: ' Show Less',
                  style: h6,
                  moreStyle: h6.copyWith(
                    color: AppColors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                  lessStyle: h6.copyWith(
                    color: AppColors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          sh20,
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
                        leadingImage: AppImages.edit,
                        title: 'My Clubs',
                        trailingImage: AppImages.arrowRightSmall,
                      ),
                      sh12,
                      CustomListTile(
                        onTap: () {
                          Get.to(() => MyFriendScreen());
                        },
                        leadingImage: AppImages.edit,
                        title: 'My Friends',
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
