import 'package:dirve_society/app/modules/home/controllers/connection_view/add_connection_request_controller.dart';
import 'package:dirve_society/app/modules/home/controllers/connection_view/people_may_know_controller.dart';
import 'package:dirve_society/app/modules/profile/others/views/others_profile_screen.dart';
import 'package:dirve_society/common/app_color/app_colors.dart';
import 'package:dirve_society/common/helper/user_card.dart';
import 'package:dirve_society/common/widgets/custom_snackbar_widget.dart';
import 'package:dirve_society/common/widgets/custom_circular_container.dart';
import 'package:dirve_society/common/app_images/app_images.dart';
import 'package:dirve_society/get_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AllPeopleYouMayScreen extends StatefulWidget {
  const AllPeopleYouMayScreen({super.key});

  @override
  State<AllPeopleYouMayScreen> createState() => _AllPeopleYouMayScreenState();
}

class _AllPeopleYouMayScreenState extends State<AllPeopleYouMayScreen> {
  final PeopleMayKnowController peopleMayKnowController =
      Get.put(PeopleMayKnowController());
  final AddConnectionRequestController addConnectionRequestController =
      Get.put(AddConnectionRequestController());

  String search = '';

  @override
  void initState() {
    super.initState();
    // Defer the getPeopleMayKnow call to avoid setState during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      peopleMayKnowController.getPeopleMayKnow();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainColor,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus(); // Dismiss keyboard on tap
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: MediaQuery.paddingOf(context).top + 4),
              Row(
                children: [
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: CustomCircularContainer(
                      imagePath: AppImages.back,
                      onTap: () => Get.back(),
                      padding: 4,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'People you may know',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkRed,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5),
              Container(
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(color: AppColors.borderColor),
                  color: Colors.white,
                ),
                child: TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'Search...',
                    border: InputBorder.none,
                    prefixIcon: Icon(
                      Icons.search,
                      color: AppColors.grey,
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      search = value; // Update search query
                    });
                  },
                ),
              ),
              SizedBox(height: 10),
              Expanded(
                child: GetBuilder<PeopleMayKnowController>(
                  builder: (controller) {
                    if (controller.inProgress) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    // Filter items based on search query
                    final filteredItems =
                        controller.peopleYouMayList?.where((item) {
                              final name = item.name?.toLowerCase() ?? '';
                              return search.isEmpty ||
                                  name.contains(search.toLowerCase());
                            }).toList() ??
                            [];

                    if (filteredItems.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              AppImages.search,
                              height: 80,
                              width: 95,
                            ),
                            Text(
                              'No results for "${search.isEmpty ? 'People' : search}"',
                              style: TextStyle(
                                fontSize: 20,
                                color: AppColors.black,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Text(
                                'We couldn’t find any matching results. Please refine your search or check back later.',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: AppColors.black,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return GridView.builder(
                      padding: const EdgeInsets.all(0.0),
                      itemCount: filteredItems.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 0.55,
                        crossAxisCount: 2,
                        crossAxisSpacing: 2,
                        mainAxisSpacing: 2,
                      ),
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: SizedBox(
                              width: 200, // Ensure UserCard respects this width
                              child: UserCard(
                                image:
                                    filteredItems[index].photoUrl?.isNotEmpty ==
                                            true
                                        ? filteredItems[index].photoUrl!
                                        : AppImages
                                            .noImage, // Fallback to placeholder
                                isOneButton: true,
                                title: filteredItems[index].name ?? '',
                                rating:
                                    filteredItems[index].ratingCount.toString(),
                                description: filteredItems[index].bio ?? '',
                                isAdded: true,
                                acceptButton: () {},
                                addFriendButton: () {
                                  addUserRequest(
                                    userId: StorageUtil.getData(
                                        StorageUtil.profileId),
                                    modelType: 'User',
                                    reference: filteredItems[index].id ?? '',
                                  );
                                },
                                rejectedButton: () {},
                                onUserDetails: () {
                                  Get.to(() => OthersProfileView(
                                        authorId: filteredItems[index].id ?? '',
                                      ));
                                },
                              ),
                            ),
                          ),
                        );
                      },
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

  Future<void> addUserRequest({
    required String userId,
    required String modelType,
    required String reference,
    String? repReference,
  }) async {
    final bool isSuccess = await addConnectionRequestController.addClubRequest(
      userId,
      modelType,
      reference,
    );
    if (isSuccess) {
      peopleMayKnowController.getPeopleMayKnow();
      if (mounted) {
        showSnackBarMessage(context, 'Connection request sent');
      }
    } else {
      if (mounted) {
        showSnackBarMessage(
          context,
          addConnectionRequestController.errorMessage ?? 'Failed',
          true,
        );
      }
    }
  }
}
