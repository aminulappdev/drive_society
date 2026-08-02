import 'package:dirve_society/app/modules/home/views/date_formatter.dart';
import 'package:dirve_society/app/modules/market_place/controllers/sell_taggle_controller.dart';
import 'package:dirve_society/app/modules/profile/controllers/my_garage_controller.dart';
import 'package:dirve_society/app/modules/profile/views/add_car_view.dart';
import 'package:dirve_society/common/widgets/custom_button.dart';
import 'package:dirve_society/common/widgets/custom_snackbar_widget.dart';
import 'package:dirve_society/common/widgets/profile_header_layout.dart';
import 'package:dirve_society/common/widgets/toogle_button.dart';
import 'package:dirve_society/get_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/app_color/app_colors.dart';
import '../../../../common/app_images/app_images.dart';
import '../../../../common/app_text_style/styles.dart';
import '../../../../common/helper/market_place_widget.dart';
import '../../../../common/size_box/custom_sizebox.dart';
import '../../market_place/views/listing_details_view.dart';

class MyGarageView extends StatefulWidget {
  const MyGarageView({super.key});

  @override
  State<MyGarageView> createState() => _MyGarageViewState();
}

class _MyGarageViewState extends State<MyGarageView> {
  final MyGarageController myGarageController = Get.put(MyGarageController());
  final SellTaggleController sellTaggleController = SellTaggleController();

  @override
  void initState() {
    myGarageController.getMyGarage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProfileHeaderLayout(
            title: StorageUtil.getData(StorageUtil.profileName) ?? '',
            coverImageUrl: StorageUtil.getData(StorageUtil.profileCoverPhoto),
            profileImageUrl: StorageUtil.getData(StorageUtil.profilePhotoUrl),
            subtitle: StorageUtil.getData(StorageUtil.profileBio) ?? '',
            onBack: Get.back,
            ratingText:
                '${StorageUtil.getData(StorageUtil.profileAvgRating) ?? '0.0'}',
            pointsText:
                '${StorageUtil.getData(StorageUtil.profileScores) ?? '0'} Points',
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'My Garage',
                  style: h1.copyWith(fontSize: 20),
                ),
                CustomButton(
                  height: 38,
                  width: 135,
                  text: 'Add Car',
                  imageAssetPath: AppImages.add,
                  iconColor: AppColors.white,
                  onPressed: () {
                    Get.to(() => AddCarView());
                  },
                ),
              ],
            ),
          ),
          GetBuilder<MyGarageController>(builder: (controller) {
            if (controller.inProgress) {
              return const SizedBox(
                height: 300,
                child: Center(child: CircularProgressIndicator()),
              );
            }
            if (controller.myGarageList == null ||
                controller.myGarageList!.isEmpty) {
              return const SizedBox(
                height: 300,
                child: Center(child: Text('No Car Found')),
              );
            }
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: controller.myGarageList?.length ?? 0,
                  itemBuilder: (context, index) {
                    final dateFormatter = DateFormatter(
                      controller.myGarageList![index].createdAt ??
                          DateTime.now(),
                    );
                    // Check if images list is not empty, otherwise use fallback
                    // final imageUrl =
                    //     controller.myGarageList![index].images.isNotEmpty
                    //         ? controller.myGarageList![index].images[0]
                    //         : AppImages.noImage;
                    return Padding(
                      padding: EdgeInsets.only(
                        top: index == 0 ? 12 : 8,
                        bottom: index == controller.myGarageList!.length - 1
                            ? 20
                            : 0,
                      ),
                      child: MarketPlaceWidget(
                        height: 200,
                        name: controller.myGarageList![index].brand ?? '',
                        price: controller.myGarageList![index].price.toString(),
                        date: dateFormatter.getFullDateFormat(),
                        imageUrl: controller.myGarageList![index].banner ?? '',
                        onTap: () {
                          Get.to(() => ListingDetailsView(
                                id: controller.myGarageList![index].id ?? '',
                              ));
                        },
                        taggle: ToggleButton(
                          isToggled:
                              controller.myGarageList![index].isSale == true
                                  ? true
                                  : false,
                          onToggle: (value) => sellTaggle(
                              controller.myGarageList![index].id ?? ''),
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Future<void> sellTaggle(String contentId) async {
    final bool isSuccess = await sellTaggleController.sellTaggle(contentId);

    if (isSuccess) {
      if (mounted) {
        sellTaggleController.isSell;
        showSnackBarMessage(
          context,
          sellTaggleController.isSell == true
              ? 'Car added on market place'
              : 'Car removed from market place',
          false,
        );
      }
    } else {
      if (mounted) {
        showSnackBarMessage(
          context,
          sellTaggleController.errorMessage ?? 'Failed to update profile',
          true,
        );
      }
    }
  }
}
